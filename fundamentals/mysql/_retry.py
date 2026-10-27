#!/usr/local/bin/python
# encoding: utf-8
"""
*Shared retry policy for transient MySQL errors*

Author
: David Young
"""

import pymysql

# MYSQL ERROR CODES THAT CLEAR THEMSELVES, SO THE SAME QUERY IS WORTH SENDING AGAIN
# 2006 (SERVER GONE AWAY) AND 2013 (LOST CONNECTION) ARE LEFT OUT ON PURPOSE: PYMYSQL CLOSES
# ITS SOCKET WHEN THEY HAPPEN, SO A RETRY ON THE SAME CONNECTION CANNOT WORK, AND A WRITE
# MAY ALREADY HAVE COMMITTED, SO SENDING IT AGAIN COULD REPEAT IT
DEADLOCK_ERROR_CODE = 1213
LOCK_WAIT_TIMEOUT_ERROR_CODE = 1205
TRANSIENT_ERROR_CODES = frozenset(
    {
        DEADLOCK_ERROR_CODE,
        LOCK_WAIT_TIMEOUT_ERROR_CODE,
    }
)

RETRY_BASE_DELAY_SECONDS = 1
RETRY_MAX_DELAY_SECONDS = 16
RETRY_TOTAL_SECONDS = 60

RETRYABLE_ERRORS = (pymysql.err.InternalError, pymysql.err.OperationalError)


def _build_retry_delays():
    """*Build the exponential backoff delays, capped per delay and in total*

    **Return**

    - ``delays`` -- tuple of seconds to sleep before each successive retry (1, 2, 4, 8, 16, 16)
    """
    delays = []
    delay = RETRY_BASE_DELAY_SECONDS
    while sum(delays) + delay <= RETRY_TOTAL_SECONDS:
        delays.append(delay)
        delay = min(delay * 2, RETRY_MAX_DELAY_SECONDS)
    return tuple(delays)


RETRY_DELAYS = _build_retry_delays()


def is_transient_error(error):
    """*Say whether a pymysql error is one that is worth retrying*

    **Key Arguments**

    - ``error`` -- the pymysql exception

    **Return**

    - ``isTransient`` -- True for deadlock and lock wait timeout
    """
    return bool(error.args) and error.args[0] in TRANSIENT_ERROR_CODES


def next_retry_delay(error, delays):
    """*Get the seconds to wait before retrying, or None if the error should be raised*

    **Key Arguments**

    - ``error`` -- the pymysql exception
    - ``delays`` -- an iterator over the remaining backoff delays (consumed one per retry)

    **Return**

    - ``delay`` -- seconds to sleep, or None if the error is not transient or the retries are used up
    """
    if not is_transient_error(error):
        return None
    return next(delays, None)
