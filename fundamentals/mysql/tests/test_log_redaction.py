import importlib
import logging
import re
from unittest import mock

import pymysql
import pytest

from fundamentals.mysql import convert_dictionary_to_mysql_table, writequery
from fundamentals.mysql._log_safety import escape_for_log, redact_sql_literals
from fundamentals.mysql.sql_identifiers import (
    MYSQL_MAX_IDENTIFIER_LENGTH,
    cap_identifier,
)

# THE PACKAGE __INIT__ REBINDS THE NAME TO THE FUNCTION, HIDING THE SUBMODULE
CONVERT_MODULE = importlib.import_module(
    "fundamentals.mysql.convert_dictionary_to_mysql_table"
)

SECRET = "hunter2-secret-value"
BAD_TABLE_NAME = "tbl\nERROR forged log line"


class Connection(object):
    """*a stand-in database connection, named so the argument checks accept it*"""

    def commit(self):
        pass


class FakeCursor(object):
    """*a cursor that raises the given error on execute*"""

    def __init__(self, executeError=None):
        self.executeError = executeError

    def execute(self, sqlQuery):
        if self.executeError:
            raise self.executeError

    def executemany(self, sqlQuery, valueList):
        if self.executeError:
            raise self.executeError

    def close(self):
        pass


class FakeConnection(object):
    def __init__(self, cursor):
        self.theCursor = cursor

    def cursor(self, cursorClass=None):
        return self.theCursor

    def commit(self):
        pass


@pytest.fixture
def testLog(caplog):
    caplog.set_level(logging.DEBUG)
    return logging.getLogger("test_log_redaction")


def logged_text(caplog):
    return "\n".join(record.getMessage() for record in caplog.records)


def convert_with_fakes(log, tableName="a_table", **kwargs):
    """*run the conversion against stand-in database helpers, return the statements written*"""
    statements = []

    def record_write(log, sqlQuery, dbConn, **writeKwargs):
        statements.append(sqlQuery)

    callKwargs = {
        "dbConn": Connection(),
        "log": log,
        "dictionary": {"a": "x"},
        "dbTableName": tableName,
    }
    callKwargs.update(kwargs)
    with mock.patch.object(CONVERT_MODULE, "writequery", side_effect=record_write):
        with mock.patch.object(CONVERT_MODULE, "table_exists") as tableExists:
            tableExists.table_exists.return_value = True
            with mock.patch.object(
                CONVERT_MODULE, "readquery", return_value=[{"COUNT(*)": 1}]
            ):
                convert_dictionary_to_mysql_table(**callKwargs)
    return statements


class TestEscapeForLog:
    def test_leaves_an_ordinary_name_unchanged(self):
        assert escape_for_log("my_table") == "my_table"

    def test_keeps_non_ascii_characters(self):
        assert escape_for_log("tablé") == "tablé"

    def test_escapes_newlines_and_other_control_characters(self):
        assert escape_for_log("a\nb\r\x1b[31m") == "a\\nb\\r\\x1b[31m"

    def test_accepts_a_name_that_is_not_a_string(self):
        assert escape_for_log(5) == "5"


