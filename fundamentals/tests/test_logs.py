from __future__ import print_function
from builtins import str
import os
import logging
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

    def write_logging_yaml(self, name, rootLevel, logFile, consoleLevel="DEBUG"):
        yamlFile = self.tmp_path_for(name) + "/" + name + ".yaml"
        content = (
            "version: 1\n"
            "handlers:\n"
            "    console:\n"
            "        class: logging.StreamHandler\n"
            f"        level: {consoleLevel}\n"
            "    file:\n"
            "        class: logging.handlers.GroupWriteRotatingFileHandler\n"
            "        level: DEBUG\n"
            f"        filename: {logFile}\n"
            + (
                "root:\n"
                f"    level: {rootLevel}\n"
                "    handlers: [file, console]\n"
                if rootLevel is not None
                else ""
            )
        )
        with open(yamlFile, "w") as f:
            f.write(content)
        return yamlFile

    def root_group_write_handler_files(self):
        from fundamentals.logs import GroupWriteRotatingFileHandler

        return [
            h.baseFilename
            for h in logging.getLogger().handlers
            if isinstance(h, GroupWriteRotatingFileHandler)
        ]

    def restore_logging_state_after_test(self):
        rootLogger = logging.getLogger()
        moduleLogger = logging.getLogger("fundamentals.logs")
        savedRoot = (rootLogger.handlers[:], rootLogger.level)
        savedModule = (moduleLogger.handlers[:], moduleLogger.level)

        def restore():
            for logger, (savedHandlers, savedLevel) in (
                (rootLogger, savedRoot),
                (moduleLogger, savedModule),
            ):
                for handler in logger.handlers[:]:
                    if handler not in savedHandlers:
                        handler.close()
                logger.handlers[:] = savedHandlers
                logger.setLevel(savedLevel)

        self.addCleanup(restore)

    def test_setup_dryx_logging_second_call_applies_second_yaml_handlers_and_levels(
        self,
    ):
        from fundamentals.logs import setup_dryx_logging

        self.restore_logging_state_after_test()
        firstLog = self.tmp_path_for("first") + "/first.log"
        secondLog = self.tmp_path_for("second") + "/second.log"
        firstYaml = self.write_logging_yaml("first", "WARNING", firstLog)
        secondYaml = self.write_logging_yaml("second", "DEBUG", secondLog, "ERROR")
        setup_dryx_logging(yaml_file=firstYaml)

        logger = setup_dryx_logging(yaml_file=secondYaml)

        rootFiles = self.root_group_write_handler_files()
        self.assertEqual(rootFiles, [os.path.abspath(secondLog)])
        self.assertEqual(logging.getLogger().level, logging.DEBUG)
        consoleHandlers = [h for h in logger.handlers if h.name == "consoleLog"]
        self.assertEqual(len(consoleHandlers), 1)
        self.assertEqual(consoleHandlers[0].level, logging.ERROR - 6)

    def test_setup_dryx_logging_repeat_call_with_same_yaml_does_not_duplicate_handlers(
        self,
    ):
        from fundamentals.logs import setup_dryx_logging

        self.restore_logging_state_after_test()
        logFile = self.tmp_path_for("repeat") + "/repeat.log"
        yamlFile = self.write_logging_yaml("repeat", "WARNING", logFile)
        setup_dryx_logging(yaml_file=yamlFile)

        logger = setup_dryx_logging(yaml_file=yamlFile)

        self.assertEqual(
            len([h for h in logger.handlers if h.name == "consoleLog"]), 1
        )
        self.assertEqual(len(self.root_group_write_handler_files()), 1)

    def test_setup_dryx_logging_defaults_to_info_when_yaml_has_no_root_key(self):
        from fundamentals.logs import setup_dryx_logging

        self.restore_logging_state_after_test()
        logFile = self.tmp_path_for("noroot") + "/noroot.log"
        yamlFile = self.write_logging_yaml("noroot", None, logFile)

        logger = setup_dryx_logging(yaml_file=yamlFile)

        self.assertEqual(logger.getEffectiveLevel(), logging.INFO)

    def test_setup_dryx_logging_raises_value_error_naming_invalid_level(self):
        from fundamentals.logs import setup_dryx_logging

        self.restore_logging_state_after_test()
        logFile = self.tmp_path_for("badlevel") + "/badlevel.log"
        yamlFile = self.write_logging_yaml(
            "badlevel", "WARNING", logFile, consoleLevel="LOUD"
        )

        with self.assertRaises(ValueError) as raised:
            setup_dryx_logging(yaml_file=yamlFile)

        self.assertIn("LOUD", str(raised.exception))

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
