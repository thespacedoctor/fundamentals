import os
import nose2
import shutil
import unittest
import yaml
from fundamentals.utKit import utKit

from fundamentals import tools

su = tools(
    arguments={"settingsFile": None},
    docString=__doc__,
    logLevel="DEBUG",
    options_first=False,
    projectName="fundamentals",
    defaultSettingsFile=False
)
arguments, settings, log, dbConn = su.setup()

# # load settings
# stream = file(
#     "/Users/Dave/.config/fundamentals/fundamentals.yaml", 'r')
# settings = yaml.load(stream)
# stream.close()

# SETUP AND TEARDOWN FIXTURE FUNCTIONS FOR THE ENTIRE MODULE
moduleDirectory = os.path.dirname(__file__)
utKit = utKit(moduleDirectory)
log, dbConn, pathToInputDir, pathToOutputDir = utKit.setupModule()
utKit.tearDownModule()

largeFile = pathToInputDir + "/ppmxl-head.csv"

# # load settings
# stream = file(
#     pathToInputDir + "/example_settings.yaml", 'r')
# settings = yaml.load(stream)
# stream.close()

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


class test_fileChunker(unittest.TestCase):

    def test_fileChunker_function(self):

        from fundamentals.files import fileChunker
        fileIterator = fileChunker(
            filepath=largeFile,
            batchSize=93840
        )
        for i in fileIterator:
            print len(i)

    def test_fileChunker_function_exception(self):

        from fundamentals.files import fileChunker
        try:
            this = fileChunker(
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
