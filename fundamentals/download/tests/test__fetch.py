from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml

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

from socket import timeout as socket_timeout
from unittest import mock
from fundamentals.download._fetch import _fetch

URLOPEN = "urllib.request.urlopen"
TRIES = 10


def make_response(body=b"payload"):
    response = mock.Mock()
    response.read.return_value = body
    return response


class test__fetch(unittest.TestCase):

    def setUp(self):
        self.url = mock.Mock()
        self.url.get_full_url.return_value = "http://example.com/file"

    def test_retries_when_errno_60_timeout_then_succeeds(self):
        errors = [OSError("[Errno 60] Operation timed out")] * 2
        with mock.patch(URLOPEN, side_effect=errors + [make_response()]) as urlopen:
            url, body = _fetch(self.url)

        self.assertEqual(urlopen.call_count, 3)
        self.assertEqual(body, b"payload")
        self.assertIs(url, self.url)

    def test_retries_when_502_proxy_error_then_succeeds(self):
        errors = [Exception("HTTP Error 502: Bad Gateway")]
        with mock.patch(URLOPEN, side_effect=errors + [make_response()]) as urlopen:
            url, body = _fetch(self.url)

        self.assertEqual(urlopen.call_count, 2)
        self.assertEqual(body, b"payload")

    def test_returns_none_after_exactly_ten_calls_when_errno_60_every_time(self):
        error = OSError("[Errno 60] Operation timed out")
        with mock.patch(URLOPEN, side_effect=error) as urlopen:
            result = _fetch(self.url)

        self.assertEqual(urlopen.call_count, TRIES)
        self.assertEqual(result, (None, None))

    def test_returns_none_after_exactly_ten_calls_when_socket_timeout_every_time(self):
        with mock.patch(URLOPEN, side_effect=socket_timeout("timed out")) as urlopen:
            result = _fetch(self.url)

        self.assertEqual(urlopen.call_count, TRIES)
        self.assertEqual(result, (None, None))

    def test_gives_up_after_one_call_when_error_is_unknown(self):
        with mock.patch(URLOPEN, side_effect=Exception("boom")) as urlopen:
            result = _fetch(self.url)

        self.assertEqual(urlopen.call_count, 1)
        self.assertEqual(result, (None, None))
