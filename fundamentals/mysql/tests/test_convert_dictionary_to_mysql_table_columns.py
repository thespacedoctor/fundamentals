import datetime
import importlib
import re
import unittest
import uuid
from unittest import mock

import pytest
import yaml

from fundamentals.mysql import convert_dictionary_to_mysql_table, writequery
from fundamentals.mysql.sql_identifiers import quote_identifier

pytestmark = pytest.mark.usefixtures("session_names")
# INJECTED BY THE session_names FIXTURE IN THE ROOT conftest.py (PYTEST ONLY)
log = dbConn = None

RUN_ID = uuid.uuid4().hex[:8]
MODULE_NAME = "fundamentals.mysql.convert_dictionary_to_mysql_table"
# THE PACKAGE __INIT__ REBINDS THE NAME TO THE FUNCTION, HIDING THE SUBMODULE
CONVERT_MODULE = importlib.import_module(MODULE_NAME)
ADD_COLUMN_PATTERN = re.compile(r"^ALTER TABLE `[^`]*` ADD `([^`]*)` (.*)$", re.DOTALL)


def unique_table_name(label):
    """*return a table name for the label that no other test run on the shared database will use*"""
    return "dy2047_%s_%s" % (label, RUN_ID)


def drop_table(tableName):
    writequery(
        log=log,
        sqlQuery="DROP TABLE IF EXISTS " + quote_identifier(tableName),
        dbConn=dbConn,
    )


class statement_recorder(object):
    """*run the function against the database and keep every statement it writes*"""

    def __init__(self, tableName):
        self.tableName = tableName
        self.statements = []

    def run(self, dictionary, **kwargs):
        def record_and_write(log, sqlQuery, dbConn, **writeKwargs):
            self.statements.append(sqlQuery)
            return writequery(log=log, sqlQuery=sqlQuery, dbConn=dbConn, **writeKwargs)

        with mock.patch.object(
            CONVERT_MODULE, "writequery", side_effect=record_and_write
        ):
            return convert_dictionary_to_mysql_table(
                dbConn=dbConn,
                log=kwargs.pop("log", log),
                dictionary=dictionary,
                dbTableName=self.tableName,
                **kwargs,
            )

    def column_definitions(self):
        """*return the definition of every column added, keyed by column name*"""
        matches = [ADD_COLUMN_PATTERN.match(s.strip()) for s in self.statements]
        return {m.group(1): m.group(2) for m in matches if m}

    def unique_key_statements(self):
        """*return every statement that added a unique index to the table*"""
        return [s for s in self.statements if " ADD unique " in s]


class column_test_case(unittest.TestCase):
    tableSuffix = "table"

    def setUp(self):
        self.tableName = unique_table_name(self.tableSuffix)
        self.reset_table_and_recorder()

    def tearDown(self):
        drop_table(self.tableName)

    def reset_table_and_recorder(self):
        """*drop the table and start a new recorder, so a sub-test begins with no table*"""
        drop_table(self.tableName)
        self.recorder = statement_recorder(self.tableName)

    def definition(self, value, key="col", **kwargs):
        self.recorder.run({key: value, "another": "x"}, **kwargs)
        return self.recorder.column_definitions()[key]


