from __future__ import print_function
import os
import logging
import unittest
import shutil
import sys
import stat
import subprocess
import tempfile
import threading
import contextlib
from unittest import mock
from fundamentals.utKit import utKit
from fundamentals import tools
from os.path import expanduser

home = expanduser("~")

packageDirectory = utKit("").get_project_root()
settingsFile = packageDirectory + "/test_settings.yaml"
# settingsFile = home + "/.config/soxspipe.recipes/soxspipe.recipes.yaml"
su = tools(
    arguments={"settingsFile": settingsFile},
    docString=__doc__,
    logLevel="DEBUG",
    options_first=False,
    projectName=None,
    defaultSettingsFile=False,
)
arguments, settings, log, dbConn = su.setup()

# SETUP AND TEARDOWN FIXTURE FUNCTIONS FOR THE ENTIRE MODULE
moduleDirectory = os.path.dirname(__file__)
utKit = utKit(moduleDirectory)
log, dbConn, pathToInputDir, pathToOutputDir = utKit.setupModule()
utKit.tearDownModule()

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


def _finished_process(returncode):
    """a fake Popen process that has already exited with `returncode`"""
    process = mock.Mock(returncode=returncode)
    process.poll.return_value = returncode
    return process


class FakeMysqlProcesses:
    """stand-in for Popen whose processes stay running until released, recording how many ran at once"""

    def __init__(self):
        self.release = threading.Event()
        self.condition = threading.Condition()
        self.started = 0
        self.finished = 0
        self.running = 0
        self.peak = 0

    def popen(self, *args, **kwargs):
        with self.condition:
            self.started += 1
            self.running += 1
            self.peak = max(self.peak, self.running)
            self.condition.notify_all()
        process = _finished_process(0)
        process.wait.side_effect = self._wait
        return process

    def _wait(self):
        self.release.wait(timeout=JOIN_TIMEOUT_SECONDS)
        with self.condition:
            self.running -= 1
            self.finished += 1

    def wait_until_started(self, count):
        with self.condition:
            return self.condition.wait_for(
                lambda: self.started >= count, timeout=JOIN_TIMEOUT_SECONDS
            )


