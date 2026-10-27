from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
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
    defaultSettingsFile=False,
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


class test_setup_database_connection(unittest.TestCase):

    def test_setup_database_connection_function(self):

        from fundamentals.mysql import setup_database_connection

        this = setup_database_connection(
            pathToYamlFile=pathToInputDir + "/db_settings.yaml"
        )
        # print(this)

    def test_raises_original_error_when_connection_fails(self):
        from unittest import mock
        import pymysql
        from fundamentals.mysql import setup_database_connection

        settingsPath = pathToOutputDir + "/connection_failure_settings.yaml"
        with open(settingsPath, "w") as stream:
            stream.write("db: unit_tests\nhost: localhost\nuser: u\npassword: p\n")

        with mock.patch(
            "pymysql.connect", side_effect=pymysql.err.OperationalError(2003, "refused")
        ):
            with self.assertRaises(pymysql.err.OperationalError):
                setup_database_connection(pathToYamlFile=settingsPath)

    def test_raises_oserror_when_settings_file_is_missing(self):
        from fundamentals.mysql import setup_database_connection

        with self.assertRaises(OSError):
            setup_database_connection(
                pathToYamlFile=pathToOutputDir + "/no_such_settings.yaml"
            )

    def test_raises_yaml_error_when_settings_file_is_malformed(self):
        from fundamentals.mysql import setup_database_connection

        settingsPath = pathToOutputDir + "/malformed_settings.yaml"
        with open(settingsPath, "w") as stream:
            stream.write("db: [unclosed\n")

        with self.assertRaises(yaml.YAMLError):
            setup_database_connection(pathToYamlFile=settingsPath)
