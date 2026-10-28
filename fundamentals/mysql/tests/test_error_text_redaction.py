import importlib
import logging
from unittest import mock

import pymysql
import pytest

from fundamentals.mysql import (
    convert_dictionary_to_mysql_table,
    readquery,
    writequery,
)
from fundamentals.mysql._log_safety import describe_error

# THE PACKAGE __INIT__ REBINDS THE NAMES TO THE FUNCTIONS, HIDING THE SUBMODULES
CONVERT_MODULE = importlib.import_module(
    "fundamentals.mysql.convert_dictionary_to_mysql_table"
)
INSERT_MODULE = importlib.import_module(
    "fundamentals.mysql.insert_list_of_dictionaries_into_database_tables"
)

SECRET = "hunter2-secret-value"
BAD_TABLE_NAME = "tbl\nFORGED log line"


def duplicate_entry_error():
    return pymysql.err.IntegrityError(
        1062, "Duplicate entry '%s' for key 'PRIMARY'" % SECRET
    )


def syntax_error():
    return pymysql.err.ProgrammingError(
        1064, "You have an error in your SQL syntax near '%s' at line 1" % SECRET
    )


def missing_table_error():
    return pymysql.err.OperationalError(1146, "Table '%s' doesn't exist" % SECRET)


def truncated_error():
    return ValueError("Data truncated for column 'a' at row '%s'" % SECRET)


def generic_duplicate_error():
    return RuntimeError("Duplicate entry '%s' for key" % SECRET)


def generic_error():
    return RuntimeError("boom %s" % SECRET)


def mysql_warning():
    return pymysql.err.Warning("Incorrect string value '%s'" % SECRET)


def table_exists_error():
    return pymysql.err.OperationalError(1050, "Table '%s' already exists" % SECRET)


def index_exists_error():
    return pymysql.err.OperationalError(1061, "Duplicate key name '%s'" % SECRET)


ALL_ERRORS = [
    duplicate_entry_error,
    syntax_error,
    missing_table_error,
    truncated_error,
    generic_duplicate_error,
    generic_error,
    mysql_warning,
    table_exists_error,
    index_exists_error,
]


class Connection(object):
    """*a stand-in database connection, named so the argument checks accept it*"""

    def commit(self):
        pass


class FakeCursor(object):
    def __init__(self, executeError=None, closeError=None):
        self.executeError = executeError
        self.closeError = closeError

    def execute(self, sqlQuery):
        if self.executeError:
            raise self.executeError

    def executemany(self, sqlQuery, valueList):
        if self.executeError:
            raise self.executeError

    def fetchall(self):
        return []

    def close(self):
        if self.closeError:
            raise self.closeError


class FakeConnection(object):
    def __init__(self, cursor=None, cursorError=None):
        self.theCursor = cursor
        self.cursorError = cursorError

    def cursor(self, cursorClass=None):
        if self.cursorError:
            raise self.cursorError
        return self.theCursor

    def commit(self):
        pass


@pytest.fixture
def testLog(caplog):
    caplog.set_level(logging.DEBUG)
    return logging.getLogger("test_error_text_redaction")


def logged_text(caplog):
    return "\n".join(record.getMessage() for record in caplog.records)


class TestDescribeError:
    def test_gives_the_class_name_and_mysql_error_code(self):
        assert (
            describe_error(duplicate_entry_error())
            == "IntegrityError (MySQL error 1062)"
        )

    def test_gives_only_the_class_name_when_there_is_no_integer_code(self):
        assert describe_error(RuntimeError("boom")) == "RuntimeError"

    @pytest.mark.parametrize(
        "error",
        [
            KeyError(987654321),
            OSError(2, "No such file"),
            RuntimeError(1062),
            RuntimeError(True, "x"),
            RuntimeError(1062, 5),
            RuntimeError(),
        ],
    )
    def test_gives_only_the_class_name_when_the_error_is_not_in_the_pymysql_shape(
        self, error
    ):
        assert describe_error(error) == type(error).__name__

    def test_never_includes_the_error_message(self):
        assert SECRET not in describe_error(syntax_error())
        assert SECRET not in describe_error(generic_error())


