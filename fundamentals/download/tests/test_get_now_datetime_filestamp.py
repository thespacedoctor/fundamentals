import os
import nose2
import nose2
import unittest
import shutil
import yaml
from fundamentals.download import get_now_datetime_filestamp
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


# class test_get_now_datetime_filestamp(unittest.TestCase):

#     def test_get_now_datetime_filestamp_function(self):
#         kwargs = {}
#         kwargs["log"] = log
#         kwargs["settings"] = settings
#         # xt-kwarg_key_and_value

#         testObject = get_now_datetime_filestamp(**kwargs)
#         testObject.get()

#         # x-print-testpage-for-pessto-marshall-web-object

#     # x-class-to-test-named-worker-function
