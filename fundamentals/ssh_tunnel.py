#!/usr/bin/env python
# encoding: utf-8
"""
*Set up an ssh tunnel to a remote database host, shared by ``tools`` and ``database``*

Author
: David Young
"""

import re
import socket
import time
from subprocess import Popen

TUNNEL_REQUIRED_KEYS = ("remote user", "remote ip", "remote datbase host", "port")
TUNNEL_CHECK_ATTEMPTS = 5
TUNNEL_CHECK_DELAY = 1
REMOTE_DATABASE_PORT = 3306
MAX_PORT = 65535

# SAFE VALUES MUST NOT START WITH A DASH (SSH WOULD READ THEM AS AN OPTION)
SAFE_USER = re.compile(r"^[A-Za-z0-9_][A-Za-z0-9._-]*$")
SAFE_HOST = re.compile(r"^[A-Za-z0-9_][A-Za-z0-9._-]*$")
SAFE_ADDRESS = re.compile(r"^[A-Za-z0-9_][A-Za-z0-9._:-]*$")


class tunnel_error(Exception):
    """
    *raised when an ssh tunnel is badly configured or cannot be set up*
    """


def setup_ssh_tunnel(tunnelParameters, log, checkHost="127.0.0.1"):
    """
    *set up an ssh tunnel to a remote database host, unless one is already listening*

    **Key Arguments**

    - ``tunnelParameters`` -- the ``tunnel`` dictionary of the database settings, with the keys ``remote user``, ``remote ip``, ``remote datbase host`` and ``port``
    - ``log`` -- logger
    - ``checkHost`` -- the local address to check for the tunnel. Default *127.0.0.1*

    **Return**

    - ``sshPort`` -- the local port the tunnel is listening on

    **Usage**

    ```python
    from fundamentals.ssh_tunnel import setup_ssh_tunnel
    sshPort = setup_ssh_tunnel(tunnelParameters=dbSettings["tunnel"], log=log)
    ```

    Raises ``tunnel_error`` if the settings are invalid, ssh cannot be started or the tunnel does not connect.
    """
    ru, rip, rh, sshPort = _validate_tunnel_parameters(tunnelParameters)

    if is_port_open(checkHost, sshPort, log):
        log.debug("ssh tunnel already exists - moving on")
        return sshPort

    argv = [
        "ssh",
        "-fnN",
        f"{ru}@{rip}",
        "-L",
        f"{sshPort}:{rh}:{REMOTE_DATABASE_PORT}",
    ]
    try:
        output = Popen(argv, close_fds=True).communicate()[0]
    except OSError as e:
        raise tunnel_error(f"could not start the ssh tunnel command: {e}") from e
    log.debug(f"output: {output}")

    for attempt in range(TUNNEL_CHECK_ATTEMPTS):
        if is_port_open(checkHost, sshPort, log):
            return sshPort
        if attempt < TUNNEL_CHECK_ATTEMPTS - 1:
            time.sleep(TUNNEL_CHECK_DELAY)

    message = f"could not set up an ssh tunnel to the remote database on port {sshPort}"
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
