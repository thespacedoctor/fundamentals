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


@pytest.fixture(scope="class")
def session_attributes(request, log, settings, dbConn):
    """
    *Set ``log``, ``settings`` and ``dbConn`` as attributes of a ``unittest.TestCase`` class*

    Request it with ``@pytest.mark.usefixtures("session_attributes")`` on the class, then use ``self.log``, ``self.settings`` and ``self.dbConn`` in the tests. A class that does not ask for it never opens the database connection, so pure unit tests still run when the database is down. Plain test functions take ``log``, ``settings`` and ``dbConn`` as arguments instead.
    """
    request.cls.log = log
    request.cls.settings = settings
    request.cls.dbConn = dbConn


@pytest.fixture(scope="module")
def output_dir(request, tmp_path_factory):
    """
    *A fresh output folder for a test module, filled with a copy of its ``input`` folder*

    The folder lives in the pytest temporary directory of the current run, so two test runs in the same checkout never share or delete each other's files, and the ``input`` folder is never written to.

    **Return**

    - ``outputDir`` -- the path of the folder, ending in ``/``
    """
    moduleFile = request.module.__file__
    moduleName = os.path.splitext(os.path.basename(moduleFile))[0]
    outputDir = tmp_path_factory.mktemp(moduleName)
    inputDir = os.path.join(os.path.dirname(moduleFile), "input")
    if os.path.isdir(inputDir):
        shutil.copytree(inputDir, outputDir, dirs_exist_ok=True)
    return str(outputDir) + os.sep


@pytest.fixture(scope="class")
def output_dir_attribute(request, output_dir):
    """
    *Set the module output folder as ``pathToOutputDir`` on a ``unittest.TestCase`` class*

    Request it with ``@pytest.mark.usefixtures("output_dir_attribute")`` on the class. Plain test functions take ``output_dir`` as an argument instead.
    """
    request.cls.pathToOutputDir = output_dir


@pytest.fixture(autouse=True)
def reset_db_connection(request):
    """
    *Undo whatever a test left on the shared database connection*

    After each test that uses ``dbConn`` or ``session_attributes``, roll back any open transaction and switch autocommit back on, so one test cannot change how the next one sees the database. A failed reset is logged as a warning, so it never hides the real test failure.
    """
    dbConn = None
    if {"dbConn", "session_attributes"} & set(request.fixturenames):
        dbConn = request.getfixturevalue("dbConn")

    yield

    if not dbConn or not dbConn.open:
        return
    try:
        dbConn.rollback()
        dbConn.autocommit(True)
    except pymysql.Error as error:
        logging.getLogger(__name__).warning(
            "could not reset the test database connection: %s", error
        )