class TestWriteQueryErrorText:
    @pytest.mark.parametrize("makeError", ALL_ERRORS)
    def test_logs_no_error_text_when_the_error_is_forced_past(
        self, makeError, testLog, caplog, capsys
    ):
        connection = FakeConnection(FakeCursor(executeError=makeError()))

        writequery(log=testLog, sqlQuery="SELECT 1", dbConn=connection, Force=True)

        assert SECRET not in logged_text(caplog)
        assert SECRET not in capsys.readouterr().out

    @pytest.mark.parametrize(
        "makeError", [syntax_error, missing_table_error, generic_error]
    )
    def test_logs_no_error_text_when_the_error_is_raised(
        self, makeError, testLog, caplog
    ):
        connection = FakeConnection(FakeCursor(executeError=makeError()))

        with pytest.raises(Exception):
            writequery(log=testLog, sqlQuery="SELECT 1", dbConn=connection)

        assert SECRET not in logged_text(caplog)

    def test_logs_the_error_class_and_code_with_the_redacted_query(
        self, testLog, caplog
    ):
        connection = FakeConnection(FakeCursor(executeError=syntax_error()))

        with pytest.raises(pymysql.err.ProgrammingError):
            writequery(log=testLog, sqlQuery="SELECT 'x'", dbConn=connection)

        text = logged_text(caplog)
        assert "ProgrammingError (MySQL error 1064)" in text
        assert "SELECT ?" in text

    def test_logs_no_error_text_when_the_cursor_fails_to_close(self, testLog, caplog):
        cursor = FakeCursor(closeError=RuntimeError("close " + SECRET))

        writequery(log=testLog, sqlQuery="SELECT 1", dbConn=FakeConnection(cursor))

        assert SECRET not in logged_text(caplog)
        assert "RuntimeError" in logged_text(caplog)

    def test_logs_no_secret_table_name_from_a_debug_log_with_a_newline_in_backticks(
        self, testLog, caplog
    ):
        sqlQuery = "SELECT * FROM `%s`" % BAD_TABLE_NAME
        connection = FakeConnection(FakeCursor())

        writequery(log=testLog, sqlQuery=sqlQuery, dbConn=connection)

        text = logged_text(caplog)
        assert "\nFORGED" not in text
        assert "tbl\\nFORGED log line" in text


class TestReadQueryRedaction:
    def test_does_not_log_literal_values_at_debug_level(self, testLog, caplog):
        sqlQuery = "SELECT * FROM `t` WHERE a = '%s'" % SECRET

        readquery(log=testLog, sqlQuery=sqlQuery, dbConn=FakeConnection(FakeCursor()))

        text = logged_text(caplog)
        assert SECRET not in text
        assert "SELECT * FROM `t` WHERE a = ?" in text

    @pytest.mark.parametrize("quiet", [True, False])
    def test_logs_no_literal_values_or_error_text_when_the_query_fails(
        self, quiet, testLog, caplog
    ):
        sqlQuery = "SELECT * FROM `t` WHERE a = '%s'" % SECRET
        connection = FakeConnection(FakeCursor(executeError=syntax_error()))

        if quiet:
            readquery(log=testLog, sqlQuery=sqlQuery, dbConn=connection, quiet=True)
        else:
            with pytest.raises(pymysql.err.ProgrammingError):
                readquery(log=testLog, sqlQuery=sqlQuery, dbConn=connection)

        text = logged_text(caplog)
        assert SECRET not in text
        assert "ProgrammingError (MySQL error 1064)" in text

    def test_redacts_before_cutting_a_long_query_short(self, testLog, caplog):
        sqlQuery = "SELECT '" + SECRET * 200 + "'"
        connection = FakeConnection(FakeCursor(executeError=syntax_error()))

        readquery(log=testLog, sqlQuery=sqlQuery, dbConn=connection, quiet=True)

        assert SECRET not in logged_text(caplog)

    def test_logs_no_error_text_when_the_cursor_cannot_be_created(
        self, testLog, caplog
    ):
        connection = FakeConnection(cursorError=RuntimeError("no cursor " + SECRET))

        with pytest.raises(IOError) as excInfo:
            readquery(log=testLog, sqlQuery="SELECT 1", dbConn=connection)

        assert SECRET not in logged_text(caplog)
        assert SECRET not in str(excInfo.value)

    def test_logs_no_error_text_when_the_cursor_fails_to_close(self, testLog, caplog):
        cursor = FakeCursor(closeError=RuntimeError("close " + SECRET))

        readquery(log=testLog, sqlQuery="SELECT 1", dbConn=FakeConnection(cursor))

        assert SECRET not in logged_text(caplog)


