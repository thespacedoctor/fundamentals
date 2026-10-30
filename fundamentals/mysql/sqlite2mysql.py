#!/usr/local/bin/python
# encoding: utf-8
"""
Take a sqlite database file and copy the tables within it to a MySQL database

Usage:
    sqlite2mysql -s <pathToSettingsFile> <pathToSqliteDB> [<tablePrefix>]

Options:

    pathToSqliteDB        path to the sqlite database file
    tablePrefix           a string to prefix the table names when copying to mysql database
    pathToSettingsFile    path to a settings file with logging and database information (yaml file)

    -h, --help            show this help message
    -v, --version         show version
    -s, --settings        the settings file
"""

from builtins import object
import sys
import os
import re
import sqlite3 as lite

os.environ["TERM"] = "vt100"
from fundamentals import tools
from fundamentals.mysql import writequery
from fundamentals.mysql.sql_identifiers import quote_identifier

from datetime import datetime, date, time

# THE START OF A SQLITE CREATE TABLE STATEMENT, UP TO AND INCLUDING THE TABLE NAME
CREATE_TABLE_HEADER_REGEX = re.compile(
    r"\A\s*CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?"
    r'(?:"(?:[^"]|"")+"|`(?:[^`]|``)+`|\[[^\]]+\]|\w+)',
    re.IGNORECASE,
)


# TOKENS OF A SQLITE STATEMENT: STRING LITERALS AND COMMENTS ARE KEPT AS THEY ARE, DOUBLE-QUOTED NAMES ARE CONVERTED
SQLITE_TOKEN_REGEX = re.compile(
    r"('(?:[^']|'')*'|--[^\n]*|/\*.*?\*/)" r'|"((?:[^"]|"")*)"',
    re.DOTALL,
)


def quote_sqlite_identifiers(sqliteSql):
    """*Return the sqlite SQL with each double-quoted name changed to a MySQL backtick-quoted name*

    String literals and comments are left as they are, so a double quote inside a default value is not changed.

    **Key Arguments**

    - ``sqliteSql`` -- the sqlite SQL text
    """

    def convert(match):
        if match.group(1) is not None:
            return match.group(1)
        return quote_identifier(match.group(2).replace('""', '"'))

    return SQLITE_TOKEN_REGEX.sub(convert, sqliteSql)


# AN IDENTIFIER ONCE THE DOUBLE QUOTES HAVE BEEN CHANGED TO BACKTICKS, OR A BARE WORD
IDENTIFIER_PATTERN = r"(?:`(?:[^`]|``)+`|\w+)"
# THE CLAUSES THAT CAN FOLLOW A REFERENCES CLAUSE
REFERENCES_PATTERN = (
    r"REFERENCES\s+" + IDENTIFIER_PATTERN + r"\s*(?:\([^)]*\))?"
    r"(?:\s+ON\s+(?:UPDATE|DELETE)\s+(?:SET\s+NULL|SET\s+DEFAULT|NO\s+ACTION|CASCADE|RESTRICT)"
    r"|\s+MATCH\s+\w+"
    r"|\s+(?:NOT\s+)?DEFERRABLE(?:\s+INITIALLY\s+(?:DEFERRED|IMMEDIATE))?)*"
)
# A TABLE-LEVEL CONSTRAINT, WITH THE COMMA THAT SEPARATES IT FROM THE DEFINITION BEFORE IT
TABLE_FOREIGN_KEY_REGEX = re.compile(
    r",\s*(?:CONSTRAINT\s+" + IDENTIFIER_PATTERN + r"\s+)?"
    r"FOREIGN\s+KEY\s*\([^)]*\)\s*" + REFERENCES_PATTERN,
    re.IGNORECASE,
)
COLUMN_REFERENCES_REGEX = re.compile(r"\s+" + REFERENCES_PATTERN, re.IGNORECASE)


def remove_foreign_keys(createBody):
    """*Return the body of a CREATE TABLE statement without its foreign key constraints*

    The MySQL copy is a plain mirror of the data, so it does not keep foreign keys. A MySQL foreign key needs the parent table to exist first, an index on the referenced columns, and key columns of the same type and length. A copy of sqlite ``TEXT`` columns meets none of these.

    **Key Arguments**

    - ``createBody`` -- the CREATE TABLE statement after the table name, with names quoted with backticks

    **Return**

    - ``createBody`` -- the text without column-level ``REFERENCES`` clauses and without table-level ``FOREIGN KEY`` constraints
    """
    createBody = TABLE_FOREIGN_KEY_REGEX.sub("", createBody)
    return COLUMN_REFERENCES_REGEX.sub("", createBody)


