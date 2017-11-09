import os
import nose2
import shutil
import unittest
import yaml

from fundamentals.utKit import utKit

import time
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

# load settings
stream = file(
    pathToInputDir + "/example_settings.yaml", 'r')
settings = yaml.load(stream)
stream.close()

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


def f(n, anotherKeyword="nothing"):
    result = 0
    for x in range(10000):
        result += n * n * x
    return result


class test_multiprocess(unittest.TestCase):

    def test_multiprocess_function(self):

        from fundamentals import multiprocess

        # DEFINE AN INPUT ARRAY
        inputArray = range(10000)
        t1 = time.time()
        result = multiprocess(log=log, function=f,
                              inputArray=inputArray, anotherKeyword="cheese")

        took = time.time() - t1
        print "Multiprocessing took: %(took)s" % locals()

        t2 = time.time()

        result = []
        for i in inputArray:
            result.append(f(i))
        took = time.time() - t2
        print "Serial processing took: %(took)s" % locals()

    def test_multiprocess_function_exception(self):

        from fundamentals import multiprocess
        try:
            this = multiprocess(
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
