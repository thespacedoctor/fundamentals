from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import pytest

pytestmark = pytest.mark.usefixtures("session_names")
# INJECTED BY THE session_names FIXTURE IN THE ROOT conftest.py (PYTEST ONLY)
log = None

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

class test_extract_filename_from_url(unittest.TestCase):
    def test_returns_html_filename_for_plain_url(self):
        from fundamentals.download import extract_filename_from_url

        filename = extract_filename_from_url(
            log=log, url="https://en.wikipedia.org/wiki/Docstring"
        )
        self.assertEqual(filename, "Docstring.html")

    def test_keeps_extension_for_plain_url_with_extension(self):
        from fundamentals.download import extract_filename_from_url

        filename = extract_filename_from_url(log=log, url="http://x.org/files/data.pdf")
        self.assertEqual(filename, "data.pdf")

    def test_ignores_query_string(self):
        from fundamentals.download import extract_filename_from_url

        filename = extract_filename_from_url(log=log, url="http://x.org/a.php?id=3")
        self.assertEqual(filename, "a.php")

    def test_ignores_query_string_when_path_has_no_extension(self):
        from fundamentals.download import extract_filename_from_url

        filename = extract_filename_from_url(log=log, url="http://x.org/page?id=3.5")
        self.assertEqual(filename, "page.html")

    def test_ignores_fragment(self):
        from fundamentals.download import extract_filename_from_url

        filename = extract_filename_from_url(
            log=log, url="http://x.org/doc.html#section.2"
        )
        self.assertEqual(filename, "doc.html")

    def test_does_not_log_the_credentials_in_the_url(self):
        from unittest import mock
        from fundamentals.download import extract_filename_from_url

        for url in (
            "http://alice:s3cret@x.org/files/data.pdf",
            "alice:s3cret@x.org/files/data.pdf",
            "http://alice:p@ss@x.org/files/data.pdf",
        ):
            with self.subTest(url=url):
                testLog = mock.Mock()

                filename = extract_filename_from_url(log=testLog, url=url)

                logged = str(testLog.mock_calls)
                self.assertEqual(filename, "data.pdf")
                self.assertNotIn("s3cret", logged)
                self.assertNotIn("alice", logged)
                self.assertNotIn("ss@", logged)
                self.assertIn("x.org/files/data.pdf", logged)

    def test_still_logs_a_url_that_has_no_credentials_unchanged(self):
        from unittest import mock
        from fundamentals.download import extract_filename_from_url

        testLog = mock.Mock()

        extract_filename_from_url(log=testLog, url="http://x.org/a.php?email=a@b.org")

        testLog.debug.assert_any_call(
            "extracting filename from url http://x.org/a.php?email=a@b.org"
        )

    def test_returns_untitled_when_url_ends_with_trailing_slash(self):
        from fundamentals.download import extract_filename_from_url

        filename = extract_filename_from_url(log=log, url="http://x.org/dir/")
        self.assertEqual(filename, "untitled.html")

    def test_returns_untitled_for_host_with_trailing_slash(self):
        from fundamentals.download import extract_filename_from_url

        filename = extract_filename_from_url(log=log, url="http://x.org/")
        self.assertEqual(filename, "untitled.html")

    def test_returns_untitled_for_bare_host(self):
        from fundamentals.download import extract_filename_from_url

        filename = extract_filename_from_url(log=log, url="http://x.org")
        self.assertEqual(filename, "untitled.html")
