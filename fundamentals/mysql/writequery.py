#!/usr/local/bin/python
# encoding: utf-8
"""
*Execute a MySQL write query on a database table*

Author
: David Young
"""

from builtins import str
import os

os.environ["TERM"] = "vt100"
from fundamentals import tools
from fundamentals.mysql._retry import RETRY_DELAYS, RETRYABLE_ERRORS, next_retry_delay
import time

# ROWS SENT PER COMMIT WHEN INSERTING A LIST OF VALUES, TO STOP MYSQL SERVER BARFING
INSERT_BATCH_SIZE = 100000


def writequery(log, sqlQuery, dbConn, Force=False, manyValueList=False):
    """*Execute a MySQL write command given a sql query*

    **Key Arguments**

    - ``sqlQuery`` -- the MySQL command to execute
    - ``dbConn`` -- the db connection
    - ``Force`` -- do not exit code if error occurs, move onto the next command
    - ``manyValueList`` -- a list of value tuples if executing more than one insert


    **Return**

    - ``message`` -- error/warning message


    **Usage**

    Here's an example of how to create a table using the database connection passed to the function:

    ```python
    from fundamentals.mysql import writequery
    sqlQuery = "CREATE TABLE `testing_table` (`id` INT NOT NULL, PRIMARY KEY (`id`))"
    message = writequery(
        log=log,
        sqlQuery=sqlQuery,
        dbConn=dbConn,
        Force=False,
        manyValueList=False
    )
    ```

    Here's a many value insert example:

    ```python
    from fundamentals.mysql import writequery
    sqlQuery = "INSERT INTO testing_table (id) values (%s)"
    message = writequery(
        log=log,
        sqlQuery=sqlQuery,
        dbConn=dbConn,
        Force=False,
        manyValueList=[(1,), (2,), (3,), (4,), (5,), (6,), (7,),
                       (8,), (9,), (10,), (11,), (12,), ]
    )
    ```

    """
    log.debug("starting the ``writequery`` function")
    import pymysql
    import warnings

    try:
        cursor = dbConn.cursor(pymysql.cursors.DictCursor)
    except Exception as e:
        log.error("could not create the database cursor.")
        raise

    try:
        # SCOPE THE WARNINGS-AS-ERRORS FILTER TO THIS CALL ONLY
        with warnings.catch_warnings():
            warnings.filterwarnings("error", category=pymysql.Warning)
            message = _execute_write_query(
                log, cursor, sqlQuery, dbConn, Force, manyValueList
            )
    finally:
        # CLOSE THE CURSOR ON EVERY PATH, WITHOUT MASKING ANY IN-FLIGHT ERROR
        try:
            cursor.close()
        except Exception as e:
            log.warning("could not close the db cursor " + str(e) + "\n")

    log.debug("completed the ``writequery`` function")
    return message


