import glob
import json
import logging
import os
import subprocess
import sys
import textwrap

import pytest

import fundamentals

PROJECT_ROOT = os.path.dirname(os.path.dirname(fundamentals.__file__))

IMPORT_ALL_TEST_MODULES = textwrap.dedent("""
    import glob
    import importlib.util
    import json
    import os
    from unittest import mock

    root = os.getcwd()
    paths = sorted(glob.glob(os.path.join(root, "fundamentals", "**", "tests", "test_*.py"), recursive=True))
    paths = [p for p in paths if not p.endswith("test_session_fixtures.py")]

    with mock.patch("pymysql.connect") as connect:
        for index, path in enumerate(paths):
            spec = importlib.util.spec_from_file_location("guard_module_%d" % index, path)
            spec.loader.exec_module(importlib.util.module_from_spec(spec))

    print(json.dumps({"imported": len(paths), "connections": connect.call_count}))
    """)


def test_importing_every_test_module_opens_no_database_connection():
    result = subprocess.run(
        [sys.executable, "-c", IMPORT_ALL_TEST_MODULES],
        cwd=PROJECT_ROOT,
        env={**os.environ, "PYTHONPATH": PROJECT_ROOT},
        capture_output=True,
        text=True,
    )

    assert result.returncode == 0, result.stderr
    report = json.loads(result.stdout.strip().splitlines()[-1])
    assert report["imported"] > 20
    assert report["connections"] == 0


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
