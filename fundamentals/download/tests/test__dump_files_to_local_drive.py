from __future__ import print_function
import os
import unittest
import shutil
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

import tempfile
from unittest import mock
from fundamentals.download import _dump_files_to_local_drive


class test__dump_files_to_local_drive(unittest.TestCase):

    def setUp(self):
        self.tmpDir = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.tmpDir, ignore_errors=True)
        self.log = mock.Mock()
        self.paths = [os.path.join(self.tmpDir, "file%d.txt" % i) for i in (1, 2, 3)]

    def read(self, path):
        with open(path, "rb") as f:
            return f.read()

    def test_returns_empty_list_when_all_files_written(self):
        bodies = [b"one", b"two", b"three"]

        result = _dump_files_to_local_drive(bodies, self.paths, self.log)

        self.assertEqual(result, [])
        self.assertEqual([self.read(p) for p in self.paths], bodies)

    def test_skips_none_body_writes_the_rest_and_returns_its_path(self):
        bodies = [b"one", None, b"three"]

        result = _dump_files_to_local_drive(bodies, self.paths, self.log)

        self.assertEqual(result, [self.paths[1]])
        self.assertEqual(self.read(self.paths[0]), b"one")
        self.assertEqual(self.read(self.paths[2]), b"three")
        self.assertFalse(os.path.exists(self.paths[1]))
        warning = self.log.warning.call_args[0][0] % self.log.warning.call_args[0][1:]
        self.assertIn(self.paths[1], warning)

    def test_carries_on_after_write_error_and_returns_failed_path(self):
        self.paths[0] = os.path.join(self.tmpDir, "missing_dir", "file1.txt")
        bodies = [b"one", b"two", b"three"]

        result = _dump_files_to_local_drive(bodies, self.paths, self.log)

        self.assertEqual(result, [self.paths[0]])
        self.assertEqual(self.read(self.paths[1]), b"two")
        self.assertEqual(self.read(self.paths[2]), b"three")
        self.log.error.assert_called_once()

    def test_skips_falsy_target_path_without_writing_it(self):
        paths = [self.paths[0], None, self.paths[2]]
        bodies = [b"one", b"two", b"three"]

        result = _dump_files_to_local_drive(bodies, paths, self.log)

        self.assertEqual(result, [])
        self.assertEqual(self.read(self.paths[0]), b"one")
        self.assertEqual(self.read(self.paths[2]), b"three")
