from __future__ import print_function
import os
import unittest
import shutil
import re
import copy
import datetime
import sys
from unittest import mock
from fundamentals.mysql.sql_identifiers import quote_identifier
import pytest

pytestmark = pytest.mark.usefixtures("session_names")
# SET FOR THE MODULE BY THE session_names FIXTURE IN THE ROOT conftest.py
log = dbConn = None

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

reDatetime = re.compile("^[0-9]{4}-[0-9]{2}-[0-9]{2}T")


def strip_string_literals(sql):
    """*remove every quoted SQL string literal (backslash escapes and doubled quotes allowed) from a statement*"""
    return re.sub(r"\"(?:[^\"\\]|\\.|\"\")*\"|'(?:[^'\\]|\\.|'')*'", "''", sql)


def string_literals(sql):
    """*return the contents of every quoted SQL string literal in a statement*"""
    return [
        a or b
        for a, b in re.findall(
            r"\"((?:[^\"\\]|\\.|\"\")*)\"|'((?:[^'\\]|\\.|'')*)'", sql
        )
    ]


class test_convert_dictionary_to_mysql_table(unittest.TestCase):

    def setUp(self):
        self.columns = []

    def test_convert_dictionary_to_mysql_table_function(self):
        from fundamentals.mysql import writequery

        sqlQuery = "DROP TABLE IF EXISTS `testing_table`; CREATE TABLE IF NOT EXISTS `testing_table` (`id` INT NOT NULL  AUTO_INCREMENT,`uniquekey1` varchar(45) NOT NULL default 'ha',`uniqueKey2` varchar(45) NOT NULL default 'ha', `dateCreated` TIMESTAMP NOT NULL default CURRENT_TIMESTAMP, `dateModified` TIMESTAMP NOT NULL default CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, PRIMARY KEY (`id`) )"
        writequery(
            log=log, sqlQuery=sqlQuery, dbConn=dbConn, Force=False, manyValueList=False
        )

        dictionary = {
            "a newKey": "cool",
            "and another": "super cool",
            "uniquekey1": "cheese",
            "uniqueKey2": "burgers",
        }
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        message = convert_dictionary_to_mysql_table(
            dbConn=dbConn,
            log=log,
            dictionary=dictionary,
            dbTableName="testing_table",
            uniqueKeyList=["uniquekey1", "uniqueKey2"],
            createHelperTables=False,
            dateModified=True,
            returnInsertOnly=False,
        )

    def test_return_inserts(self):
        from fundamentals.mysql import writequery

        sqlQuery = "CREATE TABLE IF NOT EXISTS `testing_table` (`id` INT NOT NULL, PRIMARY KEY (`id`))"
        writequery(
            log=log, sqlQuery=sqlQuery, dbConn=dbConn, Force=False, manyValueList=False
        )

        dictionary = {
            "a newKey": "cool",
            "and another": "super cool",
            "uniquekey1": "cheese",
            "uniqueKey2": "burgers",
        }
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        message = convert_dictionary_to_mysql_table(
            dbConn=dbConn,
            log=log,
            dictionary=dictionary,
            dbTableName="testing_table",
            uniqueKeyList=["uniquekey1", "uniqueKey2"],
            createHelperTables=False,
            dateModified=False,
            returnInsertOnly=True,
        )
        # print(message)

    def test_return_inserts_with_datetime_pre_compiled(self):
        from fundamentals.mysql import writequery

        sqlQuery = "CREATE TABLE IF NOT EXISTS `testing_table` (`id` INT NOT NULL, PRIMARY KEY (`id`))"
        writequery(
            log=log, sqlQuery=sqlQuery, dbConn=dbConn, Force=False, manyValueList=False
        )

        dictionary = {
            "a newKey": "cool",
            "and another": "super cool",
            "uniquekey1": "cheese",
            "uniqueKey2": "burgers",
        }
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        message = convert_dictionary_to_mysql_table(
            dbConn=dbConn,
            log=log,
            dictionary=dictionary,
            dbTableName="testing_table",
            uniqueKeyList=["uniquekey1", "uniqueKey2"],
            createHelperTables=False,
            dateModified=False,
            returnInsertOnly=True,
            reDatetime=reDatetime,
        )
        # print(message)

    def test_return_inserts_non_batch(self):
        dictionary = {
            "a newKey": "cool",
            "and another": "super cool",
            "uniquekey1": "cheese",
            "uniqueKey2": "burgers",
        }
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        inserts = convert_dictionary_to_mysql_table(
            dbConn=dbConn,
            log=log,
            dictionary=dictionary,
            dbTableName="testing_table",
            uniqueKeyList=["uniquekey1", "uniqueKey2"],
            dateModified=False,
            returnInsertOnly=True,
            replace=True,
            batchInserts=False,
        )

        # x-print-testpage-for-pessto-marshall-web-object

    def test_returns_inserts_for_mixed_type_keys_in_string_order(self):
        # ARRANGE
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        dictionary = {"a": "x", 1: "y"}

        # ACT
        insertCommand, valueTuple = convert_dictionary_to_mysql_table(
            dbConn=dbConn,
            log=log,
            dictionary=dictionary,
            dbTableName="testing_table",
            uniqueKeyList=[],
            dateModified=False,
            returnInsertOnly=True,
        )

        # ASSERT
        self.assertIn("(`1`,`a`", insertCommand)
        self.assertEqual(valueTuple, ("y", "x"))

    def test_does_not_mutate_caller_dictionary_when_returning_inserts(self):
        # ARRANGE
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        dictionary = {
            "a newKey": "cool",
            "nested": [["x", "y"], "a nested list value"],
            "skipped": [None, "a value that is dropped"],
            "uniquekey1": "cheese",
        }
        original = copy.deepcopy(dictionary)

        # ACT
        convert_dictionary_to_mysql_table(
            log=log,
            dictionary=dictionary,
            dbTableName="dy2028_testing_table",
            uniqueKeyList=["uniquekey1"],
            dateModified=True,
            returnInsertOnly=True,
        )

        # ASSERT
        self.assertEqual(dictionary, original)

    def test_does_not_mutate_caller_dictionary_when_writing_to_database(self):
        # ARRANGE
        dictionary = {
            "uni key": "cheese",
            "skipped": [None, "a value that is dropped"],
        }
        original = copy.deepcopy(dictionary)

        # ACT
        self._write_to_database(
            "dy2028_dictionary_table", dictionary, ["uni key"], dateModified=True
        )

        # ASSERT
        self.assertEqual(dictionary, original)

    def test_does_not_mutate_caller_unique_key_list(self):
        # ARRANGE
        dictionary = {"uni key": "cheese", "dec": "burgers"}
        uniqueKeyList = ["uni key", "dec"]

        # ACT
        self._write_to_database(
            "dy2028_unique_key_table", dictionary, uniqueKeyList, dateModified=False
        )

        # ASSERT
        self.assertEqual(uniqueKeyList, ["uni key", "dec"])

    def _write_to_database(
        self, tableName, dictionary, uniqueKeyList, dateModified, afterWrite=None
    ):
        from fundamentals.mysql import convert_dictionary_to_mysql_table, writequery

        try:
            convert_dictionary_to_mysql_table(
                dbConn=dbConn,
                log=log,
                dictionary=dictionary,
                dbTableName=tableName,
                uniqueKeyList=uniqueKeyList,
                dateModified=dateModified,
            )
            if afterWrite:
                afterWrite()
        finally:
            writequery(
                log=log,
                sqlQuery="DROP TABLE IF EXISTS " + quote_identifier(tableName),
                dbConn=dbConn,
            )

    def test_raises_when_column_check_query_fails(self):
        # ARRANGE
        from fundamentals.mysql import writequery

        module = sys.modules["fundamentals.mysql.convert_dictionary_to_mysql_table"]
        tableName = "dy2028_column_check_table"

        # ACT / ASSERT
        try:
            with mock.patch.object(
                module, "readquery", side_effect=RuntimeError("column check failed")
            ):
                with self.assertRaises(RuntimeError):
                    module.convert_dictionary_to_mysql_table(
                        dbConn=dbConn,
                        log=log,
                        dictionary={"a newKey": "cool", "another": "value"},
                        dbTableName=tableName,
                    )
        finally:
            writequery(
                log=log,
                sqlQuery="DROP TABLE IF EXISTS " + quote_identifier(tableName),
                dbConn=dbConn,
            )

    def test_raises_when_add_column_query_fails(self):
        # ARRANGE
        from fundamentals.mysql import writequery

        module = sys.modules["fundamentals.mysql.convert_dictionary_to_mysql_table"]
        tableName = "dy2028_add_column_table"

        def failOnAlter(log, sqlQuery, dbConn, **kwargs):
            if sqlQuery.startswith("ALTER TABLE"):
                raise RuntimeError("add column failed")
            return writequery(log=log, sqlQuery=sqlQuery, dbConn=dbConn, **kwargs)

        # ACT / ASSERT
        try:
            with mock.patch.object(module, "writequery", side_effect=failOnAlter):
                with self.assertRaises(RuntimeError):
                    module.convert_dictionary_to_mysql_table(
                        dbConn=dbConn,
                        log=log,
                        dictionary={"a newKey": "cool", "another": "value"},
                        dbTableName=tableName,
                    )
        finally:
            writequery(
                log=log,
                sqlQuery="DROP TABLE IF EXISTS " + quote_identifier(tableName),
                dbConn=dbConn,
            )

    def test_escapes_list_wrapped_value_in_insert_statement(self):
        # ARRANGE
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        dictionary = {"a": ['x"; DROP TABLE t; -- ', "c"]}

        # ACT
        insertCommand = convert_dictionary_to_mysql_table(
            log=log,
            dictionary=dictionary,
            dbTableName="sweep2_dictsql_t",
            returnInsertOnly=True,
            batchInserts=False,
        )

        # ASSERT
        self.assertNotIn("DROP TABLE", strip_string_literals(insertCommand))

    def test_escapes_plain_string_value_in_insert_statement(self):
        # ARRANGE
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        dictionary = {"a": "x'; DROP TABLE t; -- ", "b": 'y"; DROP TABLE t; -- '}

        # ACT
        insertCommand = convert_dictionary_to_mysql_table(
            log=log,
            dictionary=dictionary,
            dbTableName="sweep2_dictsql_t",
            returnInsertOnly=True,
            batchInserts=False,
        )

        # ASSERT
        self.assertNotIn("DROP TABLE", strip_string_literals(insertCommand))

    def test_binds_string_values_unescaped_in_batch_value_tuple(self):
        # ARRANGE
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        dictionary = {"a": 'say "hi" \\ bye', "b": ['x"y', "comment"]}

        # ACT
        insertCommand, valueTuple = convert_dictionary_to_mysql_table(
            log=log,
            dictionary=dictionary,
            dbTableName="sweep2_dictsql_t",
            returnInsertOnly=True,
        )

        # ASSERT
        self.assertEqual(valueTuple, ('say "hi" \\ bye', 'x"y'))
        self.assertNotIn("hi", insertCommand)

    def test_quotes_table_and_column_names_in_batch_insert_command(self):
        # ARRANGE
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        dictionary = {"a`b": "x", "100%": "y"}

        # ACT
        insertCommand, valueTuple = convert_dictionary_to_mysql_table(
            log=log,
            dictionary=dictionary,
            dbTableName="sweep2_dictsql_t`x",
            returnInsertOnly=True,
        )

        # ASSERT
        self.assertTrue(insertCommand.startswith("INSERT INTO `sweep2_dictsql_t``x` ("))
        self.assertIn("(`100%%`,`a``b`,", insertCommand)

    def test_writes_dictionary_with_awkward_names_to_database(self):
        # ARRANGE
        from fundamentals.mysql import get_database_table_column_names

        tableName = "sweep2_dictsql_awkward`table"
        dictionary = {"it's a key": "v1", "tick`key": "v2", "uni": "u"}

        # ACT
        self._write_to_database(
            tableName,
            dictionary,
            ["it's a key"],
            dateModified=False,
            afterWrite=lambda: self.columns.extend(
                get_database_table_column_names(
                    dbConn=dbConn, log=log, dbTable=tableName
                )
            ),
        )

        # ASSERT
        self.assertIn("it's_a_key", self.columns)
        self.assertIn("tick`key", self.columns)

    def _insert_statement(self, dictionary, **kwargs):
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        return convert_dictionary_to_mysql_table(
            log=log,
            dictionary=dictionary,
            dbTableName="sweep2_dictsql_t",
            returnInsertOnly=True,
            batchInserts=False,
            **kwargs,
        )

    def test_closes_quote_when_last_value_ends_in_null(self):
        # ARRANGE
        dictionary = {"a": "hello", "b": "null", "c": "annull"}

        # ACT
        insertCommand = self._insert_statement(dictionary)

        # ASSERT
        self.assertEqual(string_literals(insertCommand), ["hello", "null", "annull"])
        self.assertNotIn("'", strip_string_literals(insertCommand).replace("''", ""))

    def test_keeps_values_containing_space_comma_intact_in_update_clause(self):
        # ARRANGE
        dictionary = {"a": "x , y", "b": "z"}

        # ACT
        insertCommand = self._insert_statement(dictionary, replace=True)

        # ASSERT
        self.assertEqual(
            string_literals(insertCommand), ["x , y", "z", "x , y", "z"]
        )
        self.assertIn("ON DUPLICATE KEY UPDATE `a`='x , y', `b`='z'", insertCommand)

    def test_does_not_leave_trailing_comma_on_update_clause(self):
        # ARRANGE
        dictionary = {"a": "x", "b": "y"}

        # ACT
        insertCommand = self._insert_statement(dictionary, replace=True)

        # ASSERT
        self.assertTrue(insertCommand.strip().endswith("`b`='y'"))

    def test_update_clause_with_date_modified_tests_null_columns_with_is_null(self):
        # ARRANGE
        dictionary = {"a": "x", "b": None}

        # ACT
        insertCommand = self._insert_statement(
            dictionary, replace=True, dateModified=True
        )

        # ASSERT
        self.assertRegex(
            insertCommand,
            r"updated=IF\(`a`='x' AND `b` IS NULL AND .*, 0, 1\), "
            r"dateLastModified=IF\(`a`='x' AND `b` IS NULL AND .*, dateLastModified, NOW\(\)\)$",
        )

    def test_backtick_quotes_reserved_column_in_batch_update_clause(self):
        # ARRANGE
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        # ACT
        insertCommand, valueTuple = convert_dictionary_to_mysql_table(
            log=log,
            dictionary={"order": "x", "b": "y"},
            dbTableName="sweep2_dictsql_t",
            returnInsertOnly=True,
            replace=True,
        )

        # ASSERT
        self.assertTrue(
            insertCommand.endswith(
                "ON DUPLICATE KEY UPDATE `b`=VALUES(`b`), `order`=VALUES(`order`)"
            )
        )

    def test_keeps_percent_signs_single_in_the_batch_update_tail_without_date_created(
        self,
    ):
        # ARRANGE: PYMYSQL BATCHES THE ROWS WHEN NOW() IS NOT IN THE VALUES AND SENDS THE TAIL UNFORMATTED
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        # ACT
        insertCommand, valueTuple = convert_dictionary_to_mysql_table(
            log=log,
            dictionary={"100%": 1},
            dbTableName="sweep2_dictsql_t",
            returnInsertOnly=True,
            replace=True,
            dateCreated=False,
        )

        # ASSERT
        self.assertIn("(`100%%`) VALUES (%s)", insertCommand)
        self.assertTrue(
            insertCommand.endswith("ON DUPLICATE KEY UPDATE `100%`=VALUES(`100%`)")
        )

    def test_python_none_and_empty_string_become_null_but_none_text_stays(self):
        # ARRANGE
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        dictionary = {
            "a": None,
            "b": "",
            "c": "None",
            "d": ["", "comment"],
            "e": "null",
        }

        # ACT
        insertCommand, valueTuple = convert_dictionary_to_mysql_table(
            log=log,
            dictionary=dictionary,
            dbTableName="sweep2_dictsql_t",
            returnInsertOnly=True,
        )
        literalCommand = self._insert_statement(dictionary)

        # ASSERT
        self.assertEqual(valueTuple, (None, None, "None", None, "null"))
        self.assertIn("VALUES (NULL,NULL,'None',NULL,'null', NOW())", literalCommand)

    def test_batch_value_tuple_keeps_numbers_and_booleans_native(self):
        # ARRANGE
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        dictionary = {"a": 5, "b": True, "c": 1.5, "d": datetime.date(2020, 1, 2)}

        # ACT
        insertCommand, valueTuple = convert_dictionary_to_mysql_table(
            log=log,
            dictionary=dictionary,
            dbTableName="sweep2_dictsql_t",
            returnInsertOnly=True,
        )

        # ASSERT
        self.assertEqual(valueTuple, (5, True, 1.5, "2020-01-02"))

    def test_does_not_turn_double_quotes_inside_values_into_null(self):
        # ARRANGE
        dictionary = {"a": 'say ""hi""', "b": 'x"'}

        # ACT
        insertCommand = self._insert_statement(dictionary)

        # ASSERT
        self.assertNotIn("NULL", insertCommand.upper())
        self.assertEqual(len(string_literals(insertCommand)), 2)

    def test_keeps_values_containing_now_when_date_created_is_off(self):
        # ARRANGE
        dictionary = {"a": "x, NOW())", "b": "y"}

        # ACT
        insertCommand = self._insert_statement(dictionary, dateCreated=False)

        # ASSERT
        self.assertEqual(string_literals(insertCommand), ["x, NOW())", "y"])
        self.assertNotIn("dateCreated", insertCommand)
        self.assertTrue(insertCommand.strip().endswith("'y')"))

    def test_round_trips_awkward_values_through_database_with_replace(self):
        # ARRANGE
        from fundamentals.mysql import (
            convert_dictionary_to_mysql_table,
            readquery,
            writequery,
        )

        tableName = "sweep2_dictsql_roundtrip"
        awkward = {
            "order": "x , y",
            "uni": "k",
            "last": "null",
            "quote": 'q"uo\'te \\ end',
            "blank": "",
        }

        def write(dictionary):
            convert_dictionary_to_mysql_table(
                dbConn=dbConn,
                log=log,
                dictionary=dictionary,
                dbTableName=tableName,
                uniqueKeyList=["uni"],
                dateModified=True,
                replace=True,
            )

        # ACT
        try:
            write(awkward)
            write({**awkward, "order": "changed , again"})
            rows = readquery(
                log=log,
                sqlQuery="SELECT `order`, `last`, `quote`, `blank` FROM `%s`"
                % (tableName,),
                dbConn=dbConn,
            )
        finally:
            writequery(
                log=log,
                sqlQuery="DROP TABLE IF EXISTS " + quote_identifier(tableName),
                dbConn=dbConn,
            )

        # ASSERT
        self.assertEqual(
            rows,
            [
                {
                    "order": "changed , again",
                    "last": "null",
                    "quote": 'q"uo\'te \\ end',
                    "blank": None,
                }
            ],
        )

    def test_raises_value_error_for_empty_dictionary_key(self):
        # ARRANGE / ACT / ASSERT
        with self.assertRaises(ValueError):
            self._insert_statement({"": "x", "b": "y"})

    def test_raises_value_error_for_empty_table_name(self):
        # ARRANGE
        from fundamentals.mysql import convert_dictionary_to_mysql_table

        # ACT / ASSERT
        with self.assertRaises(ValueError):
            convert_dictionary_to_mysql_table(
                log=log,
                dictionary={"a": "x"},
                dbTableName="",
                returnInsertOnly=True,
            )

    # x-class-to-test-named-worker-function
