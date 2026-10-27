from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml
import time
import sys
import tempfile
import pandas as pd
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

dictList = []

for i in range(100000):

    dictList.append({"col1": i, "col2": i + 10.0, "col3": i / 2.0, "col4": i * 34.0})

dbSettings = dbSettings = {
    "host": "127.0.0.1",
    "user": "utuser",
    "tunnel": False,
    "password": "utpass",
    "db": "unit_tests",
}


LOAD_IN_FILE_TABLE = "test_load_in_file_cleanup"
LOAD_IN_FILE_ROWS = [
    {"col1": i, "col2": i + 10.0, "col3": i / 2.0, "col4": i * 34.0} for i in range(5)
]


class test_insert_list_of_dictionaries_into_database_tables(unittest.TestCase):

    def setUp(self):
        from fundamentals.mysql import writequery

        self.insertModule = sys.modules[
            "fundamentals.mysql.insert_list_of_dictionaries_into_database_tables"
        ]
        self.originalTempdir = tempfile.tempdir
        self.redirectedTmp = os.path.join(pathToOutputDir, "redirected_tmp")
        shutil.rmtree(self.redirectedTmp, ignore_errors=True)
        os.makedirs(self.redirectedTmp)
        tempfile.tempdir = self.redirectedTmp
        self.csvPaths = []
        self.sqlStatements = []

        writequery(
            log=log,
            sqlQuery="DROP TABLE IF EXISTS %s;" % LOAD_IN_FILE_TABLE,
            dbConn=dbConn,
        )
        writequery(
            log=log,
            sqlQuery="""CREATE TABLE %s (col1 INT, col2 DOUBLE, col3 DOUBLE, col4 DOUBLE);"""
            % LOAD_IN_FILE_TABLE,
            dbConn=dbConn,
        )

    def tearDown(self):
        from fundamentals.mysql import writequery

        tempfile.tempdir = self.originalTempdir
        shutil.rmtree(self.redirectedTmp, ignore_errors=True)
        for csvPath in self.csvPaths:
            if os.path.exists(csvPath):
                os.remove(csvPath)
        writequery(
            log=log,
            sqlQuery="DROP TABLE IF EXISTS %s;" % LOAD_IN_FILE_TABLE,
            dbConn=dbConn,
        )

    def _load_in_file(self, failOnStatement=None):
        """Run the load-in-file worker directly, recording CSV paths and SQL."""
        realToCsv = pd.DataFrame.to_csv
        realWritequery = self.insertModule.writequery

        def spyToCsv(frame, path, *args, **kwargs):
            self.csvPaths.append(path)
            return realToCsv(frame, path, *args, **kwargs)

        def spyWritequery(log, sqlQuery, dbConn, **kwargs):
            self.sqlStatements.append(sqlQuery)
            if failOnStatement and failOnStatement in sqlQuery:
                raise RuntimeError("simulated writequery failure")
            return realWritequery(log=log, sqlQuery=sqlQuery, dbConn=dbConn, **kwargs)

        with mock.patch.object(
            self.insertModule, "sharedList", [(LOAD_IN_FILE_ROWS, 5)]
        ):
            with mock.patch.object(self.insertModule, "totalCount", 5):
                with mock.patch.object(pd.DataFrame, "to_csv", spyToCsv):
                    with mock.patch.object(
                        self.insertModule, "writequery", spyWritequery
                    ):
                        self.insertModule._add_dictlist_to_database_via_load_in_file(
                            masterListIndex=0,
                            dbTablename=LOAD_IN_FILE_TABLE,
                            dbSettings=dbSettings,
                        )

    def test_load_in_file_writes_csv_inside_tempdir_and_removes_it(self):
        from fundamentals.mysql import readquery

        self._load_in_file()

        self.assertEqual(len(self.csvPaths), 1)
        csvPath = self.csvPaths[0]
        self.assertTrue(csvPath.startswith(self.redirectedTmp + os.sep))
        self.assertTrue(
            any(
                "LOAD DATA LOCAL INFILE '%s'" % csvPath in q for q in self.sqlStatements
            )
        )
        self.assertFalse(os.path.exists(csvPath))
        self.assertEqual(os.listdir(self.redirectedTmp), [])
        dbConn.commit()
        rows = readquery(
            log=log,
            sqlQuery="SELECT COUNT(*) AS n FROM %s;" % LOAD_IN_FILE_TABLE,
            dbConn=dbConn,
        )
        self.assertEqual(rows[0]["n"], len(LOAD_IN_FILE_ROWS))

    def test_load_in_file_removes_csv_when_a_query_raises(self):
        with self.assertRaises(RuntimeError):
            self._load_in_file(failOnStatement="INSERT IGNORE")

        self.assertEqual(len(self.csvPaths), 1)
        self.assertFalse(os.path.exists(self.csvPaths[0]))
        self.assertEqual(os.listdir(self.redirectedTmp), [])

    def test_load_in_file_handles_quote_in_tempdir_path(self):
        from fundamentals.mysql import readquery

        quotedTmp = os.path.join(self.redirectedTmp, "o'brien")
        os.makedirs(quotedTmp)
        tempfile.tempdir = quotedTmp

        self._load_in_file()

        self.assertEqual(os.listdir(quotedTmp), [])
        dbConn.commit()
        rows = readquery(
            log=log,
            sqlQuery="SELECT COUNT(*) AS n FROM %s;" % LOAD_IN_FILE_TABLE,
            dbConn=dbConn,
        )
        self.assertEqual(rows[0]["n"], len(LOAD_IN_FILE_ROWS))

    def test_load_in_file_refuses_backslash_in_tempdir_path(self):
        slashTmp = os.path.join(self.redirectedTmp, "back\\slash")
        os.makedirs(slashTmp)
        tempfile.tempdir = slashTmp

        with self.assertRaises(ValueError):
            self._load_in_file()

        self.assertEqual(os.listdir(slashTmp), [])

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
            dbSettings=dbSettings,
        )

        # print(time.time() - t1)

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
