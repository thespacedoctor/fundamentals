import logging
import os
import shutil
import stat
import subprocess
import sys
import tempfile
import unittest

import fundamentals

PROJECT_ROOT = os.path.dirname(os.path.dirname(fundamentals.__file__))


class test_test_logging_setup(unittest.TestCase):

    def run_python(self, code, env=None):
        return subprocess.run(
            [sys.executable, "-c", code],
            cwd=PROJECT_ROOT,
            env={**os.environ, "PYTHONPATH": PROJECT_ROOT, **(env or {})},
            capture_output=True,
            text=True,
        )

    def test_group_write_handler_resolves_in_dict_config_once_logs_is_imported(self):
        code = (
            "import logging.config, fundamentals.logs\n"
            "logging.config.dictConfig({'version': 1, 'handlers': {'file': {"
            "'class': 'logging.handlers.GroupWriteRotatingFileHandler', "
            "'filename': '/dev/null'}}, 'root': {'handlers': ['file']}})\n"
        )

        result = self.run_python(code)

        self.assertEqual(result.returncode, 0, result.stderr)

    def test_setup_dryx_logging_keeps_existing_loggers_enabled(self):
        from fundamentals.logs import setup_dryx_logging

        existing = logging.getLogger("test_test_logging_setup.existing")
        rootLogger = logging.getLogger()
        savedHandlers, savedLevel = rootLogger.handlers[:], rootLogger.level
        self.addCleanup(rootLogger.setLevel, savedLevel)
        self.addCleanup(setattr, rootLogger, "handlers", savedHandlers)
        yamlFile = self.write_file_logging_yaml()

        setup_dryx_logging(yaml_file=yamlFile)

        self.assertFalse(existing.disabled)

    def test_utkit_setup_module_keeps_existing_loggers_enabled(self):
        from fundamentals.utKit import utKit
        from unittest import mock

        existing = logging.getLogger("test_test_logging_setup.utkit_existing")
        rootLogger = logging.getLogger()
        savedHandlers, savedLevel = rootLogger.handlers[:], rootLogger.level
        self.addCleanup(rootLogger.setLevel, savedLevel)
        self.addCleanup(setattr, rootLogger, "handlers", savedHandlers)

        with mock.patch("pymysql.connect"):
            utKit(os.path.dirname(__file__)).setupModule()

        self.assertFalse(existing.disabled)

    def test_collection_succeeds_when_home_is_read_only(self):
        homeDir = tempfile.mkdtemp(prefix="test_readonly_home_")
        self.addCleanup(shutil.rmtree, homeDir, True)
        os.chmod(homeDir, stat.S_IRUSR | stat.S_IXUSR)
        self.addCleanup(os.chmod, homeDir, stat.S_IRWXU)

        result = subprocess.run(
            [
                sys.executable,
                "-m",
                "pytest",
                "fundamentals/tests/test_logs.py",
                "--collect-only",
                "-q",
                "-p",
                "no:cacheprovider",
            ],
            cwd=PROJECT_ROOT,
            env={**os.environ, "HOME": homeDir},
            capture_output=True,
            text=True,
        )

        self.assertEqual(result.returncode, 0, result.stdout[-2000:])

    def write_file_logging_yaml(self):
        tmpDir = tempfile.mkdtemp(prefix="test_test_logging_setup_")
        self.addCleanup(shutil.rmtree, tmpDir, True)
        yamlFile = tmpDir + "/logging.yaml"
        with open(yamlFile, "w") as f:
            f.write(
                "version: 1\n"
                "handlers:\n"
                "    file:\n"
                "        class: logging.handlers.GroupWriteRotatingFileHandler\n"
                f"        filename: {tmpDir}/x.log\n"
                "root:\n"
                "    level: WARNING\n"
                "    handlers: [file]\n"
            )
        return yamlFile
