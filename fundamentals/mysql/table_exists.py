#!/usr/local/bin/python
# encoding: utf-8
"""
*Probe a database to determine if a given table exists*

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
from fundamentals.mysql import readquery


def table_exists(
        dbConn,
        log,
        dbTableName):
    """*Probe a database to determine if a given table exists*

    **Key Arguments:**
        - ``dbConn`` -- mysql database connection
        - ``log`` -- logger
        - ``dbTableName`` -- the database tablename

    **Return:**
        - ``tableExists`` -- True or False

    **Usage:**

        To test if a table exists in a database:

        .. code-block:: python 

            from fundamentals.mysql import table_exists
            exists = table_exists(
                dbConn=dbConn,
                log=log,
                dbTableName="stupid_named_table"
            )

            print exists

            # OUTPUT: False
    """
    log.info('starting the ``table_exists`` function')

    sqlQuery = u"""
        SELECT count(*)
        FROM information_schema.tables
        WHERE table_name = '%(dbTableName)s'
    """ % locals()
    tableExists = readquery(
        log=log,
        sqlQuery=sqlQuery,
        dbConn=dbConn,
        quiet=False
    )

    if tableExists[0]["count(*)"] == 0:
        tableExists = False
    else:
        tableExists = True

    log.info('completed the ``table_exists`` function')
    return tableExists
