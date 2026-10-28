import logging
import os
import shutil
import tempfile
from typing import Any, NamedTuple

import pymysql
import pytest


def pytest_configure(config):
    """
    *Point HOME at a throwaway directory for the whole test session*

    The test settings write the log file under ``~/.config``. Test modules set up logging while they are collected, so HOME has to change before collection starts. This stops the suite from failing when the real HOME cannot be written and from writing into the real one.
    """
    testHome = tempfile.mkdtemp(prefix="fundamentals_test_home_")
    previousHome = os.environ.get("HOME")
    os.environ["HOME"] = testHome

    def restore_home():
        if previousHome is None:
            os.environ.pop("HOME", None)
        else:
            os.environ["HOME"] = previousHome
        shutil.rmtree(testHome, ignore_errors=True)

    config.add_cleanup(restore_home)


class SessionSetup(NamedTuple):
    """The settings, logger and database connection shared by the whole test session."""

    settings: Any
    log: Any
    dbConn: Any


@pytest.fixture(scope="session")
def session_setup():
    """
    *Set up the settings, logger and database connection once for the whole test session*

    The settings come from ``fundamentals/test_settings.yaml``. The database connection is opened here and closed when the session ends, so test modules never open their own.

    **Return**

    - ``SessionSetup`` -- a named tuple holding ``settings``, ``log`` and ``dbConn``
    """
    # IMPORTED HERE SO THE PACKAGE LOADS AFTER pytest_configure HAS POINTED HOME AT A THROWAWAY DIRECTORY
    from fundamentals import tools
    from fundamentals.utKit import utKit

    settingsFile = utKit("").get_project_root() + "/test_settings.yaml"
    su = tools(
        arguments={"settingsFile": settingsFile},
        docString=None,
        logLevel="DEBUG",
        options_first=False,
        projectName=None,
        defaultSettingsFile=False,
    )
    arguments, settings, log, dbConn = su.setup()

    yield SessionSetup(settings=settings, log=log, dbConn=dbConn)

    if dbConn:
        dbConn.close()


@pytest.fixture(scope="session")
def settings(session_setup):
    """*The settings dictionary of the test session*"""
    return session_setup.settings


@pytest.fixture(scope="session")
def log(session_setup):
    """*The logger of the test session*"""
    return session_setup.log


@pytest.fixture(scope="session", name="dbConn")
def db_conn(session_setup):
    """*The one database connection of the test session*"""
    return session_setup.dbConn


@pytest.fixture(scope="module")
def session_names(request, log, settings, dbConn):
    """
    *Make ``log``, ``settings`` and ``dbConn`` available as module-level names in a test module*

    Test modules request this fixture with ``pytestmark = pytest.mark.usefixtures("session_names")``. It lets the tests in a module, including ``unittest.TestCase`` methods, keep using the plain names ``log``, ``settings`` and ``dbConn`` without any set-up at import time.

    This only works under pytest, and it is transitional. A follow-up will move the modules to ``request.cls`` or fixture arguments and remove the injection.
    """
    request.module.__dict__.update(log=log, settings=settings, dbConn=dbConn)


@pytest.fixture(autouse=True)
def reset_db_connection(request):
    """
    *Undo whatever a test left on the shared database connection*

    After each test that uses ``dbConn`` or ``session_names``, roll back any open transaction and switch autocommit back on, so one test cannot change how the next one sees the database. A failed reset is logged as a warning, so it never hides the real test failure.
    """
    dbConn = None
    if {"dbConn", "session_names"} & set(request.fixturenames):
        try:
            dbConn = request.getfixturevalue("dbConn")
        except Exception:
            # SESSION SETUP FAILED, SO THE TEST REPORTS THAT ERROR ITSELF
            dbConn = None

    yield

    if not (dbConn and dbConn.open):
        return
    try:
        dbConn.rollback()
        dbConn.autocommit(True)
    except pymysql.Error as error:
        logging.getLogger(__name__).warning(
            "could not reset the test database connection: %s", error
        )
