from __future__ import print_function
import os
import nose2
import nose2
import unittest
import shutil
import yaml
from fundamentals.utKit import utKit

from fundamentals import tools

su = tools(
    arguments={"settingsFile": None},
    docString=__doc__,
    logLevel="DEBUG",
    options_first=False,
    projectName="fundamentals"
)
arguments, settings, log, dbConn = su.setup()

# load settings
stream = open(
    "/Users/Dave/.config/fundamentals/fundamentals.yaml", 'r')
settings = yaml.load(stream)
stream.close()

# SETUP AND TEARDOWN FIXTURE FUNCTIONS FOR THE ENTIRE MODULE
moduleDirectory = os.path.dirname(__file__)
utKit = utKit(moduleDirectory)
log, dbConn, pathToInputDir, pathToOutputDir = utKit.setupModule()
utKit.tearDownModule()


try:
    shutil.rmtree(pathToOutputDir)
    # Recursively create missing directories
    if not os.path.exists(pathToOutputDir):
        os.makedirs(pathToOutputDir)
except:
    pass

shutil.copytree(pathToInputDir + "/mysql_scripts",
                pathToOutputDir + "/mysql_scripts")


class test_directory_script_runner(unittest.TestCase):

    def test_directory_script_runner_function(self):

        from fundamentals.mysql import directory_script_runner
        directory_script_runner(
            log=log,
            pathToScriptDirectory=pathToOutputDir + "/mysql_scripts",
            databaseName="unit_tests",
            loginPath="unittesting"
        )

    def test_directory_script_runner_function_02(self):

        from fundamentals.mysql import directory_script_runner
        directory_script_runner(
            log=log,
            pathToScriptDirectory=pathToOutputDir + "/mysql_scripts",
            databaseName="unit_tests",
            loginPath="unittesting",
            successRule="passed",
            failureRule="failed"
        )

    def test_directory_script_runner_function_03(self):

        from fundamentals.mysql import directory_script_runner
        directory_script_runner(
            log=log,
            pathToScriptDirectory=pathToOutputDir + "/mysql_scripts",
            databaseName="unit_tests",
            loginPath="unittesting",
            successRule="delete",
            failureRule="failed"
        )

    def test_directory_script_runner_function_04(self):

        from fundamentals.mysql import directory_script_runner
        directory_script_runner(
            log=log,
            pathToScriptDirectory=pathToOutputDir + "/mysql_scripts",
            databaseName="unit_tests",
            loginPath="unittesting",
            successRule="delete",
            failureRule="delete"
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
            failureRule="failed"
        )

    def test_directory_script_runner_function_exception(self):

        from fundamentals.mysql import directory_script_runner
        try:
            directory_script_runner(
                log=log,
                settings=settings,
                fakeKey="break the code"
            )
            assert False
        except Exception as e:
            assert True
            # print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
