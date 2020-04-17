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

dbSettings = settings["database settings"]["atlasMovers"]
dbSettings2 = settings["database settings"]["unit_tests"]

class test_database(unittest.TestCase):

    def test_tunnel(self):

        from fundamentals.mysql import database
        db = database(
            log=log,
            dbSettings=dbSettings
        )
        sshPort = db._setup_tunnel(
            tunnelParameters=dbSettings["tunnel"]
        )

        return

    def test_no_tunnel(self):

        from fundamentals.mysql import database
        db = database(
            log=log,
            dbSettings=dbSettings2
        ).connect()

        return

    def test_database_function(self):

        # SETUP ALL DATABASE CONNECTIONS
        from fundamentals.mysql import database
        dbConn = database(
            log=log,
            dbSettings=dbSettings2
        ).connect()

        from fundamentals.mysql import readquery
        sqlQuery = u"""
            SELECT VERSION();
        """ % locals()
        rows = readquery(
            log=log,
            sqlQuery=sqlQuery,
            dbConn=dbConn,
            quiet=False
        )
        # print(rows)

    def test_database_function_exception(self):

        from fundamentals.mysql import database
        try:
            this = database(
                log=log,
                dbSettings=dbSettings2,
                fakeKey="break the code"
            )
            this.get()
            assert False
        except Exception as e:
            assert True
            # print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
