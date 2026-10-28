#!/usr/local/bin/python
# encoding: utf-8
"""
*Convert a python dictionary into rows of a mysql table*

Author
: David Young
"""

import six
from fundamentals.mysql import writequery, table_exists, readquery
from fundamentals import times
from fundamentals.mysql.sql_identifiers import (
    normalise_column_name,
    quote_identifier,
    raise_on_duplicate_columns,
)
from fundamentals.mysql.sql_inserts import build_batch_insert_command
from fundamentals.mysql.sql_values import null_if_missing
from pymysql.converters import escape_item
import datetime
import yaml
import re
from builtins import zip
from builtins import str
import os

os.environ["TERM"] = "vt100"

# CHARACTER SET USED TO ESCAPE VALUES WRITTEN INTO SQL STATEMENT STRINGS
ESCAPE_CHARSET = "utf8mb4"

# TYPES A DICTIONARY VALUE (OR THE FIRST ITEM OF A [VALUE, COMMENT] LIST) MAY HAVE
ALLOWED_VALUE_TYPES = six.string_types + (int, bool, float, datetime.date)

# COLUMNS ALWAYS CREATED AS VARCHAR(100) WHATEVER THE LENGTH OF THE VALUE
FIXED_VARCHAR_COLUMNS = ("updated_parsed", "published_parsed", "feedName", "title")
SHORT_VARCHAR_DEFINITION = "varchar(100) DEFAULT NULL"

# STRINGS THIS LONG OR LONGER GET A VARCHAR WIDER THAN THE DEFAULT
LONG_STRING_MIN_LENGTH = 80
LONG_STRING_BASE_WIDTH = 450

# INTEGERS UP TO THIS SIZE (EITHER SIGN) GET A TINYINT COLUMN
TINYINT_MAX_SIZE = 9


def _sql_literal(value):
    """*return the value as an escaped SQL literal, safe to put in a statement string*"""
    return escape_item(value, ESCAPE_CHARSET)


def _database_value(value):
    """*return the value as it should be stored: missing values become NULL (None), numbers and strings are kept, anything else is stored as text*"""
    value = null_if_missing(value)
    if value is None or isinstance(value, (str, int, float, bool)):
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


def _check_list_value(log, key, value):
    """*raise a ValueError if a ``[value, comment]`` list is not a pair or its value has an unsuitable type*"""
    if len(value) != 2:
        message = 'Please make sure the list values in "dictionary" 2 items in length'
        log.critical("%s: in %s we have a %s (%s)" % (message, key, value, type(value)))
        raise ValueError(message)
    if not (isinstance(value[0], ALLOWED_VALUE_TYPES) or value[0] == None):
        message = 'Please make sure values in "dictionary" are of an appropriate value to add to the database, must be str, float, int or bool'
        log.critical("%s: in %s we have a %s (%s)" % (message, key, value, type(value)))
        raise ValueError(message)


def _check_scalar_value(log, key, value):
    """*raise a ValueError if a plain dictionary value has an unsuitable type*"""
    if not (
        isinstance(value, ALLOWED_VALUE_TYPES)
        or value == None
        or "int" in str(type(value))
    ):
        message = (
            'Please make sure values in "dictionary" are of an appropriate value to add to the database, must be str, float, int or bool : %s is a %s'
            % (key, type(value))
        )
        log.critical("%s: in %s we have a %s (%s)" % (message, key, value, type(value)))
        raise ValueError(message)


def _check_arguments(log, dbConn, dictionary, uniqueKeyList, createHelperTables):
    """*raise a TypeError or ValueError, after logging it, if any argument is unsuitable for writing to the database*"""
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
        if isinstance(v, list):
            _check_list_value(log, k, v)
        else:
            _check_scalar_value(log, k, v)

    if not isinstance(createHelperTables, bool):
        message = 'Please make sure "createHelperTables" is a True or False'
        log.critical(message)
        raise TypeError(message)


def _create_table_if_missing(log, dbConn, dbTableName, skipChecks):
    """*create the table, with its helper columns, unless it is already there (``skipChecks`` creates it without looking)*"""
    if not skipChecks:
        tableExists = table_exists.table_exists(
            dbConn=dbConn, log=log, dbTableName=dbTableName
        )
    else:
        tableExists = False

    if tableExists is not False:
        return

    quotedTable = quote_identifier(dbTableName)
    sqlQuery = """
                CREATE TABLE IF NOT EXISTS %(quotedTable)s
                (`primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
                `dateCreated` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
                `dateLastModified` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
                `updated` tinyint(4) DEFAULT '0',
                PRIMARY KEY (`primaryId`))
                ENGINE=Innodb AUTO_INCREMENT=0 DEFAULT CHARSET=latin1;
            """ % {"quotedTable": quotedTable}
    writequery(
        log=log,
        sqlQuery=sqlQuery,
        dbConn=dbConn,
    )


