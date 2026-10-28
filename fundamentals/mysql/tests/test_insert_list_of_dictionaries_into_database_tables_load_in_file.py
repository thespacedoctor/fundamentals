from __future__ import print_function
import os
import unittest
import shutil
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
                            log=log,
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
        from fundamentals.mysql import (
            insert_list_of_dictionaries_into_database_tables,
            readquery,
            writequery,
        )

        # THE TABLE IS CREATED HERE BECAUSE table_exists LOOKS IN EVERY SCHEMA, SO A
        # test_insert_many TABLE IN ANOTHER SCHEMA WOULD STOP IT BEING CREATED IN unit_tests
        writequery(
            log=log, sqlQuery="DROP TABLE IF EXISTS test_insert_many;", dbConn=dbConn
        )
        self.addCleanup(
            writequery,
            log=log,
            sqlQuery="DROP TABLE IF EXISTS test_insert_many;",
            dbConn=dbConn,
        )
        writequery(
            log=log,
            sqlQuery="""CREATE TABLE test_insert_many
                (`primaryId` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'An internal counter',
                `dateCreated` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
                `dateLastModified` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
                `updated` tinyint(4) DEFAULT '0',
                PRIMARY KEY (`primaryId`))
                ENGINE=Innodb AUTO_INCREMENT=0 DEFAULT CHARSET=latin1;""",
            dbConn=dbConn,
        )

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

        dbConn.commit()
        rows = readquery(
            log=log,
            sqlQuery="SELECT COUNT(*) AS n FROM test_insert_many;",
            dbConn=dbConn,
        )
        self.assertEqual(rows[0]["n"], len(dictList))

    # x-class-to-test-named-worker-function

