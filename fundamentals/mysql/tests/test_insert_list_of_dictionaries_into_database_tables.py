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
        keys = ["my key", "my-key", "dec", "DEC", "ra"]

        # ACT
        result = [self.insertModule._normalise_key(k) for k in keys]

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
