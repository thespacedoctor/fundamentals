#!/usr/local/bin/python
# encoding: utf-8
"""
*Given a list of dictionaries this function will insert each dictionary as a row into the given database table*

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
from fundamentals.mysql import convert_dictionary_to_mysql_table, writequery
from fundamentals.fmultiprocess import fmultiprocess
import time
import re


count = 0
totalCount = 0
globalDbConn = False


def insert_list_of_dictionaries_into_database_tables(
        dbConn,
        log,
        dictList,
        dbTableName,
        uniqueKeyList=[],
        dateModified=False,
        batchSize=2500,
        replace=False,
        dbSettings=False):
    """insert list of dictionaries into database tables

    **Key Arguments:**
        - ``dbConn`` -- mysql database connection
        - ``log`` -- logger
        - ``dictList`` -- list of python dictionaries to add to the database table
        - ``dbTableName`` -- name of the database table
        - ``uniqueKeyList`` -- a list of column names to append as a unique constraint on the database
        - ``dateModified`` -- add the modification date as a column in the database
        - ``batchSize`` -- batch the insert commands into *batchSize* batches
        - ``replace`` -- repalce row if a duplicate is found
        - ``dbSettings`` -- pass in the database settings so multiprocessing can establish one connection per process (might not be faster)

    **Return:**
        - None

    **Usage:**

        .. code-block:: python

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
    """

    log.info(
        'starting the ``insert_list_of_dictionaries_into_database_tables`` function')

    global count
    global totalCount
    global globalDbConn

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
        convert_dictionary_to_mysql_table(
            dbConn=dbConn,
            log=log,
            dictionary=dictList[0],
            dbTableName=dbTableName,
            uniqueKeyList=uniqueKeyList,
            dateModified=dateModified,
            reDatetime=reDate,
            replace=replace,)

    dbConn.autocommit(False)

    total = len(dictList[1:])
    batches = int(total / batchSize)

    start = 0
    end = 0
    theseBatches = []
    for i in range(batches + 1):
        end = end + batchSize
        start = i * batchSize
        thisBatch = dictList[start:end]
        theseBatches.append((thisBatch, end))

    totalCount = total

    fmultiprocess(
        log=log,
        function=_insert_single_batch_into_database,
        inputArray=theseBatches,
        dbTableName=dbTableName,
        uniqueKeyList=uniqueKeyList,
        dateModified=dateModified,
        replace=replace,
        batchSize=batchSize,
        reDatetime=reDate
    )

    if len(theseBatches) > 1:
        sys.stdout.write("\x1b[1A\x1b[2K")
    print "%(total)s / %(total)s rows inserted into %(dbTableName)s" % locals()

    log.info(
        'completed the ``insert_list_of_dictionaries_into_database_tables`` function')
    return None


def _insert_single_batch_into_database(
        batch,
        log,
        dbTableName,
        uniqueKeyList,
        dateModified,
        replace,
        batchSize,
        reDatetime):
    """*summary of function*

    **Key Arguments:**
        - ``batch`` -- the batch to insert
        - ``dbConn`` -- mysql database connection
        - ``log`` -- logger

    **Return:**
        - None

    **Usage:**
        .. todo::

            add usage info
            create a sublime snippet for usage

        .. code-block:: python 

            usage code            
    """
    log.info('starting the ``_insert_single_batch_into_database`` function')

    global totalCount
    global globalDbConn

    reDate = reDatetime

    if isinstance(globalDbConn, dict):
        # SETUP ALL DATABASE CONNECTIONS
        from fundamentals.mysql import database
        dbConn = database(
            log=log,
            dbSettings=globalDbConn,
            autocommit=False
        ).connect()
    else:
        dbConn = globalDbConn

    count = batch[1]
    if count > batchSize:
        # Cursor up one line and clear line
        sys.stdout.write("\x1b[1A\x1b[2K")
    if count > totalCount:
        count = totalCount
    ltotalCount = totalCount

    inserted = False
    while inserted == False:

        if not replace:
            insertVerb = "INSERT IGNORE"
        else:
            insertVerb = "INSERT IGNORE"

        uniKeys = set().union(*(d.keys() for d in batch[0]))
        tmp = []
        tmp[:] = [m.replace(" ", "_").replace(
            "-", "_") for m in uniKeys]
        uniKeys = tmp

        myKeys = '`,`'.join(uniKeys)
        vals = [tuple([None if d[k] in ["None", None] else str(d[k])
                       for k in uniKeys]) for d in batch[0]]
        valueString = ("%s, " * len(vals[0]))[:-2]
        insertCommand = insertVerb + """ INTO `""" + dbTableName + \
            """` (`""" + myKeys + """`, dateCreated) VALUES (""" + \
            valueString + """, NOW())"""

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

        print "~%(count)s / %(ltotalCount)s rows inserted into %(dbTableName)s" % locals()

    log.info('completed the ``_insert_single_batch_into_database`` function')
    return "None"

# use the tab-trigger below for new function
# xt-def-function
