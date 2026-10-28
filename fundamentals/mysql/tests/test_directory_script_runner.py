from __future__ import print_function
import os
import unittest
import shutil
import sys
import stat
import subprocess
import tempfile
import threading
import contextlib
from unittest import mock
import pytest

pytestmark = pytest.mark.usefixtures("session_names")
# SET FOR THE MODULE BY THE session_names FIXTURE IN THE ROOT conftest.py
log = settings = dbConn = None

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

# shutil.copytree(pathToInputDir + "/mysql_scripts",
#                 pathToOutputDir + "/mysql_scripts")


class test_directory_script_runner(unittest.TestCase):

    def test_directory_script_runner_function(self):

        from fundamentals.mysql import directory_script_runner

        directory_script_runner(
            log=log,
            pathToScriptDirectory=pathToOutputDir + "/mysql_scripts",
            databaseName="unit_tests",
            loginPath="unittesting",
        )

    def test_directory_script_runner_function_02(self):

        from fundamentals.mysql import directory_script_runner

        directory_script_runner(
            log=log,
            pathToScriptDirectory=pathToOutputDir + "/mysql_scripts",
            databaseName="unit_tests",
            loginPath="unittesting",
            successRule="passed",
            failureRule="failed",
        )

    def test_directory_script_runner_function_03(self):

        from fundamentals.mysql import directory_script_runner

        directory_script_runner(
            log=log,
            pathToScriptDirectory=pathToOutputDir + "/mysql_scripts",
            databaseName="unit_tests",
            loginPath="unittesting",
            successRule="delete",
            failureRule="failed",
        )

    def test_directory_script_runner_function_04(self):

        from fundamentals.mysql import directory_script_runner

        directory_script_runner(
            log=log,
            pathToScriptDirectory=pathToOutputDir + "/mysql_scripts",
            databaseName="unit_tests",
            loginPath="unittesting",
            successRule="delete",
            failureRule="delete",
        )

    def test_directory_script_runner_function_05(self):

        from fundamentals.mysql import directory_script_runner

        directory_script_runner(
            log=log,
            pathToScriptDirectory=pathToOutputDir + "/mysql_scripts",
            force=True,
            databaseName="unit_tests",
            loginPath="unittesting",
            successRule="delete",
            failureRule="failed",
        )

    def test_directory_script_runner_function_06(self):

        from fundamentals.mysql import directory_script_runner

        directory_script_runner(
            log=log,
            pathToScriptDirectory=pathToOutputDir + "/mysql_scripts",
            dbConn=dbConn,
            successRule="delete",
            failureRule="failed",
        )

    def test_01_execute_mysql_script_function_01(self):

        pathToScript = pathToOutputDir + "/mysql_scripts/marshall_schema.sql"

        from fundamentals.mysql import execute_mysql_script

        exception = execute_mysql_script(
            pathToScript=pathToScript, log=log, dbConn=dbConn
        )
        if exception:
            print(exception)

        pathToScript = (
            pathToOutputDir
            + "/mysql_scripts/42340d_since_20160921_tns_conesearch_phot copy.sql"
        )

        from fundamentals.mysql import execute_mysql_script

        exception = execute_mysql_script(
            pathToScript=pathToScript, log=log, dbConn=dbConn
        )
        if exception:
            print(exception)

        pathToScript = (
            pathToOutputDir
            + "/mysql_scripts/42340d_since_20160921_tns_conesearch_phot.sql"
        )

        from fundamentals.mysql import execute_mysql_script

        exception = execute_mysql_script(
            pathToScript=pathToScript, log=log, dbConn=dbConn
        )
        if exception:
            print(exception)

    def test_directory_script_runner_function_exception(self):

        from fundamentals.mysql import directory_script_runner

        try:
            directory_script_runner(
                log=log, settings=settings, fakeKey="break the code"
            )
            assert False
        except Exception as e:
            assert True
            # print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function


