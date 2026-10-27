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
