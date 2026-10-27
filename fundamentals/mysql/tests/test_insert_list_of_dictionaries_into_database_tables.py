from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import sys
import tempfile
import uuid
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


BATCH_TABLE = "test_dy2025_insert_batches"


class test_insert_batches(unittest.TestCase):

    def setUp(self):
        from fundamentals.mysql import writequery

        self.insertModule = sys.modules[
            "fundamentals.mysql.insert_list_of_dictionaries_into_database_tables"
        ]
        self.originalAutocommit = dbConn.get_autocommit()
        writequery(
            log=log, sqlQuery="DROP TABLE IF EXISTS %s;" % BATCH_TABLE, dbConn=dbConn
        )

    def tearDown(self):
        from fundamentals.mysql import writequery

        dbConn.autocommit(self.originalAutocommit)
        writequery(
            log=log, sqlQuery="DROP TABLE IF EXISTS %s;" % BATCH_TABLE, dbConn=dbConn
        )

    def _insert(self, rows, batchSize=2500):
        self._insert_rows(rows, batchSize=batchSize)

    def _insert_rows(self, rows, batchSize=2500, **kwargs):
        from fundamentals.mysql import insert_list_of_dictionaries_into_database_tables

        insert_list_of_dictionaries_into_database_tables(
            dbConn=dbConn,
            log=log,
            dictList=rows,
            dbTableName=BATCH_TABLE,
            batchSize=batchSize,
            dateCreated=False,
            **kwargs
        )

    def _select(self, columns):
        from fundamentals.mysql import readquery

        dbConn.commit()
        return readquery(
            log=log,
            sqlQuery="SELECT %s FROM %s ORDER BY %s;" % (columns, BATCH_TABLE, columns),
            dbConn=dbConn,
        )

    def _run_single_batch(self, rows, writequeryMock):
        # PRIME THE TABLE WITH THE FIRST ROW, THEN RUN ONE BATCH DIRECTLY
        self._insert(rows[:1])
        with mock.patch.object(self.insertModule, "sharedList", [(rows[1:], 1)]):
            with mock.patch.object(self.insertModule, "totalCount", len(rows)):
                with mock.patch.object(self.insertModule, "globalDbConn", dbConn):
                    with mock.patch.object(
                        self.insertModule, "writequery", writequeryMock
                    ):
                        return self.insertModule._insert_single_batch_into_database(
                            batchIndex=0,
                            log=log,
                            dbTableName=BATCH_TABLE,
                            uniqueKeyList=[],
                            dateModified=False,
                            replace=False,
                            batchSize=2500,
                            reDatetime=False,
                            dateCreated=False,
                        )

    def test_inserts_all_rows_when_remaining_rows_are_an_exact_multiple_of_batch_size(
        self,
    ):
        # ARRANGE: 1 ROW CREATES THE TABLE, THE REMAINING 10 FILL 2 BATCHES OF 5
        rows = [{"col1": i} for i in range(11)]

        # ACT
        self._insert(rows, batchSize=5)

        # ASSERT
        self.assertEqual([r["col1"] for r in self._select("col1")], list(range(11)))

    def test_inserts_rows_whose_keys_contain_spaces_and_hyphens(self):
        # ARRANGE
        rows = [{"my key": i, "other-key": i * 2} for i in range(4)]

        # ACT
        self._insert(rows)

        # ASSERT
        result = self._select("my_key, other_key")
        self.assertEqual(
            [(r["my_key"], r["other_key"]) for r in result],
            [(i, i * 2) for i in range(4)],
        )

    def test_runs_batches_serially_when_only_a_connection_is_given(self):
        # ARRANGE
        rows = [{"col1": i} for i in range(6)]
        fmultiprocessSpy = mock.Mock(wraps=self.insertModule.fmultiprocess)

        # ACT
        with mock.patch.object(self.insertModule, "fmultiprocess", fmultiprocessSpy):
            self._insert_rows(rows, batchSize=2)

        # ASSERT
        self.assertTrue(fmultiprocessSpy.call_args.kwargs["turnOffMP"])

    def test_inserts_all_batches_on_the_callers_connection_without_a_serial_stand_in(
        self,
    ):
        # ARRANGE: 1 ROW CREATES THE TABLE, THE REMAINING 8 FILL 4 BATCHES OF 2
        rows = [{"col1": i} for i in range(9)]

        # ACT
        self._insert_rows(rows, batchSize=2)

        # ASSERT
        self.assertEqual([r["col1"] for r in self._select("col1")], list(range(9)))

    def test_raises_runtime_error_when_a_batch_fails_on_the_connection_only_path(self):
        # ARRANGE
        rows = [{"col1": i} for i in range(5)]

        # ACT / ASSERT
        with mock.patch.object(
            self.insertModule, "writequery", return_value="simulated write error"
        ):
            with self.assertRaises(RuntimeError):
                self._insert_rows(rows, batchSize=2)

    def test_keeps_multiprocessing_on_when_database_settings_are_given(self):
        # ARRANGE
        rows = [{"col1": i} for i in range(3)]
        fmultiprocessSpy = mock.Mock(return_value=[])

        # ACT
        with mock.patch.object(self.insertModule, "fmultiprocess", fmultiprocessSpy):
            self._insert_rows(rows, dbSettings=dbSettings)

        # ASSERT
        self.assertFalse(fmultiprocessSpy.call_args.kwargs["turnOffMP"])

    def test_normalise_key_replaces_separators_and_renames_mysql_keyword_dec(self):
        # ARRANGE
        from fundamentals.mysql.sql_identifiers import normalise_column_name

        keys = ["my key", "my-key", "dec", "DEC", "ra"]

        # ACT
        result = [normalise_column_name(k) for k in keys]

        # ASSERT
        self.assertEqual(result, ["my_key", "my_key", "decl", "DECL", "ra"])

    def test_fills_missing_keys_with_null_when_dictionaries_have_different_keys(self):
        # ARRANGE
        rows = [{"a": 1, "b": 2}, {"a": 3}, {"b": 4}]

        # ACT
        self._insert(rows)

        # ASSERT
        result = self._select("a, b")
        self.assertEqual(
            sorted((r["a"], r["b"]) for r in result if None not in (r["a"], r["b"])),
            [(1, 2)],
        )
        self.assertEqual(
            sorted(
                [(r["a"], r["b"]) for r in result if None in (r["a"], r["b"])],
                key=str,
            ),
            [(3, None), (None, 4)],
        )

    def test_restores_callers_autocommit_after_insert(self):
        # ARRANGE
        dbConn.autocommit(True)

        # ACT
        self._insert([{"col1": i} for i in range(4)])

        # ASSERT
        self.assertTrue(dbConn.get_autocommit())

    def test_restores_callers_autocommit_when_insert_fails(self):
        # ARRANGE
        dbConn.autocommit(True)
        rows = [{"col1": i} for i in range(4)]

        # ACT
        with mock.patch.object(
            self.insertModule, "writequery", return_value="simulated write error"
        ):
            with self.assertRaises(RuntimeError):
                self._insert(rows)

        # ASSERT
        self.assertTrue(dbConn.get_autocommit())

    def test_raises_when_writequery_returns_an_error_message(self):
        # ARRANGE
        rows = [{"col1": i} for i in range(3)]
        writequeryMock = mock.Mock(return_value="MySQL write command not executed")

        # ACT / ASSERT
        with self.assertRaises(RuntimeError):
            self._run_single_batch(rows, writequeryMock)

    def test_ignores_duplicate_key_message_from_writequery(self):
        # ARRANGE
        rows = [{"col1": i} for i in range(3)]
        writequeryMock = mock.Mock(return_value="duplicate key error")

        # ACT
        result = self._run_single_batch(rows, writequeryMock)

        # ASSERT
        self.assertEqual(result, "None")

    def test_does_not_swallow_keyboard_interrupt_from_writequery(self):
        # ARRANGE: INTERRUPT ONCE, THEN SUCCEED - A BARE EXCEPT WOULD HIDE THE INTERRUPT
        rows = [{"col1": i} for i in range(3)]
        writequeryMock = mock.Mock(side_effect=[KeyboardInterrupt(), ""])

        # ACT / ASSERT
        with self.assertRaises(KeyboardInterrupt):
            self._run_single_batch(rows, writequeryMock)

    def test_falls_back_to_single_row_inserts_when_the_batch_insert_raises_a_database_error(
        self,
    ):
        # ARRANGE
        import pymysql

        rows = [{"col1": i} for i in range(3)]
        writequeryMock = mock.Mock(
            side_effect=[pymysql.err.OperationalError(1213, "simulated"), ""]
        )

        # ACT
        result = self._run_single_batch(rows, writequeryMock)

        # ASSERT
        self.assertEqual(result, "None")
        self.assertEqual(writequeryMock.call_count, 2)

    def test_falls_back_with_a_matching_command_and_values_for_rows_with_different_keys(
        self,
    ):
        # ARRANGE: THE FIRST ROW CREATES THE TABLE; THE BATCH ROWS HAVE DIFFERENT KEY SETS
        import pymysql
        from fundamentals.mysql import writequery

        rows = [{"a": 1, "b": 2}, {"a": 3}, {"b": 4}]
        calls = []

        def failOnceThenWrite(**kwargs):
            calls.append(kwargs)
            if len(calls) == 1:
                raise pymysql.err.OperationalError(1213, "simulated")
            return writequery(**kwargs)

        # ACT
        result = self._run_single_batch(rows, failOnceThenWrite)

        # ASSERT
        self.assertEqual(result, "None")
        stored = self._select("a, b")
        self.assertEqual(
            sorted(((r["a"], r["b"]) for r in stored), key=str),
            [(1, 2), (3, None), (None, 4)],
        )

    def test_sorts_columns_when_dictionary_keys_are_of_mixed_types(self):
        # ARRANGE
        rows = [{"a": 1}, {"a": 2, 1: 3}]
        writequeryMock = mock.Mock(return_value="")

        # ACT
        self._run_single_batch(rows, writequeryMock)

        # ASSERT
        sqlQuery = writequeryMock.call_args.kwargs["sqlQuery"]
        self.assertIn("(`1`,`a`", sqlQuery)

    def test_restore_error_is_raised_when_the_insert_succeeded(self):
        # ARRANGE
        import pymysql
        from fundamentals.mysql import insert_list_of_dictionaries_into_database_tables

        dbConn.autocommit(True)
        realAutocommit = dbConn.autocommit

        def autocommitFailsOnRestore(value):
            if value:
                raise pymysql.err.OperationalError(2006, "server has gone away")
            return realAutocommit(value)

        # ACT / ASSERT
        with mock.patch.object(
            dbConn, "autocommit", side_effect=autocommitFailsOnRestore
        ):
            with self.assertRaises(pymysql.err.OperationalError):
                insert_list_of_dictionaries_into_database_tables(
                    dbConn=dbConn,
                    log=log,
                    dictList=[{"col1": i} for i in range(3)],
                    dbTableName=BATCH_TABLE,
                    dateCreated=False,
                )

    def test_original_error_propagates_when_autocommit_restore_also_raises(self):
        # ARRANGE
        import pymysql
        from fundamentals.mysql import insert_list_of_dictionaries_into_database_tables

        dbConn.autocommit(True)
        realAutocommit = dbConn.autocommit

        def autocommitFailsOnRestore(value):
            if value:
                raise pymysql.err.OperationalError(2006, "server has gone away")
            return realAutocommit(value)

        def insertFails(**kwargs):
            raise RuntimeError("original insert failure")

        # ACT / ASSERT
        with mock.patch.object(self.insertModule, "fmultiprocess", insertFails):
            with mock.patch.object(
                dbConn, "autocommit", side_effect=autocommitFailsOnRestore
            ):
                with self.assertRaisesRegex(RuntimeError, "original insert failure"):
                    insert_list_of_dictionaries_into_database_tables(
                        dbConn=dbConn,
                        log=log,
                        dictList=[{"col1": i} for i in range(3)],
                        dbTableName=BATCH_TABLE,
                        dateCreated=False,
                    )