class test_column_types(column_test_case):
    tableSuffix = "column_types"

    def test_datetime_string_becomes_datetime_column(self):
        # ARRANGE / ACT
        definition = self.definition("2020-01-02T03:04:05")

        # ASSERT
        self.assertEqual(definition, "datetime DEFAULT NULL")

    def test_datetime_string_matches_a_custom_compiled_pattern(self):
        # ARRANGE
        reDatetime = re.compile("^[0-9]{4}-[0-9]{2}-[0-9]{2} ")

        # ACT
        definition = self.definition("2020-01-02 03:04:05", reDatetime=reDatetime)

        # ASSERT
        self.assertEqual(definition, "datetime DEFAULT NULL")

    def test_named_feed_columns_are_varchar_100_whatever_their_length(self):
        # ARRANGE
        longText = "x" * 90

        # ACT / ASSERT
        for key in ["updated_parsed", "published_parsed", "feedName", "title"]:
            with self.subTest(key=key):
                self.reset_table_and_recorder()
                self.assertEqual(
                    self.definition(longText, key=key), "varchar(100) DEFAULT NULL"
                )

    def test_strings_under_80_characters_are_varchar_100(self):
        # ARRANGE / ACT / ASSERT
        for length in [1, 29, 30, 79]:
            with self.subTest(length=length):
                self.reset_table_and_recorder()
                self.assertEqual(
                    self.definition("x" * length), "varchar(100) DEFAULT NULL"
                )

    def test_strings_of_80_characters_or_more_get_length_from_value(self):
        # ARRANGE / ACT / ASSERT
        for length in [80, 200]:
            with self.subTest(length=length):
                self.reset_table_and_recorder()
                self.assertEqual(
                    self.definition("x" * length),
                    "varchar(%d) DEFAULT NULL" % (450 + length * 2,),
                )

    def test_integers_up_to_nine_in_size_are_tinyint(self):
        # ARRANGE / ACT / ASSERT
        for number in [0, 9, -9]:
            with self.subTest(number=number):
                self.reset_table_and_recorder()
                self.assertEqual(self.definition(number), "tinyint DEFAULT NULL")

    def test_integers_over_nine_in_size_are_int(self):
        # ARRANGE / ACT / ASSERT
        for number in [10, -10, 100000]:
            with self.subTest(number=number):
                self.reset_table_and_recorder()
                self.assertEqual(self.definition(number), "int DEFAULT NULL")

    def test_float_is_double(self):
        # ARRANGE / ACT
        definition = self.definition(1.5)

        # ASSERT
        self.assertEqual(definition, "double DEFAULT NULL")

    def test_boolean_is_tinyint(self):
        # ARRANGE / ACT
        definition = self.definition(True)

        # ASSERT
        self.assertEqual(definition, "tinyint DEFAULT NULL")

    def test_type_is_taken_from_first_item_of_a_list_value(self):
        # ARRANGE / ACT
        definition = self.definition([1.5, "a comment"])

        # ASSERT
        self.assertEqual(definition, "double DEFAULT NULL")

    def test_date_value_gets_no_column_and_is_left_out_of_the_insert(self):
        # ARRANGE
        dictionary = {"stamp": datetime.date(2020, 1, 2), "another": "x"}

        # ACT
        self.recorder.run(dictionary)

        # ASSERT
        self.assertNotIn("stamp", self.recorder.column_definitions())
        self.assertNotIn("`stamp`", self.recorder.statements[-1])
        self.assertIn("`another`", self.recorder.statements[-1])

    def test_key_changed_for_mysql_gets_original_keyword_comment(self):
        # ARRANGE / ACT
        self.recorder.run({"a key-name": "x"})

        # ASSERT
        self.assertEqual(
            self.recorder.column_definitions()["a_key_name"],
            "varchar(100) DEFAULT NULL COMMENT 'original keyword: a key-name'",
        )


