#!/usr/local/bin/python
# encoding: utf-8
"""
*Given a list of dictionaries this function will insert each dictionary as a row into the given database table*

:Author:
    David Young
"""
from __future__ import print_function
from __future__ import division
from builtins import str
from builtins import range
from past.utils import old_div
import sys
import os
os.environ['TERM'] = 'vt100'
from fundamentals import tools
from fundamentals.mysql import convert_dictionary_to_mysql_table, writequery
from fundamentals.fmultiprocess import fmultiprocess
import time
import re
from fundamentals.mysql.database import database
from datetime import datetime


count = 0
totalCount = 0
globalDbConn = False
sharedList = []


def insert_list_of_dictionaries_into_database_tables(
        dbConn,
        log,
        dictList,
        dbTableName,
        uniqueKeyList=[],
        dateModified=False,
        dateCreated=True,
        batchSize=2500,
        replace=False,
        dbSettings=False):
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
    - ``replace`` -- repalce row if a duplicate is found
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
        'starting the ````insert_list_of_dictionaries_into_database_tables`` function')

    global count
    global totalCount
    global globalDbConn
    global sharedList

    reDate = re.compile('^[0-9]{4}-[0-9]{2}-[0-9]{2}T')

    if dbSettings:
        globalDbConn = dbSettings
    else:
        globalDbConn = dbConn

    if len(dictList) == 0:
        log.warning(
            'the dictionary to be added to the database is empty' % locals())
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
            dateCreated=dateCreated)
        dictList = dictList[1:]

    dbConn.autocommit(False)

    if len(dictList):

        total = len(dictList)
        batches = int(old_div(total, batchSize))

        start = 0
        end = 0
        sharedList = []
        for i in range(batches + 1):
            end = end + batchSize
            start = i * batchSize
            thisBatch = dictList[start:end]
            sharedList.append((thisBatch, end))

        totalCount = total + 1
        ltotalCount = totalCount

        print("Starting to insert %(ltotalCount)s rows into %(dbTableName)s" % locals())

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
                dateCreated=dateCreated
            )

        else:
            fmultiprocess(log=log, function=_add_dictlist_to_database_via_load_in_file,
                          inputArray=list(range(len(sharedList))), dbTablename=dbTableName,
                          dbSettings=dbSettings, dateModified=dateModified)

        sys.stdout.write("\x1b[1A\x1b[2K")
        print("%(ltotalCount)s / %(ltotalCount)s rows inserted into %(dbTableName)s" % locals())

    log.debug(
        'completed the ``insert_list_of_dictionaries_into_database_tables`` function')
    return None


def _insert_single_batch_into_database(
        batchIndex,
        log,
        dbTableName,
        uniqueKeyList,
        dateModified,
        replace,
        batchSize,
        reDatetime,
        dateCreated):
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
    log.debug('starting the ``_insert_single_batch_into_database`` function')

    global totalCount
    global globalDbConn
    global sharedList

    batch = sharedList[batchIndex]

    reDate = reDatetime

    if isinstance(globalDbConn, dict):
        # SETUP ALL DATABASE CONNECTIONS

        dbConn = database(
            log=log,
            dbSettings=globalDbConn,
            autocommit=False
        ).connect()
    else:
        dbConn = globalDbConn

    count = batch[1]
    if count > totalCount:
        count = totalCount
    ltotalCount = totalCount

    inserted = False
    while inserted == False:

        if not replace:
            insertVerb = "INSERT IGNORE"
        else:
            insertVerb = "INSERT IGNORE"

        uniKeys = set().union(*(list(d.keys()) for d in batch[0]))
        tmp = []
        tmp[:] = [m.replace(" ", "_").replace(
            "-", "_") for m in uniKeys]
        uniKeys = tmp

        myKeys = '`,`'.join(uniKeys)
        vals = [tuple([None if d[k] in ["None", None] else d[k]
                       for k in uniKeys]) for d in batch[0]]
        valueString = ("%s, " * len(vals[0]))[:-2]
        insertCommand = insertVerb + """ INTO `""" + dbTableName + \
            """` (`""" + myKeys + """`, dateCreated) VALUES (""" + \
            valueString + """, NOW())"""

        if not dateCreated:
            insertCommand = insertCommand.replace(
                ", dateCreated)", ")").replace(", NOW())", ")")

        dup = ""
        if replace:
            dup = " ON DUPLICATE KEY UPDATE "
            for k in uniKeys:
                dup = """%(dup)s %(k)s=values(%(k)s),""" % locals()
            dup = """%(dup)s updated=1, dateLastModified=NOW()""" % locals()

        insertCommand = insertCommand + dup

        insertCommand = insertCommand.replace('\\""', '\\" "')
        insertCommand = insertCommand.replace('""', "null")
        insertCommand = insertCommand.replace('"None"', 'null')

        message = ""
        # log.debug('adding new data to the %s table; query: %s' %
        # (dbTableName, addValue))
        try:
            message = writequery(
                log=log,
                sqlQuery=insertCommand,
                dbConn=dbConn,
                Force=True,
                manyValueList=vals
            )
        except:
            theseInserts = []
            for aDict in batch[0]:
                insertCommand, valueTuple = convert_dictionary_to_mysql_table(
                    dbConn=dbConn,
                    log=log,
                    dictionary=aDict,
                    dbTableName=dbTableName,
                    uniqueKeyList=uniqueKeyList,
                    dateModified=dateModified,
                    returnInsertOnly=True,
                    replace=replace,
                    reDatetime=reDate,
                    skipChecks=True
                )
                theseInserts.append(valueTuple)

            message = ""
            # log.debug('adding new data to the %s table; query: %s' %
            # (dbTableName, addValue))
            message = writequery(
                log=log,
                sqlQuery=insertCommand,
                dbConn=dbConn,
                Force=True,
                manyValueList=theseInserts
            )

        if message == "unknown column":
            for aDict in batch:
                convert_dictionary_to_mysql_table(
                    dbConn=dbConn,
                    log=log,
                    dictionary=aDict,
                    dbTableName=dbTableName,
                    uniqueKeyList=uniqueKeyList,
                    dateModified=dateModified,
                    reDatetime=reDate,
                    replace=replace
                )
        else:
            inserted = True

        dbConn.commit()

    log.debug('completed the ``_insert_single_batch_into_database`` function')
    return "None"


