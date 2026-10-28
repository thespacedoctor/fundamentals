from __future__ import print_function
import unittest
import pytest


class _FakeCursor(object):
    """*Record the SQL and parameters executed, and return canned rows*"""

    def __init__(self, rows, error=None):
        self.rows = rows
        self.error = error
        self.executed = []
        self.closed = False

    def execute(self, sql, params=None):
        self.executed.append((sql, params))
        if self.error:
            raise self.error

    def fetchone(self):
        return self.rows[0]

    def close(self):
        self.closed = True


class _FakeConnection(object):
    def __init__(self, rows, error=None):
        self.cursorObject = _FakeCursor(rows, error)

    def cursor(self, *args, **kwargs):
        return self.cursorObject


@pytest.mark.usefixtures("session_attributes")
class test_table_exists(unittest.TestCase):

    def test_table_exists_function(self):

        from fundamentals.mysql import writequery

        sqlQuery = "CREATE TABLE IF NOT EXISTS `testing_table` (`id` INT NOT NULL, PRIMARY KEY (`id`))"
        writequery(
            log=self.log,
            sqlQuery=sqlQuery,
            dbConn=self.dbConn,
            Force=False,
            manyValueList=False,
        )

        from fundamentals.mysql import table_exists

        tableName = "testing_table"
        this = table_exists(dbConn=self.dbConn, log=self.log, dbTableName=tableName)
        # print("%(tableName)s exists: %(this)s" % locals())

        from fundamentals.mysql import writequery

        sqlQuery = "DROP TABLE `testing_table`;"
        writequery(
            log=self.log,
            sqlQuery=sqlQuery,
            dbConn=self.dbConn,
            Force=False,
            manyValueList=False,
        )

    def test_table_exists_function02(self):

        from fundamentals.mysql import table_exists

        tableName = "stupid_named_table"
        this = table_exists(dbConn=self.dbConn, log=self.log, dbTableName=tableName)
        # print("%(tableName)s exists: %(this)s" % locals())

        # x-print-testpage-for-pessto-marshall-web-object

    def test_passes_table_name_as_bound_parameter_for_current_schema_only(self):
        # ARRANGE
        from fundamentals.mysql import table_exists

        injection = "x' OR '1'='1"
        fakeConn = _FakeConnection(rows=[(0,)])

        # ACT
        exists = table_exists(dbConn=fakeConn, log=self.log, dbTableName=injection)

        # ASSERT
        sql, params = fakeConn.cursorObject.executed[0]
        self.assertFalse(exists)
        self.assertIn("DATABASE()", sql)
        self.assertNotIn(injection, sql)
        self.assertEqual(params, (injection,))
        self.assertTrue(fakeConn.cursorObject.closed)

    def test_returns_true_when_table_is_found_in_current_schema(self):
        # ARRANGE
        from fundamentals.mysql import table_exists

        fakeConn = _FakeConnection(rows=[(1,)])

        # ACT
        exists = table_exists(dbConn=fakeConn, log=self.log, dbTableName="some_table")

        # ASSERT
        self.assertTrue(exists)

    def test_closes_cursor_when_query_fails(self):
        # ARRANGE
        from fundamentals.mysql import table_exists

        fakeConn = _FakeConnection(rows=[], error=RuntimeError("boom"))

        # ACT / ASSERT
        with self.assertRaises(RuntimeError):
            table_exists(dbConn=fakeConn, log=self.log, dbTableName="some_table")
        self.assertTrue(fakeConn.cursorObject.closed)

    def test_ignores_same_named_table_in_another_schema(self):
        # ARRANGE
        from fundamentals.mysql import table_exists

        # ACT
        exists = table_exists(dbConn=self.dbConn, log=self.log, dbTableName="TABLES")

        # ASSERT
        self.assertFalse(exists)

    # x-class-to-test-named-worker-function
