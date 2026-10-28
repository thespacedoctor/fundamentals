import os
import shutil
import tempfile

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


@pytest.fixture(scope="session")
def test_session():
    """
    *Set up the settings, logger and database connection once for the whole test session*

    The settings come from ``fundamentals/test_settings.yaml``. The database connection is opened here and closed when the session ends, so test modules never open their own.

    **Return**

    - ``settings``, ``log``, ``dbConn`` -- the settings dictionary, the logger and the test database connection
    """
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

    yield settings, log, dbConn

    if dbConn:
        dbConn.close()


@pytest.fixture(scope="session")
def settings(test_session):
    """*The settings dictionary of the test session*"""
    return test_session[0]


@pytest.fixture(scope="session")
def log(test_session):
    """*The logger of the test session*"""
    return test_session[1]


@pytest.fixture(scope="session", name="dbConn")
def db_conn(test_session):
    """*The one database connection of the test session*"""
    return test_session[2]


@pytest.fixture(scope="module")
def session_names(request, log, settings, dbConn):
    """
    *Make ``log``, ``settings`` and ``dbConn`` available as module-level names in a test module*

    Test modules request this fixture with ``pytestmark = pytest.mark.usefixtures("session_names")``. It lets the tests in a module, including ``unittest.TestCase`` methods, keep using the plain names ``log``, ``settings`` and ``dbConn`` without any set-up at import time.
    """
    request.module.__dict__.update(log=log, settings=settings, dbConn=dbConn)
