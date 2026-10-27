from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import sys
import time
import unittest
import warnings
from unittest import mock
import pymysql
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

    # x-class-to-test-named-worker-function
