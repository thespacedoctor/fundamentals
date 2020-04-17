from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import pickle
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

pathToPickleFile = pathToInputDir + "/list-of-dictionaries.p"

listOfDictionaries = pickle.load(open(pathToPickleFile, "rb"))

class test_list_of_dictionaries(unittest.TestCase):

    def test_list_of_dictionaries_function(self):

        from fundamentals.renderer import list_of_dictionaries
        dataSet = list_of_dictionaries(
            log=log,
            listOfDictionaries=listOfDictionaries
        )
        # print(dataSet.table())
        dataSet.table(filepath=pathToOutputDir + "myData.dat")
        # print(dataSet.csv())
        dataSet.csv(filepath=pathToOutputDir + "myData.csv")
        # print(dataSet.mysql(tableName="TNS"))
        dataSet.mysql(tableName="TNS",
                      filepath=pathToOutputDir + "myData.mysql")

        # print(dataSet.json())
        dataSet.json(filepath=pathToOutputDir + "myData.json")
        # print(dataSet.yaml())
        dataSet.yaml(filepath=pathToOutputDir + "myData.yaml")
        # print(dataSet.markdown())
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
        # print(dataSet.table())
        dataSet.table(filepath=pathToOutputDir + "myData.dat")
        # print(dataSet.csv())
        dataSet.csv(filepath=pathToOutputDir + "myData.csv")
        # print(dataSet.mysql(tableName="TNS"))
        dataSet.mysql(tableName="TNS",
                      filepath=pathToOutputDir + "myData.mysql")
        # print(dataSet.json())
        dataSet.json(filepath=pathToOutputDir + "myData.json")
        # print(dataSet.yaml())
        dataSet.yaml(filepath=pathToOutputDir + "myData.yaml")
        # print(dataSet.markdown())
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
        except Exception as e:
            assert True
            # print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
