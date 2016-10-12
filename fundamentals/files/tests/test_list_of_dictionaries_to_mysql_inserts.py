import os
import nose
import shutil
import yaml
import pickle
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

pathToPickleFile = pathToInputDir + "/list-of-dictionaries.p"

listOfDictionaries = pickle.load(open(pathToPickleFile, "rb"))


class test_list_of_dictionaries_to_mysql():

    def test_list_of_dictionaries_to_mysql_function(self):

        from fundamentals.files.list_of_dictionaries_to_mysql_inserts import list_of_dictionaries_to_mysql_inserts
        mysqlInserts = list_of_dictionaries_to_mysql_inserts(
            log=log,
            datalist=listOfDictionaries,
            tableName="my_new_table"
        )
        print mysqlInserts

    def test_list_of_dictionaries_to_mysql_function_exception(self):

        from fundamentals.files.list_of_dictionaries_to_mysql_inserts import list_of_dictionaries_to_mysql_inserts
        try:
            this = list_of_dictionaries_to_mysql_inserts(
                log=log,
                settings=settings,
                fakeKey="break the code"
            )
            this.get()
            assert False
        except Exception, e:
            assert True
            print str(e)

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
