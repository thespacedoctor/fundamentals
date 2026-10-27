from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import sys
import warnings
from unittest import mock
import pymysql
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


class FakeCursor:
    """A stand-in cursor that records closure and can raise on execute or close."""

    def __init__(self, executeError=None, closeError=None):
        self.executeError = executeError
        self.closeError = closeError
        self.isClosed = False
        self.executed = []

    def execute(self, sqlQuery):
        self.executed.append(sqlQuery)
        if self.executeError:
            raise self.executeError

    def close(self):
        if self.closeError:
            raise self.closeError
        self.isClosed = True


class ScriptedCursor:
    """A stand-in cursor that replays a script of outcomes, one per execute or executemany call.

    Each outcome is an exception instance to raise or None to succeed. Once the script is
    exhausted every further call succeeds."""

    def __init__(self, outcomes=()):
        self.outcomes = list(outcomes)
        self.executed = []
        self.manyBatches = []
        self.isClosed = False

    def _next_outcome(self):
        if self.outcomes:
            outcome = self.outcomes.pop(0)
            if outcome:
                raise outcome

    def execute(self, sqlQuery):
        self.executed.append(sqlQuery)
        self._next_outcome()

    def executemany(self, sqlQuery, valueList):
        self.manyBatches.append(list(valueList))
        self._next_outcome()

    def close(self):
        self.isClosed = True


class FakeConnection:
    """A stand-in db connection handing out a single pre-built cursor."""

    def __init__(self, cursor=None, cursorError=None):
        self.fakeCursor = cursor
        self.cursorError = cursorError

    def cursor(self, *args, **kwargs):
        if self.cursorError:
            raise self.cursorError
        return self.fakeCursor

    def commit(self):
        pass


