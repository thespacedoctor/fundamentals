import os
import nose
import shutil
import yaml
from fundamentals.files import recursive_directory_listing
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


class test_recursive_directory_listing():

    def test_recursive_directory_listing_function(self):

        from fundamentals.files import recursive_directory_listing
        theseFiles = recursive_directory_listing(
            log,
            baseFolderPath="/tmp",
            whatToList="all"
        )
        print theseFiles

        from fundamentals.files import recursive_directory_listing
        theseFiles = recursive_directory_listing(
            log,
            baseFolderPath="/tmp",
            whatToList="files"
        )
        print theseFiles

        from fundamentals.files import recursive_directory_listing
        theseFiles = recursive_directory_listing(
            log,
            baseFolderPath="/tmp",
            whatToList="dirs"
        )
        print theseFiles

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
