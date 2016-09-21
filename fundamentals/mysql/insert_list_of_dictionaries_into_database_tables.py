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


def insert_list_of_dictionaries_into_database_tables(
        dbConn,
        log,
        dictList,
        dbTableName,
        uniqueKeyList=[],
        dateModified=False,
        batchSize=2500,
        replace=False):
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
            replace=replace)

    total = len(dictList[1:])
    batches = int(total / batchSize)

    start = 0
    end = 0
    theseBatches = []
    for i in range(batches + 1):
        end = end + batchSize
        start = i * batchSize
        thisBatch = dictList[start:end]
        theseBatches.append(thisBatch)

    totalCount = total
    count = 0

    for batch in theseBatches:
        count += len(batch)
        if count > batchSize:
            # Cursor up one line and clear line
            sys.stdout.write("\x1b[1A\x1b[2K")
        if count > totalCount:
            count = totalCount
        print "%(count)s / %(totalCount)s rows inserted into %(dbTableName)s" % locals()

        inserted = False
        while inserted == False:
            theseInserts = []
            for aDict in batch:

                insertCommand, valueTuple = convert_dictionary_to_mysql_table(
                    dbConn=dbConn,
                    log=log,
                    dictionary=aDict,
                    dbTableName=dbTableName,
                    uniqueKeyList=uniqueKeyList,
                    dateModified=dateModified,
                    returnInsertOnly=True,
                    replace=replace
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
                sys.exit(0)
                for aDict in batch:
                    convert_dictionary_to_mysql_table(
                        dbConn=dbConn,
                        log=log,
                        dictionary=aDict,
                        dbTableName=dbTableName,
                        uniqueKeyList=uniqueKeyList,
                        dateModified=dateModified,
                        replace=replace
                    )
            else:
                inserted = True

    log.info(
        'completed the ``insert_list_of_dictionaries_into_database_tables`` function')
    return None