class test_load_in_file_statements(unittest.TestCase):
    """The LOAD DATA worker run against a mocked connection that records its SQL."""

    def setUp(self):
        self.insertModule = sys.modules[
            "fundamentals.mysql.insert_list_of_dictionaries_into_database_tables"
        ]
        self.sqlStatements = []
        self.writequeryLogs = []
        self.connectionMock = mock.Mock()
        self.databaseMock = mock.Mock()
        self.databaseMock.return_value.connect.return_value = self.connectionMock

    def _run_load(
        self,
        rows,
        dbTablename="sweep2_insert_statements",
        replace=False,
        dateModified=False,
        failOnStatement=None,
    ):
        def recordWritequery(log, sqlQuery, dbConn, **kwargs):
            self.sqlStatements.append(sqlQuery)
            self.writequeryLogs.append(log)
            if failOnStatement and failOnStatement in sqlQuery:
                raise RuntimeError("simulated writequery failure")
            return ""

        with mock.patch.object(self.insertModule, "sharedList", [(rows, len(rows))]):
            with mock.patch.object(self.insertModule, "totalCount", len(rows)):
                with mock.patch.object(self.insertModule, "database", self.databaseMock):
                    with mock.patch.object(
                        self.insertModule, "writequery", recordWritequery
                    ):
                        self.insertModule._add_dictlist_to_database_via_load_in_file(
                            masterListIndex=0,
                            log=log,
                            dbTablename=dbTablename,
                            dbSettings=dbSettings,
                            dateModified=dateModified,
                            replace=replace,
                        )

    def _statement_containing(self, text):
        return next(q for q in self.sqlStatements if text in q)

    def test_marks_none_nan_and_empty_values_null_and_keeps_none_and_null_text(self):
        # ARRANGE
        rows = [
            {
                "a": None,
                "b": "None",
                "c": "",
                "d": float("nan"),
                "e": "null",
                "f": "kept",
            }
        ]
        loadedFrames = []

        def recordFrame(log, dbConn, df, *args):
            loadedFrames.append(df.copy())

        # ACT
        with mock.patch.object(
            self.insertModule, "_load_dataframe_into_table", recordFrame
        ):
            self._run_load(rows)

        # ASSERT
        self.assertEqual(
            loadedFrames[0].iloc[0].tolist(),
            ["\\N", "None", "\\N", "\\N", "null", "kept"],
        )

    def test_does_not_update_duplicates_when_replace_is_false(self):
        # ARRANGE
        rows = [{"col1": 1, "col2": 2.0}]

        # ACT
        self._run_load(rows, replace=False)

        # ASSERT
        insertStatement = self._statement_containing("INSERT IGNORE")
        self.assertNotIn("ON DUPLICATE KEY UPDATE", insertStatement)

    def test_updates_duplicates_when_replace_is_true(self):
        # ARRANGE
        rows = [{"col1": 1, "col2": 2.0}]

        # ACT
        self._run_load(rows, replace=True)

        # ASSERT
        insertStatement = self._statement_containing("INSERT IGNORE")
        self.assertIn("ON DUPLICATE KEY UPDATE `col1` = VALUES(`col1`)", insertStatement)

    def test_maps_dec_and_keys_with_separators_to_column_names_in_every_column_list(
        self,
    ):
        # ARRANGE
        rows = [{"dec": 1.5, "my key": 2, "other-key": 3}]

        # ACT
        self._run_load(rows, replace=True)

        # ASSERT
        loadStatement = self._statement_containing("LOAD DATA")
        insertStatement = self._statement_containing("INSERT IGNORE")
        for statement in (loadStatement, insertStatement):
            for column in ("`decl`", "`my_key`", "`other_key`"):
                self.assertIn(column, statement)
            for original in ("`dec`", "`my key`", "`other-key`"):
                self.assertNotIn(original, statement)
        self.assertIn("VALUES(`decl`)", insertStatement)

    def test_fills_missing_keys_with_null_when_dictionaries_have_different_keys(self):
        # ARRANGE
        rows = [{"a": 1, "b": 2}, {"a": 3}]

        # ACT
        self._run_load(rows)

        # ASSERT
        self.assertIn("(`a`, `b`)", self._statement_containing("LOAD DATA"))

    def test_backtick_quotes_table_and_temporary_table_identifiers(self):
        # ARRANGE
        rows = [{"col1": 1}]

        # ACT
        self._run_load(rows, dbTablename="sweep2_insert_statements")

        # ASSERT
        createStatement = self._statement_containing("CREATE TEMPORARY TABLE")
        self.assertIn("FROM `sweep2_insert_statements` WHERE 1=0", createStatement)
        self.assertRegex(createStatement, r"CREATE TEMPORARY TABLE `tmp_[0-9a-z]+`")
        insertStatement = self._statement_containing("INSERT IGNORE")
        self.assertIn("INTO `sweep2_insert_statements`", insertStatement)
        self.assertRegex(insertStatement, r"SELECT \* FROM `tmp_[0-9a-z]+`")
        self.assertRegex(
            self._statement_containing("LOAD DATA"), r"INTO TABLE `tmp_[0-9a-z]+`"
        )

    def test_doubles_backticks_inside_table_and_column_names(self):
        # ARRANGE
        rows = [{"we`ird": 1}]

        # ACT
        self._run_load(rows, dbTablename="sweep2`insert")

        # ASSERT
        self.assertIn("FROM `sweep2``insert` WHERE", self._statement_containing("CREATE"))
        self.assertIn("(`we``ird`)", self._statement_containing("LOAD DATA"))

    def test_closes_the_connection_when_the_load_raises(self):
        # ARRANGE
        rows = [{"col1": 1}]

        # ACT
        with self.assertRaises(RuntimeError):
            self._run_load(rows, failOnStatement="LOAD DATA")

        # ASSERT
        self.connectionMock.close.assert_called_once_with()

    def test_closes_the_connection_when_the_load_succeeds(self):
        # ARRANGE / ACT
        self._run_load([{"col1": 1}])

        # ASSERT
        self.connectionMock.commit.assert_called_once_with()
        self.connectionMock.close.assert_called_once_with()

    def test_uses_the_callers_logger(self):
        # ARRANGE / ACT
        self._run_load([{"col1": 1}])

        # ASSERT
        self.assertEqual(self.databaseMock.call_args.kwargs["log"], log)
        self.assertTrue(all(writequeryLog is log for writequeryLog in self.writequeryLogs))

