from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml

# SETUP PATHS TO COMMON DIRECTORIES FOR TEST DATA
moduleDirectory = os.path.dirname(__file__)
pathToInputDir = moduleDirectory + "/input/"
pathToOutputDir = moduleDirectory + "/output/"

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

    def test_raises_value_error_when_settings_file_is_not_a_dictionary(self):
        from fundamentals.mysql import setup_database_connection

        for name, content in (("empty", ""), ("list", "- one\n- two\n")):
            with self.subTest(name=name):
                settingsPath = pathToOutputDir + "/" + name + "_settings.yaml"
                with open(settingsPath, "w") as stream:
                    stream.write(content)

                with self.assertRaises(ValueError) as context:
                    setup_database_connection(pathToYamlFile=settingsPath)

                self.assertIn(settingsPath, str(context.exception))