class test_batch_insert_statement(unittest.TestCase):
    """The SQL built by the batch insert worker, with writequery mocked."""

    TABLE = "ba`d%table"
    ROWS = [
        {"select": 1, "we`ird": 2, "100%": 3},
        {"select": 4, "we`ird": 5, "100%": 6},
    ]

    def setUp(self):
        self.insertModule = sys.modules[
            "fundamentals.mysql.insert_list_of_dictionaries_into_database_tables"
        ]

    def _build_sql(self, rows=None, replace=False, dateCreated=True):
        writequeryMock = mock.Mock(return_value="")
        with mock.patch.object(
            self.insertModule, "sharedList", [(rows or self.ROWS, 2)]
        ):
            with mock.patch.object(self.insertModule, "totalCount", 2):
                with mock.patch.object(self.insertModule, "globalDbConn", dbConn):
                    with mock.patch.object(
                        self.insertModule, "writequery", writequeryMock
                    ):
                        self.insertModule._insert_single_batch_into_database(
                            batchIndex=0,
                            log=log,
                            dbTableName=self.TABLE,
                            uniqueKeyList=[],
                            dateModified=False,
                            replace=replace,
                            batchSize=2500,
                            reDatetime=False,
                            dateCreated=dateCreated,
                        )
        return writequeryMock.call_args.kwargs

    def test_quotes_the_table_and_columns_and_doubles_percent_signs(self):
        # ACT
        sqlQuery = self._build_sql()["sqlQuery"]

        # ASSERT
        self.assertEqual(
            sqlQuery,
            "INSERT IGNORE INTO `ba``d%%table` (`100%%`,`select`,`we``ird`, dateCreated)"
            " VALUES (%s, %s, %s, NOW())",
        )

    def test_quotes_every_column_in_the_on_duplicate_key_update_clause(self):
        # ACT
        sqlQuery = self._build_sql(replace=True)["sqlQuery"]

        # ASSERT
        self.assertTrue(
            sqlQuery.endswith(
                " ON DUPLICATE KEY UPDATE `100%%`=VALUES(`100%%`),"
                " `select`=VALUES(`select`), `we``ird`=VALUES(`we``ird`),"
                " updated=1, dateLastModified=NOW()"
            ),
            sqlQuery,
        )

    def test_keeps_percent_signs_single_in_the_update_tail_when_pymysql_batches_the_rows(
        self,
    ):
        # ACT
        sqlQuery = self._build_sql(replace=True, dateCreated=False)["sqlQuery"]

        # ASSERT
        self.assertEqual(
            sqlQuery,
            "INSERT IGNORE INTO `ba``d%%table` (`100%%`,`select`,`we``ird`)"
            " VALUES (%s, %s, %s) ON DUPLICATE KEY UPDATE `100%`=VALUES(`100%`),"
            " `select`=VALUES(`select`), `we``ird`=VALUES(`we``ird`),"
            " updated=1, dateLastModified=NOW()",
        )

    def test_leaves_identifiers_untouched_when_they_contain_double_quotes(self):
        # ARRANGE
        rows = [{'a""b': 1, 'c"None"d': 2}]

        # ACT
        sqlQuery = self._build_sql(rows=rows)["sqlQuery"]

        # ASSERT
        self.assertIn('(`a""b`,`c"None"d`', sqlQuery)

    def test_binds_none_and_empty_values_as_null_and_keeps_none_and_null_text(self):
        # ARRANGE
        rows = [{"a": None, "b": "None", "c": "", "d": 0, "e": "null"}]

        # ACT
        values = self._build_sql(rows=rows)["manyValueList"]

        # ASSERT
        self.assertEqual(values, [(None, "None", None, 0, "null")])

    def test_raises_when_a_column_name_contains_a_nul_character(self):
        # ARRANGE
        rows = [{"a\x00b": 1}]

        # ACT / ASSERT
        with self.assertRaises(ValueError):
            self._build_sql(rows=rows)


