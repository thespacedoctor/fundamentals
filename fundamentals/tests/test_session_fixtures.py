import glob
import json
import logging
import os
import shutil
import subprocess
import sys
import textwrap

import pytest

import fundamentals
from fundamentals.utKit import SESSION_PLACEHOLDER

PROJECT_ROOT = os.path.dirname(os.path.dirname(fundamentals.__file__))

COPIED_FILES = ("conftest.py", "pytest.ini")

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

    from fundamentals.utKit import SESSION_PLACEHOLDER

    pytestmark = pytest.mark.usefixtures("session_names")
    dbConn = SESSION_PLACEHOLDER


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


def find_test_modules(root):
    return glob.glob(
        os.path.join(root, "fundamentals", "**", "tests", "test_*.py"), recursive=True
    )


@pytest.fixture(scope="module")
def package_copy(tmp_path_factory):
    """A throwaway copy of the package, so subprocess runs never touch the real ``output`` directories."""
    copyRoot = str(tmp_path_factory.mktemp("package_copy"))
    shutil.copytree(
        os.path.join(PROJECT_ROOT, "fundamentals"),
        os.path.join(copyRoot, "fundamentals"),
        ignore=shutil.ignore_patterns("output", "__pycache__", "*.pyc"),
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
    )


def test_importing_every_test_module_opens_no_database_connection(package_copy):
    result = run_python_in_copy(package_copy, ["-c", IMPORT_ALL_TEST_MODULES])

    assert result.returncode == 0, result.stderr
    report = json.loads(result.stdout.strip().splitlines()[-1])
    assert report["package"].startswith(package_copy)
    assert report["imported"] == len(find_test_modules(PROJECT_ROOT))
    assert report["connections"] == 0


def test_database_connection_is_reset_after_each_test(package_copy):
    probeDirectory = os.path.join(package_copy, "probe")
    os.makedirs(probeDirectory)
    with open(os.path.join(probeDirectory, "test_probe.py"), "w") as probeFile:
        probeFile.write(CONNECTION_PROBE)

    result = run_python_in_copy(
        package_copy, ["-m", "pytest", "-p", "no:cacheprovider", "-q", "probe"]
    )

    assert result.returncode == 0, result.stdout + result.stderr


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


@pytest.mark.parametrize(
    "use",
    [
        lambda placeholder: placeholder.info,
        lambda placeholder: placeholder("query"),
        lambda placeholder: placeholder["database settings"],
        lambda placeholder: bool(placeholder),
    ],
    ids=["attribute", "call", "item", "truth"],
)
def test_placeholder_raises_a_runtime_error_when_used(use):
    with pytest.raises(RuntimeError, match="run these tests under pytest"):
        use(SESSION_PLACEHOLDER)


def test_placeholder_hides_special_attributes_from_introspection():
    assert getattr(SESSION_PLACEHOLDER, "__wrapped__", None) is None
