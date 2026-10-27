from __future__ import print_function
import os
import logging
import unittest
import shutil
import sys
import stat
import subprocess
import tempfile
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
                self._run(waitForResult=False, failureRule="failed")

        self.assertTrue(os.path.exists(scriptPath))
        self.assertIn("broken.sql", "\n".join(logs.output))
        self.assertIn("return code 3", "\n".join(logs.output))
        self.assertIn("ERROR 1064 syntax", "\n".join(logs.output))

    def test_background_mode_logs_no_error_when_mysql_succeeds(self):
        self._write_script("ok.sql")

        with self.assertNoLogs(self.log, level="ERROR"):
            self._run(waitForResult=False)

    def test_background_mode_reaps_every_mysql_process_before_returning(self):
        self._write_script("a.sql")
        self._write_script("b.sql")
        module = sys.modules["fundamentals.mysql.directory_script_runner"]
        started = []

        def recordPopen(*args, **kwargs):
            process = subprocess.Popen(*args, **kwargs)
            started.append(process)
            return process

        with mock.patch.object(module, "Popen", side_effect=recordPopen):
            self._run(waitForResult=False)

        self.assertEqual(len(started), 2)
        self.assertTrue(all(process.returncode is not None for process in started))

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