class TestConvertErrorText:
    def run_with(self, log, readArgs=None, writeArgs=None):
        with mock.patch.object(CONVERT_MODULE, "table_exists") as tableExists:
            tableExists.table_exists.return_value = True
            with mock.patch.object(CONVERT_MODULE, "writequery", **(writeArgs or {})):
                with mock.patch.object(CONVERT_MODULE, "readquery", **(readArgs or {})):
                    convert_dictionary_to_mysql_table(
                        dbConn=Connection(),
                        log=log,
                        dictionary={"a": "x"},
                        dbTableName="a_table",
                    )

    def test_logs_no_error_text_when_the_column_check_fails(
        self, testLog, caplog, capsys
    ):
        with pytest.raises(pymysql.err.ProgrammingError):
            self.run_with(testLog, readArgs={"side_effect": syntax_error()})

        assert SECRET not in logged_text(caplog)
        assert SECRET not in capsys.readouterr().out
        assert "ProgrammingError (MySQL error 1064)" in logged_text(caplog)

    def test_logs_no_error_text_when_a_column_cannot_be_created(self, testLog, caplog):
        with pytest.raises(pymysql.err.IntegrityError):
            self.run_with(
                testLog,
                readArgs={"return_value": []},
                writeArgs={"side_effect": duplicate_entry_error()},
            )

        assert SECRET not in logged_text(caplog)
        assert "IntegrityError (MySQL error 1062)" in logged_text(caplog)

    def test_leaves_no_error_text_in_the_log_stdout_or_exception_when_the_insert_fails(
        self, testLog, caplog, capsys
    ):
        def fail_on_insert(log, sqlQuery, dbConn, **kwargs):
            if sqlQuery.startswith("INSERT"):
                raise duplicate_entry_error()

        with pytest.raises(CONVERT_MODULE.insert_error) as excInfo:
            self.run_with(
                testLog,
                readArgs={"return_value": [{"x": 1}]},
                writeArgs={"side_effect": fail_on_insert},
            )

        assert SECRET not in str(excInfo.value)
        assert SECRET not in logged_text(caplog)
        assert SECRET not in capsys.readouterr().out
        assert "IntegrityError (MySQL error 1062)" in str(excInfo.value)
        assert isinstance(excInfo.value.__cause__, pymysql.err.IntegrityError)


class TestScalarValueCheck:
    def test_escapes_the_key_in_the_error_message_and_the_log(self, testLog, caplog):
        with pytest.raises(ValueError) as excInfo:
            convert_dictionary_to_mysql_table(
                dbConn=Connection(),
                log=testLog,
                dictionary={"bad\nFORGED": {"nested": SECRET}},
                dbTableName="a_table",
            )

        assert "\nFORGED" not in str(excInfo.value)
        assert "bad\\nFORGED" in str(excInfo.value)
        assert "\nFORGED" not in logged_text(caplog)
        assert SECRET not in str(excInfo.value) + logged_text(caplog)


