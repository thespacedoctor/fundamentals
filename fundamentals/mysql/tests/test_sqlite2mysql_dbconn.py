from __future__ import print_function
import logging
import os
import shutil
import sqlite3
import sys
import tempfile
import unittest
from unittest import mock

import fundamentals.mysql

log = logging.getLogger("test_sqlite2mysql_dbconn")


class test_sqlite2mysql_dbconn(unittest.TestCase):

    def setUp(self):
        self.tmpDir = tempfile.mkdtemp()
        self.pathToSqlite = os.path.join(self.tmpDir, "one_table.sqlite")
        con = sqlite3.connect(self.pathToSqlite)
        con.execute("CREATE TABLE sweep2_query_books (title TEXT, pages INTEGER)")
        con.execute("INSERT INTO sweep2_query_books VALUES ('Dune', 412)")
        con.commit()
        con.close()

    def tearDown(self):
        shutil.rmtree(self.tmpDir, ignore_errors=True)

    def _convert(self, **kwargs):
        from fundamentals.mysql import sqlite2mysql

        this = sqlite2mysql(log=log, pathToSqlite=self.pathToSqlite, **kwargs)
        module = sys.modules["fundamentals.mysql.sqlite2mysql"]
        with (
            mock.patch.object(module, "writequery") as write,
            mock.patch.object(
                fundamentals.mysql, "insert_list_of_dictionaries_into_database_tables"
            ) as insert,
        ):
            this.convert_sqlite_to_mysql()
        return write, insert

    def test_raises_value_error_when_dbconn_omitted(self):
        from fundamentals.mysql import sqlite2mysql

        with mock.patch("sqlite3.connect") as connect:
            with self.assertRaises(ValueError) as ctx:
                sqlite2mysql(log=log, pathToSqlite=self.pathToSqlite)

        self.assertIn("dbConn", str(ctx.exception))
        connect.assert_not_called()

    def test_raises_value_error_when_dbconn_is_false(self):
        from fundamentals.mysql import sqlite2mysql

        with self.assertRaises(ValueError):
            sqlite2mysql(log=log, pathToSqlite=self.pathToSqlite, dbConn=False)

    def test_converts_table_without_settings_or_system_exit(self):
        dbConn = mock.Mock()

        write, insert = self._convert(dbConn=dbConn)

        self.assertEqual(write.call_args.kwargs["dbConn"], dbConn)
        self.assertEqual(insert.call_count, 1)
        self.assertEqual(insert.call_args.kwargs["dbTableName"], "sweep2_query_books")
        self.assertNotIn("dbSettings", insert.call_args.kwargs)

    def test_passes_database_settings_when_settings_given(self):
        dbSettings = {"host": "localhost", "db": "unit_tests"}

        _, insert = self._convert(
            dbConn=mock.Mock(), settings={"database settings": dbSettings}
        )

        self.assertEqual(insert.call_args.kwargs["dbSettings"], dbSettings)

    def test_skips_database_settings_when_settings_have_no_database_section(self):
        _, insert = self._convert(dbConn=mock.Mock(), settings={"logging": {}})

        self.assertNotIn("dbSettings", insert.call_args.kwargs)
