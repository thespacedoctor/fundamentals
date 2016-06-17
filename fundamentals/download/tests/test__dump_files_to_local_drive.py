import os
import nose
import shutil
import yaml
from fundamentals.download import _dump_files_to_local_drive
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


# class test__dump_files_to_local_drive():

#     def test__dump_files_to_local_drive_function(self):
#         kwargs = {}
#         kwargs["log"] = log
#         kwargs["settings"] = settings
#         # xt-kwarg_key_and_value

#         testObject = _dump_files_to_local_drive(**kwargs)
#         testObject.get()

# x-print-testpage-for-pessto-marshall-web-object

# x-class-to-test-named-worker-function