class test_directory_script_runner_subprocess(unittest.TestCase):
    """run the loginPath branch against a fake `mysql` executable"""

    def setUp(self):
        # A LOGGER CREATED HERE IS NOT DISABLED BY OTHER TEST MODULES' dictConfig CALLS
        self.log = logging.getLogger("fundamentals.tests.directory_script_runner")
        self.log.disabled = False
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
                self._run_background(failureRule="failed")

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
            release.wait(timeout=JOIN_TIMEOUT_SECONDS)
            finishedWaiting.set()
            return (b"", b"")

        fakeProcess = _finished_process(0)
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

    def test_background_mode_runs_scripts_on_non_daemon_threads(self):
        self._write_script("a.sql")

        with self._recorded_threads() as threads:
            self._run(waitForResult=False)
            self._join(threads)

        self.assertEqual(len(threads), 1)
        self.assertFalse(threads[0].daemon)

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

    @contextlib.contextmanager
    def _fake_mysql(self, fakes, scriptCount):
        """write `scriptCount` scripts and route Popen to `fakes`, yielding the recorded threads"""
        module = sys.modules["fundamentals.mysql.directory_script_runner"]
        for i in range(scriptCount):
            self._write_script("s%02d.sql" % i)
        with self._recorded_threads() as threads:
            with mock.patch.object(module, "Popen", side_effect=fakes.popen):
                yield threads

    def test_background_mode_starts_no_more_processes_than_the_limit_at_once(self):
        fakes = FakeMysqlProcesses()

        with self._fake_mysql(fakes, 6) as threads:
            self._run(waitForResult=False, maxParallelScripts=2)
            self.assertTrue(fakes.wait_until_started(2))
            fakes.release.set()
            self._join(threads)

        self.assertEqual(len(threads), 2)
        self.assertEqual(fakes.started, 6)
        self.assertLessEqual(fakes.peak, 2)

    def test_background_mode_eventually_runs_every_script_when_scripts_exceed_limit(
        self,
    ):
        fakes = FakeMysqlProcesses()
        fakes.release.set()

        with self._fake_mysql(fakes, 7) as threads:
            self._run(waitForResult=False, maxParallelScripts=2)
            self._join(threads)

        self.assertEqual(len(threads), 2)
        self.assertEqual(fakes.started, 7)
        self.assertEqual(fakes.finished, 7)
        self.assertLessEqual(fakes.peak, 2)

    def test_background_mode_returns_before_queued_scripts_have_started(self):
        fakes = FakeMysqlProcesses()

        with self._fake_mysql(fakes, 5) as threads:
            self._run(waitForResult=False, maxParallelScripts=1)
            finishedOnReturn = fakes.finished
            fakes.release.set()
            self._join(threads)

        self.assertEqual(finishedOnReturn, 0)
        self.assertEqual(len(threads), 1)
        self.assertEqual(fakes.started, 5)

    def test_background_mode_limits_processes_to_the_module_default(self):
        module = sys.modules["fundamentals.mysql.directory_script_runner"]
        fakes = FakeMysqlProcesses()
        scriptCount = module.MAX_PARALLEL_SCRIPTS + 3

        with self._fake_mysql(fakes, scriptCount) as threads:
            self._run(waitForResult=False)
            self.assertTrue(fakes.wait_until_started(module.MAX_PARALLEL_SCRIPTS))
            fakes.release.set()
            self._join(threads)

        self.assertEqual(len(threads), module.MAX_PARALLEL_SCRIPTS)
        self.assertLessEqual(fakes.peak, module.MAX_PARALLEL_SCRIPTS)
        self.assertEqual(fakes.started, scriptCount)

    def test_background_mode_keeps_running_scripts_after_one_fails_to_launch(self):
        module = sys.modules["fundamentals.mysql.directory_script_runner"]
        self._write_script("a.sql")
        self._write_script("b.sql")
        launched = []

        def failFirstLaunch(*args, **kwargs):
            if not launched:
                launched.append("failed")
                raise FileNotFoundError("mysql")
            launched.append("ok")
            return _finished_process(0)

        with mock.patch.object(module, "Popen", side_effect=failFirstLaunch):
            with self.assertLogs(self.log, level="ERROR"):
                self._run_background(maxParallelScripts=1)

        self.assertEqual(launched, ["failed", "ok"])

    def test_background_mode_logs_unexpected_error_and_keeps_running_later_scripts(
        self,
    ):
        module = sys.modules["fundamentals.mysql.directory_script_runner"]
        self._write_script("a.sql")
        self._write_script("b.sql")
        launched = []

        def failFirstLaunch(*args, **kwargs):
            launched.append(len(launched))
            if len(launched) == 1:
                raise RuntimeError("unexpected")
            return _finished_process(0)

        with mock.patch.object(module, "Popen", side_effect=failFirstLaunch):
            with self.assertLogs(self.log, level="ERROR") as logs:
                self._run_background(maxParallelScripts=1)

        self.assertEqual(len(launched), 2)
        self.assertIn("a.sql", "\n".join(logs.output))

    def test_background_mode_logs_how_many_scripts_are_queued_behind_the_limit(self):
        fakes = FakeMysqlProcesses()
        fakes.release.set()

        with self._fake_mysql(fakes, 5) as threads:
            with self.assertLogs(self.log, level="INFO") as logs:
                self._run(waitForResult=False, maxParallelScripts=2)
            self._join(threads)

        self.assertEqual(
            logs.records[0].getMessage(),
            "3 scripts queued behind the limit of 2 parallel mysql scripts",
        )

    def test_background_mode_logs_no_queue_message_when_scripts_fit_the_limit(self):
        fakes = FakeMysqlProcesses()
        fakes.release.set()

        with self._fake_mysql(fakes, 2) as threads:
            with self.assertNoLogs(self.log, level="INFO"):
                self._run(waitForResult=False, maxParallelScripts=2)
            self._join(threads)

    def _run_with_failing_stderr(self, stderr):
        """run one script whose fake mysql writes `stderr` and exits 3, returning the error log text"""
        module = sys.modules["fundamentals.mysql.directory_script_runner"]
        self._write_script("broken.sql")

        def failingPopen(*args, **kwargs):
            kwargs["stderr"].write(stderr)
            return _finished_process(3)

        with mock.patch.object(module, "Popen", side_effect=failingPopen):
            with self.assertLogs(self.log, level="ERROR") as logs:
                self._run_background()
        return "\n".join(logs.output)

    def test_background_mode_logs_only_the_end_of_a_very_long_stderr(self):
        module = sys.modules["fundamentals.mysql.directory_script_runner"]
        stderr = b"HEADMARK" + b"x" * (module.MAX_LOGGED_STDERR_BYTES * 2) + b"TAILMARK"

        output = self._run_with_failing_stderr(stderr)

        self.assertIn("TAILMARK", output)
        self.assertNotIn("HEADMARK", output)
        self.assertLess(len(output), module.MAX_LOGGED_STDERR_BYTES * 2)

    def test_background_mode_logs_stderr_as_decoded_text(self):
        output = self._run_with_failing_stderr("caf\u00e9 ".encode("utf-8") + b"\xff")

        self.assertIn("caf\u00e9 \ufffd", output)
        self.assertNotIn("b'caf", output)

    def test_background_mode_kills_and_reaps_a_running_process_when_waiting_fails(self):
        module = sys.modules["fundamentals.mysql.directory_script_runner"]
        self._write_script("a.sql")
        process = mock.Mock(returncode=None)
        process.poll.return_value = None
        process.wait.side_effect = [RuntimeError("interrupted"), 0]

        with mock.patch.object(module, "Popen", return_value=process):
            with self.assertLogs(self.log, level="ERROR"):
                self._run_background()

        process.kill.assert_called_once_with()
        self.assertEqual(process.wait.call_count, 2)

    def test_background_mode_does_not_kill_a_process_that_already_exited(self):
        module = sys.modules["fundamentals.mysql.directory_script_runner"]
        self._write_script("a.sql")
        process = _finished_process(0)
        process.wait.side_effect = RuntimeError("interrupted")

        with mock.patch.object(module, "Popen", return_value=process):
            with self.assertLogs(self.log, level="ERROR"):
                self._run_background()

        process.kill.assert_not_called()

    def test_background_mode_uses_the_singular_when_one_script_is_queued(self):
        fakes = FakeMysqlProcesses()
        fakes.release.set()

        with self._fake_mysql(fakes, 2) as threads:
            with self.assertLogs(self.log, level="INFO") as logs:
                self._run(waitForResult=False, maxParallelScripts=1)
            self._join(threads)

        self.assertEqual(
            logs.records[0].getMessage(),
            "1 script queued behind the limit of 1 parallel mysql scripts",
        )

    def test_background_mode_logs_the_original_error_when_killing_the_process_fails(
        self,
    ):
        module = sys.modules["fundamentals.mysql.directory_script_runner"]
        self._write_script("a.sql")
        process = mock.Mock(returncode=None)
        process.poll.return_value = None
        process.wait.side_effect = [RuntimeError("interrupted"), 0]
        process.kill.side_effect = ProcessLookupError("gone")

        with mock.patch.object(module, "Popen", return_value=process):
            with self.assertLogs(self.log, level="WARNING") as logs:
                self._run_background()

        process.kill.assert_called_once_with()
        self.assertEqual(process.wait.call_count, 2)
        messages = [record.getMessage() for record in logs.records]
        self.assertIn("MySQL Script `a.sql` process kill failed: 'gone'", messages)
        self.assertIn("RuntimeError: interrupted", "\n".join(logs.output))

    def test_background_mode_logs_the_original_error_when_polling_the_process_fails(
        self,
    ):
        module = sys.modules["fundamentals.mysql.directory_script_runner"]
        self._write_script("a.sql")
        process = mock.Mock(returncode=None)
        process.poll.side_effect = ProcessLookupError("gone")
        process.wait.side_effect = RuntimeError("interrupted")

        with mock.patch.object(module, "Popen", return_value=process):
            with self.assertLogs(self.log, level="WARNING") as logs:
                self._run_background()

        process.kill.assert_not_called()
        messages = [record.getMessage() for record in logs.records]
        self.assertIn("MySQL Script `a.sql` process poll failed: 'gone'", messages)
        self.assertIn("RuntimeError: interrupted", "\n".join(logs.output))

    def test_raises_value_error_for_an_invalid_process_limit(self):
        module = sys.modules["fundamentals.mysql.directory_script_runner"]
        self._write_script("a.sql")

        for badLimit in (0, -1, 2.5, "3", None, True):
            with self.subTest(limit=badLimit):
                with mock.patch.object(module, "Popen") as popen:
                    with self.assertRaises(ValueError):
                        self._run(waitForResult=False, maxParallelScripts=badLimit)
                popen.assert_not_called()

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
