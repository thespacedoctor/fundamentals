from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml
import sys
from unittest import mock
from fundamentals.mysql.sql_identifiers import quote_identifier
import pytest

pytestmark = pytest.mark.usefixtures("session_names")
# INJECTED BY THE session_names FIXTURE IN THE ROOT conftest.py (PYTEST ONLY)
log = settings = dbConn = None

# SETUP PATHS TO COMMON DIRECTORIES FOR TEST DATA
moduleDirectory = os.path.dirname(__file__)
pathToInputDir = moduleDirectory + "/input/"
pathToOutputDir = moduleDirectory + "/output/"

try:
    shutil.rmtree(pathToOutputDir)
except:
    pass
# COPY INPUT TO OUTPUT DIR
shutil.copytree(pathToInputDir, pathToOutputDir)

# Recursively create missing directories
if not os.path.exists(pathToOutputDir):
    os.makedirs(pathToOutputDir)

# xt-setup-unit-testing-files-and-folders

pathToSqlite = pathToInputDir + "/test.sqlite"


HEADJACK_DIRECTORY = "/tmp/headjack"


class test_sqlite2mysql(unittest.TestCase):

    def test_sqlite2mysql_does_not_create_tmp_headjack_directory(self):

        import fundamentals.mysql
        from fundamentals.mysql import sqlite2mysql

        realExists = os.path.exists
        realMakedirs = os.makedirs
        makedirsCalls = []

        def fakeExists(path):
            if str(path).startswith(HEADJACK_DIRECTORY):
                return False
            return realExists(path)

        def fakeMakedirs(path, *args, **kwargs):
            if str(path).startswith(HEADJACK_DIRECTORY):
                makedirsCalls.append(path)
                return None
            return realMakedirs(path, *args, **kwargs)

        this = sqlite2mysql(
            log=log,
            settings=settings,
            pathToSqlite=pathToSqlite,
            tablePrefix="Marvin",
            dbConn=dbConn,
        )
        sqliteModule = sys.modules["fundamentals.mysql.sqlite2mysql"]

        # PATCH ONLY THE MODULE'S OWN os REFERENCE, NOT THE GLOBAL os MODULE
        fakeOs = mock.Mock(wraps=os)
        fakeOs.path = mock.Mock(wraps=os.path)
        fakeOs.path.exists.side_effect = fakeExists
        fakeOs.makedirs.side_effect = fakeMakedirs

        with (
            mock.patch.object(sqliteModule, "writequery"),
            mock.patch.object(
                fundamentals.mysql, "insert_list_of_dictionaries_into_database_tables"
            ),
            mock.patch.object(sqliteModule, "os", fakeOs),
        ):
            this.convert_sqlite_to_mysql()

        self.assertEqual(makedirsCalls, [])

    def _make_sqlite_file(self, tableName):
        import sqlite3

        path = pathToOutputDir + "/sweep2_dictsql_%d.sqlite" % (abs(hash(tableName)),)
        if os.path.exists(path):
            os.remove(path)
        con = sqlite3.connect(path)
        con.execute('CREATE TABLE "%s" (name TEXT)' % (tableName.replace('"', '""'),))
        con.execute(
            'INSERT INTO "%s" (name) VALUES (?)' % (tableName.replace('"', '""'),),
            ("row one",),
        )
        con.commit()
        con.close()
        return path

    def test_sqlite2mysql_copies_table_whose_name_contains_a_quote(self):
        # ARRANGE
        import fundamentals.mysql
        from fundamentals.mysql import sqlite2mysql

        tableName = 'it\'s a "table"'
        path = self._make_sqlite_file(tableName)
        this = sqlite2mysql(
            log=log,
            settings=settings,
            pathToSqlite=path,
            tablePrefix="Pre_",
            dbConn=dbConn,
        )
        sqliteModule = sys.modules["fundamentals.mysql.sqlite2mysql"]

        # ACT
        with (
            mock.patch.object(sqliteModule, "writequery") as writeQuery,
            mock.patch.object(
                fundamentals.mysql, "insert_list_of_dictionaries_into_database_tables"
            ) as insertList,
        ):
            this.convert_sqlite_to_mysql()

        # ASSERT
        kwargs = insertList.call_args.kwargs
        self.assertEqual(kwargs["dbTableName"], this.tablePrefix + tableName)
        createdTable = quote_identifier(kwargs["dbTableName"])
        self.assertTrue(
            writeQuery.call_args.kwargs["sqlQuery"].startswith(
                "CREATE TABLE IF NOT EXISTS " + createdTable + " ("
            ),
            writeQuery.call_args.kwargs["sqlQuery"],
        )
        self.assertEqual(kwargs["dictList"], [{"name": "row one"}])

    def test_sqlite2mysql_closes_sqlite_connection_and_cursor_when_conversion_fails(
        self,
    ):
        # ARRANGE
        import sqlite3
        from fundamentals.mysql import sqlite2mysql

        closed = []

        class RecordingCursor(sqlite3.Cursor):
            def close(self):
                closed.append("cursor")
                super().close()

        class RecordingConnection(sqlite3.Connection):
            def cursor(self, factory=RecordingCursor):
                return super().cursor(factory)

            def close(self):
                closed.append("connection")
                super().close()

        path = self._make_sqlite_file("plain_table")
        this = sqlite2mysql(
            log=log,
            settings=settings,
            pathToSqlite=path,
            tablePrefix="Pre_",
            dbConn=dbConn,
        )
        sqliteModule = sys.modules["fundamentals.mysql.sqlite2mysql"]
        fakeLite = mock.Mock(wraps=sqlite3)
        fakeLite.connect.side_effect = lambda p: sqlite3.connect(
            p, factory=RecordingConnection
        )

        # ACT
        with (
            mock.patch.object(sqliteModule, "lite", fakeLite),
            mock.patch.object(
                sqliteModule, "writequery", side_effect=RuntimeError("write failed")
            ),
        ):
            with self.assertRaises(RuntimeError):
                this.convert_sqlite_to_mysql()

        # ASSERT
        self.assertEqual(sorted(closed), ["connection", "cursor"])

    def _captured_create_statements(self, createSql, tablePrefix="Pre"):
        import sqlite3
        import fundamentals.mysql
        from fundamentals.mysql import sqlite2mysql

        path = pathToOutputDir + "/sweep2_ddl_%d.sqlite" % (abs(hash(createSql)),)
        if os.path.exists(path):
            os.remove(path)
        con = sqlite3.connect(path)
        for statement in createSql:
            con.execute(statement)
        con.commit()
        con.close()

        this = sqlite2mysql(
            log=log,
            settings=settings,
            pathToSqlite=path,
            tablePrefix=tablePrefix,
            dbConn=dbConn,
        )
        sqliteModule = sys.modules["fundamentals.mysql.sqlite2mysql"]
        with (
            mock.patch.object(sqliteModule, "writequery") as writeQuery,
            mock.patch.object(
                fundamentals.mysql, "insert_list_of_dictionaries_into_database_tables"
            ),
        ):
            this.convert_sqlite_to_mysql()
        return [call.kwargs["sqlQuery"] for call in writeQuery.call_args_list]

    def test_sqlite2mysql_quotes_table_prefix_in_create_statement(self):
        # ARRANGE
        hostilePrefix = "safe` (x INT); DROP TABLE victim; -- "
        createSql = ('CREATE TABLE "Child" ("Tag" TEXT NOT NULL)',)

        # ACT
        statements = self._captured_create_statements(createSql, hostilePrefix)

        # ASSERT
        self.assertEqual(len(statements), 1)
        expectedHeader = "CREATE TABLE IF NOT EXISTS `safe`` (x INT); DROP TABLE victim; -- _Child` ("
        self.assertTrue(statements[0].startswith(expectedHeader), statements[0])

    def test_sqlite2mysql_keeps_double_quotes_inside_string_literals(self):
        # ARRANGE
        createSql = (
            'CREATE TABLE "Child" ("Note" TEXT DEFAULT \'say "hi"\', "Tag" TEXT)',
        )

        # ACT
        statements = self._captured_create_statements(createSql)

        # ASSERT
        self.assertIn("`Note` TEXT DEFAULT 'say \"hi\"', `Tag` TEXT", statements[0])

    def test_sqlite2mysql_escapes_backtick_inside_column_name(self):
        # ARRANGE
        createSql = ('CREATE TABLE "Child" ("odd`name" TEXT)',)

        # ACT
        statements = self._captured_create_statements(createSql)

        # ASSERT
        self.assertIn("(`odd``name` TEXT", statements[0])

    def test_sqlite2mysql_drops_column_level_foreign_key_from_create_statement(self):
        # ARRANGE
        createSql = (
            'CREATE TABLE "Parent" ("ID" INTEGER PRIMARY KEY, "UUID" TEXT NOT NULL)',
            'CREATE TABLE "Child" ('
            '"ID" INTEGER PRIMARY KEY, '
            '"EntryUUID" TEXT NOT NULL REFERENCES "Parent"("UUID") '
            "ON UPDATE CASCADE ON DELETE CASCADE, "
            '"Tag" TEXT NOT NULL)',
        )

        # ACT
        statements = self._captured_create_statements(createSql)

        # ASSERT
        childStatement = [s for s in statements if "`Pre_Child`" in s][0]
        self.assertNotIn("REFERENCES", childStatement.upper())
        self.assertNotIn("CASCADE", childStatement.upper())
        self.assertIn("`EntryUUID` TEXT NOT NULL, `Tag` TEXT NOT NULL", childStatement)

    def test_sqlite2mysql_drops_table_level_foreign_key_from_create_statement(self):
        # ARRANGE
        createSql = (
            'CREATE TABLE "Parent" ("ID" INTEGER PRIMARY KEY, "UUID" TEXT NOT NULL)',
            'CREATE TABLE "Child" ("pid" TEXT NOT NULL, "Tag" TEXT, '
            'CONSTRAINT "fk_parent" FOREIGN KEY ("pid") REFERENCES "Parent" ("UUID") '
            "ON DELETE SET NULL)",
        )

        # ACT
        statements = self._captured_create_statements(createSql)

        # ASSERT
        childStatement = [s for s in statements if "`Pre_Child`" in s][0]
        self.assertNotIn("FOREIGN KEY", childStatement.upper())
        self.assertNotIn("REFERENCES", childStatement.upper())
        self.assertIn("(`pid` TEXT NOT NULL, `Tag` TEXT,", childStatement)

    def test_sqlite2mysql_function(self):

        from fundamentals.mysql import sqlite2mysql

        this = sqlite2mysql(
            log=log,
            settings=settings,
            pathToSqlite=pathToSqlite,
            tablePrefix="Marvin",
            dbConn=dbConn,
        )
        this.convert_sqlite_to_mysql()

    def test_sqlite2mysql_function_exception(self):

        from fundamentals.mysql import sqlite2mysql

        try:
            this = sqlite2mysql(
                log=log,
                settings=settings,
                pathToSqlite=pathToSqlite,
                fakeKey="break the code",
            )
            this.get()
            assert False
        except Exception as e:
            assert True
            # print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