def _prepare_rows(dictionary, dateModified, replace):
    """*return the dictionary items to write as a new list sorted by key: values copied, the modified-date columns added if requested and values that start with None dropped*"""
    rows = {k: list(v) if isinstance(v, list) else v for k, v in dictionary.items()}

    if dateModified:
        rows["dateLastModified"] = [
            str(times.get_now_sql_datetime()),
            "date row was modified",
        ]
        if replace == False:
            rows["updated"] = [0, "this row has been updated"]
        else:
            rows["updated"] = [1, "this row has been updated"]

    kept = {k: v for k, v in rows.items() if not (isinstance(v, list) and v[0] is None)}
    # SORT BY KEY (AS STRINGS SO MIXED-TYPE KEYS CAN BE COMPARED)
    return sorted(kept.items(), key=lambda kv: str(kv[0]))


def _yaml_first_item(value):
    """*return a list value whose first item is a list with that item converted to yaml text (so it can be passed as a string to mysql), otherwise the value unchanged*"""
    if isinstance(value, list) and isinstance(value[0], list):
        return [str(yaml.dump(value[0]))] + value[1:]
    return value


def _row_value(value):
    """*return the database value for a dictionary value, which is the first item if it is a ``[value, comment]`` list*"""
    if not isinstance(value, list):
        return _database_value(value)
    first = value[0]
    return _database_value(first.strip() if isinstance(first, str) else first)


def _string_column_definition(text):
    """*return the column definition for a string, wider columns for long strings*"""
    if len(text) < LONG_STRING_MIN_LENGTH:
        return SHORT_VARCHAR_DEFINITION
    columnLength = LONG_STRING_BASE_WIDTH + len(text) * 2
    return "varchar(" + str(columnLength) + ") DEFAULT NULL"


def _column_definition(formattedKey, value, reDatetime):
    """*return the mysql definition of a new column chosen from the type of the value, or None if the value cannot be stored in a column*"""
    first = value[0] if isinstance(value, list) else value

    if reDatetime.search(str(first)):
        return "datetime DEFAULT NULL"
    if formattedKey in FIXED_VARCHAR_COLUMNS:
        return SHORT_VARCHAR_DEFINITION
    if isinstance(first, str):
        return _string_column_definition(first)
    if isinstance(first, bool):
        return "tinyint DEFAULT NULL"
    if isinstance(first, int):
        if abs(first) <= TINYINT_MAX_SIZE:
            return "tinyint DEFAULT NULL"
        return "int DEFAULT NULL"
    if isinstance(first, float):
        return "double DEFAULT NULL"
    if isinstance(first, list):
        return "varchar(1024) DEFAULT NULL"
    return None


def _column_exists(log, dbConn, dbTableName, formattedKey):
    """*return True if the table already has the column*"""
    colExists = (
        "SELECT * FROM information_schema.COLUMNS WHERE TABLE_SCHEMA=DATABASE() AND COLUMN_NAME="
        + _sql_literal(formattedKey)
        + " AND TABLE_NAME="
        + _sql_literal(dbTableName)
    )
    try:
        rows = readquery(
            log=log,
            sqlQuery=colExists,
            dbConn=dbConn,
        )
    except Exception as e:
        # WITHOUT ROWS WE CANNOT DECIDE WHETHER TO ALTER THE TABLE
        log.error("something went wrong" + str(e) + "\n")
        raise
    return len(rows) != 0


def _create_column(log, dbConn, dbTableName, key, formattedKey, definition):
    """*add the column to the table, with a comment giving the original key if it had to be changed for mysql*"""
    qCreateColumn = "ALTER TABLE %s ADD %s %s" % (
        quote_identifier(dbTableName),
        quote_identifier(formattedKey),
        definition,
    )
    if key != formattedKey:
        qCreateColumn += " COMMENT " + _sql_literal("original keyword: " + key)
    try:
        log.info(
            "creating the " + formattedKey + " column in the " + dbTableName + " table"
        )
        writequery(log=log, sqlQuery=qCreateColumn, dbConn=dbConn)

    except Exception as e:
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