class test_table_and_index_creation(column_test_case):
    tableSuffix = "creation"

    def test_creates_the_table_with_the_helper_columns_when_missing(self):
        # ARRANGE / ACT
        self.recorder.run({"a": "x"})

        # ASSERT
        createStatement = self.recorder.statements[0]
        self.assertIn(
            "CREATE TABLE IF NOT EXISTS `%s`" % (self.tableName,), createStatement
        )
        self.assertIn("`primaryId` bigint(20) NOT NULL AUTO_INCREMENT", createStatement)
        self.assertIn(
            "ENGINE=Innodb AUTO_INCREMENT=0 DEFAULT CHARSET=latin1", createStatement
        )

    def test_does_not_add_columns_that_already_exist(self):
        # ARRANGE
        self.recorder.run({"a": "x", "b": "y"})
        secondRun = statement_recorder(self.tableName)

        # ACT
        secondRun.run({"a": "x", "b": "y"})

        # ASSERT
        self.assertEqual(secondRun.column_definitions(), {})
        self.assertEqual(len(secondRun.statements), 1)
        self.assertTrue(secondRun.statements[0].startswith("INSERT INTO"))

    def test_skip_checks_still_runs_create_table_without_asking_if_it_exists(self):
        # ARRANGE
        self.recorder.run({"a": "x"})
        secondRun = statement_recorder(self.tableName)
        # ACT
        with mock.patch.object(
            CONVERT_MODULE.table_exists, "table_exists"
        ) as tableExists:
            secondRun.run({"a": "x"}, skipChecks=True)

        # ASSERT
        tableExists.assert_not_called()
        self.assertIn("CREATE TABLE IF NOT EXISTS", secondRun.statements[0])

    def test_adds_a_unique_key_named_from_the_lowercased_key_columns(self):
        # ARRANGE
        dictionary = {"A key": "x", "b": "y"}

        # ACT
        self.recorder.run(dictionary, uniqueKeyList=["A key", "b"])

        # ASSERT
        self.assertEqual(
            self.recorder.unique_key_statements(),
            ["ALTER TABLE `%s` ADD unique `a_key_b` (`A_key`,`b`)" % (self.tableName,)],
        )

    def test_does_not_add_a_unique_key_that_already_exists(self):
        # ARRANGE
        dictionary = {"uni": "x", "b": "y"}
        self.recorder.run(dictionary, uniqueKeyList=["uni"])
        secondRun = statement_recorder(self.tableName)

        # ACT
        secondRun.run(dictionary, uniqueKeyList=["uni"])

        # ASSERT
        self.assertEqual(secondRun.unique_key_statements(), [])

    def test_adds_no_unique_key_without_a_unique_key_list(self):
        # ARRANGE / ACT
        self.recorder.run({"a": "x"})

        # ASSERT
        self.assertEqual(self.recorder.unique_key_statements(), [])

    def test_returns_none_pair_after_writing_to_the_database(self):
        # ARRANGE / ACT
        result = self.recorder.run({"a": "x"})

        # ASSERT
        self.assertEqual(result, (None, None))

    def test_logs_each_column_creation(self):
        # ARRANGE
        mockLog = mock.MagicMock()

        # ACT
        self.recorder.run({"a key": "x"}, log=mockLog)

        # ASSERT
        mockLog.info.assert_any_call(
            "creating the a_key column in the %s table" % (self.tableName,)
        )

    def test_raises_with_table_name_when_insert_fails(self):
        # ARRANGE
        def fail_on_insert(log, sqlQuery, dbConn, **kwargs):
            if sqlQuery.startswith("INSERT"):
                raise RuntimeError("insert failed")
            return writequery(log=log, sqlQuery=sqlQuery, dbConn=dbConn, **kwargs)

        # ACT
        with mock.patch.object(
            CONVERT_MODULE, "writequery", side_effect=fail_on_insert
        ):
            with self.assertRaises(Exception) as context:
                convert_dictionary_to_mysql_table(
                    dbConn=dbConn,
                    log=log,
                    dictionary={"a": "x"},
                    dbTableName=self.tableName,
                )

        # ASSERT
        self.assertEqual(
            str(context.exception),
            "could not add new data added to the table '%s' : insert failed\n"
            % (self.tableName,),
        )
        self.assertIsInstance(context.exception.__cause__, RuntimeError)


