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

import sys
import tempfile
from multiprocessing.pool import ThreadPool
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

    def test_prefixes_credentials_when_url_has_no_scheme(self):
        self.download(urlList=["example.com/a.html"], credentials=CREDENTIALS)

        self.assertEqual(self.entries[0][0], "alice:s3cret@example.com/a.html")

    def test_percent_encodes_credentials_so_they_cannot_change_the_host(self):
        self.download(
            urlList=URLS[:1],
            credentials={"username": "al/ice", "password": "p@ss/w:rd"},
        )

        self.assertEqual(
            self.entries[0][0], "http://al%2Fice:p%40ss%2Fw%3Ard@example.com/a.html"
        )


REQUESTS_GET = "fundamentals.download.multiobject_download.requests.get"
THREAD_POOL = "fundamentals.download.multiobject_download.ThreadPool"
MODULE_TIME = "fundamentals.download.multiobject_download.time"
THREE_URLS = [
    "http://example.com/a.html",
    "http://example.com/b.html",
    "http://example.com/c.html",
]


def make_response(chunks=(b"data",), status=200, streamError=None):
    response = mock.Mock()
    response.status_code = status

    def iter_content(chunk_size):
        for chunk in chunks:
            yield chunk
        if streamError:
            raise streamError

    response.iter_content.side_effect = iter_content
    return response