def _add_dictlist_to_database_via_load_in_file(
        masterListIndex,
        dbTablename,
        dbSettings,
        dateModified=False):
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
    from fundamentals.logs import emptyLogger
    import pandas as pd
    import numpy as np
    log = emptyLogger()
    log.debug('starting the ``_add_dictlist_to_database_via_load_in_file`` function')

    global sharedList

    dictList = sharedList[masterListIndex][0]

    count = sharedList[masterListIndex][1]
    if count > totalCount:
        count = totalCount
    ltotalCount = totalCount

    # SETUP ALL DATABASE CONNECTIONS
    dbConn = database(
        log=log,
        dbSettings=dbSettings
    ).connect()

    now = datetime.now()
    tmpTable = now.strftime("tmp_%Y%m%dt%H%M%S%f")

    # CREATE A TEMPORY TABLE TO ADD DATA TO
    sqlQuery = """CREATE TEMPORARY TABLE %(tmpTable)s SELECT * FROM %(dbTablename)s WHERE 1=0;""" % locals()
    writequery(
        log=log,
        sqlQuery=sqlQuery,
        dbConn=dbConn
    )

    csvColumns = [k for d in dictList for k in list(d.keys())]
    csvColumns = list(set(csvColumns))
    csvColumnsString = (', ').join(csvColumns)
    csvColumnsString = csvColumnsString.replace(u" dec,", u" decl,")

    df = pd.DataFrame(dictList)
    df.replace(['nan', 'None', '', 'NaN', np.nan], '\\N', inplace=True)
    df.to_csv('/tmp/%(tmpTable)s' % locals(), sep="|",
              index=False, escapechar="\\", quotechar='"', columns=csvColumns, encoding='utf-8')

    sqlQuery = """LOAD DATA LOCAL INFILE '/tmp/%(tmpTable)s'
INTO TABLE %(tmpTable)s
FIELDS TERMINATED BY '|' OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES
(%(csvColumnsString)s);""" % locals()

    writequery(
        log=log,
        sqlQuery=sqlQuery,
        dbConn=dbConn
    )

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
    writequery(
        log=log,
        sqlQuery=sqlQuery,
        dbConn=dbConn
    )

    sqlQuery = """DROP TEMPORARY TABLE %(tmpTable)s;""" % locals()
    writequery(
        log=log,
        sqlQuery=sqlQuery,
        dbConn=dbConn
    )

    try:
        os.remove('/tmp/%(tmpTable)s' % locals())
    except:
        pass

    dbConn.close()

    log.debug(
        'completed the ``_add_dictlist_to_database_via_load_in_file`` function')
    return None

# use the tab-trigger below for new function
# xt-def-function
