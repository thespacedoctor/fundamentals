from __future__ import print_function
from builtins import str
import os
import pathlib
import unittest
import shutil
import tempfile
import threading
import unittest
from unittest import mock
import yaml
import pytest
from fundamentals.utKit import SESSION_PLACEHOLDER

pytestmark = pytest.mark.usefixtures("session_names")
# SET FOR THE MODULE BY THE session_names FIXTURE IN THE ROOT conftest.py
log = SESSION_PLACEHOLDER

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


LISTING_TIMEOUT_SECONDS = 5


def list_with_timeout(**kwargs):
    """Run recursive_directory_listing in a daemon thread; return its result or None on timeout."""
    from fundamentals.files import recursive_directory_listing

    result = []
    worker = threading.Thread(
        target=lambda: result.append(recursive_directory_listing(log, **kwargs)),
        daemon=True,
    )
    worker.start()
    worker.join(LISTING_TIMEOUT_SECONDS)
    return None if worker.is_alive() else result[0]


class test_recursive_directory_listing(unittest.TestCase):

    def setUp(self):
        self.baseDir = tempfile.mkdtemp()

    def tearDown(self):
        for root, dirs, files in os.walk(self.baseDir):
            for d in dirs:
                os.chmod(os.path.join(root, d), 0o755)
        shutil.rmtree(self.baseDir)

    @unittest.skipIf(os.geteuid() == 0, "chmod 000 is ignored for root")
    def test_returns_when_subdirectory_is_unreadable(self):
        lockedDir = os.path.join(self.baseDir, "u", "locked")
        os.makedirs(lockedDir)
        os.chmod(lockedDir, 0o000)

        matched = list_with_timeout(baseFolderPath=self.baseDir, whatToList="all")

        self.assertIsNotNone(matched, "listing did not return within the timeout")
        self.assertEqual(
            sorted(matched),
            sorted([os.path.join(self.baseDir, "u"), lockedDir]),
        )

    def test_does_not_loop_on_symlink_to_ancestor(self):
        subDir = os.path.join(self.baseDir, "a", "b")
        os.makedirs(subDir)
        os.symlink(self.baseDir, os.path.join(subDir, "loop"))

        matched = list_with_timeout(baseFolderPath=self.baseDir, whatToList="all")

        self.assertIsNotNone(matched, "listing did not return within the timeout")
        self.assertEqual(
            sorted(matched),
            sorted(
                [
                    os.path.join(self.baseDir, "a"),
                    subDir,
                    os.path.join(subDir, "loop"),
                ]
            ),
        )

    def test_raises_value_error_when_what_to_list_is_invalid(self):
        from fundamentals.files import recursive_directory_listing

        open(os.path.join(self.baseDir, "f.txt"), "w").close()

        with self.assertRaises(ValueError):
            recursive_directory_listing(log, self.baseDir, whatToList="bogus")

    def test_logs_error_when_what_to_list_is_invalid(self):
        from fundamentals.files import recursive_directory_listing

        mockLog = mock.Mock()

        with self.assertRaises(ValueError):
            recursive_directory_listing(mockLog, self.baseDir, whatToList="bogus")

        mockLog.error.assert_called_once()

    def test_raises_value_error_when_what_to_list_is_invalid_for_empty_directory(self):
        from fundamentals.files import recursive_directory_listing

        with self.assertRaises(ValueError):
            recursive_directory_listing(log, self.baseDir, whatToList="bogus")

    def test_raises_file_not_found_error_when_base_folder_is_missing(self):
        from fundamentals.files import recursive_directory_listing

        missingDir = os.path.join(self.baseDir, "missing")

        with self.assertRaises(FileNotFoundError):
            recursive_directory_listing(log, missingDir, whatToList="all")

    def test_raises_file_not_found_error_when_pathlib_base_folder_is_missing(self):
        from fundamentals.files import recursive_directory_listing

        missingDir = pathlib.Path(self.baseDir) / "missing"

        with self.assertRaises(FileNotFoundError):
            recursive_directory_listing(log, missingDir, whatToList="all")

    @unittest.skipIf(os.geteuid() == 0, "chmod 000 is ignored for root")
    def test_raises_permission_error_when_base_folder_is_unreadable(self):
        from fundamentals.files import recursive_directory_listing

        lockedDir = os.path.join(self.baseDir, "locked")
        os.mkdir(lockedDir)
        os.chmod(lockedDir, 0o000)

        with self.assertRaises(PermissionError):
            recursive_directory_listing(log, lockedDir, whatToList="all")

    def test_lists_files_dirs_or_all_with_joined_paths(self):
        os.makedirs(os.path.join(self.baseDir, "d1", "d2"))
        filePath = os.path.join(self.baseDir, "d1", "d2", "f.txt")
        open(filePath, "w").close()
        dirPaths = [
            os.path.join(self.baseDir, "d1"),
            os.path.join(self.baseDir, "d1", "d2"),
        ]

        from fundamentals.files import recursive_directory_listing

        self.assertEqual(
            sorted(recursive_directory_listing(log, self.baseDir, "all")),
            sorted(dirPaths + [filePath]),
        )
        self.assertEqual(
            sorted(recursive_directory_listing(log, self.baseDir, "dirs")),
            sorted(dirPaths),
        )
        self.assertEqual(
            recursive_directory_listing(log, self.baseDir, "files"), [filePath]
        )

    def test_recursive_directory_listing_function(self):

        from fundamentals.files import recursive_directory_listing

        theseFiles = recursive_directory_listing(
            log, baseFolderPath="/tmp", whatToList="all"
        )
        # print(theseFiles)

        from fundamentals.files import recursive_directory_listing

        theseFiles = recursive_directory_listing(
            log, baseFolderPath="/tmp", whatToList="files"
        )
        # print(theseFiles)

        from fundamentals.files import recursive_directory_listing

        theseFiles = recursive_directory_listing(
            log, baseFolderPath="/tmp", whatToList="dirs"
        )
        # print(theseFiles)

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