class TestRedactSqlLiterals:
    def test_replaces_string_and_number_literals(self):
        sql = "INSERT INTO `t` (`a`,`b`) VALUES ('%s', 42)" % SECRET

        assert redact_sql_literals(sql) == "INSERT INTO `t` (`a`,`b`) VALUES (?, ?)"

    def test_keeps_digits_inside_identifiers(self):
        sql = "SELECT `col1` FROM `t2` WHERE col3 = 7"

        assert redact_sql_literals(sql) == "SELECT `col1` FROM `t2` WHERE col3 = ?"

    def test_keeps_unquoted_identifiers_containing_a_dollar_sign(self):
        sql = "SELECT col$1, $tbl2 FROM db$2.t"

        assert redact_sql_literals(sql) == sql

    def test_replaces_a_literal_with_doubled_quotes(self):
        sql = "VALUES ('a''%s', \"b\"\"c\")" % SECRET

        assert redact_sql_literals(sql) == "VALUES (?, ?)"

    def test_replaces_a_literal_with_a_backslash_escape_that_is_not_a_quote(self):
        sql = "VALUES ('a\\n%s', 'x')" % SECRET

        assert redact_sql_literals(sql) == "VALUES (?, ?)"

    def test_replaces_a_literal_with_an_escaped_backslash_before_the_closing_quote(
        self,
    ):
        sql = "VALUES ('%s\\\\', 'x')" % SECRET

        assert redact_sql_literals(sql) == "VALUES (?, ?)"

    def test_redacts_to_the_end_when_a_backslash_escapes_a_quote(self):
        sql = "VALUES ('it\\'s %s', 'other')" % SECRET

        result = redact_sql_literals(sql)

        assert SECRET not in result
        assert "other" not in result
        assert result == "VALUES (?"

    def test_does_not_expose_a_value_after_a_backslash_when_backslash_escapes_are_off(
        self,
    ):
        sql = "VALUES ('abc\\', '%s')" % SECRET

        assert SECRET not in redact_sql_literals(sql)

    def test_redacts_an_unterminated_literal_ending_in_a_lone_backslash(self):
        sql = "VALUES ('%s\\" % SECRET

        assert redact_sql_literals(sql) == "VALUES (?"

    def test_redacts_an_unterminated_literal_to_the_end(self):
        sql = "VALUES ('%s" % SECRET

        assert redact_sql_literals(sql) == "VALUES (?"

    @pytest.mark.parametrize(
        "literal",
        [
            "X'ABCDEF'",
            "x'ABCDEF'",
            "0xDEADBEEF",
            "0Xdeadbeef",
            "b'101'",
            "B'101'",
            "0b101",
            "0B101",
            "1",
            "3.14",
            ".5",
            "1e10",
            "2.5E-3",
        ],
    )
    def test_replaces_hex_binary_and_numeric_literals(self, literal):
        assert redact_sql_literals("SELECT %s, 'x'" % literal) == "SELECT ?, ?"

    def test_keeps_the_minus_sign_of_a_negative_number(self):
        assert redact_sql_literals("SELECT -12") == "SELECT -?"

    def test_replaces_an_unterminated_hex_literal_to_the_end(self):
        assert redact_sql_literals("SELECT X'%s" % SECRET) == "SELECT ?"

    @pytest.mark.parametrize(
        "sql, expected",
        [
            ("SELECT 1 -- %s\nFROM t" % SECRET, "SELECT ? -- ?\nFROM t"),
            ("SELECT 1 # %s\nFROM t" % SECRET, "SELECT ? # ?\nFROM t"),
            ("SELECT /* %s */ 1" % SECRET, "SELECT /*?*/ ?"),
            ("SELECT 1 /* %s" % SECRET, "SELECT ? /*?"),
            ("SELECT 1 -- %s" % SECRET, "SELECT ? -- ?"),
        ],
    )
    def test_replaces_the_body_of_a_comment(self, sql, expected):
        assert redact_sql_literals(sql) == expected

    def test_escapes_a_newline_inside_a_quoted_identifier(self):
        sql = "SELECT * FROM `t\nFAKE LOG LINE`"

        assert redact_sql_literals(sql) == "SELECT * FROM `t\\nFAKE LOG LINE`"

    def test_keeps_a_doubled_backtick_inside_a_quoted_identifier(self):
        sql = "SELECT * FROM `a``b2`"

        assert redact_sql_literals(sql) == sql

    def test_redacts_to_the_end_after_an_unterminated_quoted_identifier(self):
        sql = "SELECT * FROM `abc'%s'" % SECRET

        assert SECRET not in redact_sql_literals(sql)

    def test_leaves_the_statement_placeholders_alone(self):
        sql = "INSERT INTO `t` (`a`) VALUES (%s)"

        assert redact_sql_literals(sql) == sql


class TestCapIdentifier:
    def test_returns_a_short_name_unchanged(self):
        assert cap_identifier("short_name") == "short_name"

    def test_returns_a_name_of_exactly_the_limit_unchanged(self):
        name = "a" * MYSQL_MAX_IDENTIFIER_LENGTH

        assert cap_identifier(name) == name

    def test_shortens_a_long_name_to_the_limit(self):
        result = cap_identifier("column_" * 40)

        assert len(result) == MYSQL_MAX_IDENTIFIER_LENGTH

    def test_gives_the_same_result_for_the_same_name(self):
        name = "column_" * 40

        assert cap_identifier(name) == cap_identifier(name)

    def test_gives_different_results_for_long_names_sharing_a_prefix(self):
        prefix = "a" * 70

        assert cap_identifier(prefix + "_one") != cap_identifier(prefix + "_two")

    def test_keeps_a_readable_prefix_of_the_original_name(self):
        result = cap_identifier("start_" + "x" * 100)

        assert result.startswith("start_xxx")

    def test_gives_different_results_for_the_names_that_collided_with_a_short_hash(
        self,
    ):
        assert cap_identifier("a" * 60 + "83296") != cap_identifier("a" * 60 + "170707")

    def test_ends_a_capped_name_with_sixteen_hex_characters(self):
        result = cap_identifier("a" * 100)

        assert re.fullmatch(r"a+_[0-9a-f]{16}", result)

    def test_raises_type_error_for_a_name_that_is_not_a_string(self):
        with pytest.raises(TypeError):
            cap_identifier(5)

    def test_raises_value_error_when_the_limit_is_too_small_for_a_hash(self):
        with pytest.raises(ValueError):
            cap_identifier("a" * 100, maxLength=17)

    def test_caps_to_the_smallest_limit_that_fits_a_prefix_and_hash(self):
        assert len(cap_identifier("a" * 100, maxLength=18)) == 18


