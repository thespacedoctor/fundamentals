#!/usr/local/bin/python
# encoding: utf-8
"""
*Convert a python dictionary into rows of a mysql table*

Author
: David Young
"""

import six
from fundamentals.mysql import writequery, table_exists, readquery
from fundamentals import tools, times
from fundamentals.mysql.sql_identifiers import (
    normalise_column_name,
    quote_identifier,
    raise_on_duplicate_columns,
)
from pymysql.converters import escape_item
import collections as c
import datetime
import time
import yaml
import re
from builtins import zip
from builtins import str
from builtins import range
import sys
import os

os.environ["TERM"] = "vt100"

# CHARACTER SET USED TO ESCAPE VALUES WRITTEN INTO SQL STATEMENT STRINGS
ESCAPE_CHARSET = "utf8mb4"


def _sql_literal(value):
    """*return the value as an escaped SQL literal, safe to put in a statement string*"""
    return escape_item(value, ESCAPE_CHARSET)


def _database_value(value):
    """*return the value as it should be stored: None and empty strings become NULL (None), numbers and strings are kept, anything else is stored as text*"""
    if value is None or value == "":
        return None
    if isinstance(value, (str, int, float, bool)):
        return value
    return str(value)


def _remove_conversion_noise(value):
    """*remove the yaml and feedparser conversion noise from a string value*"""
    if not isinstance(value, str):
        return value
    for noise in [
        "time.struct_time",
        "- !!python/object/new:feedparser.FeedParserDict",
        "!!python/object/new:feedparser.FeedParserDict",
        "dictitems:",
        "dictitems",
        "!!python/unicode:",
        "!!python/unicode",
    ]:
        value = value.replace(noise, "")
    return value


def _build_batch_insert(
    insertVerb, dbTableName, formattedKeyList, values, replace, dateCreated
):
    """*build an insert command with ``%s`` placeholders, and the tuple of values to bind to it*

    **Return**

    - ``insertCommand``, ``valueTuple`` -- the command and the values to bind
    """
    quotedKeys = [_quote_for_format(k) for k in formattedKeyList]
    placeholders = ", ".join(["%s"] * len(values))
    insertCommand = "%s INTO %s (%s%s) VALUES (%s%s)" % (
        insertVerb,
        _quote_for_format(dbTableName),
        ",".join(quotedKeys),
        ", dateCreated" if dateCreated else "",
        placeholders,
        ", NOW()" if dateCreated else "",
    )
    if replace:
        insertCommand += " ON DUPLICATE KEY UPDATE " + ", ".join(
            "%s=VALUES(%s)" % (k, k) for k in quotedKeys
        )
    return insertCommand, tuple(values)


def _build_literal_insert(
    insertVerb,
    dbTableName,
    formattedKeyList,
    values,
    replace,
    dateModified,
    dateCreated,
):
    """*build an insert statement with every value escaped and written into the statement*

    **Return**

    - ``insertStatement`` -- the statement as a string
    """
    quotedKeys = [quote_identifier(k) for k in formattedKeyList]
    literals = [_sql_literal(_remove_conversion_noise(v)) for v in values]
    insertStatement = "%s INTO %s (%s%s) VALUES (%s%s)" % (
        insertVerb,
        quote_identifier(dbTableName),
        ",".join(quotedKeys),
        ", dateCreated" if dateCreated else "",
        ",".join(literals),
        ", NOW()" if dateCreated else "",
    )
    if not replace:
        return insertStatement

    assignments = ["%s=%s" % (k, v) for k, v in zip(quotedKeys, literals)]
    insertStatement += " ON DUPLICATE KEY UPDATE " + ", ".join(assignments)
    if dateModified:
        # THE ROW IS ONLY MARKED AS UPDATED IF A COLUMN CHANGED
        unchanged = " AND ".join(
            "%s IS NULL" % (k,) if v == "NULL" else "%s=%s" % (k, v)
            for k, v in zip(quotedKeys, literals)
        )
        insertStatement += (
            ", updated=IF(%s, 0, 1), dateLastModified=IF(%s, dateLastModified, NOW())"
            % (unchanged, unchanged)
        )
    return insertStatement


def _quote_for_format(name):
    """*quote an identifier for a statement that is later formatted with ``%s`` placeholders*"""
    return quote_identifier(name).replace("%", "%%")


