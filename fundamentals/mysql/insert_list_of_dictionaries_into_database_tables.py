#!/usr/local/bin/python
# encoding: utf-8
"""
*Given a list of dictionaries this function will insert each dictionary as a row into the given database table*

Author
: David Young
"""

from __future__ import print_function
from __future__ import division
from datetime import datetime
from fundamentals.mysql.database import database
import re
from fundamentals.fmultiprocess import fmultiprocess
from fundamentals.mysql import convert_dictionary_to_mysql_table, writequery
from fundamentals.mysql.sql_identifiers import (
    normalise_column_name,
    quote_identifier,
    quote_identifier_for_format,
    raise_on_duplicate_columns,
)
from fundamentals.mysql.sql_values import null_if_missing
from builtins import str
from builtins import range
import sys
import os
import tempfile

os.environ["TERM"] = "vt100"


count = 0
totalCount = 0
globalDbConn = False
sharedList = []

# MESSAGES FROM writequery THAT ARE EXPECTED WHEN USING INSERT IGNORE
BENIGN_WRITE_MESSAGES = ("", "duplicate key error")


_normalise_key = normalise_column_name


def _map_keys_to_columns(rows):
    """*map every key used in a list of dictionaries to its database column name*

    **Return**

    - ``originalKeys`` -- the sorted, de-duplicated keys of all the dictionaries
    - ``columnNames`` -- the database column name for each key, in the same order
    """
    originalKeys = sorted(set().union(*(list(d.keys()) for d in rows)), key=str)
    raise_on_duplicate_columns(originalKeys)
    return originalKeys, [_normalise_key(k) for k in originalKeys]


def _restore_autocommit(dbConn, originalAutocommit, log, isErrorInFlight=False):
    """*restore the caller's autocommit setting*

    If ``isErrorInFlight`` is True a failed restore is logged so it cannot mask the error being raised. Otherwise a failed restore is raised.
    """
    import pymysql

    try:
        dbConn.autocommit(originalAutocommit)
    except pymysql.Error as e:
        if not isErrorInFlight:
            raise
        log.warning("could not restore the autocommit setting: %s" % (e,))


def _require_stats_dependencies():
    """*import numpy and pandas in the calling process, so forked workers inherit them*

    Importing them for the first time inside a forked worker can abort the interpreter on macOS.

    Raises ``ImportError`` naming the ``stats`` extra if either is missing.
    """
    try:
        import numpy  # noqa: F401
        import pandas  # noqa: F401
    except ImportError as e:
        raise ImportError(
            "loading rows with LOAD DATA needs numpy and pandas: "
            "install them with `pip install fundamentals[stats]`"
        ) from e


