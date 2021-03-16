#!/usr/local/bin/python
# encoding: utf-8
"""
*Given a mysql query, read the data from the database and return the results as a list of dictionaries (database rows)*

:Author:
    David Young
"""
from builtins import str
import sys
import os
os.environ['TERM'] = 'vt100'
from fundamentals import tools


def readquery(
        sqlQuery,
        dbConn,
        log,
        quiet=False):
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
    log.debug('starting the ``readquery`` function')
    import pymysql
    import warnings
    warnings.filterwarnings('error', category=pymysql.Warning)

    rows = []

    log.debug("\nSQLQUERY: %(sqlQuery)s}\n" % locals())

    try:
        cursor = dbConn.cursor(pymysql.cursors.DictCursor)
    except Exception as e:
        log.error('could not create the database cursor: %s' % (e, ))
        raise IOError('could not create the database cursor: %s' % (e, ))
    # EXECUTE THE SQL COMMAND
    tryAgain = True
    tries = 1
    while tryAgain:
        tryAgain = False
        try:
            cursor.execute(sqlQuery)
            rows = cursor.fetchall()
        except pymysql.err.InternalError as e:
            if tries < 61:
                tryAgain = True
                log.warning(f"MySQL error: {e}. Attempt {tries}/60.")
                tries += 1
            else:
                log.warning(f"MySQL error: {e}. Attempt {tries}/60 failed. ")
                raise
        except Exception as e:
            sqlQuery = sqlQuery[:1000]
            if quiet == False:
                log.warning(
                    'MySQL raised an error - read command not executed.\n' + str(e) + '\nHere is the sqlQuery\n\t%(sqlQuery)s' % locals())
                raise e
            else:
                log.warning(
                    'MySQL raised an error - read command not executed.\n' + str(e) + '\nHere is the sqlQuery\n\t%(sqlQuery)s' % locals())
                pass

    # CLOSE THE CURSOR
    try:
        cursor.close()
    except Exception as e:
        log.warning('could not close the db cursor ' + str(e) + '\n')

    log.debug('completed the ``readquery`` function')
    return rows
