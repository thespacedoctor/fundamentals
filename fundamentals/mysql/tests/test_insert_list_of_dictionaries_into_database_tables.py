from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml
import time
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

dictList = []

for i in range(100000):

    dictList.append({
        "col1": i,
        "col2": i + 10.,
        "col3": i / 2.,
        "col4": i * 34.
    })

dbSettings = dbSettings = {
    'host': '127.0.0.1',
    'user': 'utuser',
    'tunnel': False,
    'password': 'utpass',
    'db': 'unit_tests'
}

class test_insert_list_of_dictionaries_into_database_tables(unittest.TestCase):

    def test_insert_list_of_dictionaries_into_database_tables_function(self):

        t1 = time.time()

        from fundamentals.mysql import insert_list_of_dictionaries_into_database_tables
        insert_list_of_dictionaries_into_database_tables(
            dbConn=dbConn,
            log=log,
            dictList=dictList,
            dbTableName="test_insert_many",
            uniqueKeyList=["col1", "col3"],
            dateModified=True,
            batchSize=10000,
            replace=True,
            dbSettings=dbSettings
        )

        # print(time.time() - t1)

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
