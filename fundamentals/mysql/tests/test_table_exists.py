from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml
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

class test_table_exists(unittest.TestCase):

    def test_table_exists_function(self):

        from fundamentals.mysql import writequery
        sqlQuery = "CREATE TABLE IF NOT EXISTS `testing_table` (`id` INT NOT NULL, PRIMARY KEY (`id`))"
        writequery(
            log=log,
            sqlQuery=sqlQuery,
            dbConn=dbConn,
            Force=False,
            manyValueList=False
        )

        from fundamentals.mysql import table_exists
        tableName = "testing_table"
        this = table_exists(
            dbConn=dbConn,
            log=log,
            dbTableName=tableName
        )
        # print("%(tableName)s exists: %(this)s" % locals())

        from fundamentals.mysql import writequery
        sqlQuery = "DROP TABLE `testing_table`;"
        writequery(
            log=log,
            sqlQuery=sqlQuery,
            dbConn=dbConn,
            Force=False,
            manyValueList=False
        )

    def test_table_exists_function02(self):

        from fundamentals.mysql import table_exists
        tableName = "stupid_named_table"
        this = table_exists(
            dbConn=dbConn,
            log=log,
            dbTableName=tableName
        )
        # print("%(tableName)s exists: %(this)s" % locals())

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
