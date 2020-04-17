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
import sqlite3 as lite
os.environ['TERM'] = 'vt100'
from fundamentals import tools
from fundamentals.mysql import writequery

from datetime import datetime, date, time

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
        projectName=False
    )
    arguments, settings, log, dbConn = su.setup()

    # unpack remaining cl arguments using `exec` to setup the variable names
    # automatically
    for arg, val in list(arguments.items()):
        if arg[0] == "-":
            varname = arg.replace("-", "") + "Flag"
        else:
            varname = arg.replace("<", "").replace(">", "")
        if isinstance(val, str):
            exec(varname + " = '%s'" % (val,))
        else:
            exec(varname + " = %s" % (val,))
        if arg == "--dbConn":
            dbConn = val
        log.debug('%s = %s' % (varname, val,))

    from fundamentals.mysql import sqlite2mysql
    converter = sqlite2mysql(
        log=log,
        settings=settings,
        pathToSqlite=pathToSqliteDB,
        tablePrefix=tablePrefix,
        dbConn=dbConn
    )
    converter.convert_sqlite_to_mysql()

    return

class sqlite2mysql(object):
    """
    *Take a sqlite database file and copy the tables within it to a MySQL database*

    **Key Arguments**

    - ``log`` -- logger
    - ``settings`` -- the settings dictionary
    - ``pathToSqlite`` -- path to the sqlite database to transfer into the MySQL database
    - ``tablePrefix`` -- a prefix to add to all the tablename when converting to mysql. Default *""*
    - ``dbConn`` -- mysql database connection 
    

    **Usage**

    To setup your logger, settings and database connections, please use the ``fundamentals`` package (`see tutorial here <http://fundamentals.readthedocs.io/en/latest/#tutorial>`_). 

    To convert and import the content of a sqlite database into MySQL run the following:

    .. todo::

        - add a tutorial about ``sqlite2mysql`` to documentation

    ```python
    from fundamentals.mysql import sqlite2mysql
    converter = sqlite2mysql(
        log=log,
        settings=settings,
        pathToSqlite="/path/to/sqlite.db",
        tablePrefix="external"
    )
    converter.convert_sqlite_to_mysql()
    ```
    
    """
    # Initialisation

    def __init__(
            self,
            log,
            pathToSqlite,
            tablePrefix="",
            settings=False,
            dbConn=False
    ):
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

    def convert_sqlite_to_mysql(
            self):
        """*copy the contents of the sqlite database into the mysql database*

        See class docstring for usage
        """
        from fundamentals.renderer import list_of_dictionaries
        from fundamentals.mysql import directory_script_runner
        self.log.debug('starting the ``convert_sqlite_to_mysql`` method')

        con = lite.connect(self.pathToSqlite)
        con.row_factory = lite.Row
        cur = con.cursor()

        # GET ALL TABLE NAMES
        cur.execute("SELECT name FROM sqlite_master WHERE type='table';")
        tables = cur.fetchall()

        createStatements = []
        inserts = []
        for table in tables:
            table = table['name']
            if table == "sqlite_sequence":
                continue

            # CREATE TABLE collection_books (folder_id, fingerprint, primary key(folder_id, fingerprint));
            # GENEREATE THE MYSQL CREATE STATEMENTS FOR EACH TABLE
            cur.execute(
                "SELECT sql FROM sqlite_master WHERE name = '%(table)s';" % locals())
            createStatement = cur.fetchone()
            createStatement = createStatement[0].replace('"', '`') + ";"
            if "DEFAULT" not in createStatement:
                if "primary key(" in createStatement:
                    tmp = createStatement.split("primary key(")
                    tmp[0] = tmp[0].replace(
                        ",", " varchar(150) DEFAULT NULL,")
                    createStatement = ("primary key(").join(tmp)
                if "primary key," in createStatement:
                    tmp = createStatement.split("primary key,")
                    tmp[1] = tmp[1].replace(
                        ",", " varchar(150) DEFAULT NULL,")
                    tmp[1] = tmp[1].replace(
                        ");", " varchar(150) DEFAULT NULL);")
                    createStatement = ("primary key,").join(tmp)
            createStatement = createStatement.replace(
                "INTEGER PRIMARY KEY", "INTEGER AUTO_INCREMENT PRIMARY KEY")
            createStatement = createStatement.replace(
                "AUTOINCREMENT", "AUTO_INCREMENT")
            createStatement = createStatement.replace(
                "DEFAULT 't'", "DEFAULT '1'")
            createStatement = createStatement.replace(
                "DEFAULT 'f'", "DEFAULT '0'")
            createStatement = createStatement.replace(",'t'", ",'1'")
            createStatement = createStatement.replace(",'f'", ",'0'")
            if "CREATE TABLE `" in createStatement:
                createStatement = createStatement.replace(
                    "CREATE TABLE `", "CREATE TABLE IF NOT EXISTS `" + self.tablePrefix)
            else:
                createStatement = createStatement.replace(
                    "CREATE TABLE ", "CREATE TABLE IF NOT EXISTS " + self.tablePrefix)
            if ", primary key(" in createStatement:
                createStatement = createStatement.replace(", primary key(", """,
`dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
`dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP,
`updated` tinyint(4) DEFAULT '0',
primary key(""")
            else:
                createStatement = createStatement.replace(");", """,
    `dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,
    `dateLastModified` datetime DEFAULT CURRENT_TIMESTAMP,
    `updated` tinyint(4) DEFAULT '0');
                """)
            createStatement = createStatement.replace(
                " text primary key", " varchar(100) primary key")
            createStatement = createStatement.replace(
                "`EntryText` TEXT NOT NULL,", "`EntryText` TEXT,")
            createStatement = createStatement.replace(
                "`SelectionText` TEXT NOT NULL", "`SelectionText` TEXT")
            createStatement = createStatement.replace(
                "`Filename` INTEGER NOT NULL,", "`Filename` TEXT NOT NULL,")
            createStatement = createStatement.replace(
                "`SessionPartUUID` TEXT NOT NULL UNIQUE,", "`SessionPartUUID` VARCHAR(100) NOT NULL UNIQUE,")
            createStatement = createStatement.replace(
                "`Name` TEXT PRIMARY KEY NOT NULL", "`Name` VARCHAR(100) PRIMARY KEY NOT NULL")
            createStatement = createStatement.replace(
                " VARCHAR ", " VARCHAR(100) ")
            createStatement = createStatement.replace(
                " VARCHAR,", " VARCHAR(100),")

            if len(createStatement.lower().split("datecreated")) > 2:
                createStatement = createStatement.replace(
                    "`dateCreated` datetime DEFAULT CURRENT_TIMESTAMP,\n", "")

            # GRAB THE DATA TO ADD TO THE MYSQL DATABASE TABLES
            cur.execute(
                "SELECT * from '%(table)s';" % locals())
            rows = cur.fetchall()

            allRows = []
            dateCreated = True
            for row in rows:
                thisDict = dict(row)
                # CHECK FOR DATE-CREATED COLUMN - DON'T WANT TO DUPLICATE
                if dateCreated and "datecreated" in str(thisDict.keys()).lower():
                    dateCreated = False
                allRows.append(thisDict)

            # RECURSIVELY CREATE MISSING DIRECTORIES
            if not os.path.exists("/tmp/headjack/"):
                os.makedirs("/tmp/headjack/")

            writequery(
                log=self.log,
                sqlQuery=createStatement,
                dbConn=self.dbConn,
            )

            from fundamentals.mysql import insert_list_of_dictionaries_into_database_tables
            # USE dbSettings TO ACTIVATE MULTIPROCESSING
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
                dbSettings=self.settings["database settings"]
            )

            # # DUMP THE DATA INTO A MYSQL DATABASE
            # dataSet = list_of_dictionaries(
            #     log=self.log,
            #     listOfDictionaries=allRows
            # )
            # originalList = dataSet.list
            # now = datetime.now()
            # now = now.strftime("%Y%m%dt%H%M%S%f.sql")
            # mysqlData = dataSet.mysql(
            # tableName=self.tablePrefix + table, filepath="/tmp/headjack/" +
            # now, createStatement=createStatement)

            # directory_script_runner(
            #     log=self.log,
            #     pathToScriptDirectory="/tmp/headjack/",
            #     databaseName=self.settings["database settings"]["db"],
            #     loginPath=self.settings["database settings"]["loginPath"],
            #     successRule="delete",
            #     failureRule="failed"
            # )

        con.close()

        self.log.debug('completed the ``convert_sqlite_to_mysql`` method')
        return None

    # use the tab-trigger below for new method
    # xt-class-method

if __name__ == '__main__':
    main()
