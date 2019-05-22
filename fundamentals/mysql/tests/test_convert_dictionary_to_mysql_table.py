from __future__ import print_function
import os
import nose2
import nose2
import unittest
import shutil
import yaml
import re

from fundamentals.utKit import utKit

from fundamentals import tools

su = tools(
    arguments={"settingsFile": None},
    docString=__doc__,
    logLevel="DEBUG",
    options_first=False,
    projectName="fundamentals"
)
arguments, settings, log, dbConn = su.setup()

# load settings
stream = open(
    "/Users/Dave/.config/fundamentals/fundamentals.yaml", 'r')
settings = yaml.load(stream)
stream.close()

# SETUP AND TEARDOWN FIXTURE FUNCTIONS FOR THE ENTIRE MODULE
moduleDirectory = os.path.dirname(__file__)
utKit = utKit(moduleDirectory)
log, dbConn, pathToInputDir, pathToOutputDir = utKit.setupModule()
utKit.tearDownModule()

reDatetime = re.compile('^[0-9]{4}-[0-9]{2}-[0-9]{2}T')


class test_convert_dictionary_to_mysql_table(unittest.TestCase):

    def test_convert_dictionary_to_mysql_table_function(self):
        from fundamentals.mysql import writequery
        sqlQuery = "DROP TABLE IF EXISTS `testing_table`; CREATE TABLE IF NOT EXISTS `testing_table` (`id` INT NOT NULL,`uniquekey1` varchar(45) NOT NULL default 'ha',`uniqueKey2` varchar(45) NOT NULL default 'ha', PRIMARY KEY (`id`))"
        writequery(
            log=log,
            sqlQuery=sqlQuery,
            dbConn=dbConn,
            Force=False,
            manyValueList=False
        )

        dictionary = {"a newKey": "cool", "and another": "super cool",
                      "uniquekey1": "cheese", "uniqueKey2": "burgers"}
        from fundamentals.mysql import convert_dictionary_to_mysql_table
        message = convert_dictionary_to_mysql_table(
            dbConn=dbConn,
            log=log,
            dictionary=dictionary,
            dbTableName="testing_table",
            uniqueKeyList=["uniquekey1", "uniqueKey2"],
            createHelperTables=False,
            dateModified=False,
            returnInsertOnly=False
        )

    def test_return_inserts(self):
        from fundamentals.mysql import writequery
        sqlQuery = "CREATE TABLE IF NOT EXISTS `testing_table` (`id` INT NOT NULL, PRIMARY KEY (`id`))"
        writequery(
            log=log,
            sqlQuery=sqlQuery,
            dbConn=dbConn,
            Force=False,
            manyValueList=False
        )

        dictionary = {"a newKey": "cool", "and another": "super cool",
                      "uniquekey1": "cheese", "uniqueKey2": "burgers"}
        from fundamentals.mysql import convert_dictionary_to_mysql_table
        message = convert_dictionary_to_mysql_table(
            dbConn=dbConn,
            log=log,
            dictionary=dictionary,
            dbTableName="testing_table",
            uniqueKeyList=["uniquekey1", "uniqueKey2"],
            createHelperTables=False,
            dateModified=False,
            returnInsertOnly=True
        )
        # print(message)

    def test_return_inserts_with_datetime_pre_compiled(self):
        from fundamentals.mysql import writequery
        sqlQuery = "CREATE TABLE IF NOT EXISTS `testing_table` (`id` INT NOT NULL, PRIMARY KEY (`id`))"
        writequery(
            log=log,
            sqlQuery=sqlQuery,
            dbConn=dbConn,
            Force=False,
            manyValueList=False
        )

        dictionary = {"a newKey": "cool", "and another": "super cool",
                      "uniquekey1": "cheese", "uniqueKey2": "burgers"}
        from fundamentals.mysql import convert_dictionary_to_mysql_table
        message = convert_dictionary_to_mysql_table(
            dbConn=dbConn,
            log=log,
            dictionary=dictionary,
            dbTableName="testing_table",
            uniqueKeyList=["uniquekey1", "uniqueKey2"],
            createHelperTables=False,
            dateModified=False,
            returnInsertOnly=True,
            reDatetime=reDatetime
        )
        # print(message)

    def test_return_inserts_non_batch(self):
        dictionary = {"a newKey": "cool", "and another": "super cool",
                      "uniquekey1": "cheese", "uniqueKey2": "burgers"}
        from fundamentals.mysql import convert_dictionary_to_mysql_table
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

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
