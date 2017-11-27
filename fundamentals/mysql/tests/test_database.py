import os
import nose
import shutil
import yaml
import unittest
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

# # load settings
# stream = file(
#     "/Users/Dave/.config/rockAtlas/rockAtlas.yaml", 'r')
# settings = yaml.load(stream)
# stream.close()

# SETUP AND TEARDOWN FIXTURE FUNCTIONS FOR THE ENTIRE MODULE
moduleDirectory = os.path.dirname(__file__)
utKit = utKit(moduleDirectory)
log, dbConn, pathToInputDir, pathToOutputDir = utKit.setupModule()
utKit.tearDownModule()

# load settings
stream = file(
    pathToInputDir + "/example_settings_2.yaml", 'r')
settings = yaml.load(stream)
stream.close()

import shutil
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

dbSettings = settings["database settings"]["atlasMovers"]
dbSettings2 = settings["database settings"]["dryx_unit_testing"]


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
            dbSettings=dbSettings
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
        print rows

    def test_database_function_exception(self):

        from fundamentals.mysql import database
        try:
            this = database(
                log=log,
                dbSettings=dbSettings,
                fakeKey="break the code"
            )
            this.get()
            assert False
        except Exception, e:
            assert True
            print str(e)

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
