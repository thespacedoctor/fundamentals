import os
import nose2
import nose2
import unittest
import shutil
import yaml
import pickle
from fundamentals.renderer import list_of_dictionaries
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


class test_list_of_dictionaries(unittest.TestCase):

    def test_list_of_dictionaries_function(self):

        from fundamentals.renderer import list_of_dictionaries
        dataSet = list_of_dictionaries(
            log=log,
            listOfDictionaries=listOfDictionaries
        )
        print dataSet.table()
        dataSet.table(filepath=pathToOutputDir + "myData.dat")
        print dataSet.csv()
        dataSet.csv(filepath=pathToOutputDir + "myData.csv")
        print dataSet.mysql(tableName="TNS")
        dataSet.mysql(tableName="TNS",
                      filepath=pathToOutputDir + "myData.mysql")

        print dataSet.json()
        dataSet.json(filepath=pathToOutputDir + "myData.json")
        print dataSet.yaml()
        dataSet.yaml(filepath=pathToOutputDir + "myData.yaml")
        print dataSet.markdown()
        dataSet.markdown(filepath=pathToOutputDir + "myData.md")

    def test_list_of_dictionaries_function_02(self):

        dataList = [
            {
                "owner": "daisy",
                "pet": "dog",
                "address": "belfast, uk"
            },
            {
                "owner": "john",
                "pet": "snake",
                "address": "the moon"
            },
            {
                "owner": "susan",
                "pet": "crocodile",
                "address": "larne"
            }

        ]

        from fundamentals.renderer import list_of_dictionaries
        dataSet = list_of_dictionaries(
            log=log,
            listOfDictionaries=dataList
        )
        print dataSet.table()
        dataSet.table(filepath=pathToOutputDir + "myData.dat")
        print dataSet.csv()
        dataSet.csv(filepath=pathToOutputDir + "myData.csv")
        print dataSet.mysql(tableName="TNS")
        dataSet.mysql(tableName="TNS",
                      filepath=pathToOutputDir + "myData.mysql")
        print dataSet.json()
        dataSet.json(filepath=pathToOutputDir + "myData.json")
        print dataSet.yaml()
        dataSet.yaml(filepath=pathToOutputDir + "myData.yaml")
        print dataSet.markdown()
        dataSet.markdown(filepath=pathToOutputDir + "myData.md")

    def test_list_of_dictionaries_function_exception(self):

        from fundamentals.renderer import list_of_dictionaries
        try:
            this = list_of_dictionaries(
                log=log,
                listOfDictionaries=listOfDictionaries,
                fakeKey="break the code"
            )
            this.get()
            assert False
        except Exception, e:
            assert True
            print str(e)

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
