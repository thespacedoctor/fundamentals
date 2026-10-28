from __future__ import print_function
from builtins import str
import unittest
import unittest
import yaml
from unittest.mock import patch
from fundamentals.download import append_now_datestamp_to_filename
import pytest

STAMP = "20160316t154123"


@pytest.mark.usefixtures("session_attributes")
class test_append_now_datestamp_to_filename(unittest.TestCase):

    def setUp(self):
        patcher = patch(
            "fundamentals.download.get_now_datetime_filestamp", return_value=STAMP
        )
        patcher.start()
        self.addCleanup(patcher.stop)

    def test_keeps_extension_when_filename_has_one_dot(self):
        result = append_now_datestamp_to_filename(log=self.log, filename="a.html")

        self.assertEqual(result, "a_" + STAMP + ".html")

    def test_keeps_last_extension_when_filename_has_two_dots(self):
        result = append_now_datestamp_to_filename(log=self.log, filename="a.b.html")

        self.assertEqual(result, "a.b_" + STAMP + ".html")

    def test_keeps_last_extension_for_tar_gz(self):
        result = append_now_datestamp_to_filename(log=self.log, filename="a.tar.gz")

        self.assertEqual(result, "a.tar_" + STAMP + ".gz")

    def test_adds_no_extension_when_filename_has_none(self):
        result = append_now_datestamp_to_filename(log=self.log, filename="noext")

        self.assertEqual(result, "noext_" + STAMP)

    def test_keeps_folders_when_filename_is_a_path(self):
        result = append_now_datestamp_to_filename(
            log=self.log, filename="some/dir/a.html"
        )

        self.assertEqual(result, "some/dir/a_" + STAMP + ".html")

    def test_raises_type_error_when_filename_is_not_a_string(self):
        with self.assertRaisesRegex(TypeError, "filename must be a string"):
            append_now_datestamp_to_filename(log=self.log, filename=None)
