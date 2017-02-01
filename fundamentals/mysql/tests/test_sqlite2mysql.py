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
    projectName="headjack"
)
arguments, settings, log, dbConn = su.setup()

# # load settings
# stream = file(
#     "/Users/Dave/.config/headjack/headjack.yaml", 'r')
# settings = yaml.load(stream)
# stream.close()

# SETUP AND TEARDOWN FIXTURE FUNCTIONS FOR THE ENTIRE MODULE
moduleDirectory = os.path.dirname(__file__)
utKit = utKit(moduleDirectory)
log, dbConn, pathToInputDir, pathToOutputDir = utKit.setupModule()
utKit.tearDownModule()

# load settings
stream = file(
    pathToInputDir + "/example_settings.yaml", 'r')
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

pathToSqlite = pathToInputDir + "/test.sqlite"


class test_sqlite2mysql(unittest.TestCase):

    def test_sqlite2mysql_function(self):

        from fundamentals.mysql import sqlite2mysql
        this = sqlite2mysql(
            log=log,
            settings=settings,
            pathToSqlite=pathToSqlite,
            tablePrefix="Marvin"
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
        except Exception, e:
            assert True
            print str(e)

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