REPLACE_TABLE = "sweep2_insert_replace"


class test_load_in_file_duplicates(unittest.TestCase):
    """The LOAD DATA worker against the real test database."""

    def setUp(self):
        from fundamentals.mysql import writequery

        self.insertModule = sys.modules[
            "fundamentals.mysql.insert_list_of_dictionaries_into_database_tables"
        ]
        writequery(
            log=log, sqlQuery="DROP TABLE IF EXISTS %s;" % REPLACE_TABLE, dbConn=dbConn
        )
        writequery(
            log=log,
            sqlQuery="CREATE TABLE %s (id INT PRIMARY KEY, `my_key` INT, decl DOUBLE);"
            % REPLACE_TABLE,
            dbConn=dbConn,
        )
        writequery(
            log=log,
            sqlQuery="INSERT INTO %s VALUES (1, 10, 1.5);" % REPLACE_TABLE,
            dbConn=dbConn,
        )

    def tearDown(self):
        from fundamentals.mysql import writequery

        writequery(
            log=log, sqlQuery="DROP TABLE IF EXISTS %s;" % REPLACE_TABLE, dbConn=dbConn
        )

    def _load_duplicate_and_new_row(self, replace):
        from fundamentals.mysql import readquery

        rows = [
            {"id": 1, "my key": 99, "dec": 9.5},
            {"id": 2, "my key": 20, "dec": 2.5},
        ]
        with mock.patch.object(self.insertModule, "sharedList", [(rows, 2)]):
            with mock.patch.object(self.insertModule, "totalCount", 2):
                self.insertModule._add_dictlist_to_database_via_load_in_file(
                    masterListIndex=0,
                    log=log,
                    dbTablename=REPLACE_TABLE,
                    dbSettings=dbSettings,
                    replace=replace,
                )
        dbConn.commit()
        return readquery(
            log=log,
            sqlQuery="SELECT id, my_key, decl FROM %s ORDER BY id;" % REPLACE_TABLE,
            dbConn=dbConn,
        )

    def test_keeps_existing_row_and_adds_new_row_when_replace_is_false(self):
        # ACT
        result = self._load_duplicate_and_new_row(replace=False)

        # ASSERT
        self.assertEqual(
            [(r["id"], r["my_key"], r["decl"]) for r in result],
            [(1, 10, 1.5), (2, 20, 2.5)],
        )

    def test_overwrites_existing_row_and_adds_new_row_when_replace_is_true(self):
        # ACT
        result = self._load_duplicate_and_new_row(replace=True)

        # ASSERT
        self.assertEqual(
            [(r["id"], r["my_key"], r["decl"]) for r in result],
            [(1, 99, 9.5), (2, 20, 2.5)],
        )

class test_dataframe_libraries_loaded_in_parent(unittest.TestCase):
    """numpy and pandas must be imported before the worker pool forks."""

    def setUp(self):
        self.insertModule = sys.modules[
            "fundamentals.mysql.insert_list_of_dictionaries_into_database_tables"
        ]

    def test_imports_numpy_and_pandas_before_the_load_in_file_pool_starts(self):
        # ARRANGE
        calls = []
        requireMock = mock.Mock(side_effect=lambda: calls.append("require"))
        fmultiprocessMock = mock.Mock(side_effect=lambda **kwargs: calls.append("pool"))

        # ACT
        with mock.patch.object(self.insertModule, "_import_dataframe_libraries", requireMock):
            with mock.patch.object(self.insertModule, "fmultiprocess", fmultiprocessMock):
                self.insertModule.insert_list_of_dictionaries_into_database_tables(
                    dbConn=dbConn,
                    log=log,
                    dictList=[{"col1": i} for i in range(3)],
                    dbTableName="ut_dy2032_stats_order",
                    dbSettings=dbSettings,
                    dateCreated=False,
                )

        # ASSERT
        self.assertEqual(calls, ["require", "pool"])

    def tearDown(self):
        from fundamentals.mysql import writequery

        writequery(
            log=log,
            sqlQuery="DROP TABLE IF EXISTS ut_dy2032_stats_order;",
            dbConn=dbConn,
        )
