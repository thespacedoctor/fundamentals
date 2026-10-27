from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml
import re
import copy
import sys
from unittest import mock
from fundamentals.utKit import utKit
from fundamentals import tools
from os.path import expanduser

home = expanduser("~")

packageDirectory = utKit("").get_project_root()
settingsFile = packageDirectory + "/test_settings.yaml"
# settingsFile = home + "/.config/soxspipe.recipes/soxspipe.recipes.yaml"
su = tools(
    arguments={"settingsFile": settingsFile},
    docString=__doc__,
    logLevel="DEBUG",
    options_first=False,
    projectName=None,
    defaultSettingsFile=False,
)
arguments, settings, log, dbConn = su.setup()

# SETUP AND TEARDOWN FIXTURE FUNCTIONS FOR THE ENTIRE MODULE
moduleDirectory = os.path.dirname(__file__)
utKit = utKit(moduleDirectory)
log, dbConn, pathToInputDir, pathToOutputDir = utKit.setupModule()
utKit.tearDownModule()

try:
    shutil.rmtree(pathToOutputDir)
except:
    pass
# COPY INPUT TO OUTPUT DIR
shutil.copytree(pathToInputDir, pathToOutputDir)

# Recursively create missing directories
if not os.path.exists(pathToOutputDir):
    os.makedirs(pathToOutputDir)

reDatetime = re.compile("^[0-9]{4}-[0-9]{2}-[0-9]{2}T")


class test_convert_dictionary_to_mysql_table(unittest.TestCase):

    def test_convert_dictionary_to_mysql_table_function(self):
        from fundamentals.mysql import writequery

        sqlQuery = "DROP TABLE IF EXISTS `testing_table`; CREATE TABLE IF NOT EXISTS `testing_table` (`id` INT NOT NULL  AUTO_INCREMENT,`uniquekey1` varchar(45) NOT NULL default 'ha',`uniqueKey2` varchar(45) NOT NULL default 'ha', `dateCreated` TIMESTAMP NOT NULL default CURRENT_TIMESTAMP, `dateModified` TIMESTAMP NOT NULL default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`id`) )"
        writequery(
            log=log, sqlQuery=sqlQuery, dbConn=dbConn, Force=False, manyValueList=False
        )

        dictionary = {
            "a newKey": "cool",
            "and another": "super cool",
            "uniquekey1": "cheese",
            "uniqueKey2": "burgers",
        }
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        message = convert_dictionary_to_mysql_table(
            dbConn=dbConn,
            log=log,
            dictionary=dictionary,
            dbTableName="testing_table",
            uniqueKeyList=["uniquekey1", "uniqueKey2"],
            createHelperTables=False,
            dateModified=True,
            returnInsertOnly=False,
        )

    def test_return_inserts(self):
        from fundamentals.mysql import writequery

        sqlQuery = "CREATE TABLE IF NOT EXISTS `testing_table` (`id` INT NOT NULL, PRIMARY KEY (`id`))"
        writequery(
            log=log, sqlQuery=sqlQuery, dbConn=dbConn, Force=False, manyValueList=False
        )

        dictionary = {
            "a newKey": "cool",
            "and another": "super cool",
            "uniquekey1": "cheese",
            "uniqueKey2": "burgers",
        }
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
        )
        # print(message)

    def test_return_inserts_with_datetime_pre_compiled(self):
        from fundamentals.mysql import writequery

        sqlQuery = "CREATE TABLE IF NOT EXISTS `testing_table` (`id` INT NOT NULL, PRIMARY KEY (`id`))"
        writequery(
            log=log, sqlQuery=sqlQuery, dbConn=dbConn, Force=False, manyValueList=False
        )

        dictionary = {
            "a newKey": "cool",
            "and another": "super cool",
            "uniquekey1": "cheese",
            "uniqueKey2": "burgers",
        }
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
            reDatetime=reDatetime,
        )
        # print(message)

    def test_return_inserts_non_batch(self):
        dictionary = {
            "a newKey": "cool",
            "and another": "super cool",
            "uniquekey1": "cheese",
            "uniqueKey2": "burgers",
        }
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
            batchInserts=False,
        )

        # x-print-testpage-for-pessto-marshall-web-object

    def test_does_not_mutate_caller_dictionary_when_returning_inserts(self):
        # ARRANGE
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        dictionary = {
            "a newKey": "cool",
            "nested": [["x", "y"], "a nested list value"],
            "skipped": [None, "a value that is dropped"],
            "uniquekey1": "cheese",
        }
        original = copy.deepcopy(dictionary)

        # ACT
        convert_dictionary_to_mysql_table(
            log=log,
            dictionary=dictionary,
            dbTableName="dy2028_testing_table",
            uniqueKeyList=["uniquekey1"],
            dateModified=True,
            returnInsertOnly=True,
        )

        # ASSERT
        self.assertEqual(dictionary, original)

    def test_does_not_mutate_caller_dictionary_when_writing_to_database(self):
        # ARRANGE
        dictionary = {
            "uni key": "cheese",
            "skipped": [None, "a value that is dropped"],
        }
        original = copy.deepcopy(dictionary)

        # ACT
        self._write_to_database(
            "dy2028_dictionary_table", dictionary, ["uni key"], dateModified=True
        )

        # ASSERT
        self.assertEqual(dictionary, original)

    def test_does_not_mutate_caller_unique_key_list(self):
        # ARRANGE
        dictionary = {"uni key": "cheese", "dec": "burgers"}
        uniqueKeyList = ["uni key", "dec"]

        # ACT
        self._write_to_database(
            "dy2028_unique_key_table", dictionary, uniqueKeyList, dateModified=False
        )

        # ASSERT
        self.assertEqual(uniqueKeyList, ["uni key", "dec"])

    def _write_to_database(self, tableName, dictionary, uniqueKeyList, dateModified):
        from fundamentals.mysql import convert_dictionary_to_mysql_table, writequery

        try:
            convert_dictionary_to_mysql_table(
                dbConn=dbConn,
                log=log,
                dictionary=dictionary,
                dbTableName=tableName,
                uniqueKeyList=uniqueKeyList,
                dateModified=dateModified,
            )
        finally:
            writequery(
                log=log,
                sqlQuery="DROP TABLE IF EXISTS `%s`" % (tableName,),
                dbConn=dbConn,
            )

    def test_raises_when_column_check_query_fails(self):
        # ARRANGE
        from fundamentals.mysql import writequery

        module = sys.modules["fundamentals.mysql.convert_dictionary_to_mysql_table"]
        tableName = "dy2028_column_check_table"

        # ACT / ASSERT
        try:
            with mock.patch.object(
                module, "readquery", side_effect=RuntimeError("column check failed")
            ):
                with self.assertRaises(RuntimeError):
                    module.convert_dictionary_to_mysql_table(
                        dbConn=dbConn,
                        log=log,
                        dictionary={"a newKey": "cool", "another": "value"},
                        dbTableName=tableName,
                    )
        finally:
            writequery(
                log=log,
                sqlQuery="DROP TABLE IF EXISTS `%s`" % (tableName,),
                dbConn=dbConn,
            )

    # x-class-to-test-named-worker-function
