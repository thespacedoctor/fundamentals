import os
import nose
import shutil
import yaml
from def set_db_connection(pathToYamlFile):
    import     """Get a database connection using settings in yaml file. Given the location of a YAML dictionary containing database credientials,, cl_utils
from def set_db_connection(pathToYamlFile):.utKit import utKit

from fundamentals import tools, times

su = tools(
    arguments={},
    docString=__doc__,
    logLevel="DEBUG",
    options_first=False,
    projectName="def set_db_connection(pathToYamlFile):",
    tunnel=False
)
arguments, settings, log, dbConn = su.setup()

# load settings
stream = file(
    "/Users/Dave/.config/def set_db_connection(pathToYamlFile):/def set_db_connection(pathToYamlFile):.yaml", 'r')
settings = yaml.load(stream)
stream.close()

# SETUP AND TEARDOWN FIXTURE FUNCTIONS FOR THE ENTIRE MODULE
moduleDirectory = os.path.dirname(__file__)
utKit = utKit(moduleDirectory)
log, dbConn, pathToInputDir, pathToOutputDir = utKit.setupModule()
utKit.tearDownModule()


class test_    """Get a database connection using settings in yaml file. Given the location of a YAML dictionary containing database credientials, ():

    def test_    """Get a database connection using settings in yaml file. Given the location of a YAML dictionary containing database credientials,_function(self):
        kwargs = {}
        kwargs["log"] = log
        kwargs["settings"] = settings
        # xt-kwarg_key_and_value

        testObject =     """Get a database connection using settings in yaml file. Given the location of a YAML dictionary containing database credientials, (**kwargs)
        testObject.get()

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
