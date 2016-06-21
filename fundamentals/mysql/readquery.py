#!/usr/local/bin/python
# encoding: utf-8
"""
*Given a mysql query, read the data from the database and return the results as a list of dictionaries (database rows)*

:Author:
    David Young

:Date Created:
    June 21, 2016
"""
################# GLOBAL IMPORTS ####################
import sys
import os
import MySQLdb
import warnings
warnings.filterwarnings('error', category=MySQLdb.Warning)
os.environ['TERM'] = 'vt100'
from fundamentals import tools


def readquery(
        sqlQuery,
        dbConn,
        log,
        quiet=False):
    """readquery

    **Key Arguments:**
        - ``log`` -- the logger.
        - ``sqlQuery`` -- the MySQL command to execute
        - ``dbConn`` -- the db connection
        - ``quiet`` -- ignore mysql warnings and errors and move on. Be careful when setting this to true - damaging errors can easily be missed. Default *False*.

    **Return:**
        - ``rows`` -- the rows returned by the sql query

    **Usage:**

        .. code-block:: python 

            from fundamentals.mysql import readquery
            rows = readquery(
                log=log,
                sqlQuery=sqlQuery,
                dbConn=dbConn,
                quiet=False
            )
    """
    log.info('starting the ``readquery`` function')

    rows = []

    try:
        cursor = dbConn.cursor(MySQLdb.cursors.DictCursor)
    except Exception as e:
        log.error('could not create the database cursor: %s' % (e, ))
        raise IOError('could not create the database cursor: %s' % (e, ))
    # EXECUTE THE SQL COMMAND
    try:
        cursor.execute(sqlQuery)
        rows = cursor.fetchall()
    except Exception as e:
        sqlQuery = sqlQuery[:1000]
        if quiet == False:
            log.error(
                'MySQL raised an error - read command not executed.\n' + str(e) + '\nHere is the sqlQuery\n\t%(sqlQuery)s' % locals())
            raise e
    # CLOSE THE CURSOR
    try:
        cursor.close()
    except Exception as e:
        log.warning('could not close the db cursor ' + str(e) + '\n')

    log.info('completed the ``readquery`` function')
    return rows
