from __future__ import print_function
from builtins import range
import os
import nose2
import nose2
import unittest
import shutil
import yaml
from fundamentals.utKit import utKit
import time
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