class test_batch_insert_round_trip(unittest.TestCase):
    """Rows with awkward table and column names go through the real test database."""

    def setUp(self):
        from fundamentals.mysql import writequery

        self.tableName = "ut_dy2026_%s`_%%t" % uuid.uuid4().hex[:12]
        self.quotedTable = "`" + self.tableName.replace("`", "``") + "`"
        self.originalAutocommit = dbConn.get_autocommit()
        self.addCleanup(
            writequery,
            log=log,
            sqlQuery="DROP TABLE IF EXISTS %s;" % self.quotedTable,
            dbConn=dbConn,
        )
        self.addCleanup(dbConn.autocommit, self.originalAutocommit)

    def _insert(self, rows, replace, dateCreated):
        from fundamentals.mysql import insert_list_of_dictionaries_into_database_tables

        insert_list_of_dictionaries_into_database_tables(
            dbConn=dbConn,
            log=log,
            dictList=rows,
            dbTableName=self.tableName,
            uniqueKeyList=["select"],
            dateModified=True,
            dateCreated=dateCreated,
            batchSize=2,
            replace=replace,
        )

    def _select(self):
        from fundamentals.mysql import readquery

        dbConn.commit()
        return readquery(
            log=log,
            sqlQuery="SELECT `select`, `we``ird`, `100%` FROM "
            + self.quotedTable
            + " ORDER BY `select`;",
            dbConn=dbConn,
        )

    def test_inserts_rows_into_awkward_names_and_skips_duplicates_when_replace_is_false(
        self,
    ):
        for dateCreated in (True, False):
            with self.subTest(dateCreated=dateCreated):
                # ARRANGE
                self.tearDown_table()
                firstRows = [
                    {"select": i, "we`ird": i * 2, "100%": i * 3} for i in range(1, 6)
                ]
                secondRows = [{"select": 1, "we`ird": 99, "100%": 99}]

                # ACT
                self._insert(firstRows, replace=False, dateCreated=dateCreated)
                self._insert(secondRows + firstRows[1:2], False, dateCreated)

                # ASSERT
                self.assertEqual(
                    [(r["select"], r["we`ird"], r["100%"]) for r in self._select()],
                    [(i, i * 2, i * 3) for i in range(1, 6)],
                )

    def test_overwrites_duplicates_in_awkward_names_when_replace_is_true(self):
        for dateCreated in (True, False):
            with self.subTest(dateCreated=dateCreated):
                # ARRANGE
                self.tearDown_table()
                firstRows = [
                    {"select": i, "we`ird": i * 2, "100%": i * 3} for i in range(1, 6)
                ]
                secondRows = [
                    {"select": 1, "we`ird": 99, "100%": 98},
                    {"select": 2, "we`ird": 97, "100%": 96},
                    {"select": 3, "we`ird": 95, "100%": 94},
                ]

                # ACT
                self._insert(firstRows, replace=False, dateCreated=dateCreated)
                self._insert(secondRows, replace=True, dateCreated=dateCreated)

                # ASSERT
                self.assertEqual(
                    [(r["select"], r["we`ird"], r["100%"]) for r in self._select()],
                    [(1, 99, 98), (2, 97, 96), (3, 95, 94), (4, 8, 12), (5, 10, 15)],
                )

    def tearDown_table(self):
        from fundamentals.mysql import writequery

        writequery(
            log=log,
            sqlQuery="DROP TABLE IF EXISTS %s;" % self.quotedTable,
            dbConn=dbConn,
        )


class test_stats_dependencies_loaded_in_parent(unittest.TestCase):
    """numpy and pandas must be imported before the worker pool forks."""

    def setUp(self):
        self.insertModule = sys.modules[
            "fundamentals.mysql.insert_list_of_dictionaries_into_database_tables"
        ]

    def test_raises_import_error_naming_the_stats_extra_when_pandas_is_missing(self):
        # ACT / ASSERT
        with mock.patch.dict(sys.modules, {"pandas": None}):
            with self.assertRaisesRegex(ImportError, r"pip install fundamentals\[stats\]"):
                self.insertModule._require_stats_dependencies()

    def test_imports_numpy_and_pandas_before_the_load_in_file_pool_starts(self):
        # ARRANGE
        calls = []
        requireMock = mock.Mock(side_effect=lambda: calls.append("require"))
        fmultiprocessMock = mock.Mock(side_effect=lambda **kwargs: calls.append("pool"))

        # ACT
        with mock.patch.object(self.insertModule, "_require_stats_dependencies", requireMock):
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
