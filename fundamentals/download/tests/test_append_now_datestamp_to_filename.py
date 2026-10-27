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

from unittest.mock import patch
from fundamentals.download import append_now_datestamp_to_filename

STAMP = "20160316t154123"


class test_append_now_datestamp_to_filename(unittest.TestCase):

    def setUp(self):
        patcher = patch(
            "fundamentals.download.get_now_datetime_filestamp", return_value=STAMP
        )
        patcher.start()
        self.addCleanup(patcher.stop)

    def test_keeps_extension_when_filename_has_one_dot(self):
        result = append_now_datestamp_to_filename(log=log, filename="a.html")

        self.assertEqual(result, "a_" + STAMP + ".html")

    def test_keeps_last_extension_when_filename_has_two_dots(self):
        result = append_now_datestamp_to_filename(log=log, filename="a.b.html")

        self.assertEqual(result, "a.b_" + STAMP + ".html")

    def test_keeps_last_extension_for_tar_gz(self):
        result = append_now_datestamp_to_filename(log=log, filename="a.tar.gz")

        self.assertEqual(result, "a.tar_" + STAMP + ".gz")

    def test_defaults_to_xhtml_when_filename_has_no_extension(self):
        result = append_now_datestamp_to_filename(log=log, filename="noext")

        self.assertEqual(result, "noext_" + STAMP + ".xhtml")

    def test_raises_type_error_when_filename_is_not_a_string(self):
        with self.assertRaisesRegex(TypeError, "filename must be a string"):
            append_now_datestamp_to_filename(log=log, filename=None)