def _execute_write_query(log, cursor, sqlQuery, dbConn, Force, manyValueList):
    """*Run the write query (with retries and error handling) on an open cursor*

    **Key Arguments**

    - ``log`` -- the logger
    - ``cursor`` -- an open db cursor (closed by the caller)
    - ``sqlQuery`` -- the MySQL command to execute
    - ``dbConn`` -- the db connection
    - ``Force`` -- do not raise if an error occurs, move onto the next command
    - ``manyValueList`` -- a list of value tuples if executing more than one insert

    **Return**

    - ``message`` -- error/warning message, or -1 if a non-MySQL error was forced past
    """
    import pymysql

    message = ""
    # EXECUTE THE SQL COMMAND
    log.debug("\nSQLQUERY: %(sqlQuery)s}\n" % locals())
    if sqlQuery.endswith(","):
        sqlQuery = sqlQuery[:-1]

    try:
        _send_with_retries(log, cursor, sqlQuery, dbConn, manyValueList)
    except pymysql.err.ProgrammingError as e:
        message = (
            "MySQL write command not executed for this query: << %s >>\nThe error was: %s \n"
            % (sqlQuery, str(e))
        )
        if Force == False:
            log.error(message)
            raise
        else:
            log.warning(message)
    except pymysql.Error as e:
        try:
            e = e.args
        except:
            pass

        if e[0] == 1050 and "already exists" in e[1]:
            log.info(str(e) + "\n")
        elif e[0] == 1062:
            # Duplicate Key error
            log.debug("Duplicate Key error: %s\n" % (str(e),))
            message = "duplicate key error"
        elif e[0] == 1061:
            # Duplicate Key error
            log.debug("index already exists: %s\n" % (str(e),))
            message = "index already exists"
        elif "Duplicate entry" in str(e):
            log.debug("Duplicate Key error: %s\n" % (str(e),))
            message = "duplicate key error"
        else:
            message = (
                "MySQL write command not executed for this query: << %s >>\nThe error was: %s \n"
                % (sqlQuery, str(e))
            )
            if Force == False:
                log.error(message)
                raise
            else:
                log.warning(message)

    except pymysql.Warning as e:
        log.info(str(e))
    except Exception as e:
        if "truncated" in str(e):
            log.error("%s\n Here is the sqlquery:\n%s\n" % (str(e), sqlQuery))
            if manyValueList:
                log.error(
                    "... and the first batch of values:\n%s\n"
                    % (manyValueList[:INSERT_BATCH_SIZE],)
                )
        elif "Duplicate entry" in str(e):
            log.warning("Duplicate Key error: %s\n" % (str(e),))
            message = "duplicate key error"
        else:
            log.error(
                "MySQL write command not executed for this query: << %s >>\nThe error was: %s \n"
                % (sqlQuery, str(e))
            )
            if Force == False:
                raise
            return -1
    dbConn.commit()
    return message


def _send_with_retries(log, cursor, sqlQuery, dbConn, manyValueList):
    """*Send the write query, retrying transient MySQL errors with a bounded backoff*

    Errors that are not transient, and transient errors that outlast the backoff, are raised.

    **Key Arguments**

    - ``log`` -- the logger
    - ``cursor`` -- an open db cursor
    - ``sqlQuery`` -- the MySQL command to execute
    - ``dbConn`` -- the db connection
    - ``manyValueList`` -- a list of value tuples if executing more than one insert
    """
    delays = iter(RETRY_DELAYS)
    # BATCHES ALREADY COMMITTED ARE NEVER SENT AGAIN WHEN A LATER BATCH IS RETRIED
    progress = {"committedRows": 0}
    attempt = 1
    while True:
        try:
            if manyValueList == False:
                cursor.execute(sqlQuery)
            else:
                _insert_in_batches(cursor, sqlQuery, dbConn, manyValueList, progress)
            return
        except RETRYABLE_ERRORS as e:
            delay = next_retry_delay(e, delays)
            if delay is None:
                raise
            log.warning(
                f"Transient MySQL error: {e}. Retrying in {delay}s (attempt {attempt} failed)."
            )
            time.sleep(delay)
            attempt += 1


def _insert_in_batches(cursor, sqlQuery, dbConn, manyValueList, progress):
    """*Insert the value list in committed batches, resuming after the last committed batch*

    **Key Arguments**

    - ``cursor`` -- an open db cursor
    - ``sqlQuery`` -- the MySQL command to execute
    - ``dbConn`` -- the db connection
    - ``manyValueList`` -- a list of value tuples
    - ``progress`` -- dictionary holding ``committedRows``, updated after each commit
    """
    while True:
        offset = progress["committedRows"]
        thisList = manyValueList[offset : offset + INSERT_BATCH_SIZE]
        cursor.executemany(sqlQuery, thisList)
        dbConn.commit()
        progress["committedRows"] = offset + len(thisList)
        if len(thisList) < INSERT_BATCH_SIZE:
            return