class TestGetColumnNamesErrorLogging:
    def test_logs_the_escaped_table_name_and_no_error_text(self, testLog, caplog):
        from fundamentals.mysql import get_database_table_column_names

        connection = FakeConnection(FakeCursor(executeError=syntax_error()))

        result = get_database_table_column_names(
            dbConn=connection, log=testLog, dbTable="tbl\nFORGED\x1b[31m"
        )

        text = logged_text(caplog)
        assert result == -1
        assert SECRET not in text
        assert "\nFORGED" not in text
        assert "\x1b" not in text
        assert "tbl\\nFORGED\\x1b[31m" in text
        assert "ProgrammingError (MySQL error 1064)" in text


class TestRetryLogging:
    def test_logs_the_error_class_and_code_not_the_error_text(self, testLog, caplog):
        from fundamentals.mysql._retry import run_with_retries

        deadlock = pymysql.err.OperationalError(1213, "deadlock near '%s'" % SECRET)
        operation = mock.Mock(side_effect=[deadlock, "rows"])

        with mock.patch("time.sleep"):
            run_with_retries(testLog, operation)

        text = logged_text(caplog)
        assert SECRET not in text
        assert "OperationalError (MySQL error 1213)" in text


class TestInsertListErrorLogging:
    def test_logs_no_error_text_when_the_autocommit_restore_fails(
        self, testLog, caplog
    ):
        connection = mock.Mock()
        connection.autocommit.side_effect = syntax_error()

        INSERT_MODULE._restore_autocommit(
            connection, True, testLog, isErrorInFlight=True
        )

        text = logged_text(caplog)
        assert SECRET not in text
        assert "ProgrammingError (MySQL error 1064)" in text

    def test_escapes_the_table_name_in_a_failed_batch_log_and_exception(
        self, testLog, caplog
    ):
        with (
            mock.patch.object(INSERT_MODULE, "sharedList", [([{"a": 1}], 1)]),
            mock.patch.object(INSERT_MODULE, "totalCount", 1),
            mock.patch.object(INSERT_MODULE, "globalDbConn", mock.Mock()),
            mock.patch.object(
                INSERT_MODULE, "writequery", return_value="insert failed"
            ),
        ):
            with pytest.raises(RuntimeError) as excInfo:
                INSERT_MODULE._insert_single_batch_into_database(
                    batchIndex=0,
                    log=testLog,
                    dbTableName=BAD_TABLE_NAME,
                    uniqueKeyList=[],
                    dateModified=False,
                    replace=False,
                    batchSize=2500,
                    reDatetime=False,
                    dateCreated=True,
                )

        assert "\nFORGED" not in str(excInfo.value)
        assert "\nFORGED" not in logged_text(caplog)
        assert "tbl\\nFORGED log line" in str(excInfo.value)


class TestInsertListProgressMessages:
    def run_insert(self, log, tableName):
        connection = mock.Mock()
        connection.get_autocommit.return_value = True
        with (
            mock.patch.object(INSERT_MODULE, "convert_dictionary_to_mysql_table"),
            mock.patch.object(INSERT_MODULE, "fmultiprocess"),
        ):
            INSERT_MODULE.insert_list_of_dictionaries_into_database_tables(
                dbConn=connection,
                log=log,
                dictList=[{"a": 1}, {"a": 2}, {"a": 3}],
                dbTableName=tableName,
            )

    def test_writes_no_table_name_to_stdout(self, testLog, capsys):
        self.run_insert(testLog, BAD_TABLE_NAME)

        assert capsys.readouterr().out == ""

    def test_logs_the_escaped_table_name(self, testLog, caplog):
        self.run_insert(testLog, BAD_TABLE_NAME)

        text = logged_text(caplog)
        assert "\nFORGED" not in text
        assert "tbl\\nFORGED log line" in text
