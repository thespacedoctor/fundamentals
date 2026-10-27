from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml
import sys
import stat
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
"""


class test_directory_script_runner_subprocess(unittest.TestCase):
    """run the loginPath branch against a fake `mysql` executable"""

    def setUp(self):
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
            log=log,
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
            ["--login-path=lp;touch m1", "--force", "db; touch m2"],
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
