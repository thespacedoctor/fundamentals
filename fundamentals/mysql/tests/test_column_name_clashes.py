import sys
import unittest
from unittest import mock
import pytest

pytestmark = pytest.mark.usefixtures("session_names")
# INJECTED BY THE session_names FIXTURE IN THE ROOT conftest.py (PYTEST ONLY)
log = dbConn = None

TABLE_NAME = "sweep2_dictsql_clash_table"
INSERT_MODULE = "fundamentals.mysql.insert_list_of_dictionaries_into_database_tables"


def drop_clash_table():
    from fundamentals.mysql import writequery

    writequery(
        log=log, sqlQuery="DROP TABLE IF EXISTS `%s`" % (TABLE_NAME,), dbConn=dbConn
    )


class test_normalise_column_name(unittest.TestCase):

    def test_replaces_spaces_and_hyphens_with_underscores(self):
        # ARRANGE
        from fundamentals.mysql.sql_identifiers import normalise_column_name

        # ACT
        name = normalise_column_name("my key-name")

        # ASSERT
        self.assertEqual(name, "my_key_name")

    def test_converts_non_string_keys_to_strings(self):
        # ARRANGE
        from fundamentals.mysql.sql_identifiers import normalise_column_name

        # ACT
        name = normalise_column_name(1)

        # ASSERT
        self.assertEqual(name, "1")

    def test_renames_the_mysql_keyword_dec(self):
        # ARRANGE
        from fundamentals.mysql.sql_identifiers import normalise_column_name

        # ACT / ASSERT
        self.assertEqual(normalise_column_name("dec"), "decl")
        self.assertEqual(normalise_column_name("DEC"), "DECL")


class test_raise_on_duplicate_columns(unittest.TestCase):

    def test_raises_naming_both_keys_for_int_and_str_clash(self):
        # ARRANGE
        from fundamentals.mysql.sql_identifiers import raise_on_duplicate_columns

        # ACT
        with self.assertRaises(ValueError) as context:
            raise_on_duplicate_columns([1, "1"])

        # ASSERT
        self.assertEqual(
            str(context.exception), "keys 1 and '1' both map to column '1'"
        )

    def test_raises_naming_all_keys_for_space_hyphen_underscore_clash(self):
        # ARRANGE
        from fundamentals.mysql.sql_identifiers import raise_on_duplicate_columns

        # ACT
        with self.assertRaises(ValueError) as context:
            raise_on_duplicate_columns(["my key", "my-key", "my_key"])

        # ASSERT
        self.assertEqual(
            str(context.exception),
            "keys 'my key', 'my-key' and 'my_key' all map to column 'my_key'",
        )

    def test_raises_for_a_key_that_clashes_with_the_renamed_dec_column(self):
        # ARRANGE
        from fundamentals.mysql.sql_identifiers import raise_on_duplicate_columns

        # ACT / ASSERT
        with self.assertRaises(ValueError):
            raise_on_duplicate_columns(["dec", "decl"])

    def test_returns_normally_when_columns_are_distinct(self):
        # ARRANGE
        from fundamentals.mysql.sql_identifiers import raise_on_duplicate_columns

        # ACT / ASSERT
        self.assertIsNone(raise_on_duplicate_columns(["a key", "b-key", 1]))


class test_convert_dictionary_to_mysql_table_clashes(unittest.TestCase):

    def setUp(self):
        drop_clash_table()
        self.addCleanup(drop_clash_table)

    def test_raises_naming_both_keys_when_int_and_str_keys_clash(self):
        # ARRANGE
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        # ACT
        with self.assertRaises(ValueError) as context:
            convert_dictionary_to_mysql_table(
                log=log,
                dictionary={1: "a", "1": "b"},
                dbTableName=TABLE_NAME,
                returnInsertOnly=True,
            )

        # ASSERT
        self.assertEqual(
            str(context.exception), "keys 1 and '1' both map to column '1'"
        )

    def test_raises_and_creates_no_table_when_separator_keys_clash(self):
        # ARRANGE
        from fundamentals.mysql import convert_dictionary_to_mysql_table, table_exists

        # ACT
        with self.assertRaises(ValueError) as context:
            convert_dictionary_to_mysql_table(
                log=log,
                dictionary={"my key": 1, "my-key": 2, "my_key": 3},
                dbConn=dbConn,
                dbTableName=TABLE_NAME,
            )

        # ASSERT
        self.assertIn("'my_key'", str(context.exception))
        self.assertFalse(table_exists(dbConn=dbConn, log=log, dbTableName=TABLE_NAME))


class test_insert_list_of_dictionaries_clashes(unittest.TestCase):

    def setUp(self):
        drop_clash_table()
        self.addCleanup(drop_clash_table)

    def test_raises_and_creates_no_table_when_first_dictionary_has_clashing_keys(
        self,
    ):
        # ARRANGE
        from fundamentals.mysql import (
            insert_list_of_dictionaries_into_database_tables,
            table_exists,
        )

        # ACT
        with self.assertRaises(ValueError) as context:
            insert_list_of_dictionaries_into_database_tables(
                dbConn=dbConn,
                log=log,
                dictList=[{1: "a", "1": "b"}],
                dbTableName=TABLE_NAME,
            )

        # ASSERT
        self.assertIn("'1'", str(context.exception))
        self.assertFalse(table_exists(dbConn=dbConn, log=log, dbTableName=TABLE_NAME))

    def test_raises_before_any_sql_runs_when_batch_keys_clash(self):
        # ARRANGE
        insertModule = sys.modules[INSERT_MODULE]
        rows = [{"my key": 1}, {"my_key": 2}]
        writequeryMock = mock.Mock(return_value="")

        # ACT
        with (
            mock.patch.object(insertModule, "sharedList", [(rows, 2)]),
            mock.patch.object(insertModule, "totalCount", 2),
            mock.patch.object(insertModule, "globalDbConn", dbConn),
            mock.patch.object(insertModule, "writequery", writequeryMock),
        ):
            with self.assertRaises(ValueError) as context:
                insertModule._insert_single_batch_into_database(
                    batchIndex=0,
                    log=log,
                    dbTableName=TABLE_NAME,
                    uniqueKeyList=[],
                    dateModified=False,
                    replace=False,
                    batchSize=2500,
                    reDatetime=False,
                    dateCreated=False,
                )

        # ASSERT
        self.assertEqual(
            str(context.exception), "keys 'my key' and 'my_key' both map to column 'my_key'"
        )
        writequeryMock.assert_not_called()


if __name__ == "__main__":
    unittest.main()
