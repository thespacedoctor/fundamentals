#!/usr/bin/env python
# encoding: utf-8
"""
*Set up a private ssh tunnel to a remote database host, shared by ``tools`` and ``database``*

Author
: David Young
"""

import atexit
import re
import socket
import time
from subprocess import Popen, TimeoutExpired

TUNNEL_REQUIRED_KEYS = ("remote user", "remote ip", "remote datbase host", "port")
TUNNEL_CHECK_ATTEMPTS = 5
TUNNEL_CHECK_DELAY = 1
TUNNEL_CONNECT_TIMEOUT = 5
TUNNEL_CLOSE_TIMEOUT = 5
LOOPBACK_ADDRESS = "127.0.0.1"
REMOTE_DATABASE_PORT = 3306
MAX_PORT = 65535

# SSH PROCESSES STARTED BY THIS MODULE, KEYED BY LOCAL PORT
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
    *start a private ssh tunnel to a remote database host on a free local port*

    Every call starts its own ssh process, listening on a free port of the loopback address. An existing listener is never reused, because a listening port cannot prove that it belongs to ssh. The process is stopped by ``close_ssh_tunnel`` or when the interpreter exits.

    **Key Arguments**

    - ``tunnelParameters`` -- the ``tunnel`` dictionary of the database settings, with the keys ``remote user``, ``remote ip``, ``remote datbase host`` and ``port``. The ``port`` value is still checked, but it is not used: the local port is chosen at random

    - ``log`` -- logger

    **Return**

    - ``sshPort`` -- the local port the tunnel is listening on. Connect to ``127.0.0.1`` on this port

    **Usage**

    ```python
    from fundamentals.ssh_tunnel import setup_ssh_tunnel, close_ssh_tunnel
    sshPort = setup_ssh_tunnel(tunnelParameters=dbSettings["tunnel"], log=log)
    close_ssh_tunnel(sshPort)
    ```

    Raises ``tunnel_error`` if the settings are invalid, ssh cannot be started, ssh exits, or the tunnel does not connect.
    """
    remoteUser, remoteIp, remoteHost, _ = _validate_tunnel_parameters(tunnelParameters)

    localPort = _find_free_port()
    argv = [
        "ssh",
        "-nN",
        "-o",
        "ExitOnForwardFailure=yes",
        f"{remoteUser}@{remoteIp}",
        "-L",
        f"{LOOPBACK_ADDRESS}:{localPort}:{remoteHost}:{REMOTE_DATABASE_PORT}",
    ]
    try:
        process = Popen(argv, close_fds=True)
    except OSError as e:
        raise tunnel_error(f"could not start the ssh tunnel command: {e}") from e

    TUNNEL_PROCESSES[localPort] = process
    atexit.register(close_ssh_tunnel, localPort)
    try:
        _wait_for_tunnel(process, localPort, log)
    except BaseException:
        close_ssh_tunnel(localPort)
        raise
    return localPort


def close_ssh_tunnel(sshPort):
    """
    *stop the ssh process serving a tunnel started by ``setup_ssh_tunnel``*

    Does nothing if the tunnel is unknown or already closed.

    **Key Arguments**

    - ``sshPort`` -- the local port returned by ``setup_ssh_tunnel``
    """
    process = TUNNEL_PROCESSES.pop(sshPort, None)
    if process is None or process.poll() is not None:
        return
    process.terminate()
    try:
        process.wait(timeout=TUNNEL_CLOSE_TIMEOUT)
    except TimeoutExpired:
        process.kill()
        process.wait()


def _find_free_port():
    """
    *ask the operating system for a free port on the loopback address*

    **Return**

    - ``port`` -- a port that was free when the socket was closed
    """
    with socket.socket() as s:
        s.bind((LOOPBACK_ADDRESS, 0))
        return s.getsockname()[1]


def _wait_for_tunnel(process, localPort, log):
    """
    *wait until the ssh process is alive and the local port accepts connections*

    Raises ``tunnel_error`` if ssh exits or the port does not open in time.
    """
    for attempt in range(TUNNEL_CHECK_ATTEMPTS):
        # A PORT IS ONLY TRUSTED WHILE OUR OWN SSH PROCESS IS ALIVE
        _raise_if_exited(process, log)
        if is_port_open(LOOPBACK_ADDRESS, localPort, log):
            _raise_if_exited(process, log)
            return
        if attempt < TUNNEL_CHECK_ATTEMPTS - 1:
            time.sleep(TUNNEL_CHECK_DELAY)

    message = (
        f"could not set up an ssh tunnel to the remote database on port {localPort}"
    )
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


def is_port_open(address, port, log):
    """
    *check whether a TCP port accepts connections*

    **Key Arguments**

    - ``address`` -- the address to connect to
    - ``port`` -- the port to connect to
    - ``log`` -- logger

    **Return**

    - ``isOpen`` -- True if the connection succeeded
    """
    with socket.socket() as s:
        log.debug(f"Attempting to connect to `{address}` on port `{port}`")
        s.settimeout(TUNNEL_CONNECT_TIMEOUT)
        try:
            s.connect((address, port))
        except socket.error as e:
            log.warning(
                f"Connection to `{address}` on port `{port}` failed - try again: {e}"
            )
            return False
    log.debug(f"Connected to `{address}` on port `{port}`")
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
