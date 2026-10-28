from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import signal
import tempfile
from unittest import mock
import pytest

pytestmark = pytest.mark.usefixtures("session_names")
# INJECTED BY THE session_names FIXTURE IN THE ROOT conftest.py (PYTEST ONLY)
log = settings = None

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


# xt-setup-unit-testing-files-and-folders
# xt-utkit-refresh-database


class test_daemonise(unittest.TestCase):

    def test_daemonise_function(self):

        from fundamentals import daemonise

        this = daemonise(log=log, settings=settings, name="nice")

    def test_daemonise_function_exception(self):

        from fundamentals import daemonise

        try:
            this = daemonise(log=log, settings=settings, fakeKey="break the code")
            this.get()
            assert False
        except Exception as e:
            assert True
            print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function


class test_daemonise_pidfile(unittest.TestCase):

    def setUp(self):
        self.tmpHome = tempfile.mkdtemp()
        homePatch = mock.patch.dict(os.environ, {"HOME": self.tmpHome})
        homePatch.start()
        self.addCleanup(homePatch.stop)
        self.addCleanup(shutil.rmtree, self.tmpHome, True)

        from fundamentals import daemonise

        self.log = mock.MagicMock()
        self.daemon = daemonise(log=self.log, name="pidtest")
        with open(self.daemon.pidFile, "w") as f:
            f.write("4242")

    def test_start_keeps_pidfile_and_refuses_when_kill_is_permission_denied(self):
        with mock.patch("os.kill", side_effect=PermissionError), mock.patch(
            "daemon.DaemonContext"
        ) as context, mock.patch.object(type(self.daemon), "action"):
            self.daemon.start()

        self.assertTrue(os.path.exists(self.daemon.pidFile))
        context.assert_not_called()

    def test_start_removes_stale_pidfile_when_process_is_gone(self):
        with mock.patch("os.kill", side_effect=ProcessLookupError), mock.patch(
            "daemon.DaemonContext"
        ) as context, mock.patch.object(type(self.daemon), "action"):
            self.daemon.start()

        self.assertFalse(os.path.exists(self.daemon.pidFile))
        context.assert_called_once()

    def test_stop_keeps_pidfile_when_kill_is_permission_denied(self):
        with mock.patch("os.kill", side_effect=PermissionError):
            self.daemon.stop()

        self.assertTrue(os.path.exists(self.daemon.pidFile))
        self.log.error.assert_called_once()

    def test_stop_keeps_pidfile_when_kill_fails_with_other_os_error(self):
        with mock.patch("os.kill", side_effect=OSError("boom")):
            self.daemon.stop()

        self.assertTrue(os.path.exists(self.daemon.pidFile))
        self.log.error.assert_called_once()

    def test_stop_removes_pidfile_when_process_is_gone(self):
        with mock.patch("os.kill", side_effect=ProcessLookupError):
            self.daemon.stop()

        self.assertFalse(os.path.exists(self.daemon.pidFile))

    def test_stop_keeps_pidfile_after_successful_signal(self):
        with mock.patch("os.kill") as kill:
            self.daemon.stop()

        kill.assert_called_once_with(4242, signal.SIGTERM)
        self.assertTrue(os.path.exists(self.daemon.pidFile))

    def test_status_keeps_pidfile_and_reports_running_when_kill_is_permission_denied(
        self,
    ):
        with mock.patch("os.kill", side_effect=PermissionError), mock.patch(
            "builtins.print"
        ) as printed:
            self.daemon.status()

        self.assertTrue(os.path.exists(self.daemon.pidFile))
        printed.assert_called_once_with(
            "pidtest daemon is running (PID = 4242, owned by another user)."
        )

    def test_status_removes_pidfile_and_reports_not_running_when_process_is_gone(self):
        with mock.patch("os.kill", side_effect=ProcessLookupError), mock.patch(
            "builtins.print"
        ) as printed:
            self.daemon.status()

        self.assertFalse(os.path.exists(self.daemon.pidFile))
        printed.assert_called_once_with("pidtest daemon is not running.")

    def test_status_keeps_pidfile_and_logs_error_when_kill_fails_with_other_os_error(
        self,
    ):
        with mock.patch("os.kill", side_effect=OSError("boom")), mock.patch(
            "builtins.print"
        ) as printed:
            self.daemon.status()

        self.assertTrue(os.path.exists(self.daemon.pidFile))
        self.log.error.assert_called_once()
        self.assertNotIn("is not running", str(printed.call_args_list))

    def test_restart_logs_restart_method_name(self):
        with mock.patch.object(type(self.daemon), "stop"), mock.patch.object(
            type(self.daemon), "start"
        ):
            os.remove(self.daemon.pidFile)
            self.daemon.restart()

        self.log.debug.assert_any_call("starting the ``restart`` method")
        self.log.debug.assert_any_call("completed the ``restart`` method")
