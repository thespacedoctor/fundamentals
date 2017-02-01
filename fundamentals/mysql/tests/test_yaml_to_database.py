import os
import nose2
import nose2
import unittest
import shutil
import yaml
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


class test_yaml_to_database(unittest.TestCase):

    def test_single_yaml_to_database_function(self):

        from fundamentals.mysql import yaml_to_database
        yaml2db = yaml_to_database(
            log=log,
            settings=settings,
            dbConn=dbConn,
            pathToInputDir=pathToOutputDir + "/yaml"
        )
        yaml2db.add_yaml_file_content_to_database(
            filepath=pathToOutputDir + "/yaml/20161219105124.yaml"
        )

    def test_yaml_to_database_function(self):

        from fundamentals.mysql import yaml_to_database
        yaml2db = yaml_to_database(
            log=log,
            settings=settings,
            dbConn=dbConn,
            pathToInputDir=pathToOutputDir + "/yaml"
        )
        yaml2db.ingest()

    def test_yaml_to_database_function_exception(self):

        from fundamentals.mysql import yaml_to_database
        try:
            this = yaml_to_database(
                log=log,
                settings=settings,
                dbConn=dbConn,
                fakeKey="break the code"
            )
            this.get()
            assert False
        except Exception, e:
            assert True
            print str(e)

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
