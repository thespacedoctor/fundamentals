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
stream = file(
    "/Users/Dave/.config/fundamentals/fundamentals.yaml", 'r')
settings = yaml.load(stream)
stream.close()

# SETUP AND TEARDOWN FIXTURE FUNCTIONS FOR THE ENTIRE MODULE
moduleDirectory = os.path.dirname(__file__)
utKit = utKit(moduleDirectory)
log, dbConn, pathToInputDir, pathToOutputDir = utKit.setupModule()
utKit.tearDownModule()


class test_get_database_table_column_names(unittest.TestCase):

    def test_get_database_table_column_names_function(self):

        from fundamentals.mysql import get_database_table_column_names
        columnNames = get_database_table_column_names(
            dbConn=dbConn,
            log=log,
            dbTable="testing_table"
        )
        print columnNames

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
