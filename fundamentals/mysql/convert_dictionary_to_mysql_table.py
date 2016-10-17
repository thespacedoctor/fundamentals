#!/usr/local/bin/python
# encoding: utf-8
"""
*Convert a python dictionary into rows of a mysql table*

:Author:
    David Young

:Date Created:
    June 21, 2016
"""
################# GLOBAL IMPORTS ####################
import sys
import os
os.environ['TERM'] = 'vt100'
import MySQLdb as mdb
import re
import yaml
import time
import datetime
from fundamentals import tools, times
from fundamentals.mysql import writequery, table_exists, readquery


def convert_dictionary_to_mysql_table(
        log,
        dictionary,
        dbTableName,
        uniqueKeyList=[],
        dbConn=False,
        createHelperTables=False,
        dateModified=False,
        returnInsertOnly=False,
        replace=False,
        batchInserts=True):
    """convert dictionary to mysql table

    **Key Arguments:**
        - ``log`` -- logger
        - ``dictionary`` -- python dictionary
        - ``dbConn`` -- the db connection
        - ``dbTableName`` -- name of the table you wish to add the data to (or create if it does not exist)
        - ``uniqueKeyList`` - a lists column names that need combined to create the primary key
        - ``createHelperTables`` -- create some helper tables with the main table, detailing original keywords etc
        - ``returnInsertOnly`` -- returns only the insert command (does not execute it)
        - ``dateModified`` -- add a modification date to the mysql table
        - ``replace`` -- use replace instead of mysql insert statements (useful when updates are required)
        - ``batchInserts`` -- if returning insert statements return separate insert commands and value tuples

    **Return:**
        - ``returnInsertOnly`` -- the insert statement if requested

    **Usage:**

        To add a python dictionary to a database table, creating the table and/or columns if they don't yet exist:

        .. code-block:: python

            from fundamentals.mysql import convert_dictionary_to_mysql_table
            dictionary = {"a newKey": "cool", "and another": "super cool",
                      "uniquekey1": "cheese", "uniqueKey2": "burgers"}

            convert_dictionary_to_mysql_table(
                dbConn=dbConn,
                log=log,
                dictionary=dictionary,
                dbTableName="testing_table",
                uniqueKeyList=["uniquekey1", "uniqueKey2"],
                dateModified=False,
                returnInsertOnly=False,
                replace=True
            )

        Or just return the insert statement with a list of value tuples, i.e. do not execute the command on the database:

            insertCommand, valueTuple = convert_dictionary_to_mysql_table(
                dbConn=dbConn,
                log=log,
                dictionary=dictionary,
                dbTableName="testing_table",
                uniqueKeyList=["uniquekey1", "uniqueKey2"],
                dateModified=False,
                returnInsertOnly=True,
                replace=False,
                batchInserts=True
            )

            print insertCommand, valueTuple

            # OUT: 'INSERT IGNORE INTO `testing_table`
            # (a_newKey,and_another,dateCreated,uniqueKey2,uniquekey1) VALUES
            # (%s, %s, %s, %s, %s)', ('cool', 'super cool',
            # '2016-06-21T12:08:59', 'burgers', 'cheese')

        You can also return a list of single insert statements using ``batchInserts = False``. Using ``replace = True`` will also add instructions about how to replace duplicate entries in the database table if found:

            inserts = convert_dictionary_to_mysql_table(
                dbConn=dbConn,
                log=log,
                dictionary=dictionary,
                dbTableName="testing_table",
                uniqueKeyList=["uniquekey1", "uniqueKey2"],
                dateModified=False,
                returnInsertOnly=True,
                replace=True,
                batchInserts=False
            )

            print inserts

            # OUT: INSERT INTO `testing_table` (a_newKey,and_another,dateCreated,uniqueKey2,uniquekey1)
            # VALUES ("cool" ,"super cool" ,"2016-09-14T13:12:08" ,"burgers" ,"cheese")
            # ON DUPLICATE KEY UPDATE  a_newKey="cool", and_another="super
            # cool", dateCreated="2016-09-14T13:12:08", uniqueKey2="burgers",
            # uniquekey1="cheese"
    """
    log.info('starting the ``convert_dictionary_to_mysql_table`` function')

    # # >IMPORTS #
    # import ordereddict as c  # REMOVE WHEN PYTHON 2.7 INSTALLED ON PSDB
    import collections as c

    log.debug('starting convert_dictionary_to_mysql_table')

    if replace:
        insertVerb = "INSERT"
    else:
        insertVerb = "INSERT IGNORE"

    if returnInsertOnly == False:
        # TEST THE ARGUMENTS
        if str(type(dbConn).__name__) != "Connection":
            message = 'Please use a valid MySQL DB connection.'
            log.critical(message)
            raise TypeError(message)

        if not isinstance(dictionary, dict):
            message = 'Please make sure "dictionary" argument is a dict type.'
            log.critical(message)
            raise TypeError(message)

        if not isinstance(uniqueKeyList, list):
            message = 'Please make sure "uniqueKeyList" is a list'
            log.critical(message)
            raise TypeError(message)

        for i in uniqueKeyList:
            if i not in dictionary.keys():
                message = 'Please make sure values in "uniqueKeyList" are present in the "dictionary" you are tring to convert'
                log.critical(message)
                raise ValueError(message)

        for k, v in dictionary.iteritems():
            # log.debug('k: %s, v: %s' % (k, v,))
            if isinstance(v, list) and len(v) != 2:
                message = 'Please make sure the list values in "dictionary" 2 items in length'
                log.critical("%s: in %s we have a %s (%s)" %
                             (message, k, v, type(v)))
                raise ValueError(message)
            if isinstance(v, list):
                if not (isinstance(v[0], str) or isinstance(v[0], int) or isinstance(v[0], bool) or isinstance(v[0], float) or isinstance(v[0], long) or isinstance(v[0], datetime.date) or v[0] == None):
                    message = 'Please make sure values in "dictionary" are of an appropriate value to add to the database, must be str, float, int or bool'
                    log.critical("%s: in %s we have a %s (%s)" %
                                 (message, k, v, type(v)))
                    raise ValueError(message)
            else:
                if not (isinstance(v, str) or isinstance(v, int) or isinstance(v, bool) or isinstance(v, float) or isinstance(v, long) or isinstance(v, unicode) or isinstance(v, datetime.date) or v == None):
                    this = type(v)
                    message = 'Please make sure values in "dictionary" are of an appropriate value to add to the database, must be str, float, int or bool : %(k)s is a %(this)s' % locals(
                    )
                    log.critical("%s: in %s we have a %s (%s)" %
                                 (message, k, v, type(v)))
                    raise ValueError(message)

        if not isinstance(createHelperTables, bool):
            message = 'Please make sure "createHelperTables" is a True or False'
            log.critical(message)
            raise TypeError(message)

        # TEST IF TABLE EXISTS
        tableExists = table_exists.table_exists(
            dbConn=dbConn,
            log=log,
            dbTableName=dbTableName
        )

        # CREATE THE TABLE IF IT DOES NOT EXIST
        if tableExists is False:
            sqlQuery = """
                CREATE TABLE `%(dbTableName)s`
                (`primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
                PRIMARY KEY (`primaryId`))
                ENGINE=MyISAM AUTO_INCREMENT=0 DEFAULT CHARSET=latin1;
            """ % locals()
            writequery(
                log=log,
                sqlQuery=sqlQuery,
                dbConn=dbConn,

            )

    reFeedParserClass = re.compile('FeedParserDict')
    reDatetime = re.compile('^[0-9]{4}-[0-9]{2}-[0-9]{2}T')
    reTypeTime = re.compile('struct_time')
    qCreateColumn = ''
    formattedKey = ''
    formattedKeyList = []
    myValues = []

    # ADD EXTRA COLUMNS TO THE DICTIONARY
    if dateModified:
        dictionary['dateModified'] = [
            str(times.get_now_sql_datetime()), "date row was modified"]

    # ITERATE THROUGH THE DICTIONARY AND GENERATE THE A TABLE COLUMN WITH THE
    # NAME OF THE KEY, IF IT DOES NOT EXIST
    count = len(dictionary)
    i = 1
    for (key, value) in dictionary.items():
        if (isinstance(value, list) and value[0] is None):
            del dictionary[key]
    # SORT THE DICTIONARY BY KEY
    odictionary = c.OrderedDict(sorted(dictionary.items()))
    for (key, value) in odictionary.iteritems():

        formattedKey = key.replace(" ", "_").replace("-", "_")
        # DEC A KEYWORD IN MYSQL - NEED TO CHANGE BEFORE INGEST
        if formattedKey == "dec":
            formattedKey = "decl"
        if formattedKey == "DEC":
            formattedKey = "DECL"

        formattedKeyList.extend([formattedKey])
        if len(key) > 0:
            # CONVERT LIST AND FEEDPARSER VALUES TO YAML (SO I CAN PASS IT AS A
            # STRING TO MYSQL)
            if isinstance(value, list) and (isinstance(value[0], list) or reFeedParserClass.search(str(type(value[0])))):
                value[0] = yaml.dump(value[0])
                value[0] = str(value[0])
            # REMOVE CHARACTERS THAT COLLIDE WITH MYSQL
            # if type(value[0]) == str or type(value[0]) == unicode:
            #     value[0] = value[0].replace('"', """'""")
            # JOIN THE VALUES TOGETHER IN A LIST - EASIER TO GENERATE THE MYSQL
            # COMMAND LATER
            if isinstance(value, str):
                value = value.replace('\\', '\\\\')
                value = value.replace('"', '\\"')
                try:
                    udata = value.decode("utf-8", "ignore")
                    value = udata.encode("ascii", "ignore")
                except:
                    log.error('cound not decode value %(value)s' % locals())

                # log.debug('udata: %(udata)s' % locals())

            if isinstance(value, unicode):
                value = value.replace('"', '\\"')
                value = value.encode("ascii", "ignore")

            if isinstance(value, list) and isinstance(value[0], unicode):
                myValues.extend(['%s' % value[0].strip()])
            elif isinstance(value, list):
                myValues.extend(['%s' % (value[0], )])
            else:
                myValues.extend(['%s' % (value, )])

            if returnInsertOnly == False:
                # CHECK IF COLUMN EXISTS YET
                colExists = \
                    "SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND COLUMN_NAME='" + \
                    formattedKey + "'AND TABLE_NAME='" + dbTableName + """'"""
                try:
                    # log.debug('checking if the column '+formattedKey+' exists
                    # in the '+dbTableName+' table')

                    rows = readquery(
                        log=log,
                        sqlQuery=colExists,
                        dbConn=dbConn,
                    )
                except Exception as e:
                    log.error('something went wrong' + str(e) + '\n')

                # IF COLUMN DOESN'T EXIT - GENERATE IT
                if len(rows) == 0:
                    qCreateColumn = """ALTER TABLE %s ADD `%s""" % (
                        dbTableName, formattedKey)
                    if not isinstance(value, list):
                        value = [value]
                    if reDatetime.search(str(value[0])):
                        # log.debug('Ok - a datetime string was found')
                        qCreateColumn += '` datetime DEFAULT NULL'
                    elif formattedKey == 'updated_parsed' or formattedKey == 'published_parsed' or formattedKey \
                            == 'feedName' or formattedKey == 'title':
                        qCreateColumn += '` varchar(100) DEFAULT NULL'
                    elif (isinstance(value[0], str) or isinstance(value[0], unicode)) and len(value[0]) < 30:
                        qCreateColumn += '` varchar(100) DEFAULT NULL'
                    elif (isinstance(value[0], str) or isinstance(value[0], unicode)) and len(value[0]) >= 30 and len(value[0]) < 80:
                        qCreateColumn += '` varchar(100) DEFAULT NULL'
                    elif isinstance(value[0], str) or isinstance(value[0], unicode):
                        columnLength = 450 + len(value[0]) * 2
                        qCreateColumn += '` varchar(' + str(
                            columnLength) + ') DEFAULT NULL'
                    elif isinstance(value[0], int) and abs(value[0]) <= 9:
                        qCreateColumn += '` tinyint DEFAULT NULL'
                    elif isinstance(value[0], int):
                        qCreateColumn += '` int DEFAULT NULL'
                    elif isinstance(value[0], float) or isinstance(value[0], long):
                        qCreateColumn += '` double DEFAULT NULL'
                    elif isinstance(value[0], bool):
                        qCreateColumn += '` tinyint DEFAULT NULL'
                    elif isinstance(value[0], list):
                        qCreateColumn += '` varchar(1024) DEFAULT NULL'
                    else:
                        # log.debug('Do not know what format to add this key in
                        # MySQL - removing from dictionary: %s, %s'
                                 # % (key, type(value[0])))
                        formattedKeyList.pop()
                        myValues.pop()
                        qCreateColumn = None
                    if qCreateColumn:
                        # ADD COMMENT TO GIVE THE ORGINAL KEYWORD IF formatted FOR
                        # MYSQL
                        if key is not formattedKey:
                            qCreateColumn += " COMMENT 'original keyword: " + \
                                key + """'"""
                        # CREATE THE COLUMN IF IT DOES NOT EXIST
                        try:
                            log.info('creating the ' +
                                     formattedKey + ' column in the ' + dbTableName + ' table')
                            writequery(
                                log=log,
                                sqlQuery=qCreateColumn,
                                dbConn=dbConn
                            )

                        except Exception as e:
                            # log.debug('qCreateColumn: %s' % (qCreateColumn,
                            # ))
                            log.error('could not create the ' + formattedKey + ' column in the ' + dbTableName
                                      + ' table -- ' + str(e) + '\n')

    if returnInsertOnly == False:
        # GENERATE THE INDEX NAME - THEN CREATE INDEX IF IT DOES NOT YET EXIST
        if len(uniqueKeyList):
            for i in range(len(uniqueKeyList)):
                uniqueKeyList[i] = uniqueKeyList[
                    i].replace(" ", "_").replace("-", "_")
                if uniqueKeyList[i] == "dec":
                    uniqueKeyList[i] = "decl"
                if uniqueKeyList[i] == "DEC":
                    uniqueKeyList[i] = "DECL"

            indexName = uniqueKeyList[0].replace(" ", "_").replace("-", "_")
            for i in range(len(uniqueKeyList) - 1):
                indexName += '_' + uniqueKeyList[i + 1]

            indexName = indexName.lower().replace("  ", " ").replace(" ", "_")

            sqlQuery = u"""SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = '""" + \
                dbTableName + """' AND INDEX_NAME = '""" + indexName + """'"""
            rows = readquery(
                log=log,
                sqlQuery=sqlQuery,
                dbConn=dbConn,
                quiet=False
            )

            exists = rows[0]['COUNT(*)']
            # log.debug('uniqueKeyList: %s' % (uniqueKeyList,))
            if exists == 0:
                if isinstance(uniqueKeyList, list):
                    uniqueKeyList = ','.join(uniqueKeyList)

                addUniqueKey = 'ALTER TABLE ' + dbTableName + \
                    ' ADD unique ' + indexName + """ (""" + uniqueKeyList + ')'
                # log.debug('HERE IS THE COMMAND:'+addUniqueKey)
                writequery(
                    log=log,
                    sqlQuery=addUniqueKey,
                    dbConn=dbConn
                )

    if returnInsertOnly == True and batchInserts == True:
        myKeys = ','.join(formattedKeyList)
        valueString = ("%s, " * len(myValues))[:-2]
        insertCommand = insertVerb + """ INTO `""" + dbTableName + \
            """` (""" + myKeys + """) VALUES (""" + valueString + """)"""
        mv = []
        mv[:] = [None if m == "None" else m for m in myValues]
        valueTuple = tuple(mv)

        dup = ""
        if replace:
            dup = " ON DUPLICATE KEY UPDATE "
            for k, v in zip(formattedKeyList, mv):
                dup = """%(dup)s %(k)s=values(%(k)s),""" % locals()
            dup = """%(dup)s updated=1, dateLastModified=NOW()""" % locals()

        insertCommand = insertCommand + dup

        insertCommand = insertCommand.replace('""', "null")
        insertCommand = insertCommand.replace('!!python/unicode:', '')
        insertCommand = insertCommand.replace('!!python/unicode', '')
        insertCommand = insertCommand.replace('"None"', 'null')

        return insertCommand, valueTuple

    # GENERATE THE INSERT COMMAND - IGNORE DUPLICATE ENTRIES
    myKeys = ','.join(formattedKeyList)
    myValues = '" ,"'.join(myValues)
    # log.debug(myValues+" ------ PRESTRIP")
    # REMOVE SOME CONVERSION NOISE
    myValues = myValues.replace('time.struct_time', '')
    myValues = myValues.replace(
        '- !!python/object/new:feedparser.FeedParserDict', '')
    myValues = myValues.replace(
        '!!python/object/new:feedparser.FeedParserDict', '')
    myValues = myValues.replace('dictitems:', '')
    myValues = myValues.replace('dictitems', '')
    myValues = myValues.replace('!!python/unicode:', '')
    myValues = myValues.replace('!!python/unicode', '')
    myValues = myValues.replace('"None"', 'null')
    # myValues = myValues.replace('"None', 'null')

    if myValues[-4:] != 'null':
        myValues += '"'

    dup = ""
    if replace:
        dupValues = ('"' + myValues).split(" ,")
        dupKeys = myKeys.split(",")
        dup = dup + " ON DUPLICATE KEY UPDATE "
        for k, v in zip(dupKeys, dupValues):
            dup = """%(dup)s %(k)s=%(v)s,""" % locals()

        dup = """%(dup)s updated=IF(""" % locals()
        for k, v in zip(dupKeys, dupValues):
            if v == "null":
                dup = """%(dup)s %(k)s is %(v)s AND """ % locals()
            else:
                dup = """%(dup)s %(k)s=%(v)s AND """ % locals()
        dup = dup[:-5] + ", 0, 1), dateLastModified=IF("
        for k, v in zip(dupKeys, dupValues):
            if v == "null":
                dup = """%(dup)s %(k)s is %(v)s AND """ % locals()
            else:
                dup = """%(dup)s %(k)s=%(v)s AND """ % locals()
        dup = dup[:-5] + ", dateLastModified, NOW())"

    # log.debug(myValues+" ------ POSTSTRIP")
    addValue = insertVerb + """ INTO `""" + dbTableName + \
        """` (""" + myKeys + """) VALUES (\"""" + \
        myValues + """) %(dup)s """ % locals()

    addValue = addValue.replace('""', "null")
    addValue = addValue.replace('!!python/unicode:', '')
    addValue = addValue.replace('!!python/unicode', '')
    addValue = addValue.replace('"None"', 'null')
    # log.debug(addValue)

    if returnInsertOnly == True:
        return addValue

    message = ""
    try:
        # log.debug('adding new data to the %s table; query: %s' %
        # (dbTableName, addValue))"
        writequery(
            log=log,
            sqlQuery=addValue,
            dbConn=dbConn
        )

    except Exception as e:
        log.error("could not add new data added to the table '" +
                  dbTableName + "' : " + str(e) + '\n')

    log.info('completed the ``convert_dictionary_to_mysql_table`` function')
    return None, None
