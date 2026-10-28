#!/usr/bin/env python
# encoding: utf-8
"""
*Set up a private ssh tunnel to a remote database host, shared by ``tools`` and ``database``*

Author
: David Young
"""

import atexit
import os
import re
import shutil
import socket
import tempfile
import time
from subprocess import Popen, TimeoutExpired

TUNNEL_REQUIRED_KEYS = ("remote user", "remote ip", "remote datbase host", "port")
TUNNEL_CHECK_ATTEMPTS = 5
TUNNEL_CHECK_DELAY = 1
TUNNEL_CONNECT_TIMEOUT = 5
TUNNEL_CLOSE_TIMEOUT = 5
SOCKET_DIR_PREFIX = "fundamentals-tunnel-"
SOCKET_NAME = "mysql.sock"
# THE SHORTEST sun_path LIMIT (macOS: 104 BYTES INCLUDING THE TRAILING NUL)
MAX_SOCKET_PATH = 103
REMOTE_DATABASE_PORT = 3306
MAX_PORT = 65535

# SSH PROCESSES STARTED BY THIS MODULE, KEYED BY LOCAL SOCKET PATH
TUNNEL_PROCESSES = {}

# SAFE VALUES MUST NOT START WITH A DASH (SSH WOULD READ THEM AS AN OPTION)
SAFE_NAME_PATTERN = r"^[A-Za-z0-9_][A-Za-z0-9._-]*$"
SAFE_USER = re.compile(SAFE_NAME_PATTERN)
SAFE_HOST = re.compile(SAFE_NAME_PATTERN)
SAFE_ADDRESS = re.compile(r"^[A-Za-z0-9_][A-Za-z0-9._:-]*$")


class tunnel_error(Exception):
    """
    *raised when an ssh tunnel is badly configured or cannot be set up*
    """


def setup_ssh_tunnel(tunnelParameters, log):
    """
    *start a private ssh tunnel to a remote database host, listening on a unix socket*

    Every call starts its own ssh process, forwarding a unix socket inside a new directory that only the current user can open. No other process can take the place of the tunnel, because nobody else can create a file in that directory. The process is stopped by ``close_ssh_tunnel`` or when the interpreter exits.

    **Key Arguments**

    - ``tunnelParameters`` -- the ``tunnel`` dictionary of the database settings, with the keys ``remote user``, ``remote ip``, ``remote datbase host`` and ``port``. The ``port`` value is still checked, but it is not used: the tunnel listens on a unix socket, not on a TCP port

    - ``log`` -- logger

    **Return**

    - ``socketPath`` -- the path of the unix socket the tunnel is listening on. Connect to it with ``unix_socket=socketPath``

    **Usage**

    ```python
    from fundamentals.ssh_tunnel import setup_ssh_tunnel, close_ssh_tunnel
    socketPath = setup_ssh_tunnel(tunnelParameters=dbSettings["tunnel"], log=log)
    close_ssh_tunnel(socketPath)
    ```

    Raises ``tunnel_error`` if the settings are invalid, ssh cannot be started, ssh exits, or the tunnel does not connect.
    """
    remoteUser, remoteIp, remoteHost, _ = _validate_tunnel_parameters(tunnelParameters)

    socketPath = _make_socket_path()
    argv = [
        "ssh",
        "-nN",
        "-o",
        "ExitOnForwardFailure=yes",
        f"{remoteUser}@{remoteIp}",
        "-L",
        f"{socketPath}:{remoteHost}:{REMOTE_DATABASE_PORT}",
    ]
    try:
        process = Popen(argv, close_fds=True)
    except OSError as e:
        _remove_socket_dir(socketPath, log)
        raise tunnel_error(f"could not start the ssh tunnel command: {e}") from e

    TUNNEL_PROCESSES[socketPath] = process
    atexit.register(close_ssh_tunnel, socketPath)
    try:
        _wait_for_tunnel(process, socketPath, log)
    except BaseException:
        close_ssh_tunnel(socketPath, log)
        raise
    return socketPath


def close_ssh_tunnel(socketPath, log=None):
    """
    *stop the ssh process serving a tunnel started by ``setup_ssh_tunnel`` and remove its socket directory*

    Does nothing if the tunnel is unknown or already closed.

    **Key Arguments**

    - ``socketPath`` -- the socket path returned by ``setup_ssh_tunnel``
    - ``log`` -- logger, used to report a socket directory that could not be removed. Default *None*
    """
    process = TUNNEL_PROCESSES.pop(socketPath, None)
    if process is None:
        return
    if process.poll() is None:
        process.terminate()
        try:
            process.wait(timeout=TUNNEL_CLOSE_TIMEOUT)
        except TimeoutExpired:
            process.kill()
            process.wait()
    _remove_socket_dir(socketPath, log)


