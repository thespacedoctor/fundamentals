#!/usr/local/bin/python
# encoding: utf-8
"""
*Given a mysql query, read the data from the database and return the results as a list of dictionaries (database rows)*

Author
: David Young
"""

from fundamentals import tools
from fundamentals.mysql._retry import RETRY_DELAYS, RETRYABLE_ERRORS, next_retry_delay
from builtins import str
import sys
import os
import time

os.environ["TERM"] = "vt100"


def readquery(sqlQuery, dbConn, log, quiet=False):
    """Given a mysql query, read the data from the database and return the results as a list of dictionaries (database rows)

    **Key Arguments**

    - ``log`` -- the logger.
    - ``sqlQuery`` -- the MySQL command to execute
    - ``dbConn`` -- the db connection
    - ``quiet`` -- ignore mysql warnings and errors and move on. Be careful when setting this to true - damaging errors can easily be missed. Default *False*.


    **Return**

    - ``rows`` -- the rows returned by the sql query


    **Usage**

    ```python
    from fundamentals.mysql import readquery
    rows = readquery(
        log=log,
        sqlQuery=sqlQuery,
        dbConn=dbConn,
        quiet=False
    )
    ```

    """
    log.debug("starting the ``readquery`` function")
    import pymysql
    import warnings

    log.debug("\nSQLQUERY: %(sqlQuery)s}\n" % locals())

    try:
        cursor = dbConn.cursor(pymysql.cursors.DictCursor)
        # cursor = dbConn.SScursor(pymysql.cursors.SSDictCursor)
    except Exception as e:
        log.error("could not create the database cursor: %s" % (e,))
        raise IOError("could not create the database cursor: %s" % (e,))

    try:
        # SCOPE THE WARNINGS-AS-ERRORS FILTER TO THIS CALL ONLY
        with warnings.catch_warnings():
            warnings.filterwarnings("error", category=pymysql.Warning)
            rows = _execute_read_query(log, cursor, sqlQuery, quiet)
    finally:
        # CLOSE THE CURSOR ON EVERY PATH
        try:
            cursor.close()
        except Exception as e:
            log.warning("could not close the db cursor " + str(e) + "\n")

    log.debug("completed the ``readquery`` function")
    return rows


def _execute_read_query(log, cursor, sqlQuery, quiet):
    """*Run the read query (with retries and error handling) on an open cursor*

    **Key Arguments**

    - ``log`` -- the logger
    - ``cursor`` -- an open db cursor (closed by the caller)
    - ``sqlQuery`` -- the MySQL command to execute
    - ``quiet`` -- log MySQL errors and return no rows instead of raising

    **Return**

    - ``rows`` -- the rows returned by the sql query (empty if the error was ignored)
    """
    rows = []
    try:
        rows = _fetch_with_retries(log, cursor, sqlQuery)
    except Exception as e:
        sqlQuery = sqlQuery[:1000]
        log.warning(
            "MySQL raised an error - read command not executed.\n"
            + str(e)
            + "\nHere is the sqlQuery\n\t%(sqlQuery)s" % locals()
        )
        if quiet == False:
            raise

    return rows


def _fetch_with_retries(log, cursor, sqlQuery):
    """*Run the read query, retrying transient MySQL errors with a bounded backoff*

    Errors that are not transient, and transient errors that outlast the backoff, are raised.

    **Key Arguments**

    - ``log`` -- the logger
    - ``cursor`` -- an open db cursor
    - ``sqlQuery`` -- the MySQL command to execute

    **Return**

    - ``rows`` -- the rows returned by the sql query
    """
    delays = iter(RETRY_DELAYS)
    attempt = 1
    while True:
        try:
            cursor.execute(sqlQuery)
            return cursor.fetchall()
        except RETRYABLE_ERRORS as e:
            delay = next_retry_delay(e, delays)
            if delay is None:
                raise
            log.warning(
                f"Transient MySQL error: {e}. Retrying in {delay}s (attempt {attempt} failed)."
            )
            time.sleep(delay)
            attempt += 1
