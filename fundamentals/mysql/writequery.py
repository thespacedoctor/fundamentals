#!/usr/local/bin/python
# encoding: utf-8
"""
*Execute a MySQL write query on a database table*

:Author:
    David Young

:Date Created:
    June 21, 2016
"""
################# GLOBAL IMPORTS ####################
import sys
import os
os.environ['TERM'] = 'vt100'
from fundamentals import tools
import time


def writequery(
    log,
    sqlQuery,
    dbConn,
    Force=False,
    manyValueList=False
):
    """*Execute a MySQL write command given a sql query*

    **Key Arguments:**
        - ``sqlQuery`` -- the MySQL command to execute
        - ``dbConn`` -- the db connection
        - ``Force`` -- do not exit code if error occurs, move onto the next command
        - ``manyValueList`` -- a list of value tuples if executing more than one insert

    **Return:**
        - ``message`` -- error/warning message

    **Usage:**

        Here's an example of how to create a table using the database connection passed to the function:

        .. code-block:: python 

            from fundamentals.mysql import writequery
            sqlQuery = "CREATE TABLE `testing_table` (`id` INT NOT NULL, PRIMARY KEY (`id`))"
            message = writequery(
                log=log,
                sqlQuery=sqlQuery,
                dbConn=dbConn,
                Force=False,
                manyValueList=False
            )

        Here's a many value insert example:

        .. code-block:: python 

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

    """
    log.info('starting the ``writequery`` function')
    import MySQLdb
    import warnings
    warnings.filterwarnings('error', category=MySQLdb.Warning)
    message = ""
    try:
        cursor = dbConn.cursor(MySQLdb.cursors.DictCursor)
    except Exception as e:
        log.error('could not create the database cursor.')
    # EXECUTE THE SQL COMMAND
    try:
        if manyValueList == False:
            cursor.execute(sqlQuery)
        else:
            # cursor.executemany(sqlQuery, manyValueList)
            # INSET LARGE LISTS IN BATCHES TO STOP MYSQL SERVER BARFING
            batch = 100000
            offset = 0
            stop = 0
            while stop == 0:
                thisList = manyValueList[offset:offset + batch]
                offset += batch
                a = len(thisList)
                cursor.executemany(sqlQuery, thisList)
                if len(thisList) < batch:
                    stop = 1

    except MySQLdb.Error as e:
        if e[0] == 1050 and 'already exists' in e[1]:
            log.info(str(e) + '\n')
        elif e[0] == 1062:
                           # Duplicate Key error
            log.debug('Duplicate Key error: %s' % (str(e), ))
            message = "duplicate key error"
        elif e[0] == 1061:
                           # Duplicate Key error
            log.debug('index already exists: %s' % (str(e), ))
            message = "index already exists"
        elif "Duplicate entry" in str(e):
            log.debug('Duplicate Key error: %s' % (str(e), ))
            message = "duplicate key error"
        else:
            sqlQueryTrim = sqlQuery[:1000]
            message = 'MySQL write command not executed for this query: << %s >>\nThe error was: %s ' % (sqlQuery,
                                                                                                         str(e))
            if Force == False:
                log.error(message)
                sys.exit(0)
            else:
                log.warning(message)
                return -1
    except MySQLdb.Warning as e:
        log.info(str(e))
    except Exception as e:
        if "truncated" in str(e):
            log.error('%s\n Here is the sqlquery:\n%s' % (str(e), sqlQuery))
            if manyValueList:
                log.error('... and the values:\n%s' % (thisList, ))
        elif "Duplicate entry" in str(e):
            log.debug('Duplicate Key error: %s' % (str(e), ))
            message = "duplicate key error"
        else:
            sqlQuery = sqlQuery[:2000]
            log.error(
                'MySQL write command not executed for this query: << %s >>\nThe error was: %s ' %
                (sqlQuery, str(e)))
            if Force == False:
                sys.exit(0)
            return -1
    # CLOSE THE CURSOR
    cOpen = True
    count = 0
    while cOpen:
        try:
            cursor.close()
            cOpen = False
        except Exception as e:
            time.sleep(1)
            count += 1
            if count == 10:
                log.warning('could not close the db cursor ' + str(e) + '\n')
                raise e
                count = 0

    log.info('completed the ``writequery`` function')
    return message
