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


class test_logs(unittest.TestCase):

    def tmp_path_for(self, name):
        import tempfile

        tmpDir = tempfile.mkdtemp(prefix="test_logs_" + name + "_")
        self.addCleanup(shutil.rmtree, tmpDir, True)
        return tmpDir

    def test_logs_function(self):
        from fundamentals.logs import emptyLogger

        log = emptyLogger()
        log.error("crap")

        # x-print-testpage-for-pessto-marshall-web-object

    def test_empty_logger_accepts_format_args_and_keyword_args(self):
        from fundamentals.logs import emptyLogger

        log = emptyLogger()

        log.error("could not read %s", 1, exc_info=True)

    def test_group_write_handler_defines_open_and_do_rollover(self):
        from fundamentals.logs import GroupWriteRotatingFileHandler

        self.assertIn("_open", GroupWriteRotatingFileHandler.__dict__)
        self.assertIn("doRollover", GroupWriteRotatingFileHandler.__dict__)

    def test_group_write_handler_rollover_leaves_log_group_writable(self):
        import stat
        from fundamentals.logs import GroupWriteRotatingFileHandler

        logFile = self.tmp_path_for("rollover") + "/rollover.log"
        handler = GroupWriteRotatingFileHandler(logFile, maxBytes=10, backupCount=1)
        try:
            os.chmod(logFile, 0o600)

            handler.doRollover()

            mode = os.stat(logFile).st_mode
            self.assertTrue(mode & stat.S_IWGRP)
            self.assertFalse(mode & stat.S_IWOTH)
        finally:
            handler.close()

    def test_group_write_handler_creates_log_group_writable_not_world_writable(self):
        import stat
        from fundamentals.logs import GroupWriteRotatingFileHandler

        logFile = self.tmp_path_for("create") + "/create.log"
        previous = os.umask(0o022)
        try:
            handler = GroupWriteRotatingFileHandler(logFile)
        finally:
            os.umask(previous)
        try:
            mode = os.stat(logFile).st_mode
            self.assertTrue(mode & stat.S_IWGRP)
            self.assertFalse(mode & stat.S_IWOTH)
        finally:
            handler.close()

    def test_group_write_handler_restores_umask_when_open_fails(self):
        from unittest import mock
        from fundamentals.logs import GroupWriteRotatingFileHandler

        logFile = self.tmp_path_for("umask") + "/umask.log"
        previous = os.umask(0o027)
        try:
            with mock.patch(
                "logging.handlers.RotatingFileHandler._open", side_effect=OSError
            ):
                with self.assertRaises(OSError):
                    GroupWriteRotatingFileHandler(logFile)
            current = os.umask(previous)
        finally:
            os.umask(previous)

        self.assertEqual(current, 0o027)

    # x-class-to-test-named-worker-function


# class test_logs(unittest.TestCase):

#     def test_logs_function(self):
#         kwargs = {}
#         kwargs["log"] = log
#         kwargs["settings"] = settings
#         # xt-kwarg_key_and_value

#         testObject = logs(**kwargs)
#         testObject.get()

#         # x-print-testpage-for-pessto-marshall-web-object

#     # x-class-to-test-named-worker-function