class test_multiobject_download_fetching(unittest.TestCase):

    def setUp(self):
        self.tmpDir = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, self.tmpDir, ignore_errors=True)
        self.log = mock.Mock()
        sleepPatch = mock.patch(MODULE_TIME)
        sleepPatch.start()
        self.addCleanup(sleepPatch.stop)

    def download(self, responses, urlList=THREE_URLS, log=None, **kwargs):
        kwargs.setdefault("timeStamp", False)
        with mock.patch(REQUESTS_GET, side_effect=lambda uri, **kw: responses[uri]):
            return multiobject_download(
                urlList=urlList,
                downloadDirectory=self.tmpDir,
                log=log or self.log,
                **kwargs,
            )

    def path(self, name):
        return os.path.join(self.tmpDir, name)

    def test_failed_stream_gives_none_in_its_slot_and_leaves_no_partial_file(self):
        responses = {
            THREE_URLS[0]: make_response([b"aa"]),
            THREE_URLS[1]: make_response([b"b"], streamError=OSError("reset")),
            THREE_URLS[2]: make_response([b"cc"]),
        }

        result = self.download(responses)

        self.assertEqual(result, [self.path("a.html"), None, self.path("c.html")])
        self.assertFalse(os.path.exists(self.path("b.html")))
        with open(self.path("c.html"), "rb") as f:
            self.assertEqual(f.read(), b"cc")

    def test_closes_response_when_status_is_not_200(self):
        response = make_response(status=404)

        result = self.download({THREE_URLS[0]: response}, urlList=THREE_URLS[:1])

        self.assertEqual(result, [None])
        response.close.assert_called()

    def test_closes_response_after_successful_download(self):
        response = make_response()

        self.download({THREE_URLS[0]: response}, urlList=THREE_URLS[:1])

        response.close.assert_called_once_with()

    def test_streams_in_large_chunks(self):
        response = make_response()

        self.download({THREE_URLS[0]: response}, urlList=THREE_URLS[:1])

        response.iter_content.assert_called_once_with(65536)

    def test_passes_timeout_to_requests(self):
        response = make_response()
        with mock.patch(REQUESTS_GET, return_value=response) as get:
            multiobject_download(
                urlList=THREE_URLS[:1],
                downloadDirectory=self.tmpDir,
                log=self.log,
                timeout=7,
            )

        self.assertEqual(get.call_args.kwargs["timeout"], 7.0)

    def test_each_call_logs_to_its_own_logger_even_when_calls_overlap(self):
        logA, logB = mock.Mock(), mock.Mock()
        notFound = make_response(status=404)
        nested = []

        def getWithNestedCall(uri, **kwargs):
            # START A SECOND DOWNLOAD WHILE THE FIRST IS IN PROGRESS
            if not nested:
                nested.append(True)
                self.download(
                    {THREE_URLS[0]: notFound}, urlList=THREE_URLS[:1], log=logB
                )
            return notFound

        with mock.patch(REQUESTS_GET, side_effect=getWithNestedCall):
            multiobject_download(
                urlList=THREE_URLS[:1],
                downloadDirectory=self.tmpDir,
                log=logA,
                timeStamp=False,
            )

        self.assertGreater(logA.warning.call_count, 0)
        self.assertGreater(logB.warning.call_count, 0)

    def test_module_has_no_shared_timeout_or_logger_globals(self):
        moduleUnderTest = sys.modules["fundamentals.download.multiobject_download"]

        self.assertFalse(hasattr(moduleUnderTest, "gtimeout"))
        self.assertFalse(hasattr(moduleUnderTest, "llog"))

    def test_shuts_down_the_thread_pool_after_downloading(self):
        pool = ThreadPool(1)
        pool.terminate = mock.Mock(wraps=pool.terminate)

        with mock.patch(THREAD_POOL, return_value=pool):
            self.download({THREE_URLS[0]: make_response()}, urlList=THREE_URLS[:1])

        pool.terminate.assert_called_once_with()

    def test_never_logs_credentials_or_urls_containing_them(self):
        secretUrl = "http://alice:s3cret@example.com/a.html"
        error = OSError("cannot reach " + secretUrl)

        with mock.patch(REQUESTS_GET, side_effect=error):
            result = multiobject_download(
                urlList=THREE_URLS[:1],
                downloadDirectory=self.tmpDir,
                log=self.log,
                timeStamp=False,
                credentials=CREDENTIALS,
            )

        self.assertEqual(result, [None])
        logged = str(self.log.mock_calls)
        self.assertNotIn("s3cret", logged)
        self.assertNotIn("alice", logged)

    def test_retries_a_request_exception_and_then_succeeds(self):
        import requests

        responses = [requests.ConnectionError("down"), make_response([b"ok"])]

        with mock.patch(REQUESTS_GET, side_effect=responses) as get:
            result = multiobject_download(
                urlList=THREE_URLS[:1],
                downloadDirectory=self.tmpDir,
                log=self.log,
                timeStamp=False,
            )

        self.assertEqual(result, [self.path("a.html")])
        self.assertEqual(get.call_count, 2)

    def test_does_not_retry_a_local_os_error_and_removes_the_partial_file(self):
        secretUrl = "http://alice:s3cret@example.com/a.html"
        response = make_response(
            [b"half"], streamError=OSError(28, "No space left " + secretUrl)
        )

        with mock.patch(REQUESTS_GET, return_value=response) as get:
            result = multiobject_download(
                urlList=THREE_URLS[:1],
                downloadDirectory=self.tmpDir,
                log=self.log,
                timeStamp=False,
            )

        self.assertEqual(result, [None])
        self.assertEqual(get.call_count, 1)
        self.assertFalse(os.path.exists(self.path("a.html")))

    def test_logs_the_file_path_and_error_type_but_not_the_message_for_a_local_os_error(
        self,
    ):
        secretUrl = "http://alice:s3cret@example.com/a.html"
        response = make_response(
            [b"half"], streamError=PermissionError("denied " + secretUrl)
        )

        with mock.patch(REQUESTS_GET, return_value=response):
            multiobject_download(
                urlList=THREE_URLS[:1],
                downloadDirectory=self.tmpDir,
                log=self.log,
                timeStamp=False,
            )

        logged = str(self.log.error.mock_calls + self.log.warning.mock_calls)
        self.assertIn(self.path("a.html"), logged)
        self.assertIn("PermissionError", logged)
        self.assertNotIn("s3cret", logged)
        self.assertNotIn("example.com", logged)

    def test_does_not_retry_when_the_download_file_cannot_be_opened(self):
        missingPath = os.path.join(self.tmpDir, "missing", "a.html")
        entry = (THREE_URLS[0], missingPath, 5, self.log)

        with mock.patch(REQUESTS_GET, return_value=make_response()) as get:
            result = sys.modules[
                "fundamentals.download.multiobject_download"
            ].fetch_url(entry)

        self.assertIsNone(result)
        self.assertEqual(get.call_count, 1)
