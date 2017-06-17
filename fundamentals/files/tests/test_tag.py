import os
import nose
import shutil
import unittest
import yaml
from fundamentals.utKit import utKit
from fundamentals.files import tag

from fundamentals import tools

su = tools(
    arguments={"settingsFile": None},
    docString=__doc__,
    logLevel="DEBUG",
    options_first=False,
    projectName="fundamentals"
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


class test_tag(unittest.TestCase):

    def test_tag_function(self):

        from fundamentals.files.tag import tag
        tag(
            log=log,
            filepath=pathToOutputDir + "/file_needing_tagged.dat",
            tags="test,tags, fundamentals",
            rating=3,
            wherefrom="http://www.thespacedoctor.co.uk"
        )

    def test_tag_function_exception(self):

        from fundamentals.files import tag
        try:
            this = tag(
                log=log,
                fakeKey="break the code"
            )
            assert False
        except Exception, e:
            assert True
            print str(e)

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
