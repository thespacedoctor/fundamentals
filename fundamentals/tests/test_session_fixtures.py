import json
import logging
import os
import shutil
import subprocess
import sys
import textwrap

import pymysql
import pytest
import yaml

import fundamentals

PROJECT_ROOT = os.path.dirname(os.path.dirname(fundamentals.__file__))

COPIED_FILES = ("conftest.py", "pytest.ini")
COPY_IGNORE = shutil.ignore_patterns("output", "__pycache__", "*.pyc")
SUBPROCESS_TIMEOUT_SECONDS = 300
DATABASE_CONNECT_TIMEOUT_SECONDS = 3

IMPORT_ALL_TEST_MODULES = textwrap.dedent("""
    import glob
    import importlib.util
    import json
    import os
    from unittest import mock

    import fundamentals

    root = os.getcwd()
    paths = sorted(glob.glob(os.path.join(root, "fundamentals", "**", "tests", "test_*.py"), recursive=True))

    with mock.patch("pymysql.connect") as connect:
        for index, path in enumerate(paths):
            spec = importlib.util.spec_from_file_location("guard_module_%d" % index, path)
            spec.loader.exec_module(importlib.util.module_from_spec(spec))

    print(json.dumps({"imported": len(paths), "connections": connect.call_count, "package": fundamentals.__file__}))
    """)

CONNECTION_PROBE = textwrap.dedent("""
    import pytest

    pytestmark = pytest.mark.usefixtures("session_names")
    dbConn = None


    # THESE TWO TESTS RELY ON PYTEST RUNNING THEM IN FILE ORDER
    def test_a_leaves_an_open_transaction_in_manual_commit_mode():
        dbConn.autocommit(False)
        cursor = dbConn.cursor()
        cursor.execute("CREATE TEMPORARY TABLE probe_rows (a INT) ENGINE=InnoDB")
        cursor.execute("INSERT INTO probe_rows VALUES (1)")
        cursor.close()


    def test_b_finds_the_connection_reset():
        cursor = dbConn.cursor()
        cursor.execute("SELECT COUNT(*) FROM probe_rows")
        rowCount = cursor.fetchone()[0]
        cursor.close()
        assert rowCount == 0
        assert dbConn.get_autocommit() is True
    """)

BROKEN_CONNECTION_PROBE = textwrap.dedent("""
    import pymysql
    import pytest


    class FakeConnection:
        def __init__(self, isOpen):
            self.open = isOpen

        def rollback(self):
            if not self.open:
                raise AssertionError("a closed connection must be left alone")
            raise pymysql.err.OperationalError(2006, "MySQL server has gone away")

        autocommit = rollback


    @pytest.fixture(params=[True, False], ids=["broken", "closed"])
    def dbConn(request):
        return FakeConnection(request.param)


    def test_teardown_survives_a_connection_that_cannot_be_reset(dbConn):
        assert dbConn is not None
    """)


def find_test_modules(root):
    """The test modules the copy keeps, found with the same ignore rules as the copy."""
    testModules = []
    for directory, subdirectories, fileNames in os.walk(
        os.path.join(root, "fundamentals")
    ):
        ignoredDirectories = COPY_IGNORE(directory, subdirectories)
        subdirectories[:] = [
            name for name in subdirectories if name not in ignoredDirectories
        ]
        if os.path.basename(directory) != "tests":
            continue
        ignoredFiles = COPY_IGNORE(directory, fileNames)
        testModules += [
            os.path.join(directory, name)
            for name in fileNames
            if name.startswith("test_")
            and name.endswith(".py")
            and name not in ignoredFiles
        ]
    return testModules


@pytest.fixture(scope="module")
def package_copy(tmp_path_factory):
    """A throwaway copy of the package, so subprocess runs never touch the real ``output`` directories."""
    copyRoot = str(tmp_path_factory.mktemp("package_copy"))
    shutil.copytree(
        os.path.join(PROJECT_ROOT, "fundamentals"),
        os.path.join(copyRoot, "fundamentals"),
        ignore=COPY_IGNORE,
    )
    for fileName in COPIED_FILES:
        shutil.copy(os.path.join(PROJECT_ROOT, fileName), copyRoot)
    return copyRoot


def run_python_in_copy(copyRoot, args):
    return subprocess.run(
        [sys.executable, *args],
        cwd=copyRoot,
        env={**os.environ, "PYTHONPATH": copyRoot},
        capture_output=True,
        text=True,
        timeout=SUBPROCESS_TIMEOUT_SECONDS,
    )


def write_probe(copyRoot, directoryName, source, pytestArgs=()):
    """Write a probe test module into the copy and run pytest on it there."""
    probeDirectory = os.path.join(copyRoot, directoryName)
    os.makedirs(probeDirectory)
    with open(
        os.path.join(probeDirectory, "test_probe.py"), "w", encoding="utf-8"
    ) as probeFile:
        probeFile.write(source)
    return run_python_in_copy(
        copyRoot,
        ["-m", "pytest", "-p", "no:cacheprovider", "-q", *pytestArgs, directoryName],
    )


def test_importing_every_test_module_opens_no_database_connection(package_copy):
    result = run_python_in_copy(package_copy, ["-c", IMPORT_ALL_TEST_MODULES])

    assert result.returncode == 0, result.stderr
    report = json.loads(result.stdout.strip().splitlines()[-1])
    assert os.path.realpath(report["package"]).startswith(
        os.path.realpath(package_copy)
    )
    assert report["imported"] == len(find_test_modules(PROJECT_ROOT))
    assert report["connections"] == 0


def skip_unless_test_database_is_reachable():
    settingsFile = os.path.join(
        os.path.dirname(fundamentals.__file__), "test_settings.yaml"
    )
    with open(settingsFile, encoding="utf-8") as stream:
        databaseSettings = yaml.safe_load(stream)["database settings"]
    try:
        pymysql.connect(
            host=databaseSettings["host"],
            user=databaseSettings["user"],
            password=databaseSettings["password"],
            database=databaseSettings["db"],
            connect_timeout=DATABASE_CONNECT_TIMEOUT_SECONDS,
        ).close()
    except pymysql.Error as error:
        pytest.skip("the unit_tests database is unreachable: %s" % error)


def test_database_connection_is_reset_after_each_test(package_copy):
    skip_unless_test_database_is_reachable()
    result = write_probe(package_copy, "probe", CONNECTION_PROBE)

    assert result.returncode == 0, result.stdout + result.stderr


def test_teardown_survives_a_connection_that_cannot_be_reset(package_copy):
    result = write_probe(
        package_copy,
        "probe_broken",
        BROKEN_CONNECTION_PROBE,
        pytestArgs=("-o", "log_cli=true", "-o", "log_cli_level=WARNING"),
    )

    assert result.returncode == 0, result.stdout + result.stderr
    assert "could not reset the test database connection" in result.stdout


@pytest.mark.usefixtures("session_names")
def test_session_names_are_injected_into_the_test_module(
    request, log, settings, dbConn
):
    moduleNamespace = request.module.__dict__

    assert moduleNamespace["log"] is log
    assert moduleNamespace["settings"] is settings
    assert moduleNamespace["dbConn"] is dbConn


def test_log_fixture_is_a_logger(log):
    assert isinstance(log, logging.Logger)


def test_settings_fixture_holds_the_test_database_settings(settings):
    assert settings["database settings"]["db"] == "unit_tests"


def test_dbconn_fixture_is_an_open_connection(dbConn):
    assert dbConn.open
