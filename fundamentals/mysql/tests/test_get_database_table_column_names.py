from __future__ import print_function
import unittest
import pytest


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


@pytest.mark.usefixtures("session_attributes")
class test_get_database_table_column_names(unittest.TestCase):

    def test_get_database_table_column_names_function(self):

        from fundamentals.mysql import get_database_table_column_names

        columnNames = get_database_table_column_names(
            dbConn=self.dbConn, log=self.log, dbTable="testing_table"
        )
        # print(columnNames)

        # x-print-testpage-for-pessto-marshall-web-object

    def test_quotes_table_name_so_it_cannot_inject_sql(self):
        # ARRANGE
        from fundamentals.mysql import get_database_table_column_names

        fakeConn = _FakeConnection(["a", "b"])

        # ACT
        columnNames = get_database_table_column_names(
            dbConn=fakeConn, log=self.log, dbTable="t`; DROP TABLE t; -- "
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
            log=self.log,
            sqlQuery="CREATE TABLE IF NOT EXISTS `%s` (`id` INT NOT NULL, `name` VARCHAR(10))"
            % (tableName,),
            dbConn=self.dbConn,
        )

        # ACT
        try:
            columnNames = get_database_table_column_names(
                dbConn=self.dbConn, log=self.log, dbTable=tableName
            )
        finally:
            writequery(
                log=self.log,
                sqlQuery="DROP TABLE IF EXISTS `%s`" % (tableName,),
                dbConn=self.dbConn,
            )

        # ASSERT
        self.assertEqual(columnNames, ["id", "name"])

    def test_returns_minus_one_when_table_does_not_exist(self):
        # ARRANGE
        from fundamentals.mysql import get_database_table_column_names

        # ACT
        columnNames = get_database_table_column_names(
            dbConn=self.dbConn, log=self.log, dbTable="sweep2_dictsql_no_such_table"
        )

        # ASSERT
        self.assertEqual(columnNames, -1)

    def test_closes_cursor_when_query_fails(self):
        # ARRANGE
        from fundamentals.mysql import get_database_table_column_names

        fakeConn = _FakeConnection([], error=RuntimeError("boom"))

        # ACT
        columnNames = get_database_table_column_names(
            dbConn=fakeConn, log=self.log, dbTable="some_table"
        )

        # ASSERT
        self.assertEqual(columnNames, -1)
        self.assertTrue(fakeConn.cursorObject.closed)

    # x-class-to-test-named-worker-function
