from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml
import sys
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
    defaultSettingsFile=False
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

    def test_directory_script_runner_function_06(self):

        from fundamentals.mysql import directory_script_runner
        directory_script_runner(
            log=log,
            pathToScriptDirectory=pathToOutputDir + "/mysql_scripts",
            dbConn=dbConn,
            successRule="delete",
            failureRule="failed"
        )

    def test_01_execute_mysql_script_function_01(self):

        pathToScript = pathToOutputDir + \
            "/mysql_scripts/42340d_since_20160921_tns_conesearch_phot copy.sql"

        from fundamentals.mysql import execute_mysql_script
        exception = execute_mysql_script(
            pathToScript=pathToScript,
            log=log,
            dbConn=dbConn
        )

        pathToScript = pathToOutputDir + \
            "/mysql_scripts/42340d_since_20160921_tns_conesearch_phot.sql"

        from fundamentals.mysql import execute_mysql_script
        exception = execute_mysql_script(
            pathToScript=pathToScript,
            log=log,
            dbConn=dbConn
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
