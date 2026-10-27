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

import re
from unittest import mock
from fundamentals.download import multiobject_download

FETCH_URL = "fundamentals.download.multiobject_download.fetch_url"
CREDENTIALS = {"username": "alice", "password": "s3cret"}
URLS = ["http://example.com/a.html", "http://example.com/b.html"]


class test_multiobject_download(unittest.TestCase):

    def setUp(self):
        self.entries = []

    def record_fetch(self, entry):
        self.entries.append(entry)
        return entry[1]

    def download(self, urlList=URLS, downloadDirectory="/dl", **kwargs):
        kwargs.setdefault("timeStamp", False)
        with mock.patch(FETCH_URL, side_effect=self.record_fetch):
            result = multiobject_download(
                urlList=urlList, downloadDirectory=downloadDirectory, log=log, **kwargs
            )
        return result, sorted((e[0], e[1]) for e in self.entries)

    def test_applies_credentials_to_every_url_when_download_directory_is_a_list(self):
        self.download(downloadDirectory=["/d1", "/d2"], credentials=CREDENTIALS)

        urls = [e[0] for e in self.entries]
        self.assertEqual(len(urls), 2)
        for url in urls:
            self.assertIn("alice:s3cret@", url)

    def test_single_and_list_directory_forms_give_identical_url_and_path_pairs(self):
        kwargs = {"credentials": CREDENTIALS, "indexFilenames": True}

        _, single = self.download(downloadDirectory="/dl", **kwargs)
        self.entries = []
        _, multiple = self.download(downloadDirectory=["/dl", "/dl"], **kwargs)

        self.assertEqual(single, multiple)

    def test_applies_index_prefix_when_download_directory_is_a_list(self):
        result, _ = self.download(downloadDirectory=["/d1", "/d2"], indexFilenames=True)

        self.assertEqual(result, ["/d1/000_a.html", "/d2/001_b.html"])

    def test_applies_long_timestamp_when_download_directory_is_a_list(self):
        result, _ = self.download(
            downloadDirectory=["/d1", "/d2"], timeStamp=True, longTime=True
        )

        for path in result:
            self.assertRegex(path, r"_\d{8}t\d{12}\.html$")

    def test_string_reset_filename_is_not_split_into_characters(self):
        result, _ = self.download(urlList=URLS[:1], resetFilename="fixed.html")

        self.assertEqual(result, ["/dl/fixed.html"])

    def test_string_reset_filename_applies_when_download_directory_is_a_list(self):
        result, _ = self.download(
            downloadDirectory=["/d1", "/d2"], resetFilename="fixed.html"
        )

        self.assertEqual(result, ["/d1/fixed.html", "/d2/fixed.html"])

    def test_list_reset_filename_applies_per_url_in_both_directory_forms(self):
        names = ["x.html", "y.html"]

        single, _ = self.download(downloadDirectory="/dl", resetFilename=names)
        multiple, _ = self.download(
            downloadDirectory=["/dl", "/dl"], resetFilename=names
        )

        self.assertEqual(single, ["/dl/x.html", "/dl/y.html"])
        self.assertEqual(multiple, single)

    def test_keeps_urls_whose_filename_cannot_be_extracted(self):
        with mock.patch(
            "fundamentals.download.extract_filename_from_url", return_value=None
        ):
            result, _ = self.download(downloadDirectory=["/d1", "/d2"])

        self.assertEqual(len(result), 2)

    def test_raises_value_error_when_directory_list_length_differs_from_url_list(self):
        with self.assertRaises(ValueError):
            self.download(downloadDirectory=["/d1"])

    def test_raises_value_error_when_reset_filename_list_length_differs(self):
        with self.assertRaises(ValueError):
            self.download(resetFilename=["only_one.html"])

    def test_percent_encodes_credentials_so_they_cannot_change_the_host(self):
        self.download(
            urlList=URLS[:1],
            credentials={"username": "al/ice", "password": "p@ss/w:rd"},
        )

        self.assertEqual(
            self.entries[0][0], "http://al%2Fice:p%40ss%2Fw%3Ard@example.com/a.html"
        )
