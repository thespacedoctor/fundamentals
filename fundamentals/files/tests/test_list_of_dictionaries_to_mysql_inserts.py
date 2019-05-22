from __future__ import print_function
from builtins import str
import os
import nose2
import nose2
import unittest
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
stream = open(
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


class test_list_of_dictionaries_to_mysql(unittest.TestCase):

    def test_list_of_dictionaries_to_mysql_function(self):

        from fundamentals.files.list_of_dictionaries_to_mysql_inserts import list_of_dictionaries_to_mysql_inserts
        mysqlInserts = list_of_dictionaries_to_mysql_inserts(
            log=log,
            datalist=listOfDictionaries,
            tableName="my_new_table"
        )

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
        except Exception as e:
            assert True
            print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