FAKE_MYSQL = """#!/bin/sh
printf '%s\\n' "$@" > "__OUT__/args.txt"
printf '%s' "$FAKE_TEST_VAR" > "__OUT__/var.txt"
sleep 0.3
cat > "__OUT__/stdin.txt"
if [ -n "$FAKE_STDERR" ]; then
    printf '%s' "$FAKE_STDERR" >&2
    exit 3
fi
if [ -n "$FAKE_EXIT" ]; then
    exit "$FAKE_EXIT"
fi
"""


# LONGEST A TEST WAITS FOR A REAPER THREAD, OR FOR A FAKE PROCESS THAT SHOULD NOT BE WAITED ON
JOIN_TIMEOUT_SECONDS = 10
BLOCK_SAFETY_SECONDS = 1


class test_directory_script_runner_subprocess(unittest.TestCase):
    """run the loginPath branch against a fake `mysql` executable"""

    def setUp(self):
        self.log = log
        self.workDir = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.workDir, True)
        self.scriptDir = os.path.join(self.workDir, "scripts")
        os.makedirs(self.scriptDir)
        binDir = os.path.join(self.workDir, "bin")
        os.makedirs(binDir)
        fakePath = os.path.join(binDir, "mysql")
        with open(fakePath, "w") as f:
            f.write(FAKE_MYSQL.replace("__OUT__", self.workDir))
        os.chmod(fakePath, os.stat(fakePath).st_mode | stat.S_IEXEC)

        envPatch = mock.patch.dict(
            os.environ,
            {
                "PATH": binDir + ":" + os.environ["PATH"],
                "FAKE_TEST_VAR": "kept",
            },
        )
        envPatch.start()
        self.addCleanup(envPatch.stop)

        cwd = os.getcwd()
        os.chdir(self.workDir)
        self.addCleanup(os.chdir, cwd)

    def _write_script(self, name, content="SELECT 1;"):
        path = os.path.join(self.scriptDir, name)
        with open(path, "w") as f:
            f.write(content)
        return path

    def _read(self, name):
        with open(os.path.join(self.workDir, name)) as f:
            return f.read()

    def _run(self, **kwargs):
        from fundamentals.mysql import directory_script_runner

        directory_script_runner(
            log=self.log,
            pathToScriptDirectory=self.scriptDir,
            databaseName=kwargs.pop("databaseName", "unit_tests"),
            loginPath=kwargs.pop("loginPath", "unittesting"),
            **kwargs,
        )

    def _run_background(self, **kwargs):
        """run in background mode, then wait for the reaper thread so its logging is complete"""
        with self._recorded_threads() as threads:
            self._run(waitForResult=False, **kwargs)
            self._join(threads)

    @contextlib.contextmanager
    def _recorded_threads(self):
        realThread = threading.Thread
        threads = []

        def recordThread(*args, **kwargs):
            thread = realThread(*args, **kwargs)
            threads.append(thread)
            return thread

        with mock.patch("threading.Thread", side_effect=recordThread):
            yield threads

    def _join(self, threads):
        for thread in threads:
            thread.join(timeout=JOIN_TIMEOUT_SECONDS)
            self.assertFalse(thread.is_alive())

    def test_does_not_execute_shell_syntax_in_script_filename(self):
        self._write_script("a$(touch injected_marker).sql", "SELECT 42;")

        self._run()

        self.assertFalse(os.path.exists(os.path.join(self.workDir, "injected_marker")))
        self.assertEqual(self._read("stdin.txt"), "SELECT 42;")

    def test_passes_login_path_and_database_name_as_literal_arguments(self):
        self._write_script("a.sql")

        self._run(loginPath="lp;touch m1", databaseName="db; touch m2")

        self.assertEqual(
            self._read("args.txt").splitlines(),
            ["--login-path=lp;touch m1", "--force", "--", "db; touch m2"],
        )
        self.assertFalse(os.path.exists(os.path.join(self.workDir, "m1")))
        self.assertFalse(os.path.exists(os.path.join(self.workDir, "m2")))

    def test_delete_mode_waits_for_mysql_before_removing_script(self):
        scriptPath = self._write_script("a.sql", "SELECT 7;")

        self._run(waitForResult="delete")

        self.assertEqual(self._read("stdin.txt"), "SELECT 7;")
        self.assertFalse(os.path.exists(scriptPath))

    def test_keeps_existing_environment_variables_for_mysql(self):
        self._write_script("a.sql")

        self._run()

        self.assertEqual(self._read("var.txt"), "kept")

    def test_does_not_raise_when_path_and_home_are_unset(self):
        self._write_script("a.sql")
        module = sys.modules["fundamentals.mysql.directory_script_runner"]
        fakeProcess = mock.Mock()
        fakeProcess.communicate.return_value = (b"", b"")

        with mock.patch.dict(os.environ):
            del os.environ["PATH"]
            os.environ.pop("HOME", None)
            with mock.patch.object(module, "Popen", return_value=fakeProcess) as popen:
                self._run()

        self.assertIn("/usr/local/bin", popen.call_args.kwargs["env"]["PATH"])

    def test_database_name_starting_with_dash_is_not_parsed_as_an_option(self):
        self._write_script("a.sql")

        self._run(databaseName="--evil-option")

        self.assertEqual(
            self._read("args.txt").splitlines()[-2:], ["--", "--evil-option"]
        )

    def test_applies_failure_rule_when_mysql_binary_is_missing(self):
        scriptPath = self._write_script("a.sql")
        module = sys.modules["fundamentals.mysql.directory_script_runner"]

        with mock.patch.object(module, "Popen", side_effect=FileNotFoundError("mysql")):
            with self.assertLogs(self.log, level="ERROR") as logs:
                self._run(failureRule="failed", successRule="passed")

        self.assertFalse(os.path.exists(scriptPath))
        self.assertTrue(os.path.exists(os.path.join(self.scriptDir, "failed", "a.sql")))
        self.assertIn("a.sql", "\n".join(logs.output))

    def test_applies_failure_rule_when_script_is_unreadable(self):
        scriptPath = self._write_script("a.sql")
        os.chmod(scriptPath, 0)

        with self.assertLogs(self.log, level="ERROR") as logs:
            self._run(failureRule="failed")

        os.chmod(os.path.join(self.scriptDir, "failed", "a.sql"), stat.S_IRUSR)
        self.assertTrue(os.path.exists(os.path.join(self.scriptDir, "failed", "a.sql")))
        self.assertIn("a.sql", "\n".join(logs.output))

    def test_logs_and_leaves_script_in_place_when_launch_fails_in_background_mode(self):
        self._write_script("a.sql")
        module = sys.modules["fundamentals.mysql.directory_script_runner"]

        with mock.patch.object(
            module, "Popen", side_effect=FileNotFoundError("mysql")
        ) as popen:
            with self.assertLogs(self.log, level="ERROR"):
                self._run(waitForResult=False, failureRule="failed")

        self.assertEqual(popen.call_count, 1)
        self.assertTrue(os.path.exists(os.path.join(self.scriptDir, "a.sql")))

    def test_background_mode_logs_error_naming_script_and_return_code_when_mysql_fails(
        self,
    ):
        scriptPath = self._write_script("broken.sql")

        with mock.patch.dict(
            os.environ, {"FAKE_EXIT": "3", "FAKE_STDERR": "ERROR 1064 syntax"}
        ):
            with self.assertLogs(self.log, level="ERROR") as logs:
                self._run_background(failureRule="failed")

        self.assertTrue(os.path.exists(scriptPath))
        self.assertIn("broken.sql", "\n".join(logs.output))
        self.assertIn("return code 3", "\n".join(logs.output))
        self.assertIn("ERROR 1064 syntax", "\n".join(logs.output))

    def test_background_mode_logs_no_error_when_mysql_succeeds(self):
        self._write_script("ok.sql")

        with self.assertNoLogs(self.log, level="ERROR"):
            self._run_background()

    def test_background_mode_reaps_every_mysql_process(self):
        self._write_script("a.sql")
        self._write_script("b.sql")
        module = sys.modules["fundamentals.mysql.directory_script_runner"]
        started = []

        def recordPopen(*args, **kwargs):
            process = subprocess.Popen(*args, **kwargs)
            started.append(process)
            return process

        with mock.patch.object(module, "Popen", side_effect=recordPopen):
            self._run_background()

        self.assertEqual(len(started), 2)
        self.assertTrue(all(process.returncode is not None for process in started))

    def test_background_mode_returns_before_mysql_finishes_and_reaps_it_afterwards(self):
        self._write_script("a.sql")
        module = sys.modules["fundamentals.mysql.directory_script_runner"]
        release = threading.Event()
        finishedWaiting = threading.Event()

        def blockUntilReleased(*args, **kwargs):
            release.wait(timeout=BLOCK_SAFETY_SECONDS)
            finishedWaiting.set()
            return (b"", b"")

        fakeProcess = mock.Mock(returncode=0)
        fakeProcess.wait.side_effect = blockUntilReleased
        fakeProcess.communicate.side_effect = blockUntilReleased

        with self._recorded_threads() as threads:
            with mock.patch.object(module, "Popen", return_value=fakeProcess):
                self._run(waitForResult=False)
            returnedBeforeFinish = not finishedWaiting.is_set()
            release.set()
            self._join(threads)

        self.assertTrue(returnedBeforeFinish)
        self.assertTrue(finishedWaiting.is_set())
        fakeProcess.wait.assert_called_once_with()

    def test_background_mode_reaps_on_a_daemon_thread(self):
        self._write_script("a.sql")

        with self._recorded_threads() as threads:
            self._run(waitForResult=False)
            self._join(threads)

        self.assertEqual(len(threads), 1)
        self.assertTrue(threads[0].daemon)

    def test_background_mode_sends_stderr_to_a_temp_file_that_is_closed_after_reaping(
        self,
    ):
        self._write_script("a.sql")
        module = sys.modules["fundamentals.mysql.directory_script_runner"]
        stderrTargets = []

        def recordPopen(*args, **kwargs):
            stderrTargets.append(kwargs["stderr"])
            return subprocess.Popen(*args, **kwargs)

        with mock.patch.object(module, "Popen", side_effect=recordPopen):
            self._run_background()

        self.assertEqual(len(stderrTargets), 1)
        self.assertNotEqual(stderrTargets[0], subprocess.PIPE)
        self.assertTrue(stderrTargets[0].closed)

    def test_delete_mode_logs_error_naming_script_when_mysql_fails(self):
        scriptPath = self._write_script("broken.sql")

        with mock.patch.dict(os.environ, {"FAKE_STDERR": "ERROR 1064 syntax"}):
            with self.assertLogs(self.log, level="ERROR") as logs:
                self._run(waitForResult="delete")

        self.assertFalse(os.path.exists(scriptPath))
        self.assertIn("broken.sql", "\n".join(logs.output))
        self.assertIn("ERROR 1064 syntax", "\n".join(logs.output))

    def test_delete_mode_logs_no_error_when_mysql_succeeds(self):
        self._write_script("ok.sql")

        with self.assertNoLogs(self.log, level="ERROR"):
            self._run(waitForResult="delete")

    def test_wait_mode_applies_failure_rule_when_mysql_exits_non_zero_without_stderr(
        self,
    ):
        scriptPath = self._write_script("silent.sql")

        with mock.patch.dict(os.environ, {"FAKE_EXIT": "3"}):
            with self.assertLogs(self.log, level="ERROR") as logs:
                self._run(successRule="passed", failureRule="failed")

        self.assertFalse(os.path.exists(scriptPath))
        self.assertTrue(
            os.path.exists(os.path.join(self.scriptDir, "failed", "silent.sql"))
        )
        self.assertFalse(os.path.exists(os.path.join(self.scriptDir, "passed")))
        self.assertIn("silent.sql", "\n".join(logs.output))
        self.assertIn("3", "\n".join(logs.output))