def main(arguments=None):
    """
    The main function used when ``yaml_to_database.py`` when installed as a cl tool
    """

    # setup the command-line util settings
    su = tools(
        arguments=arguments,
        docString=__doc__,
        logLevel="WARNING",
        options_first=False,
        projectName=False,
    )
    arguments, settings, log, dbConn = su.setup()

    pathToSqliteDB = arguments["<pathToSqliteDB>"]
    tablePrefix = arguments["<tablePrefix>"]

    from fundamentals.mysql import sqlite2mysql

    converter = sqlite2mysql(
        log=log,
        settings=settings,
        pathToSqlite=pathToSqliteDB,
        tablePrefix=tablePrefix,
        dbConn=dbConn,
    )
    converter.convert_sqlite_to_mysql()

    return


class sqlite2mysql(object):
    """
    *Take a sqlite database file and copy the tables within it to a MySQL database*

    **Key Arguments**

    - ``log`` -- logger
    - ``settings`` -- the settings dictionary. Optional; when it holds a ``database settings`` entry, that is passed on so the bulk insert can open one connection per process. Default *False*
    - ``pathToSqlite`` -- path to the sqlite database to transfer into the MySQL database
    - ``tablePrefix`` -- a prefix to add to all the tablename when converting to mysql. Default *""*
    - ``dbConn`` -- mysql database connection. **Required**: a ``ValueError`` is raised if it is missing


    **Usage**

    To setup your logger, settings and database connections, please use the ``fundamentals`` package (see tutorial here https://fundamentals.readthedocs.io/en/master/initialisation.html).

    To convert and import the content of a sqlite database into MySQL run the following:

    .. todo::

        - add a tutorial about ``sqlite2mysql`` to documentation

    ```python
    from fundamentals.mysql import sqlite2mysql
    converter = sqlite2mysql(
        log=log,
        settings=settings,
        pathToSqlite="/path/to/sqlite.db",
        tablePrefix="external",
        dbConn=dbConn
    )
    converter.convert_sqlite_to_mysql()
    ```

    """

    # Initialisation

    def __init__(self, log, pathToSqlite, tablePrefix="", settings=False, dbConn=None):
        if dbConn is None or dbConn is False:
            raise ValueError(
                "sqlite2mysql requires a database connection: pass dbConn=<connection>"
            )
        self.log = log
        log.debug("instansiating a new 'sqlite2mysql' object")
        self.settings = settings
        self.pathToSqlite = pathToSqlite
        self.tablePrefix = tablePrefix
        self.dbConn = dbConn

        if not self.tablePrefix:
            self.tablePrefix = ""

        if len(self.tablePrefix):
            self.tablePrefix = self.tablePrefix + "_"
        # xt-self-arg-tmpx

        return None

    def convert_sqlite_to_mysql(self):
        """*copy the contents of the sqlite database into the mysql database*

        See class docstring for usage
        """
        self.log.debug("starting the ``convert_sqlite_to_mysql`` method")

        con = lite.connect(self.pathToSqlite)
        try:
            con.row_factory = lite.Row
            cur = con.cursor()
            try:
                self._copy_tables(cur)
            finally:
                cur.close()
        finally:
            con.close()

        self.log.debug("completed the ``convert_sqlite_to_mysql`` method")
        return None

    def _copy_tables(self, cur):
        """*copy every table read through the sqlite cursor into the mysql database*

        **Key Arguments**

        - ``cur`` -- an open sqlite cursor (closed by the caller)
        """
        from fundamentals.renderer import list_of_dictionaries
        from fundamentals.mysql import directory_script_runner

        # GET ALL TABLE NAMES
        cur.execute("SELECT name FROM sqlite_master WHERE type='table';")
        tables = cur.fetchall()

        createStatements = []
        inserts = []
        for table in tables:
            table = table["name"]
            if table == "sqlite_sequence":
                continue

            # CREATE TABLE collection_books (folder_id, fingerprint, primary key(folder_id, fingerprint));
            # GENEREATE THE MYSQL CREATE STATEMENTS FOR EACH TABLE
            cur.execute("SELECT sql FROM sqlite_master WHERE name = ?;", (table,))
            createStatement = cur.fetchone()
            createStatement = createStatement[0]
            headerMatch = CREATE_TABLE_HEADER_REGEX.match(createStatement)
            if headerMatch is None:
                raise ValueError(
                    "cannot find the table name in the sqlite statement: %s"
                    % (createStatement,)
                )
            # THE BODY IS CONVERTED ON ITS OWN SO THE QUOTED TABLE NAME IS NEVER REWRITTEN
            createStatement = (
                remove_foreign_keys(
                    quote_sqlite_identifiers(createStatement[headerMatch.end() :])
                )
                + ";"
            )
            if "DEFAULT" not in createStatement:
                if "primary key(" in createStatement:
                    tmp = createStatement.split("primary key(")
                    tmp[0] = tmp[0].replace(",", " varchar(150) DEFAULT NULL,")
                    createStatement = ("primary key(").join(tmp)
                if "primary key," in createStatement:
                    tmp = createStatement.split("primary key,")
                    tmp[1] = tmp[1].replace(",", " varchar(150) DEFAULT NULL,")
                    tmp[1] = tmp[1].replace(");", " varchar(150) DEFAULT NULL);")
                    createStatement = ("primary key,").join(tmp)
            createStatement = createStatement.replace(
                "INTEGER PRIMARY KEY", "INTEGER AUTO_INCREMENT PRIMARY KEY"
            )
            createStatement = createStatement.replace("AUTOINCREMENT", "AUTO_INCREMENT")
            createStatement = createStatement.replace("DEFAULT 't'", "DEFAULT '1'")
            createStatement = createStatement.replace("DEFAULT 'f'", "DEFAULT '0'")
            createStatement = createStatement.replace(",'t'", ",'1'")
            createStatement = createStatement.replace(",'f'", ",'0'")
            if ", primary key(" in createStatement:
                createStatement = createStatement.replace(
                    ", primary key(",
                    """,
`dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
`dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP,
`updated` tinyint(4) DEFAULT '0',
primary key(""",
                )
            else:
                createStatement = createStatement.replace(
                    ");",
                    """,
    `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
    `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP,
    `updated` tinyint(4) DEFAULT '0');
                """,
                )
            createStatement = createStatement.replace(
                " text primary key", " varchar(100) primary key"
            )
            createStatement = createStatement.replace(
                "`EntryText` TEXT NOT NULL,", "`EntryText` TEXT,"
            )
            createStatement = createStatement.replace(
                "`SelectionText` TEXT NOT NULL", "`SelectionText` TEXT"
            )
            createStatement = createStatement.replace(
                "`Filename` INTEGER NOT NULL,", "`Filename` TEXT NOT NULL,"
            )
            createStatement = createStatement.replace(
                "`SessionPartUUID` TEXT NOT NULL UNIQUE,",
                "`SessionPartUUID` VARCHAR(100) NOT NULL UNIQUE,",
            )
            createStatement = createStatement.replace(
                "`Name` TEXT PRIMARY KEY NOT NULL",
                "`Name` VARCHAR(100) PRIMARY KEY NOT NULL",
            )
            createStatement = createStatement.replace(" VARCHAR ", " VARCHAR(100) ")
            createStatement = createStatement.replace(" VARCHAR,", " VARCHAR(100),")

            if len(createStatement.lower().split("datecreated")) > 2:
                createStatement = createStatement.replace(
                    "`dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,\n", ""
                )

            createStatement = (
                "CREATE TABLE IF NOT EXISTS "
                + quote_identifier(self.tablePrefix + table)
                + createStatement
            )

            # GRAB THE DATA TO ADD TO THE MYSQL DATABASE TABLES
            quotedTable = '"' + table.replace('"', '""') + '"'
            cur.execute("SELECT * FROM %s;" % (quotedTable,))
            rows = cur.fetchall()

            allRows = []
            dateCreated = True
            for row in rows:
                thisDict = dict(row)
                # CHECK FOR DATE-CREATED COLUMN - DON'T WANT TO DUPLICATE
                if dateCreated and "datecreated" in str(thisDict.keys()).lower():
                    dateCreated = False
                allRows.append(thisDict)

            writequery(
                log=self.log,
                sqlQuery=createStatement,
                dbConn=self.dbConn,
            )

            from fundamentals.mysql import (
                insert_list_of_dictionaries_into_database_tables,
            )

            # USE dbSettings TO ACTIVATE MULTIPROCESSING, IF SETTINGS WERE GIVEN
            insertKwargs = {}
            if self.settings and "database settings" in self.settings:
                insertKwargs["dbSettings"] = self.settings["database settings"]
            insert_list_of_dictionaries_into_database_tables(
                dbConn=self.dbConn,
                log=self.log,
                dictList=allRows,
                dbTableName=self.tablePrefix + table,
                uniqueKeyList=[],
                dateModified=True,
                dateCreated=dateCreated,
                batchSize=10000,
                replace=True,
                **insertKwargs,
            )

    # use the tab-trigger below for new method
    # xt-class-method


if __name__ == "__main__":
    main()