def convert_dictionary_to_mysql_table(
    log,
    dictionary,
    dbTableName,
    uniqueKeyList=None,
    dbConn=False,
    createHelperTables=False,
    dateModified=False,
    returnInsertOnly=False,
    replace=False,
    batchInserts=True,
    reDatetime=False,
    skipChecks=False,
    dateCreated=True,
):
    """convert dictionary to mysql table

    **Key Arguments**

    - ``log`` -- logger
    - ``dictionary`` -- python dictionary
    - ``dbConn`` -- the db connection
    - ``dbTableName`` -- name of the table you wish to add the data to (or create if it does not exist)
    - ``uniqueKeyList`` - a lists column names that need combined to create the primary key
    - ``createHelperTables`` -- create some helper tables with the main table, detailing original keywords etc
    - ``returnInsertOnly`` -- returns only the insert command (does not execute it)
    - ``dateModified`` -- add a modification date and updated flag to the mysql table
    - ``replace`` -- use replace instead of mysql insert statements (useful when updates are required)
    - ``batchInserts`` -- if returning insert statements return separate insert commands and value tuples


        - ``reDatetime`` -- compiled regular expression matching datetime (passing this in cuts down on execution time as it doesn't have to be recompiled everytime during multiple iterations of ``convert_dictionary_to_mysql_table``)
        - ``skipChecks`` -- skip reliability checks. Less robust but a little faster.
        - ``dateCreated`` -- add a timestamp for dateCreated?

    **Return**

    - ``returnInsertOnly`` -- the insert statement if requested


    **Usage**

    To add a python dictionary to a database table, creating the table and/or columns if they don't yet exist:

    ```python
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
    ```

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

        print(insertCommand, valueTuple)

        # OUT: INSERT INTO `testing_table`
        # (`a newKey`,`and another`,`uniqueKey2`,`uniquekey1`, dateCreated) VALUES
        # (%s, %s, %s, %s, NOW())  ('cool', 'super cool', 'burgers', 'cheese')

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

        print(inserts)

        # OUT: INSERT IGNORE INTO `testing_table` (`a_newKey`,`and_another`,`uniqueKey2`,`uniquekey1`, dateCreated)
        # VALUES ('cool','super cool','burgers','cheese', NOW())
        # ON DUPLICATE KEY UPDATE `a_newKey`='cool', `and_another`='super cool',
        # `uniqueKey2`='burgers', `uniquekey1`='cheese'

    """

    log.debug("starting the ``convert_dictionary_to_mysql_table`` function")

    if uniqueKeyList is None:
        uniqueKeyList = []

    if not reDatetime:
        reDatetime = re.compile("^[0-9]{4}-[0-9]{2}-[0-9]{2}T")

    if not replace:
        insertVerb = "INSERT"
    else:
        insertVerb = "INSERT IGNORE"

    if isinstance(dictionary, dict):
        # REFUSE KEYS THAT GIVE THE SAME COLUMN, BEFORE ANY TABLE IS CREATED
        raise_on_duplicate_columns(dictionary.keys())

    if returnInsertOnly == False:
        # TEST THE ARGUMENTS
        if str(type(dbConn).__name__) != "Connection":
            message = "Please use a valid MySQL DB connection."
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
            if i not in list(dictionary.keys()):
                message = 'Please make sure values in "uniqueKeyList" are present in the "dictionary" you are tring to convert'
                log.critical(message)
                raise ValueError(message)

        for k, v in list(dictionary.items()):
            # log.debug('k: %s, v: %s' % (k, v,))
            if isinstance(v, list) and len(v) != 2:
                message = (
                    'Please make sure the list values in "dictionary" 2 items in length'
                )
                log.critical("%s: in %s we have a %s (%s)" % (message, k, v, type(v)))
                raise ValueError(message)
            if isinstance(v, list):
                if not (
                    isinstance(v[0], six.string_types)
                    or isinstance(v[0], int)
                    or isinstance(v[0], bool)
                    or isinstance(v[0], float)
                    or isinstance(v[0], int)
                    or isinstance(v[0], datetime.date)
                    or v[0] == None
                ):
                    message = 'Please make sure values in "dictionary" are of an appropriate value to add to the database, must be str, float, int or bool'
                    log.critical(
                        "%s: in %s we have a %s (%s)" % (message, k, v, type(v))
                    )
                    raise ValueError(message)
            else:
                if not (
                    isinstance(v, six.string_types)
                    or isinstance(v, int)
                    or isinstance(v, bool)
                    or isinstance(v, float)
                    or isinstance(v, datetime.date)
                    or v == None
                    or "int" in str(type(v))
                ):
                    this = type(v)
                    message = (
                        'Please make sure values in "dictionary" are of an appropriate value to add to the database, must be str, float, int or bool : %(k)s is a %(this)s'
                        % locals()
                    )
                    log.critical(
                        "%s: in %s we have a %s (%s)" % (message, k, v, type(v))
                    )
                    raise ValueError(message)

        if not isinstance(createHelperTables, bool):
            message = 'Please make sure "createHelperTables" is a True or False'
            log.critical(message)
            raise TypeError(message)

        # TEST IF TABLE EXISTS
        if not skipChecks:
            tableExists = table_exists.table_exists(
                dbConn=dbConn, log=log, dbTableName=dbTableName
            )
        else:
            tableExists = False

        # CREATE THE TABLE IF IT DOES NOT EXIST
        if tableExists is False:
            quotedTable = quote_identifier(dbTableName)
            sqlQuery = """
                CREATE TABLE IF NOT EXISTS %(quotedTable)s
                (`primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
                `dateCreated` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
                `dateLastModified` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
                `updated` tinyint(4) DEFAULT '0',
                PRIMARY KEY (`primaryId`))
                ENGINE=Innodb AUTO_INCREMENT=0 DEFAULT CHARSET=latin1;
            """ % locals()
            writequery(
                log=log,
                sqlQuery=sqlQuery,
                dbConn=dbConn,
            )

    qCreateColumn = ""
    formattedKey = ""
    formattedKeyList = []
    myValues = []

    # COPY THE ARGUMENTS SO THE CALLER'S DATA IS NEVER MODIFIED (LIST VALUES
    # ARE COPIED TOO AS value[0] IS REWRITTEN BELOW)
    dictionary = {
        k: list(v) if isinstance(v, list) else v for k, v in dictionary.items()
    }
    uniqueKeyList = list(uniqueKeyList)

    # ADD EXTRA COLUMNS TO THE DICTIONARY todo: do I need this?
    if dateModified:
        dictionary["dateLastModified"] = [
            str(times.get_now_sql_datetime()),
            "date row was modified",
        ]
        if replace == False:
            dictionary["updated"] = [0, "this row has been updated"]
        else:
            dictionary["updated"] = [1, "this row has been updated"]

    # ITERATE THROUGH THE DICTIONARY AND GENERATE THE TABLE COLUMN WITH THE
    # NAME OF THE KEY, IF IT DOES NOT EXIST
    count = len(dictionary)
    i = 1
    for key, value in list(dictionary.items()):
        if isinstance(value, list) and value[0] is None:
            del dictionary[key]
    # SORT THE DICTIONARY BY KEY (AS STRINGS SO MIXED-TYPE KEYS CAN BE COMPARED)
    odictionary = c.OrderedDict(sorted(dictionary.items(), key=lambda kv: str(kv[0])))
    for key, value in list(odictionary.items()):
        key = str(key)
        formattedKey = normalise_column_name(key)

        # RAISES VALUEERROR FOR AN EMPTY OR OTHERWISE INVALID COLUMN NAME
        quote_identifier(formattedKey)
        formattedKeyList.append(formattedKey)

        # CONVERT LIST AND FEEDPARSER VALUES TO YAML (SO I CAN PASS IT AS A
        # STRING TO MYSQL)
        if isinstance(value, list) and (isinstance(value[0], list)):
            value[0] = yaml.dump(value[0])
            value[0] = str(value[0])
        # JOIN THE VALUES TOGETHER IN A LIST - EASIER TO GENERATE THE MYSQL
        # COMMAND LATER (ESCAPING IS DONE WHEN THE COMMAND IS BUILT)
        if isinstance(value, list) and isinstance(value[0], str):
            myValues.append(_database_value(value[0].strip()))
        elif isinstance(value, list):
            myValues.append(_database_value(value[0]))
        else:
            myValues.append(_database_value(value))

        if returnInsertOnly == False:
            # CHECK IF COLUMN EXISTS YET
            colExists = (
                "SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND COLUMN_NAME="
                + _sql_literal(formattedKey)
                + " AND TABLE_NAME="
                + _sql_literal(dbTableName)
            )
            try:
                # log.debug('checking if the column '+formattedKey+' exists
                # in the '+dbTableName+' table')

                rows = readquery(
                    log=log,
                    sqlQuery=colExists,
                    dbConn=dbConn,
                )
            except Exception as e:
                # WITHOUT ROWS WE CANNOT DECIDE WHETHER TO ALTER THE TABLE
                log.error("something went wrong" + str(e) + "\n")
                raise

            # IF COLUMN DOESN'T EXIT - GENERATE IT
            if len(rows) == 0:
                qCreateColumn = "ALTER TABLE %s ADD %s" % (
                    quote_identifier(dbTableName),
                    quote_identifier(formattedKey),
                )
                if not isinstance(value, list):
                    value = [value]
                if reDatetime.search(str(value[0])):
                    # log.debug('Ok - a datetime string was found')
                    qCreateColumn += " datetime DEFAULT NULL"
                elif (
                    formattedKey == "updated_parsed"
                    or formattedKey == "published_parsed"
                    or formattedKey == "feedName"
                    or formattedKey == "title"
                ):
                    qCreateColumn += " varchar(100) DEFAULT NULL"
                elif isinstance(value[0], str) and len(value[0]) < 30:
                    qCreateColumn += " varchar(100) DEFAULT NULL"
                elif (
                    isinstance(value[0], str)
                    and len(value[0]) >= 30
                    and len(value[0]) < 80
                ):
                    qCreateColumn += " varchar(100) DEFAULT NULL"
                elif isinstance(value[0], str):
                    columnLength = 450 + len(value[0]) * 2
                    qCreateColumn += (
                        " varchar(" + str(columnLength) + ") DEFAULT NULL"
                    )
                elif (
                    isinstance(value[0], int)
                    and not isinstance(value[0], bool)
                    and abs(value[0]) <= 9
                ):
                    qCreateColumn += " tinyint DEFAULT NULL"
                elif isinstance(value[0], int) and not isinstance(value[0], bool):
                    qCreateColumn += " int DEFAULT NULL"
                elif (
                    isinstance(value[0], float) or isinstance(value[0], int)
                ) and not isinstance(value[0], bool):
                    qCreateColumn += " double DEFAULT NULL"
                elif isinstance(value[0], bool):
                    qCreateColumn += " tinyint DEFAULT NULL"
                elif isinstance(value[0], list):
                    qCreateColumn += " varchar(1024) DEFAULT NULL"
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
                    if key != formattedKey:
                        qCreateColumn += " COMMENT " + _sql_literal(
                            "original keyword: " + key
                        )
                    # CREATE THE COLUMN IF IT DOES NOT EXIST
                    try:
                        log.info(
                            "creating the "
                            + formattedKey
                            + " column in the "
                            + dbTableName
                            + " table"
                        )
                        writequery(log=log, sqlQuery=qCreateColumn, dbConn=dbConn)

                    except Exception as e:
                        # log.debug('qCreateColumn: %s' % (qCreateColumn,
                        # ))
                        log.error(
                            "could not create the "
                            + formattedKey
                            + " column in the "
                            + dbTableName
                            + " table -- "
                            + str(e)
                            + "\n"
                        )
                        raise

    if returnInsertOnly == False:
        # GENERATE THE INDEX NAME - THEN CREATE INDEX IF IT DOES NOT YET EXIST
        if len(uniqueKeyList):
            for i in range(len(uniqueKeyList)):
                uniqueKeyList[i] = normalise_column_name(uniqueKeyList[i])

            indexName = uniqueKeyList[0]
            for i in range(len(uniqueKeyList) - 1):
                indexName += "_" + uniqueKeyList[i + 1]

            indexName = indexName.lower().replace("  ", " ").replace(" ", "_")

            sqlQuery = (
                "SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = "
                + _sql_literal(dbTableName)
                + " AND INDEX_NAME = "
                + _sql_literal(indexName)
            )
            rows = readquery(log=log, sqlQuery=sqlQuery, dbConn=dbConn, quiet=False)

            exists = rows[0]["COUNT(*)"]
            # log.debug('uniqueKeyList: %s' % (uniqueKeyList,))
            if exists == 0:
                uniqueColumns = ",".join(quote_identifier(k) for k in uniqueKeyList)

                addUniqueKey = (
                    "ALTER TABLE "
                    + quote_identifier(dbTableName)
                    + " ADD unique "
                    + quote_identifier(indexName)
                    + " ("
                    + uniqueColumns
                    + ")"
                )
                # log.debug('HERE IS THE COMMAND:'+addUniqueKey)
                writequery(log=log, sqlQuery=addUniqueKey, dbConn=dbConn)

    if returnInsertOnly == True and batchInserts == True:
        return _build_batch_insert(
            insertVerb, dbTableName, formattedKeyList, myValues, replace, dateCreated
        )

    addValue = _build_literal_insert(
        insertVerb,
        dbTableName,
        formattedKeyList,
        myValues,
        replace,
        dateModified,
        dateCreated,
    )

    if returnInsertOnly == True:
        return addValue

    message = ""
    try:
        # log.debug('adding new data to the %s table; query: %s' %
        # (dbTableName, addValue))"
        writequery(log=log, sqlQuery=addValue, dbConn=dbConn)

    except Exception as e:
        message = (
            "could not add new data added to the table '"
            + dbTableName
            + "' : "
            + str(e)
            + "\n"
        )
        log.error(message)
        print(message)
        raise Exception(message) from e

    log.debug("completed the ``convert_dictionary_to_mysql_table`` function")
    return None, None
