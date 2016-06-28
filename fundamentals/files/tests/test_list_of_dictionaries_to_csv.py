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


class test_list_of_dictionaries_to_csv():

    def test_list_of_dictionaries_to_csv_function(self):

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

        from fundamentals.files import list_of_dictionaries_to_csv
        csvOutput = list_of_dictionaries_to_csv(
            log=log,
            datalist=dataList
        )
        print csvOutput

        from fundamentals.files import list_of_dictionaries_to_csv
        csvOutput = list_of_dictionaries_to_csv(
            log=log,
            datalist=dataList,
            csvType="machine"
        )
        print csvOutput

    def test_list_of_dictionaries_to_csv_function_exception(self):

        from fundamentals.files import list_of_dictionaries_to_csv
        try:
            this = list_of_dictionaries_to_csv(
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