def insert_list_of_dictionaries_into_database_tables(
    dbConn,
    log,
    dictList,
    dbTableName,
    uniqueKeyList=None,
    dateModified=False,
    dateCreated=True,
    batchSize=2500,
    replace=False,
    dbSettings=False,
):
    """insert list of dictionaries into database tables

    **Key Arguments**

    - ``dbConn`` -- mysql database connection
    - ``log`` -- logger
    - ``dictList`` -- list of python dictionaries to add to the database table
    - ``dbTableName`` -- name of the database table
    - ``uniqueKeyList`` -- a list of column names to append as a unique constraint on the database
    - ``dateModified`` -- add the modification date as a column in the database
    - ``dateCreated`` -- add the created date as a column in the database
    - ``batchSize`` -- batch the insert commands into *batchSize* batches
    - ``replace`` -- replace row if a duplicate is found
    - ``dbSettings`` -- pass in the database settings so multiprocessing can establish one connection per process (might not be faster)


    **Return**

    - None


    **Usage**

    ```python
    from fundamentals.mysql import insert_list_of_dictionaries_into_database_tables
    insert_list_of_dictionaries_into_database_tables(
        dbConn=dbConn,
        log=log,
        dictList=dictList,
        dbTableName="test_insert_many",
        uniqueKeyList=["col1", "col3"],
        dateModified=False,
        batchSize=2500
    )
    ```

    """

    log.debug(
        "starting the ````insert_list_of_dictionaries_into_database_tables`` function"
    )

    if uniqueKeyList is None:
        uniqueKeyList = []

    global count
    global totalCount
    global globalDbConn
    global sharedList

    reDate = re.compile("^[0-9]{4}-[0-9]{2}-[0-9]{2}T")

    if dbSettings:
        globalDbConn = dbSettings
    else:
        globalDbConn = dbConn

    if len(dictList) == 0:
        log.warning("the dictionary to be added to the database is empty" % locals())
        return None

    if len(dictList):
        convert_dictionary_to_mysql_table(
            dbConn=dbConn,
            log=log,
            dictionary=dictList[0],
            dbTableName=dbTableName,
            uniqueKeyList=uniqueKeyList,
            dateModified=dateModified,
            reDatetime=reDate,
            replace=replace,
            dateCreated=dateCreated,
        )
        dictList = dictList[1:]

    # THE CALLER'S AUTOCOMMIT SETTING IS RESTORED WHEN THE INSERTS END
    originalAutocommit = dbConn.get_autocommit()
    dbConn.autocommit(False)
    try:
        if len(dictList):

            total = len(dictList)
            batches = -(-total // batchSize)

            start = 0
            end = 0
            sharedList = []
            for i in range(batches):
                end = end + batchSize
                start = i * batchSize
                thisBatch = dictList[start:end]
                sharedList.append((thisBatch, end))

            totalCount = total + 1
            ltotalCount = totalCount

            print(
                "Starting to insert %(ltotalCount)s rows into %(dbTableName)s"
                % locals()
            )

            if dbSettings == False:
                fmultiprocess(
                    log=log,
                    function=_insert_single_batch_into_database,
                    inputArray=list(range(len(sharedList))),
                    dbTableName=dbTableName,
                    uniqueKeyList=uniqueKeyList,
                    dateModified=dateModified,
                    replace=replace,
                    batchSize=batchSize,
                    reDatetime=reDate,
                    dateCreated=dateCreated,
                    # FORKED WORKERS WOULD SHARE THE CALLER'S SINGLE CONNECTION, SO RUN IN THIS PROCESS
                    turnOffMP=True,
                )

            else:
                _require_stats_dependencies()
                fmultiprocess(
                    log=log,
                    function=_add_dictlist_to_database_via_load_in_file,
                    inputArray=list(range(len(sharedList))),
                    dbTablename=dbTableName,
                    dbSettings=dbSettings,
                    dateModified=dateModified,
                    replace=replace,
                    turnOffMP=False,
                    progressBar=True,
                )

            sys.stdout.write("\x1b[1A\x1b[2K")
            print(
                "%(ltotalCount)s / %(ltotalCount)s rows inserted into %(dbTableName)s"
                % locals()
            )
    except BaseException:
        _restore_autocommit(dbConn, originalAutocommit, log, isErrorInFlight=True)
        raise
    _restore_autocommit(dbConn, originalAutocommit, log)

    log.debug(
        "completed the ``insert_list_of_dictionaries_into_database_tables`` function"
    )
    return None


def _insert_rows_individually(
    rows, dbConn, log, dbTableName, uniqueKeyList, dateModified, replace, reDatetime
):
    """*insert each row with its own insert command, grouping rows that share a command*

    **Return**

    - the first message from writequery that is not benign, or an empty string
    """
    insertsByCommand = {}
    for aDict in rows:
        insertCommand, valueTuple = convert_dictionary_to_mysql_table(
            dbConn=dbConn,
            log=log,
            dictionary=aDict,
            dbTableName=dbTableName,
            uniqueKeyList=uniqueKeyList,
            dateModified=dateModified,
            returnInsertOnly=True,
            replace=replace,
            reDatetime=reDatetime,
            skipChecks=True,
        )
        insertsByCommand.setdefault(insertCommand, []).append(valueTuple)

    for insertCommand, valueTuples in insertsByCommand.items():
        message = writequery(
            log=log,
            sqlQuery=insertCommand,
            dbConn=dbConn,
            Force=True,
            manyValueList=valueTuples,
        )
        if message not in BENIGN_WRITE_MESSAGES:
            return message
    return ""


def _build_batch_insert_command(dbTableName, columns, replace, dateCreated):
    """*build the multi-row insert command, with ``%s`` placeholders for the values*

    Every identifier is quoted, and ``%`` inside an identifier is doubled because pymysql formats the command afterwards.
    The exception is the ``ON DUPLICATE KEY UPDATE`` tail when the values are only placeholders: pymysql then batches the rows and sends that tail as it is, so ``%`` stays single.

    **Key Arguments**

    - ``dbTableName`` -- the table to insert into
    - ``columns`` -- the column names, in the order of the values
    - ``replace`` -- update the row if a duplicate key is found?
    - ``dateCreated`` -- also fill the dateCreated column?

    **Return**

    - ``insertCommand`` -- the command to hand to writequery
    """
    quotedColumns = [quote_identifier_for_format(c) for c in columns]
    placeholders = ", ".join(["%s"] * len(columns))
    insertCommand = "INSERT IGNORE INTO %s (%s%s) VALUES (%s%s)" % (
        quote_identifier_for_format(dbTableName),
        ",".join(quotedColumns),
        ", dateCreated" if dateCreated else "",
        placeholders,
        ", NOW()" if dateCreated else "",
    )
    if replace:
        # PYMYSQL ONLY FORMATS THE TAIL WHEN IT CANNOT BATCH THE ROWS (NOW() IN THE VALUES)
        tailColumns = quotedColumns
        if not dateCreated:
            tailColumns = [quote_identifier(c) for c in columns]
        assignments = ["%s=VALUES(%s)" % (c, c) for c in tailColumns]
        assignments += ["updated=1", "dateLastModified=NOW()"]
        insertCommand += " ON DUPLICATE KEY UPDATE " + ", ".join(assignments)
    return insertCommand


def _insert_single_batch_into_database(
    batchIndex,
    log,
    dbTableName,
    uniqueKeyList,
    dateModified,
    replace,
    batchSize,
    reDatetime,
    dateCreated,
):
    """*summary of function*

    **Key Arguments**

    - ``batchIndex`` -- the index of the batch to insert
    - ``dbConn`` -- mysql database connection
    - ``log`` -- logger


    **Return**

    - None


    **Usage**

    .. todo::

        add usage info
        create a sublime snippet for usage

    ```python
    usage code
    ```

    """
    log.debug("starting the ``_insert_single_batch_into_database`` function")

    global totalCount
    global globalDbConn
    global sharedList

    batch = sharedList[batchIndex]

    reDate = reDatetime

    if isinstance(globalDbConn, dict):
        # SETUP ALL DATABASE CONNECTIONS

        dbConn = database(log=log, dbSettings=globalDbConn, autocommit=False).connect()
    else:
        dbConn = globalDbConn

    count = batch[1]
    if count > totalCount:
        count = totalCount
    ltotalCount = totalCount

    import pymysql

    # MAP EACH ORIGINAL KEY TO ITS COLUMN NAME; KEYS MISSING FROM A ROW BECOME NULL
    originalKeys, uniKeys = _map_keys_to_columns(batch[0])

    vals = [tuple([null_if_missing(d.get(k)) for k in originalKeys]) for d in batch[0]]
    insertCommand = _build_batch_insert_command(
        dbTableName, uniKeys, replace, dateCreated
    )

    try:
        message = writequery(
            log=log,
            sqlQuery=insertCommand,
            dbConn=dbConn,
            Force=True,
            manyValueList=vals,
        )
    except pymysql.Error:
        message = _insert_rows_individually(
            batch[0],
            dbConn,
            log,
            dbTableName,
            uniqueKeyList,
            dateModified,
            replace,
            reDate,
        )

    if message not in BENIGN_WRITE_MESSAGES:
        error = "could not insert a batch of rows into %s: %s" % (dbTableName, message)
        log.error(error)
        raise RuntimeError(error)

    dbConn.commit()

    log.debug("completed the ``_insert_single_batch_into_database`` function")
    return "None"


def _add_dictlist_to_database_via_load_in_file(
    masterListIndex, log, dbTablename, dbSettings, dateModified=False, replace=False
):
    """*load a list of dictionaries into a database table with load data infile*

    **Key Arguments**

    - ``masterListIndex`` -- the index of the sharedList of dictionary lists to process
    - ``log`` -- logger
    - ``dbTablename`` -- the name of the database table to add the list to
    - ``dbSettings`` -- the dictionary of database settings
    - ``dateModified`` -- add a dateModified stamp with an updated flag to rows?
    - ``replace`` -- update rows that already exist? If False, duplicates are skipped


    **Return**

    - None

    """
    global sharedList

    import numpy as np
    import pandas as pd
    import random

    log.debug("starting the ``_add_dictlist_to_database_via_load_in_file`` function")

    dictList = sharedList[masterListIndex][0]
    originalKeys, columns = _map_keys_to_columns(dictList)

    now = datetime.now()
    rand = random.randint(0, 10000)
    tmpTable = now.strftime(f"tmp_%Y%m%dt%H%M%S%f{rand}")
    quotedTmpTable = quote_identifier(tmpTable)
    quotedTable = quote_identifier(dbTablename)

    df = pd.DataFrame(dictList)
    # THE SAME NULL RULE AS null_if_missing, PLUS NAN (A PANDAS NAN MEANS MISSING)
    df.replace(["", np.nan, None], "\\N", inplace=True)

    # SETUP ALL DATABASE CONNECTIONS
    dbConn = database(log=log, dbSettings=dbSettings).connect()
    try:
        # CREATE A TEMPORY TABLE TO ADD DATA TO
        sqlQuery = (
            "CREATE TEMPORARY TABLE %(quotedTmpTable)s SELECT * FROM %(quotedTable)s WHERE 1=0;"
            % locals()
        )
        writequery(log=log, sqlQuery=sqlQuery, dbConn=dbConn)

        sqlQuery = "ALTER TABLE %(quotedTmpTable)s DISABLE KEYS;" % locals()
        writequery(log=log, sqlQuery=sqlQuery, dbConn=dbConn)

        _load_dataframe_into_table(
            log, dbConn, df, originalKeys, columns, tmpTable, quotedTmpTable
        )

        updateClause = _build_update_clause(columns, dateModified) if replace else ""
        sqlQuery = """
INSERT IGNORE INTO %(quotedTable)s
SELECT * FROM %(quotedTmpTable)s%(updateClause)s;""" % locals()
        writequery(log=log, sqlQuery=sqlQuery, dbConn=dbConn)

        sqlQuery = "DROP TEMPORARY TABLE %(quotedTmpTable)s;" % locals()
        writequery(log=log, sqlQuery=sqlQuery, dbConn=dbConn)

        dbConn.commit()
    finally:
        dbConn.close()

    log.debug("completed the ``_add_dictlist_to_database_via_load_in_file`` function")
    return None


def _load_dataframe_into_table(
    log, dbConn, df, originalKeys, columns, tmpTable, quotedTmpTable
):
    """*write a dataframe to a scratch csv file and LOAD DATA it into the temporary table*"""
    with tempfile.TemporaryDirectory(prefix="fundamentals-load-") as tmpDir:
        csvPath = os.path.join(tmpDir, tmpTable + ".csv")
        df.to_csv(
            csvPath,
            sep="|",
            index=False,
            quotechar='"',
            columns=originalKeys,
            encoding="utf-8",
        )

        # A BACKSLASH IS READ DIFFERENTLY DEPENDING ON THE SERVER'S NO_BACKSLASH_ESCAPES
        # MODE, SO REFUSE SUCH PATHS; DOUBLED QUOTES ARE SAFE IN EVERY MODE
        if "\\" in csvPath:
            raise ValueError(
                "the temporary CSV path contains a backslash and cannot be used in LOAD DATA: %s"
                % csvPath
            )
        sqlCsvPath = csvPath.replace("'", "''")
        csvColumnsString = ", ".join(quote_identifier(c) for c in columns)
        sqlQuery = """LOAD DATA LOCAL INFILE '%(sqlCsvPath)s'
INTO TABLE %(quotedTmpTable)s
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES
(%(csvColumnsString)s);""" % locals()
        writequery(log=log, sqlQuery=sqlQuery, dbConn=dbConn)


def _build_update_clause(columns, dateModified):
    """*return the ON DUPLICATE KEY UPDATE clause that overwrites duplicates with the new values*"""
    assignments = [
        "%(c)s = VALUES(%(c)s)" % {"c": quote_identifier(column)} for column in columns
    ]
    if dateModified:
        assignments.append("dateLastModified = NOW()")
        assignments.append("updated = 1")
    return "\nON DUPLICATE KEY UPDATE " + ", ".join(assignments)


# use the tab-trigger below for new function
# xt-def-function
