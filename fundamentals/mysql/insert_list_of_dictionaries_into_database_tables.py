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
import time
from fundamentals.fmultiprocess import fmultiprocess
from fundamentals.mysql import convert_dictionary_to_mysql_table, writequery
from fundamentals import tools
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


def _normalise_key(key):
    """*return the database column name for a dictionary key*"""
    formattedKey = str(key).replace(" ", "_").replace("-", "_")
    # DEC IS A KEYWORD IN MYSQL - MATCHES THE RENAME IN convert_dictionary_to_mysql_table
    if formattedKey == "dec":
        formattedKey = "decl"
    if formattedKey == "DEC":
        formattedKey = "DECL"
    return formattedKey


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
        # FIND BUG IN MYSQL QUERY BY UNCOMMENTING
        # tot = len(dictList)
        # for index, d in enumerate(dictList):
        #     if index > 1:
        #         # Cursor up one line and clear line
        #         sys.stdout.write("\x1b[1A\x1b[2K")

        #     percent = (float(index) / float(tot)) * 100.
        #     print('%(index)s/%(tot)s (%(percent)1.1f%% done)' % locals())

        #     convert_dictionary_to_mysql_table(
        #         dbConn=dbConn,
        #         log=log,
        #         dictionary=d,
        #         dbTableName=dbTableName,
        #         uniqueKeyList=uniqueKeyList,
        #         dateModified=dateModified,
        #         reDatetime=reDate,
        #         replace=replace,
        #         dateCreated=dateCreated)

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
                fmultiprocess(
                    log=log,
                    function=_add_dictlist_to_database_via_load_in_file,
                    inputArray=list(range(len(sharedList))),
                    dbTablename=dbTableName,
                    dbSettings=dbSettings,
                    dateModified=dateModified,
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

    if not replace:
        insertVerb = "INSERT IGNORE"
    else:
        insertVerb = "INSERT IGNORE"

    # MAP EACH ORIGINAL KEY TO ITS COLUMN NAME; KEYS MISSING FROM A ROW BECOME NULL
    originalKeys = sorted(set().union(*(list(d.keys()) for d in batch[0])), key=str)
    uniKeys = [_normalise_key(k) for k in originalKeys]

    myKeys = "`,`".join(uniKeys)
    vals = [
        tuple([None if d.get(k) in ["None", None] else d[k] for k in originalKeys])
        for d in batch[0]
    ]
    valueString = ("%s, " * len(vals[0]))[:-2]
    insertCommand = (
        insertVerb
        + """ INTO `"""
        + dbTableName
        + """` (`"""
        + myKeys
        + """`, dateCreated) VALUES ("""
        + valueString
        + """, NOW())"""
    )

    if not dateCreated:
        insertCommand = insertCommand.replace(", dateCreated)", ")").replace(
            ", NOW())", ")"
        )

    dup = ""
    if replace:
        dup = " ON DUPLICATE KEY UPDATE "
        for k in uniKeys:
            dup = """%(dup)s %(k)s=values(%(k)s),""" % locals()
        dup = """%(dup)s updated=1, dateLastModified=NOW()""" % locals()

    insertCommand = insertCommand + dup

    insertCommand = insertCommand.replace('\\""', '\\" "')
    insertCommand = insertCommand.replace('""', "null")
    insertCommand = insertCommand.replace('"None"', "null")

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
    masterListIndex, dbTablename, dbSettings, dateModified=False
):
    """*load a list of dictionaries into a database table with load data infile*

    **Key Arguments**

    - ``masterListIndex`` -- the index of the sharedList of dictionary lists to process
    - ``dbTablename`` -- the name of the database table to add the list to
    - ``dbSettings`` -- the dictionary of database settings
    - ``log`` -- logger
    - ``dateModified`` -- add a dateModified stamp with an updated flag to rows?


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
    global sharedList

    from fundamentals.logs import emptyLogger
    import numpy as np
    import pandas as pd

    log = emptyLogger()
    log.debug("starting the ``_add_dictlist_to_database_via_load_in_file`` function")

    dictList = sharedList[masterListIndex][0]

    count = sharedList[masterListIndex][1]
    if count > totalCount:
        count = totalCount
    ltotalCount = totalCount

    # SETUP ALL DATABASE CONNECTIONS
    dbConn = database(log=log, dbSettings=dbSettings).connect()

    now = datetime.now()

    import random

    rand = random.randint(0, 10000)

    tmpTable = now.strftime(f"tmp_%Y%m%dt%H%M%S%f{rand}")

    # CREATE A TEMPORY TABLE TO ADD DATA TO
    sqlQuery = (
        """CREATE TEMPORARY TABLE %(tmpTable)s SELECT * FROM %(dbTablename)s WHERE 1=0;"""
        % locals()
    )
    writequery(log=log, sqlQuery=sqlQuery, dbConn=dbConn)

    sqlQuery = """ALTER TABLE %(tmpTable)s DISABLE KEYS;""" % locals()
    writequery(log=log, sqlQuery=sqlQuery, dbConn=dbConn)

    csvColumns = [k for d in dictList for k in list(d.keys())]
    csvColumns = list(set(csvColumns))
    csvColumnsString = ("`, `").join(csvColumns)
    csvColumnsString = f"`{csvColumnsString}`"
    csvColumnsString = csvColumnsString.replace("`dec`", "`decl`")

    df = pd.DataFrame(dictList)
    df.replace(["nan", "None", "", "NaN", np.nan, None], "\\N", inplace=True)

    with tempfile.TemporaryDirectory(prefix="fundamentals-load-") as tmpDir:
        csvPath = os.path.join(tmpDir, tmpTable + ".csv")
        df.to_csv(
            csvPath,
            sep="|",
            index=False,
            quotechar='"',
            columns=csvColumns,
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
        sqlQuery = """LOAD DATA LOCAL INFILE '%(sqlCsvPath)s'
INTO TABLE %(tmpTable)s
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES
(%(csvColumnsString)s);""" % locals()

        writequery(log=log, sqlQuery=sqlQuery, dbConn=dbConn)

        updateStatement = ""
        for i in csvColumns:
            updateStatement += "`%(i)s` = VALUES(`%(i)s`), " % locals()
        if dateModified:
            updateStatement += "dateLastModified = NOW(), updated = 1"
        else:
            updateStatement = updateStatement[0:-2]

        sqlQuery = """
INSERT IGNORE INTO %(dbTablename)s
SELECT * FROM %(tmpTable)s
ON DUPLICATE KEY UPDATE %(updateStatement)s;""" % locals()
        writequery(log=log, sqlQuery=sqlQuery, dbConn=dbConn)

        sqlQuery = """DROP TEMPORARY TABLE %(tmpTable)s;""" % locals()
        writequery(log=log, sqlQuery=sqlQuery, dbConn=dbConn)

    dbConn.commit()
    dbConn.close()

    log.debug("completed the ``_add_dictlist_to_database_via_load_in_file`` function")
    return None


# use the tab-trigger below for new function
# xt-def-function
