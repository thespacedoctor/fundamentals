from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import warnings
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
    """A stand-in cursor that records closure and can raise on execute."""

    def __init__(self, executeError=None, rows=()):
        self.executeError = executeError
        self.rows = list(rows)
        self.isClosed = False

    def execute(self, sqlQuery):
        if self.executeError:
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

    # x-class-to-test-named-worker-function
