from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml
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

class test_readquery(unittest.TestCase):

    def test_readquery_function(self):

        from fundamentals.mysql import readquery
        rows = readquery(
            log=log,
            sqlQuery="show tables",
            dbConn=dbConn,
            quiet=False
        )

    def test_readquery_error_function(self):

        from fundamentals.mysql import readquery
        try:
            rows = readquery(
                log=log,
                sqlQuery="rubbish query",
                dbConn=dbConn,
                quiet=False
            )
            assert False
        except Exception as e:
            assert True
            # print(str(e))

    def test_readquery_error_function_quiet(self):

        from fundamentals.mysql import readquery
        try:
            rows = readquery(
                log=log,
                sqlQuery="rubbish query",
                dbConn=dbConn,
                quiet=True
            )
            assert True
        except Exception as e:
            assert False
            # print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