def _make_socket_path():
    """
    *create a private (mode 0700) directory and return the socket path inside it*

    Raises ``tunnel_error`` if the path cannot be used in an ssh ``-L`` argument or as a unix socket.
    """
    socketDir = tempfile.mkdtemp(prefix=SOCKET_DIR_PREFIX)
    socketPath = os.path.join(socketDir, SOCKET_NAME)
    # ":" SEPARATES THE FIELDS OF AN SSH FORWARD AND THE PATH MUST FIT IN sun_path
    if ":" in socketPath or len(os.fsencode(socketPath)) > MAX_SOCKET_PATH:
        shutil.rmtree(socketDir, ignore_errors=True)
        raise tunnel_error(
            f"the tunnel socket path cannot be used (set TMPDIR to a short path without ':'): {socketPath}"
        )
    return socketPath


def _remove_socket_dir(socketPath, log):
    """
    *remove the private directory holding the tunnel socket, logging any failure*
    """
    try:
        shutil.rmtree(os.path.dirname(socketPath))
    except FileNotFoundError:
        pass
    except OSError as e:
        if log is not None:
            log.warning(f"could not remove the tunnel socket directory: {e}")


def _wait_for_tunnel(process, socketPath, log):
    """
    *wait until the ssh process is alive and the tunnel socket accepts connections*

    Raises ``tunnel_error`` if ssh exits or the socket does not open in time.
    """
    for attempt in range(TUNNEL_CHECK_ATTEMPTS):
        # THE SOCKET IS ONLY TRUSTED WHILE OUR OWN SSH PROCESS IS ALIVE
        _raise_if_exited(process, log)
        if is_unix_socket_open(socketPath, log):
            _raise_if_exited(process, log)
            return
        if attempt < TUNNEL_CHECK_ATTEMPTS - 1:
            time.sleep(TUNNEL_CHECK_DELAY)

    message = f"could not set up an ssh tunnel to the remote database at `{socketPath}`"
    log.error(message)
    raise tunnel_error(message)


def _raise_if_exited(process, log):
    """
    *raise ``tunnel_error`` if the ssh process has exited*
    """
    exitCode = process.poll()
    if exitCode is None:
        return
    message = f"the ssh tunnel process exited with code {exitCode}"
    log.error(message)
    raise tunnel_error(message)


def is_unix_socket_open(socketPath, log):
    """
    *check whether a unix socket accepts connections*

    **Key Arguments**

    - ``socketPath`` -- the path of the unix socket
    - ``log`` -- logger

    **Return**

    - ``isOpen`` -- True if the connection succeeded
    """
    with socket.socket(socket.AF_UNIX) as s:
        log.debug(f"Attempting to connect to socket `{socketPath}`")
        s.settimeout(TUNNEL_CONNECT_TIMEOUT)
        try:
            s.connect(socketPath)
        except OSError as e:
            log.warning(f"Connection to socket `{socketPath}` failed - try again: {e}")
            return False
    log.debug(f"Connected to socket `{socketPath}`")
    return True


def _validate_tunnel_parameters(tunnelParameters):
    """
    *check the tunnel settings and return the values used to build the ssh command*

    **Return**

    - ``(remoteUser, remoteIp, remoteHost, port)``
    """
    if not isinstance(tunnelParameters, dict):
        raise tunnel_error(
            "the database `tunnel` setting must be a mapping with the keys "
            + ", ".join(f"`{key}`" for key in TUNNEL_REQUIRED_KEYS)
        )
    missing = [key for key in TUNNEL_REQUIRED_KEYS if key not in tunnelParameters]
    if missing:
        raise tunnel_error(
            "the database `tunnel` setting is missing: "
            + ", ".join(f"`{key}`" for key in missing)
        )

    remoteUser = _check_value("remote user", tunnelParameters, SAFE_USER)
    remoteIp = _check_value("remote ip", tunnelParameters, SAFE_ADDRESS)
    remoteHost = _check_value("remote datbase host", tunnelParameters, SAFE_HOST)

    port = tunnelParameters["port"]
    if isinstance(port, bool) or not re.fullmatch(r"[0-9]+", str(port)):
        raise tunnel_error(f"the tunnel `port` setting is not a port number: {port!r}")
    port = int(port)
    if not 1 <= port <= MAX_PORT:
        raise tunnel_error(f"the tunnel `port` setting is out of range: {port}")
    return remoteUser, remoteIp, remoteHost, port


def _check_value(key, tunnelParameters, pattern):
    """
    *return a string tunnel setting if it matches the safe pattern, otherwise raise ``tunnel_error``*
    """
    value = tunnelParameters[key]
    if not isinstance(value, str) or not pattern.fullmatch(value):
        raise tunnel_error(f"the tunnel `{key}` setting is not valid: {value!r}")
    return value
