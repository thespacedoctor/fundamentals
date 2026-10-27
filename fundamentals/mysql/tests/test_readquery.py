from __future__ import print_function
import os
import unittest
import shutil
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
    """A stand-in cursor that records closure and can raise on execute."""

    def __init__(self, executeError=None, rows=(), errorCount=None):
        self.executeError = executeError
        self.errorCount = errorCount
        self.rows = list(rows)
        self.isClosed = False
        self.executeCalls = 0

    def execute(self, sqlQuery):
        self.executeCalls += 1
        if self.executeError and (
            self.errorCount is None or self.executeCalls <= self.errorCount
        ):
            raise self.executeError

    def fetchall(self):
        return self.rows

    def close(self):
        self.isClosed = True


class FakeConnection:
    """A stand-in db connection handing out a single pre-built cursor."""

    def __init__(self, cursor):
        self.fakeCursor = cursor

    def cursor(self, *args, **kwargs):
        return self.fakeCursor


class test_readquery(unittest.TestCase):

    def test_readquery_function(self):

        from fundamentals.mysql import readquery

        rows = readquery(log=log, sqlQuery="show tables", dbConn=dbConn, quiet=False)

    def test_readquery_error_function(self):

        from fundamentals.mysql import readquery

        try:
            rows = readquery(
                log=log, sqlQuery="rubbish query", dbConn=dbConn, quiet=False
            )
            assert False
        except Exception as e:
            assert True
            # print(str(e))

    def test_readquery_error_function_quiet(self):

        from fundamentals.mysql import readquery

        try:
            rows = readquery(
                log=log, sqlQuery="rubbish query", dbConn=dbConn, quiet=True
            )
            assert True
        except Exception as e:
            assert False
            # print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    def test_closes_cursor_when_query_raises(self):
        from fundamentals.mysql import readquery

        cursor = FakeCursor(executeError=ValueError("boom"))

        with self.assertRaises(ValueError):
            readquery(
                log=log, sqlQuery="SELECT 1", dbConn=FakeConnection(cursor), quiet=False
            )

        self.assertTrue(cursor.isClosed)

    def test_closes_cursor_when_query_raises_and_quiet(self):
        from fundamentals.mysql import readquery

        cursor = FakeCursor(executeError=ValueError("boom"))

        rows = readquery(
            log=log, sqlQuery="SELECT 1", dbConn=FakeConnection(cursor), quiet=True
        )

        self.assertEqual(rows, [])
        self.assertTrue(cursor.isClosed)

    def test_closes_cursor_on_success(self):
        from fundamentals.mysql import readquery

        cursor = FakeCursor(rows=[{"id": 1}])

        rows = readquery(log=log, sqlQuery="SELECT 1", dbConn=FakeConnection(cursor))

        self.assertEqual(rows, [{"id": 1}])
        self.assertTrue(cursor.isClosed)

    def test_does_not_change_global_warning_filters(self):
        from fundamentals.mysql import readquery

        filtersBefore = list(warnings.filters)

        readquery(log=log, sqlQuery="SELECT 1", dbConn=FakeConnection(FakeCursor()))

        self.assertEqual(warnings.filters, filtersBefore)

    def test_makes_one_execute_then_raises_when_internal_error(self):
        from fundamentals.mysql import readquery

        cursor = FakeCursor(executeError=pymysql.err.InternalError(1, "internal"))

        with mock.patch("time.sleep") as sleep:
            with self.assertRaises(pymysql.err.InternalError):
                readquery(log=log, sqlQuery="SELECT 1", dbConn=FakeConnection(cursor))

        self.assertEqual(cursor.executeCalls, 1)
        sleep.assert_not_called()

    def test_makes_one_execute_and_returns_no_rows_when_internal_error_and_quiet(self):
        from fundamentals.mysql import readquery

        cursor = FakeCursor(executeError=pymysql.err.InternalError(1, "internal"))

        rows = readquery(
            log=log, sqlQuery="SELECT 1", dbConn=FakeConnection(cursor), quiet=True
        )

        self.assertEqual(rows, [])
        self.assertEqual(cursor.executeCalls, 1)

    def test_makes_one_execute_then_raises_when_operational_error_is_not_transient(
        self,
    ):
        from fundamentals.mysql import readquery

        cursor = FakeCursor(
            executeError=pymysql.err.OperationalError(1054, "Unknown column 'x'")
        )

        with self.assertRaises(pymysql.err.OperationalError):
            readquery(log=log, sqlQuery="SELECT x", dbConn=FakeConnection(cursor))

        self.assertEqual(cursor.executeCalls, 1)

    def test_returns_rows_after_retrying_transient_error_with_backoff(self):
        from fundamentals.mysql import readquery

        cursor = FakeCursor(
            executeError=pymysql.err.OperationalError(1213, "Deadlock found"),
            rows=[{"id": 1}],
            errorCount=2,
        )

        with mock.patch("time.sleep") as sleep:
            rows = readquery(
                log=log, sqlQuery="SELECT 1", dbConn=FakeConnection(cursor)
            )

        self.assertEqual(rows, [{"id": 1}])
        self.assertEqual(cursor.executeCalls, 3)
        self.assertEqual(sleep.call_count, 2)

    def test_raises_after_bounded_backoff_when_transient_error_persists(self):
        from fundamentals.mysql import readquery

        cursor = FakeCursor(
            executeError=pymysql.err.OperationalError(1213, "Deadlock found")
        )

        with mock.patch("time.sleep") as sleep:
            with self.assertRaises(pymysql.err.OperationalError):
                readquery(log=log, sqlQuery="SELECT 1", dbConn=FakeConnection(cursor))

        delays = [call.args[0] for call in sleep.call_args_list]
        self.assertEqual(cursor.executeCalls, len(delays) + 1)
        self.assertGreater(len(delays), 1)
        self.assertLessEqual(sum(delays), 60)

    def test_does_not_retry_on_the_same_connection_after_the_connection_is_lost(self):
        from fundamentals.mysql import readquery

        # PYMYSQL CLOSES ITS SOCKET WHEN THE CONNECTION DROPS, SO A RETRY CANNOT SUCCEED
        for code in (2006, 2013):
            with self.subTest(code=code):
                cursor = FakeCursor(
                    executeError=pymysql.err.OperationalError(code, "Lost connection")
                )

                with mock.patch("time.sleep") as sleep:
                    with self.assertRaises(pymysql.err.OperationalError) as raised:
                        readquery(
                            log=log,
                            sqlQuery="SELECT 1",
                            dbConn=FakeConnection(cursor),
                        )

                self.assertEqual(raised.exception.args[0], code)
                self.assertEqual(cursor.executeCalls, 1)
                sleep.assert_not_called()

    # x-class-to-test-named-worker-function