class test_argument_checks(unittest.TestCase):

    def convert(self, **overrides):
        callKwargs = {
            "dbConn": dbConn,
            "log": log,
            "dictionary": {"a": "x"},
            "dbTableName": unique_table_name("checks"),
        }
        callKwargs.update(overrides)
        return convert_dictionary_to_mysql_table(**callKwargs)

    def test_raises_type_error_without_a_database_connection(self):
        # ARRANGE / ACT / ASSERT
        with self.assertRaisesRegex(TypeError, "valid MySQL DB connection"):
            self.convert(dbConn=False)

    def test_raises_type_error_when_dictionary_is_not_a_dict(self):
        # ARRANGE / ACT / ASSERT
        with self.assertRaisesRegex(TypeError, '"dictionary" argument is a dict'):
            self.convert(dictionary=[("a", "x")])

    def test_raises_type_error_when_unique_key_list_is_not_a_list(self):
        # ARRANGE / ACT / ASSERT
        with self.assertRaisesRegex(TypeError, '"uniqueKeyList" is a list'):
            self.convert(uniqueKeyList="a")

    def test_raises_value_error_when_unique_key_is_not_in_dictionary(self):
        # ARRANGE / ACT / ASSERT
        with self.assertRaisesRegex(ValueError, '"uniqueKeyList" are present'):
            self.convert(uniqueKeyList=["missing"])

    def test_raises_value_error_when_list_value_is_not_two_items_long(self):
        # ARRANGE / ACT / ASSERT
        with self.assertRaisesRegex(ValueError, "2 items in length"):
            self.convert(dictionary={"a": ["x"]})

    def test_raises_value_error_when_list_value_starts_with_unsupported_type(self):
        # ARRANGE / ACT / ASSERT
        with self.assertRaisesRegex(ValueError, "appropriate value"):
            self.convert(dictionary={"a": [{"nested": 1}, "comment"]})

    def test_raises_value_error_naming_key_and_type_for_unsupported_value(self):
        # ARRANGE / ACT / ASSERT
        with self.assertRaisesRegex(ValueError, "a is a <class 'dict'>"):
            self.convert(dictionary={"a": {"nested": 1}})

    def test_raises_type_error_when_create_helper_tables_is_not_a_bool(self):
        # ARRANGE / ACT / ASSERT
        with self.assertRaisesRegex(
            TypeError, '"createHelperTables" is a True or False'
        ):
            self.convert(createHelperTables="yes")

    def test_logs_critical_before_raising(self):
        # ARRANGE
        mockLog = mock.MagicMock()

        # ACT
        with self.assertRaises(TypeError):
            self.convert(dbConn=False, log=mockLog)

        # ASSERT
        mockLog.critical.assert_called_once_with(
            "Please use a valid MySQL DB connection."
        )

    def test_ignores_a_non_iterable_unique_key_list_when_returning_inserts(self):
        # ARRANGE / ACT
        _, valueTuple = self.convert(uniqueKeyList=5, returnInsertOnly=True)

        # ASSERT
        self.assertEqual(valueTuple, ("x",))

    def test_accepts_a_list_value_starting_with_none_or_a_date(self):
        # ARRANGE
        dictionary = {"a": [None, "comment"], "b": [datetime.date(2020, 1, 2), "c"]}

        # ACT
        _, valueTuple = self.convert(dictionary=dictionary, returnInsertOnly=True)

        # ASSERT
        self.assertEqual(valueTuple, ("2020-01-02",))


class test_insert_values(unittest.TestCase):

    def convert(self, dictionary, **kwargs):
        return convert_dictionary_to_mysql_table(
            log=log,
            dictionary=dictionary,
            dbTableName=unique_table_name("values"),
            returnInsertOnly=True,
            **kwargs,
        )

    def test_nested_list_value_is_dumped_to_yaml_text(self):
        # ARRANGE
        dictionary = {"a": [["x", "y"], "a comment"]}

        # ACT
        _, valueTuple = self.convert(dictionary)

        # ASSERT
        self.assertEqual(valueTuple, (yaml.dump(["x", "y"]).strip(),))

    def test_date_modified_adds_columns_with_updated_zero_when_inserting(self):
        # ARRANGE
        # ACT
        with mock.patch.object(
            CONVERT_MODULE.times,
            "get_now_sql_datetime",
            return_value="2020-01-02T03:04:05",
        ):
            insertCommand, valueTuple = self.convert({"a": "x"}, dateModified=True)

        # ASSERT
        self.assertEqual(valueTuple, ("x", "2020-01-02T03:04:05", 0))
        self.assertIn("(`a`,`dateLastModified`,`updated`, dateCreated)", insertCommand)

    def test_date_modified_sets_updated_one_when_replacing(self):
        # ARRANGE
        # ACT
        with mock.patch.object(
            CONVERT_MODULE.times,
            "get_now_sql_datetime",
            return_value="2020-01-02T03:04:05",
        ):
            insertCommand, valueTuple = self.convert(
                {"a": "x"}, dateModified=True, replace=True
            )

        # ASSERT
        self.assertEqual(valueTuple, ("x", "2020-01-02T03:04:05", 1))
        self.assertTrue(insertCommand.startswith("INSERT IGNORE INTO"))

    def test_only_the_first_item_of_a_list_value_is_stripped_of_whitespace(self):
        # ARRANGE / ACT
        _, valueTuple = self.convert({"a": "  x  ", "b": ["  y ", "c"]})

        # ASSERT
        self.assertEqual(valueTuple, ("  x  ", "y"))

    def test_conversion_noise_is_removed_from_literal_insert_values(self):
        # ARRANGE / ACT
        insertCommand = self.convert({"a": "x!!python/unicode: y"}, batchInserts=False)

        # ASSERT
        self.assertIn("VALUES ('x y', NOW())", insertCommand)
