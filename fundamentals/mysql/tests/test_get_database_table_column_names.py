from __future__ import print_function
import os
import unittest
import shutil
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


class _FakeCursor(object):
    """*Record the SQL executed, and expose canned column metadata*"""

    def __init__(self, columnNames, error=None):
        self.description = tuple((name, None) for name in columnNames)
        self.error = error
        self.executed = []
        self.closed = False

    def execute(self, sql, params=None):
        self.executed.append((sql, params))
        if self.error:
            raise self.error

    def close(self):
        self.closed = True


class _FakeConnection(object):
    def __init__(self, columnNames, error=None):
        self.cursorObject = _FakeCursor(columnNames, error)

    def cursor(self, *args, **kwargs):
        return self.cursorObject


class test_get_database_table_column_names(unittest.TestCase):

    def test_get_database_table_column_names_function(self):

        from fundamentals.mysql import get_database_table_column_names

        columnNames = get_database_table_column_names(
            dbConn=dbConn, log=log, dbTable="testing_table"
        )
        # print(columnNames)

        # x-print-testpage-for-pessto-marshall-web-object

    def test_quotes_table_name_so_it_cannot_inject_sql(self):
        # ARRANGE
        from fundamentals.mysql import get_database_table_column_names

        fakeConn = _FakeConnection(["a", "b"])

        # ACT
        columnNames = get_database_table_column_names(
            dbConn=fakeConn, log=log, dbTable="t`; DROP TABLE t; -- "
        )

        # ASSERT
        sql, params = fakeConn.cursorObject.executed[0]
        self.assertEqual(columnNames, ["a", "b"])
        self.assertEqual(sql, "SELECT * FROM `t``; DROP TABLE t; -- ` LIMIT 0")
        self.assertTrue(fakeConn.cursorObject.closed)

    def test_returns_column_names_for_empty_table(self):
        # ARRANGE
        from fundamentals.mysql import get_database_table_column_names, writequery

        tableName = "sweep2_dictsql_empty_table"
        writequery(
            log=log,
            sqlQuery="CREATE TABLE IF NOT EXISTS `%s` (`id` INT NOT NULL, `name` VARCHAR(10))"
            % (tableName,),
            dbConn=dbConn,
        )

        # ACT
        try:
            columnNames = get_database_table_column_names(
                dbConn=dbConn, log=log, dbTable=tableName
            )
        finally:
            writequery(
                log=log,
                sqlQuery="DROP TABLE IF EXISTS `%s`" % (tableName,),
                dbConn=dbConn,
            )

        # ASSERT
        self.assertEqual(columnNames, ["id", "name"])

    def test_returns_minus_one_when_table_does_not_exist(self):
        # ARRANGE
        from fundamentals.mysql import get_database_table_column_names

        # ACT
        columnNames = get_database_table_column_names(
            dbConn=dbConn, log=log, dbTable="sweep2_dictsql_no_such_table"
        )

        # ASSERT
        self.assertEqual(columnNames, -1)

    def test_closes_cursor_when_query_fails(self):
        # ARRANGE
        from fundamentals.mysql import get_database_table_column_names

        fakeConn = _FakeConnection([], error=RuntimeError("boom"))

        # ACT
        columnNames = get_database_table_column_names(
            dbConn=fakeConn, log=log, dbTable="some_table"
        )

        # ASSERT
        self.assertEqual(columnNames, -1)
        self.assertTrue(fakeConn.cursorObject.closed)

    # x-class-to-test-named-worker-function
