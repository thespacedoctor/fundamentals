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

# xt-setup-unit-testing-files-and-folders

pathToSqlite = pathToInputDir + "/test.sqlite"

class test_sqlite2mysql(unittest.TestCase):

    def test_sqlite2mysql_function(self):

        from fundamentals.mysql import sqlite2mysql
        this = sqlite2mysql(
            log=log,
            settings=settings,
            pathToSqlite=pathToSqlite,
            tablePrefix="Marvin",
            dbConn=dbConn
        )
        this.convert_sqlite_to_mysql()

    def test_sqlite2mysql_function_exception(self):

        from fundamentals.mysql import sqlite2mysql
        try:
            this = sqlite2mysql(
                log=log,
                settings=settings,
                pathToSqlite=pathToSqlite,
                fakeKey="break the code"
            )
            this.get()
            assert False
        except Exception as e:
            assert True
            # print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
