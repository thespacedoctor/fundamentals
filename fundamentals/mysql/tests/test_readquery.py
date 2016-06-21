import os
import nose
import shutil
import yaml
from fundamentals.mysql import readquery
from fundamentals.utKit import utKit

from fundamentals import tools

su = tools(
    arguments={"settingsFile": None},
    docString=__doc__,
    logLevel="DEBUG",
    options_first=False,
    projectName="fundamentals",
    tunnel=False
)
arguments, settings, log, dbConn = su.setup()

# load settings
stream = file(
    "/Users/Dave/.config/fundamentals/fundamentals.yaml", 'r')
settings = yaml.load(stream)
stream.close()

# SETUP AND TEARDOWN FIXTURE FUNCTIONS FOR THE ENTIRE MODULE
moduleDirectory = os.path.dirname(__file__)
utKit = utKit(moduleDirectory)
log, dbConn, pathToInputDir, pathToOutputDir = utKit.setupModule()
utKit.tearDownModule()


class test_readquery():

    def test_readquery_function(self):

        from fundamentals.mysql import readquery
        rows = readquery(
            log=log,
            sqlQuery="show tables",
            dbConn=dbConn,
            quiet=False
        )
        print rows

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
        except Exception, e:
            assert True
            print str(e)

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
        except Exception, e:
            assert False
            print str(e)

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
