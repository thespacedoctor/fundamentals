#!/usr/local/bin/python
# encoding: utf-8
"""
*Shared retry policy for transient MySQL errors*

Author
: David Young
"""

import time

import pymysql

from fundamentals.mysql._log_safety import describe_error

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


def run_with_retries(log, operation):
    """*Run an operation, retrying transient MySQL errors with a bounded backoff*

    Errors that are not transient, and transient errors that outlast the backoff, are raised.

    **Key Arguments**

    - ``log`` -- the logger
    - ``operation`` -- a function that takes no arguments. It is called again after each transient error, so it must be safe to repeat

    **Return**

    - ``result`` -- whatever ``operation`` returns
    """
    delays = iter(RETRY_DELAYS)
    attempt = 1
    while True:
        try:
            return operation()
        except RETRYABLE_ERRORS as e:
            delay = next_retry_delay(e, delays)
            if delay is None:
                raise
            log.warning(
                f"Transient MySQL error: {describe_error(e)}. Retrying in {delay}s (attempt {attempt} failed)."
            )
            time.sleep(delay)
            attempt += 1