def _ensure_column(log, dbConn, dbTableName, key, formattedKey, value, reDatetime):
    """*add the column to the table (``ALTER TABLE``) if it does not exist yet*

    **Return**

    - ``isStorable`` -- False if the column is missing and the value has a type that cannot be stored in a new column, so the value should be left out of the insert
    """
    if _column_exists(log, dbConn, dbTableName, formattedKey):
        return True
    definition = _column_definition(formattedKey, value, reDatetime)
    if definition is None:
        return False
    _create_column(log, dbConn, dbTableName, key, formattedKey, definition)
    return True


def _prepare_columns(log, dbConn, dbTableName, rows, reDatetime, addColumns):
    """*return the column names and the values to insert for the rows, and ``ALTER`` the table to add any missing columns if ``addColumns``*

    **Return**

    - ``formattedKeyList`` -- the mysql column names
    - ``myValues`` -- the value for each column
    """
    formattedKeyList = []
    myValues = []
    for key, value in rows:
        key = str(key)
        formattedKey = normalise_column_name(key)

        # RAISES VALUEERROR FOR AN EMPTY OR OTHERWISE INVALID COLUMN NAME
        quote_identifier(formattedKey)

        value = _yaml_first_item(value)
        if addColumns:
            isStorable = _ensure_column(
                log, dbConn, dbTableName, key, formattedKey, value, reDatetime
            )
            if not isStorable:
                continue
        formattedKeyList.append(formattedKey)
        myValues.append(_row_value(value))
    return formattedKeyList, myValues


def _add_unique_key(log, dbConn, dbTableName, uniqueKeyList):
    """*add a unique index over the key columns, named from them, unless the table already has it*"""
    uniqueColumns = [normalise_column_name(k) for k in uniqueKeyList]
    indexName = "_".join(uniqueColumns)
    indexName = indexName.lower().replace("  ", " ").replace(" ", "_")

    sqlQuery = (
        "SELECT COUNT(*) FROM INFORMATION_SCHEMA.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = "
        + _sql_literal(dbTableName)
        + " AND INDEX_NAME = "
        + _sql_literal(indexName)
    )
    rows = readquery(log=log, sqlQuery=sqlQuery, dbConn=dbConn, quiet=False)

    if rows[0]["COUNT(*)"] != 0:
        return

    addUniqueKey = (
        "ALTER TABLE "
        + quote_identifier(dbTableName)
        + " ADD unique "
        + quote_identifier(indexName)
        + " ("
        + ",".join(quote_identifier(k) for k in uniqueColumns)
        + ")"
    )
    writequery(log=log, sqlQuery=addUniqueKey, dbConn=dbConn)


def _execute_insert(log, dbConn, dbTableName, insertStatement):
    """*run the insert statement, logging and re-raising any failure with the table name added to the message*"""
    try:
        writequery(log=log, sqlQuery=insertStatement, dbConn=dbConn)

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
        # REFUSE CLASHING KEYS BEFORE ANY TABLE IS CREATED (NON-DICTS ARE REJECTED LATER BY THE ARGUMENT CHECKS)
        raise_on_duplicate_columns(dictionary.keys())

    if returnInsertOnly == False:
        _check_arguments(log, dbConn, dictionary, uniqueKeyList, createHelperTables)
        _create_table_if_missing(log, dbConn, dbTableName, skipChecks)

    # ITERATE THROUGH THE DICTIONARY AND GENERATE THE TABLE COLUMN WITH THE
    # NAME OF THE KEY, IF IT DOES NOT EXIST
    rows = _prepare_rows(dictionary, dateModified, replace)
    formattedKeyList, myValues = _prepare_columns(
        log, dbConn, dbTableName, rows, reDatetime, returnInsertOnly == False
    )

    if returnInsertOnly == False and len(uniqueKeyList):
        _add_unique_key(log, dbConn, dbTableName, uniqueKeyList)

    if returnInsertOnly == True and batchInserts == True:
        insertCommand = build_batch_insert_command(
            insertVerb, dbTableName, formattedKeyList, replace, dateCreated
        )
        return insertCommand, tuple(myValues)

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

    _execute_insert(log, dbConn, dbTableName, addValue)

    log.debug("completed the ``convert_dictionary_to_mysql_table`` function")
    return None, None