class TestArgumentCheckLogging:
    def test_logs_the_key_and_type_not_the_value_of_a_bad_list_value(
        self, testLog, caplog
    ):
        dictionary = {"mykey": [{"nested": SECRET}, "comment"]}

        with pytest.raises(ValueError):
            convert_with_fakes(testLog, dictionary=dictionary)

        text = logged_text(caplog)
        assert SECRET not in text
        assert "mykey" in text
        assert "dict" in text

    def test_logs_the_key_and_type_not_the_value_of_a_bad_scalar_value(
        self, testLog, caplog
    ):
        dictionary = {"mykey": {"nested": SECRET}}

        with pytest.raises(ValueError):
            convert_with_fakes(testLog, dictionary=dictionary)

        text = logged_text(caplog)
        assert SECRET not in text
        assert "mykey" in text
        assert "dict" in text

    def test_logs_the_key_not_the_value_of_a_list_of_the_wrong_length(
        self, testLog, caplog
    ):
        dictionary = {"mykey": [SECRET, "comment", "extra"]}

        with pytest.raises(ValueError):
            convert_with_fakes(testLog, dictionary=dictionary)

        text = logged_text(caplog)
        assert SECRET not in text
        assert "mykey" in text

    def test_escapes_a_key_containing_a_newline(self, testLog, caplog):
        dictionary = {"bad\nkey": {"nested": 1}}

        with pytest.raises(ValueError):
            convert_with_fakes(testLog, dictionary=dictionary)

        critical = [r for r in caplog.records if r.levelno == logging.CRITICAL]
        assert "bad\\nkey" in critical[0].getMessage()
        assert "\n" not in critical[0].getMessage().split(": in ", 1)[1]


class TestTableNameLogging:
    def test_escapes_the_table_name_in_the_column_creation_logs(self, testLog, caplog):
        def fail_to_write(log, sqlQuery, dbConn, **kwargs):
            raise RuntimeError("cannot alter")

        with mock.patch.object(CONVERT_MODULE, "writequery", side_effect=fail_to_write):
            with mock.patch.object(CONVERT_MODULE, "table_exists") as tableExists:
                tableExists.table_exists.return_value = True
                with mock.patch.object(CONVERT_MODULE, "readquery", return_value=[]):
                    with pytest.raises(RuntimeError):
                        convert_dictionary_to_mysql_table(
                            dbConn=Connection(),
                            log=testLog,
                            dictionary={"a": "x"},
                            dbTableName=BAD_TABLE_NAME,
                        )

        errorMessages = [
            r.getMessage() for r in caplog.records if r.levelno >= logging.INFO
        ]
        assert len(errorMessages) == 2
        assert all("\n" not in message.rstrip("\n") for message in errorMessages)
        assert all("tbl\\nERROR forged log line" in m for m in errorMessages)


class TestInsertFailure:
    def run_failing_insert(self, log, tableName):
        def fail_on_insert(log, sqlQuery, dbConn, **kwargs):
            if sqlQuery.startswith("INSERT"):
                raise RuntimeError("insert failed")

        with mock.patch.object(
            CONVERT_MODULE, "writequery", side_effect=fail_on_insert
        ):
            with mock.patch.object(CONVERT_MODULE, "table_exists") as tableExists:
                tableExists.table_exists.return_value = True
                with mock.patch.object(
                    CONVERT_MODULE, "readquery", return_value=[{"x": 1}]
                ):
                    convert_dictionary_to_mysql_table(
                        dbConn=Connection(),
                        log=log,
                        dictionary={"a": "x"},
                        dbTableName=tableName,
                    )

    def test_raises_a_specific_exception_type_with_the_cause(self, testLog):
        with pytest.raises(CONVERT_MODULE.insert_error) as excInfo:
            self.run_failing_insert(testLog, "a_table")

        assert isinstance(excInfo.value, Exception)
        assert isinstance(excInfo.value.__cause__, RuntimeError)

    def test_does_not_write_the_error_to_stdout(self, testLog, capsys):
        with pytest.raises(CONVERT_MODULE.insert_error):
            self.run_failing_insert(testLog, "a_table")

        assert capsys.readouterr().out == ""

    def test_escapes_the_table_name_in_the_log_and_the_exception(self, testLog, caplog):
        with pytest.raises(CONVERT_MODULE.insert_error) as excInfo:
            self.run_failing_insert(testLog, BAD_TABLE_NAME)

        assert "\nERROR forged" not in str(excInfo.value)
        assert "tbl\\nERROR forged log line" in str(excInfo.value)
        assert "\nERROR forged" not in logged_text(caplog)


