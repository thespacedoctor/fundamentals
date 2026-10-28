#!/usr/local/bin/python
# encoding: utf-8
"""
*Given a mysql query, read the data from the database and return the results as a list of dictionaries (database rows)*

Author
: David Young
"""

from fundamentals.mysql._log_safety import describe_error, redact_sql_literals
from fundamentals.mysql._retry import run_with_retries
from builtins import str
import os

os.environ["TERM"] = "vt100"

# LONGEST QUERY, IN CHARACTERS, WRITTEN TO THE LOG WHEN A READ FAILS
MAX_LOGGED_QUERY_LENGTH = 1000


def readquery(sqlQuery, dbConn, log, quiet=False):
    """Given a mysql query, read the data from the database and return the results as a list of dictionaries (database rows)

    **Key Arguments**

    - ``log`` -- the logger.
    - ``sqlQuery`` -- the MySQL command to execute
    - ``dbConn`` -- the db connection
    - ``quiet`` -- ignore mysql warnings and errors and move on. Be careful when setting this to true - damaging errors can easily be missed. Default *False*.


    **Return**

    - ``rows`` -- the rows returned by the sql query


    Logs hold the error class and MySQL error code, not the error text. An exception that is raised still carries the original server message, which may contain data values, so do not log it verbatim.

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

    log.debug("\nSQLQUERY: %s\n" % (redact_sql_literals(sqlQuery),))

    try:
        cursor = dbConn.cursor(pymysql.cursors.DictCursor)
        # cursor = dbConn.SScursor(pymysql.cursors.SSDictCursor)
    except Exception as e:
        message = "could not create the database cursor: %s" % (describe_error(e),)
        log.error(message)
        raise IOError(message)

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
            log.warning("could not close the db cursor: %s\n" % (describe_error(e),))

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
        rows = run_with_retries(log, lambda: _fetch_rows(cursor, sqlQuery))
    except Exception as e:
        loggedQuery = redact_sql_literals(sqlQuery)[:MAX_LOGGED_QUERY_LENGTH]
        log.warning(
            "MySQL raised an error - read command not executed.\n%s\nHere is the sqlQuery\n\t%s"
            % (describe_error(e), loggedQuery)
        )
        if quiet == False:
            raise

    return rows


def _fetch_rows(cursor, sqlQuery):
    """*Run the read query once and return its rows*

    **Key Arguments**

    - ``cursor`` -- an open db cursor
    - ``sqlQuery`` -- the MySQL command to execute

    **Return**

    - ``rows`` -- the rows returned by the sql query
    """
    cursor.execute(sqlQuery)
    return cursor.fetchall()
