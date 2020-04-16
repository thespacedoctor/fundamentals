from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml
import re
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
    defaultSettingsFile=False
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

reDatetime = re.compile('^[0-9]{4}-[0-9]{2}-[0-9]{2}T')

class test_convert_dictionary_to_mysql_table(unittest.TestCase):

    def test_convert_dictionary_to_mysql_table_function(self):
        from fundamentals.mysql import writequery
        sqlQuery = "DROP TABLE IF EXISTS `testing_table`; CREATE TABLE IF NOT EXISTS `testing_table` (`id` INT NOT NULL  AUTO_INCREMENT,`uniquekey1` varchar(45) NOT NULL default 'ha',`uniqueKey2` varchar(45) NOT NULL default 'ha', `dateCreated` TIMESTAMP NOT NULL default CURRENT_TIMESTAMP, `dateModified` TIMESTAMP NOT NULL default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`id`) )"
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
            dateModified=True,
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
