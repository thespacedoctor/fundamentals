#!/usr/local/bin/python
# encoding: utf-8
"""
*Given a database connection and a database table name, return the column names for the table*

Author
: David Young
"""

from builtins import str
import os

os.environ["TERM"] = "vt100"
from fundamentals.mysql.sql_identifiers import quote_identifier


def get_database_table_column_names(dbConn, log, dbTable):
    """get database table column names

    **Key Arguments**

    - ``dbConn`` -- mysql database connection
    - ``log`` -- logger
    - ``dbTable`` -- database tablename


    **Return**

    - ``columnNames`` -- table column names (works for empty tables), or -1 if the names could not be read


    **Usage**

    To get the column names of a table in a given database:

    ```python
    from fundamentals.mysql import get_database_table_column_names
    columnNames = get_database_table_column_names(
        dbConn=dbConn,
        log=log,
        dbTable="test_table"
    )
    ```

    """
    log.debug("starting the ``get_database_table_column_names`` function")

    # LIMIT 0 RETURNS NO ROWS BUT STILL DESCRIBES THE COLUMNS (WORKS FOR EMPTY TABLES)
    try:
        sqlQuery = "SELECT * FROM %s LIMIT 0" % (quote_identifier(dbTable),)
        cursor = dbConn.cursor()
        try:
            cursor.execute(sqlQuery)
            columnNames = [column[0] for column in cursor.description]
        finally:
            cursor.close()
    except Exception as e:
        log.error(
            "could not find column names for dbTable %s - failed with this error: %s "
            % (dbTable, str(e))
        )
        return -1

    log.debug("completed the ``get_database_table_column_names`` function")
    return columnNames
