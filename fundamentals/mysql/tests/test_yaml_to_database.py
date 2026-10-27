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

# xt-setup-unit-testing-files-and-folders


class test_yaml_to_database(unittest.TestCase):

    def test_single_yaml_to_database_function(self):
        # COPY INPUT TO OUTPUT DIR
        import shutil

        try:
            shutil.rmtree(pathToOutputDir)
        except:
            pass
        # COPY INPUT TO OUTPUT DIR
        shutil.copytree(pathToInputDir, pathToOutputDir)

        from fundamentals.mysql import yaml_to_database

        yaml2db = yaml_to_database(
            log=log,
            settings=settings,
            dbConn=dbConn,
            pathToInputDir=pathToOutputDir + "yaml",
        )
        yaml2db.add_yaml_file_content_to_database(
            filepath=pathToOutputDir + "yaml/20161219105124.yaml"
        )

    def test_yaml_to_database_function(self):

        from fundamentals.mysql import yaml_to_database

        yaml2db = yaml_to_database(
            log=log,
            settings=settings,
            dbConn=dbConn,
            pathToInputDir=pathToOutputDir + "/yaml",
        )
        yaml2db.ingest()

    def test_yaml_to_database_function_exception(self):

        from fundamentals.mysql import yaml_to_database

        try:
            this = yaml_to_database(
                log=log, settings=settings, dbConn=dbConn, fakeKey="break the code"
            )
            this.get()
            assert False
        except Exception as e:
            assert True
            # print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function


def test_empty_value_in_yaml_file_does_not_raise(tmp_path):
    import requests
    from unittest import mock
    from fundamentals.mysql import yaml_to_database

    yamlFile = tmp_path / "empty_value.yaml"
    yamlFile.write_text("table: test_table\ntitle: \nurl: http://example.com\n")
    yaml2db = yaml_to_database(log=mock.Mock(), dbConn=mock.Mock())

    with mock.patch(
        "fundamentals.mysql.yaml_to_database.convert_dictionary_to_mysql_table"
    ) as convert, mock.patch("requests.head", side_effect=requests.ConnectionError):
        yaml2db.add_yaml_file_content_to_database(filepath=str(yamlFile))

    dictionary = convert.call_args.kwargs["dictionary"]
    assert dictionary["title"] == ""


def _ingest_yaml_with_url(tmp_path, url, headSideEffect=None, headReturn=None):
    """
    Run a one-line yaml file through the ingester with ``requests.head`` and the database writer mocked. Return the ``head`` mock and the dictionary passed to the writer.
    """
    from unittest import mock
    from fundamentals.mysql import yaml_to_database

    yamlFile = tmp_path / "url.yaml"
    yamlFile.write_text("table: test_table\ntitle: a title\nurl: %s\n" % (url,))
    yaml2db = yaml_to_database(log=mock.Mock(), dbConn=mock.Mock())

    with mock.patch(
        "fundamentals.mysql.yaml_to_database.convert_dictionary_to_mysql_table"
    ) as convert, mock.patch(
        "requests.head", side_effect=headSideEffect, return_value=headReturn
    ) as head:
        yaml2db.add_yaml_file_content_to_database(filepath=str(yamlFile))

    return head, convert.call_args.kwargs["dictionary"]


def test_url_lookup_uses_a_ten_second_timeout(tmp_path):
    from unittest import mock

    response = mock.Mock(url="http://example.com/final")

    head, dictionary = _ingest_yaml_with_url(
        tmp_path, "http://example.com/short", headReturn=response
    )

    assert head.call_args.kwargs["timeout"] == 10
    assert dictionary["url"] == "http://example.com/final"


def test_url_lookup_is_skipped_for_non_http_schemes(tmp_path):
    head, dictionary = _ingest_yaml_with_url(tmp_path, "file:///etc/passwd")

    head.assert_not_called()
    assert dictionary["url"] == "file:///etc/passwd"


def test_original_url_is_kept_when_request_raises_request_exception(tmp_path):
    import requests

    head, dictionary = _ingest_yaml_with_url(
        tmp_path, "http://example.com/short", headSideEffect=requests.Timeout
    )

    assert dictionary["url"] == "http://example.com/short"


def test_original_url_is_kept_when_url_is_malformed(tmp_path):
    head, dictionary = _ingest_yaml_with_url(tmp_path, "http://[not-a-host")

    head.assert_not_called()
    assert dictionary["url"] == "http://[not-a-host"


def test_unexpected_exceptions_from_url_lookup_are_not_swallowed(tmp_path):
    import pytest

    with pytest.raises(KeyboardInterrupt):
        _ingest_yaml_with_url(
            tmp_path, "http://example.com/short", headSideEffect=KeyboardInterrupt
        )


def test_yaml_without_url_is_added_without_a_request(tmp_path):
    from unittest import mock
    from fundamentals.mysql import yaml_to_database

    yamlFile = tmp_path / "nourl.yaml"
    yamlFile.write_text("table: test_table\ntitle: a title\n")
    yaml2db = yaml_to_database(log=mock.Mock(), dbConn=mock.Mock())

    with mock.patch(
        "fundamentals.mysql.yaml_to_database.convert_dictionary_to_mysql_table"
    ) as convert, mock.patch("requests.head") as head:
        yaml2db.add_yaml_file_content_to_database(filepath=str(yamlFile))

    head.assert_not_called()
    assert "url" not in convert.call_args.kwargs["dictionary"]
    assert convert.call_args.kwargs["uniqueKeyList"] == []


def test_ingesting_a_yaml_file_leaves_urllib3_warnings_enabled(tmp_path):
    import warnings
    import requests
    from urllib3.exceptions import InsecureRequestWarning

    with warnings.catch_warnings(record=True) as caught:
        warnings.simplefilter("always")
        _ingest_yaml_with_url(
            tmp_path, "http://example.com/short", headSideEffect=requests.Timeout
        )
        warnings.warn("tls check", InsecureRequestWarning)

    assert [w for w in caught if w.category is InsecureRequestWarning]