class test_writequery(unittest.TestCase):

    def test_writequery_function(self):

        from fundamentals.mysql import writequery

        sqlQuery = "CREATE TABLE  IF NOT EXISTS `testing_table` (`id` INT NOT NULL, PRIMARY KEY (`id`))"
        writequery(
            log=log, sqlQuery=sqlQuery, dbConn=dbConn, Force=False, manyValueList=False
        )

    def test_manyvalue_insert(self):
        from fundamentals.mysql import writequery

        sqlQuery = "CREATE TABLE  IF NOT EXISTS  `testing_table` (`id` INT NOT NULL, PRIMARY KEY (`id`))"
        writequery(
            log=log, sqlQuery=sqlQuery, dbConn=dbConn, Force=False, manyValueList=False
        )

        from fundamentals.mysql import writequery

        sqlQuery = """INSERT INTO testing_table (id) values (%s)"""
        writequery(
            log=log,
            sqlQuery=sqlQuery,
            dbConn=dbConn,
            Force=False,
            manyValueList=[
                (1,),
                (2,),
                (3,),
                (4,),
                (5,),
                (6,),
                (7,),
                (8,),
                (9,),
                (10,),
                (11,),
                (12,),
            ],
        )

    def test_writequery_function_delete(self):

        from fundamentals.mysql import writequery

        sqlQuery = "DROP TABLE `testing_table`;"
        writequery(
            log=log, sqlQuery=sqlQuery, dbConn=dbConn, Force=False, manyValueList=False
        )

    def test_writequery_error_force(self):

        from fundamentals.mysql import writequery

        sqlQuery = "rubbish query;"
        writequery(
            log=log, sqlQuery=sqlQuery, dbConn=dbConn, Force=True, manyValueList=False
        )

        # x-print-testpage-for-pessto-marshall-web-object

    def test_raises_original_error_when_cursor_creation_fails(self):
        from fundamentals.mysql import writequery

        conn = FakeConnection(cursorError=RuntimeError("no cursor"))

        with self.assertRaises(RuntimeError) as ctx:
            writequery(log=log, sqlQuery="SELECT 1", dbConn=conn)

        self.assertEqual(str(ctx.exception), "no cursor")

    def test_raises_error_not_system_exit_when_generic_error_and_not_force(self):
        from fundamentals.mysql import writequery

        cursor = FakeCursor(executeError=ValueError("boom"))

        with self.assertRaises(ValueError):
            writequery(
                log=log, sqlQuery="SELECT 1", dbConn=FakeConnection(cursor), Force=False
            )

    def test_closes_cursor_when_generic_error_and_not_force(self):
        from fundamentals.mysql import writequery

        cursor = FakeCursor(executeError=ValueError("boom"))

        with self.assertRaises(ValueError):
            writequery(
                log=log, sqlQuery="SELECT 1", dbConn=FakeConnection(cursor), Force=False
            )

        self.assertTrue(cursor.isClosed)

    def test_closes_cursor_and_returns_minus_one_when_generic_error_and_force(self):
        from fundamentals.mysql import writequery

        cursor = FakeCursor(executeError=ValueError("boom"))

        result = writequery(
            log=log, sqlQuery="SELECT 1", dbConn=FakeConnection(cursor), Force=True
        )

        self.assertEqual(result, -1)
        self.assertTrue(cursor.isClosed)

    def test_closes_cursor_when_programming_error_raised(self):
        from fundamentals.mysql import writequery

        cursor = FakeCursor(executeError=pymysql.err.ProgrammingError(1064, "syntax"))

        with self.assertRaises(pymysql.err.ProgrammingError):
            writequery(
                log=log, sqlQuery="rubbish", dbConn=FakeConnection(cursor), Force=False
            )

        self.assertTrue(cursor.isClosed)

    def test_closes_cursor_on_success(self):
        from fundamentals.mysql import writequery

        cursor = FakeCursor()

        writequery(log=log, sqlQuery="SELECT 1", dbConn=FakeConnection(cursor))

        self.assertTrue(cursor.isClosed)

    def test_does_not_raise_index_error_when_query_is_empty(self):
        from fundamentals.mysql import writequery

        cursor = FakeCursor()

        message = writequery(log=log, sqlQuery="", dbConn=FakeConnection(cursor))

        self.assertEqual(message, "")

    def test_strips_trailing_comma_from_query(self):
        from fundamentals.mysql import writequery

        cursor = FakeCursor()

        writequery(log=log, sqlQuery="SELECT 1,", dbConn=FakeConnection(cursor))

        self.assertEqual(cursor.executed, ["SELECT 1"])

    def test_does_not_change_global_warning_filters(self):
        from fundamentals.mysql import writequery

        filtersBefore = list(warnings.filters)

        writequery(log=log, sqlQuery="SELECT 1", dbConn=FakeConnection(FakeCursor()))

        self.assertEqual(warnings.filters, filtersBefore)

    def test_does_not_retry_or_sleep_when_cursor_close_fails(self):
        from fundamentals.mysql import writequery

        cursor = FakeCursor(closeError=RuntimeError("close failed"))
        writequeryModule = sys.modules["fundamentals.mysql.writequery"]

        with mock.patch.object(writequeryModule.time, "sleep") as sleep:
            writequery(log=log, sqlQuery="SELECT 1", dbConn=FakeConnection(cursor))

        sleep.assert_not_called()

    def test_original_error_not_masked_when_cursor_close_also_fails(self):
        from fundamentals.mysql import writequery

        cursor = FakeCursor(
            executeError=ValueError("boom"), closeError=RuntimeError("close failed")
        )

        with self.assertRaises(ValueError):
            writequery(
                log=log, sqlQuery="SELECT 1", dbConn=FakeConnection(cursor), Force=False
            )

    def test_makes_one_execute_and_logs_when_table_already_exists(self):
        from fundamentals.mysql import writequery

        cursor = ScriptedCursor(
            [pymysql.err.OperationalError(1050, "Table 't' already exists")]
        )

        message = writequery(
            log=log, sqlQuery="CREATE TABLE t", dbConn=FakeConnection(cursor)
        )

        self.assertEqual(len(cursor.executed), 1)
        self.assertEqual(message, "")

    def test_makes_one_execute_when_index_already_exists(self):
        from fundamentals.mysql import writequery

        cursor = ScriptedCursor(
            [pymysql.err.OperationalError(1061, "Duplicate key name 'k'")]
        )

        message = writequery(
            log=log, sqlQuery="CREATE INDEX k", dbConn=FakeConnection(cursor)
        )

        self.assertEqual(len(cursor.executed), 1)
        self.assertEqual(message, "index already exists")

    def test_succeeds_after_retrying_deadlock_twice(self):
        from fundamentals.mysql import writequery

        deadlock = pymysql.err.OperationalError(1213, "Deadlock found")
        cursor = ScriptedCursor([deadlock, deadlock])

        with mock.patch("time.sleep") as sleep:
            message = writequery(
                log=log, sqlQuery="UPDATE t", dbConn=FakeConnection(cursor)
            )

        self.assertEqual(len(cursor.executed), 3)
        self.assertEqual(sleep.call_count, 2)
        self.assertEqual(message, "")

    def test_retries_each_transient_error_code(self):
        from fundamentals.mysql import writequery

        for code in (1213, 1205):
            with self.subTest(code=code):
                cursor = ScriptedCursor(
                    [pymysql.err.OperationalError(code, "transient")]
                )

                with mock.patch("time.sleep"):
                    writequery(
                        log=log, sqlQuery="UPDATE t", dbConn=FakeConnection(cursor)
                    )

                self.assertEqual(len(cursor.executed), 2)

    def test_does_not_resend_a_write_after_the_connection_is_lost(self):
        from fundamentals.mysql import writequery

        # THE WRITE MAY HAVE COMMITTED BEFORE THE CONNECTION DROPPED, AND THE CONNECTION IS DEAD
        for code in (2006, 2013):
            with self.subTest(code=code):
                cursor = ScriptedCursor(
                    [
                        pymysql.err.OperationalError(code, "connection lost"),
                        pymysql.err.InterfaceError(0, ""),
                    ]
                )

                with mock.patch("time.sleep") as sleep:
                    with self.assertRaises(pymysql.err.OperationalError) as raised:
                        writequery(
                            log=log,
                            sqlQuery="INSERT INTO t VALUES (1)",
                            dbConn=FakeConnection(cursor),
                        )

                self.assertEqual(raised.exception.args[0], code)
                self.assertEqual(len(cursor.executed), 1)
                sleep.assert_not_called()

    def test_raises_the_original_error_when_it_has_only_one_argument(self):
        from fundamentals.mysql import writequery

        cursor = ScriptedCursor([pymysql.err.Error("no code, no message tuple")])

        with self.assertRaises(pymysql.err.Error) as raised:
            writequery(log=log, sqlQuery="UPDATE t", dbConn=FakeConnection(cursor))

        self.assertEqual(raised.exception.args, ("no code, no message tuple",))

    def test_returns_a_message_when_a_forced_error_has_no_error_code(self):
        from fundamentals.mysql import writequery

        cursor = ScriptedCursor([pymysql.err.Error()])

        message = writequery(
            log=log, sqlQuery="UPDATE t", dbConn=FakeConnection(cursor), Force=True
        )

        self.assertIn("MySQL write command not executed", message)

    def test_raises_after_one_execute_when_error_is_not_transient(self):
        from fundamentals.mysql import writequery

        cursor = ScriptedCursor(
            [pymysql.err.OperationalError(1054, "Unknown column 'x'")]
        )

        with mock.patch("time.sleep") as sleep:
            with self.assertRaises(pymysql.err.OperationalError):
                writequery(
                    log=log,
                    sqlQuery="SELECT x",
                    dbConn=FakeConnection(cursor),
                    Force=False,
                )

        self.assertEqual(len(cursor.executed), 1)
        sleep.assert_not_called()

    def test_returns_message_after_one_execute_when_error_is_not_transient_and_force(
        self,
    ):
        from fundamentals.mysql import writequery

        cursor = ScriptedCursor(
            [pymysql.err.OperationalError(1054, "Unknown column 'x'")]
        )

        message = writequery(
            log=log, sqlQuery="SELECT x", dbConn=FakeConnection(cursor), Force=True
        )

        self.assertEqual(len(cursor.executed), 1)
        self.assertIn("Unknown column", message)

    def test_raises_after_one_execute_when_internal_error_is_not_transient(self):
        from fundamentals.mysql import writequery

        cursor = ScriptedCursor([pymysql.err.InternalError(1, "internal")])

        with self.assertRaises(pymysql.err.InternalError):
            writequery(log=log, sqlQuery="SELECT 1", dbConn=FakeConnection(cursor))

        self.assertEqual(len(cursor.executed), 1)

    def test_raises_after_bounded_backoff_when_transient_error_persists(self):
        from fundamentals.mysql import writequery

        deadlock = pymysql.err.OperationalError(1213, "Deadlock found")
        cursor = ScriptedCursor([deadlock] * 100)

        with mock.patch("time.sleep") as sleep:
            with self.assertRaises(pymysql.err.OperationalError):
                writequery(log=log, sqlQuery="UPDATE t", dbConn=FakeConnection(cursor))

        delays = [call.args[0] for call in sleep.call_args_list]
        self.assertEqual(len(cursor.executed), len(delays) + 1)
        self.assertGreater(len(delays), 1)
        self.assertLessEqual(sum(delays), 60)
        self.assertEqual(delays, sorted(delays))

    def test_does_not_resend_committed_batches_when_retrying_executemany(self):
        from fundamentals.mysql import writequery

        writequeryModule = sys.modules["fundamentals.mysql.writequery"]
        deadlock = pymysql.err.OperationalError(1213, "Deadlock found")
        cursor = ScriptedCursor([None, deadlock])
        values = [(1,), (2,), (3,), (4,), (5,)]

        with mock.patch("time.sleep"):
            with mock.patch.object(writequeryModule, "INSERT_BATCH_SIZE", 2):
                writequery(
                    log=log,
                    sqlQuery="INSERT INTO t (id) VALUES (%s)",
                    dbConn=FakeConnection(cursor),
                    manyValueList=values,
                )

        self.assertEqual(
            cursor.manyBatches,
            [[(1,), (2,)], [(3,), (4,)], [(3,), (4,)], [(5,)]],
        )

    # x-class-to-test-named-worker-function