class TestUniqueKeyIndexName:
    def test_looks_up_and_creates_the_index_under_the_same_capped_name(self):
        columns = ["a_rather_long_column_name_%d" % i for i in range(6)]
        dictionary = {column: "x" for column in columns}
        lookups = []
        statements = []

        def record_lookup(log, sqlQuery, dbConn, **kwargs):
            lookups.append(sqlQuery)
            return [{"COUNT(*)": 0}]

        def record_write(log, sqlQuery, dbConn, **kwargs):
            statements.append(sqlQuery)

        with mock.patch.object(CONVERT_MODULE, "writequery", side_effect=record_write):
            with mock.patch.object(CONVERT_MODULE, "table_exists") as tableExists:
                tableExists.table_exists.return_value = True
                with mock.patch.object(
                    CONVERT_MODULE, "readquery", side_effect=record_lookup
                ):
                    convert_dictionary_to_mysql_table(
                        dbConn=Connection(),
                        log=logging.getLogger("unused"),
                        dictionary=dictionary,
                        dbTableName="a_table",
                        uniqueKeyList=columns,
                    )

        expectedName = cap_identifier("_".join(columns))
        assert len(expectedName) == MYSQL_MAX_IDENTIFIER_LENGTH
        assert "INDEX_NAME = '%s'" % expectedName in lookups[-1]
        addUniqueKey = [s for s in statements if " ADD unique " in s]
        assert " ADD unique `%s` (" % expectedName in addUniqueKey[0]


class TestWriteQueryLogging:
    def run_write(self, log, error, **kwargs):
        sqlQuery = "INSERT INTO `t` (`a`) VALUES ('%s')" % SECRET
        connection = FakeConnection(FakeCursor(executeError=error))
        return writequery(log=log, sqlQuery=sqlQuery, dbConn=connection, **kwargs)

    def test_does_not_log_literal_values_at_debug_level(self, testLog, caplog):
        self.run_write(testLog, None)

        text = logged_text(caplog)
        assert SECRET not in text
        assert "INSERT INTO `t` (`a`) VALUES (?)" in text

    def test_does_not_log_literal_values_when_a_programming_error_is_raised(
        self, testLog, caplog
    ):
        error = pymysql.err.ProgrammingError(1064, "syntax")

        with pytest.raises(pymysql.err.ProgrammingError):
            self.run_write(testLog, error)

        text = logged_text(caplog)
        assert SECRET not in text
        assert "MySQL write command not executed" in text

    def test_does_not_log_literal_values_when_a_programming_error_is_forced_past(
        self, testLog, caplog
    ):
        error = pymysql.err.ProgrammingError(1064, "syntax")

        self.run_write(testLog, error, Force=True)

        assert SECRET not in logged_text(caplog)

    def test_does_not_log_literal_values_for_another_mysql_error(self, testLog, caplog):
        error = pymysql.err.OperationalError(1146, "no such table")

        with pytest.raises(pymysql.err.OperationalError):
            self.run_write(testLog, error)

        assert SECRET not in logged_text(caplog)

    def test_does_not_log_literal_values_for_a_generic_error(self, testLog, caplog):
        with pytest.raises(ValueError):
            self.run_write(testLog, ValueError("boom"))

        assert SECRET not in logged_text(caplog)

    def test_does_not_log_the_value_list_when_data_is_truncated(self, testLog, caplog):
        error = ValueError("Data truncated for column 'a'")

        self.run_write(
            testLog,
            error,
            manyValueList=[(SECRET,)],
        )

        text = logged_text(caplog)
        assert SECRET not in text
        assert "INSERT INTO `t` (`a`) VALUES (?)" in text
