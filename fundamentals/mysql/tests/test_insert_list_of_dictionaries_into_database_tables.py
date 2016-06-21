import os
import nose
import shutil
import yaml
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


class test_insert_list_of_dictionaries_into_database_tables():

    def test_insert_list_of_dictionaries_into_database_tables_function(self):

        dictList = []

        for i in range(14000):

            dictList.append({
                "col1": i,
                "col2": i + 10.,
                "col3": i / 2.,
                "col4": i * 34.
            })

        from fundamentals.mysql import insert_list_of_dictionaries_into_database_tables
        insert_list_of_dictionaries_into_database_tables(
            dbConn=dbConn,
            log=log,
            dictList=dictList,
            dbTableName="test_insert_many",
            uniqueKeyList=["col1", "col3"],
            dateModified=False,
            batchSize=2500
        )

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
