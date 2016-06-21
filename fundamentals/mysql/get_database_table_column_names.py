#!/usr/local/bin/python
# encoding: utf-8
"""
*Given a database connection and a database table name, return the column names for the table*

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


def get_database_table_column_names(
    dbConn,
    log,
    dbTable
):
    """get database table column names

    **Key Arguments:**
        - ``dbConn`` -- mysql database connection
        - ``log`` -- logger
        - ``dbTable`` -- database tablename

    **Return:**
        - ``columnNames`` -- table column names

    **Usage:**

        To get the column names of a table in a given database:

        .. code-block:: python 

            from fundamentals.mysql import get_database_table_column_names
            columnNames = get_database_table_column_names(
                dbConn=dbConn,
                log=log,
                dbTable="test_table"
            )
    """
    log.info('starting the ``get_database_table_column_names`` function')

    sqlQuery = """SELECT * FROM %s LIMIT 1""" \
        % (dbTable, )
    # ############### >ACTION(S) ################
    try:
        rows = readquery(
            log=log,
            sqlQuery=sqlQuery,
            dbConn=dbConn,
        )
    except Exception as e:
        log.error(
            'could not find column names for dbTable %s - failed with this error: %s ' %
            (dbTable, str(e)))
        return -1
    columnNames = rows[0].keys()

    log.info('completed the ``get_database_table_column_names`` function')
    return columnNames
