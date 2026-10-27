from __future__ import print_function
from builtins import str
import contextlib
import os
import unittest
import shutil
import unittest
import pytest
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
    ) as convert, _patched_head(side_effect=requests.ConnectionError):
        yaml2db.add_yaml_file_content_to_database(filepath=str(yamlFile))

    dictionary = convert.call_args.kwargs["dictionary"]
    assert dictionary["title"] == ""


PUBLIC_IP = "93.184.216.34"


@contextlib.contextmanager
def _patched_head(side_effect=None, return_value=None):
    """
    Replace ``requests.Session`` with a mock session and yield its ``head`` mock. The session mock is available as ``head.session``.
    """
    from unittest import mock

    session = mock.MagicMock()
    session.__enter__.return_value = session
    session.head.side_effect = side_effect
    session.head.return_value = return_value
    session.head.session = session
    with mock.patch("requests.Session", return_value=session):
        yield session.head


def _fake_getaddrinfo(hostIps):
    """
    Build a ``socket.getaddrinfo`` stand-in resolving each host to the address in ``hostIps`` (default ``PUBLIC_IP``).
    """

    def getaddrinfo(host, port, *args, **kwargs):
        ip = hostIps.get(host, PUBLIC_IP)
        family = 10 if ":" in ip else 2
        return [(family, 1, 6, "", (ip, 0))]

    return getaddrinfo


def _redirect(location, status=301):
    from unittest import mock

    return mock.Mock(status_code=status, headers={"Location": location})


def _final_response():
    from unittest import mock

    return mock.Mock(status_code=200, headers={})


def _ingest_yaml_with_url(
    tmp_path, url, headSideEffect=None, headReturn=None, hostIps=None, log=None
):
    """
    Run a one-line yaml file through the ingester with ``requests.Session``, ``socket.getaddrinfo`` and the database writer mocked. Return the ``head`` mock and the dictionary passed to the writer.
    """
    from unittest import mock
    from fundamentals.mysql import yaml_to_database

    yamlFile = tmp_path / "url.yaml"
    yamlFile.write_text("table: test_table\ntitle: a title\nurl: %s\n" % (url,))
    yaml2db = yaml_to_database(log=log or mock.Mock(), dbConn=mock.Mock())

    with mock.patch(
        "fundamentals.mysql.yaml_to_database.convert_dictionary_to_mysql_table"
    ) as convert, _patched_head(headSideEffect, headReturn) as head, mock.patch(
        "socket.getaddrinfo", side_effect=_fake_getaddrinfo(hostIps or {})
    ):
        yaml2db.add_yaml_file_content_to_database(filepath=str(yamlFile))

    return head, convert.call_args.kwargs["dictionary"]


def test_url_lookup_uses_a_ten_second_timeout(tmp_path):
    head, dictionary = _ingest_yaml_with_url(
        tmp_path, "http://example.com/short", headReturn=_final_response()
    )

    assert head.call_args.kwargs["timeout"] == 10
    assert head.call_args.kwargs["allow_redirects"] is False


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
    ) as convert, _patched_head() as head:
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


@pytest.mark.parametrize(
    "url,ip",
    [
        ("http://localhost/x", "127.0.0.1"),
        ("http://metadata.internal/", "169.254.169.254"),
        ("http://intranet.example/", "10.0.0.5"),
        ("http://intranet.example/", "192.168.1.10"),
        ("http://multicast.example/", "224.0.0.1"),
        ("http://reserved.example/", "240.0.0.1"),
        ("http://any.example/", "0.0.0.0"),
        ("http://v6.example/", "::1"),
        ("http://v6.example/", "fe80::1"),
        ("http://mapped.example/", "::ffff:127.0.0.1"),
    ],
)
def test_no_request_is_made_when_host_resolves_to_a_non_public_address(
    tmp_path, url, ip
):
    from urllib.parse import urlparse

    hostIps = {urlparse(url).hostname: ip}

    head, dictionary = _ingest_yaml_with_url(
        tmp_path, url, headReturn=_final_response(), hostIps=hostIps
    )

    head.assert_not_called()
    assert dictionary["url"] == url


def test_no_request_is_made_when_any_resolved_address_is_non_public(tmp_path):
    from unittest import mock
    from fundamentals.mysql import yaml_to_database

    yamlFile = tmp_path / "url.yaml"
    yamlFile.write_text("table: t\nurl: http://mixed.example/\n")
    yaml2db = yaml_to_database(log=mock.Mock(), dbConn=mock.Mock())
    addresses = [(2, 1, 6, "", (PUBLIC_IP, 0)), (2, 1, 6, "", ("127.0.0.1", 0))]

    with mock.patch(
        "fundamentals.mysql.yaml_to_database.convert_dictionary_to_mysql_table"
    ) as convert, _patched_head() as head, mock.patch(
        "socket.getaddrinfo", return_value=addresses
    ):
        yaml2db.add_yaml_file_content_to_database(filepath=str(yamlFile))

    head.assert_not_called()
    assert convert.call_args.kwargs["dictionary"]["url"] == "http://mixed.example/"


def test_no_request_is_made_for_a_url_with_credentials(tmp_path):
    url = "http://user:secret@example.com/path"

    head, dictionary = _ingest_yaml_with_url(
        tmp_path, url, headReturn=_final_response()
    )

    head.assert_not_called()
    assert dictionary["url"] == url


def test_original_url_is_kept_and_warning_logged_when_dns_lookup_fails(tmp_path):
    import socket
    from unittest import mock
    from fundamentals.mysql import yaml_to_database

    yamlFile = tmp_path / "url.yaml"
    yamlFile.write_text("table: t\nurl: http://nosuchhost.invalid/\n")
    log = mock.Mock()
    yaml2db = yaml_to_database(log=log, dbConn=mock.Mock())

    with mock.patch(
        "fundamentals.mysql.yaml_to_database.convert_dictionary_to_mysql_table"
    ) as convert, _patched_head() as head, mock.patch(
        "socket.getaddrinfo", side_effect=socket.gaierror
    ):
        yaml2db.add_yaml_file_content_to_database(filepath=str(yamlFile))

    head.assert_not_called()
    log.warning.assert_called()
    assert convert.call_args.kwargs["dictionary"]["url"] == "http://nosuchhost.invalid/"


def test_redirect_to_an_internal_host_is_not_requested_and_original_url_is_kept(
    tmp_path,
):
    url = "http://public.example/short"

    head, dictionary = _ingest_yaml_with_url(
        tmp_path,
        url,
        headSideEffect=[_redirect("http://169.254.169.254/latest/meta-data/")],
        hostIps={"169.254.169.254": "169.254.169.254"},
    )

    assert head.call_count == 1
    assert head.call_args.args[0] == url
    assert dictionary["url"] == url


def test_public_redirect_chain_stores_the_final_url_with_relative_locations(tmp_path):
    head, dictionary = _ingest_yaml_with_url(
        tmp_path,
        "http://short.example/abc",
        headSideEffect=[
            _redirect("https://long.example/a/b", status=302),
            _redirect("../c/final", status=308),
            _final_response(),
        ],
    )

    assert [c.args[0] for c in head.call_args_list] == [
        "http://short.example/abc",
        "https://long.example/a/b",
        "https://long.example/c/final",
    ]
    assert all(c.kwargs["timeout"] == 10 for c in head.call_args_list)
    assert all(c.kwargs["allow_redirects"] is False for c in head.call_args_list)
    assert dictionary["url"] == "https://long.example/c/final"


def test_original_url_is_kept_when_redirect_hop_limit_is_exceeded(tmp_path):
    import importlib
    from unittest import mock

    module = importlib.import_module("fundamentals.mysql.yaml_to_database")
    url = "http://loop.example/a"
    log = mock.Mock()

    head, dictionary = _ingest_yaml_with_url(
        tmp_path, url, headReturn=_redirect("http://loop.example/a"), log=log
    )

    assert head.call_count == module.MAX_REDIRECT_HOPS + 1
    assert dictionary["url"] == url
    log.warning.assert_called()


def test_warning_is_logged_when_the_url_request_fails(tmp_path):
    from unittest import mock
    import requests

    log = mock.Mock()

    _ingest_yaml_with_url(
        tmp_path, "http://example.com/short", headSideEffect=requests.Timeout, log=log
    )

    log.warning.assert_called()


def test_warning_is_logged_when_the_url_is_malformed(tmp_path):
    from unittest import mock

    log = mock.Mock()

    _ingest_yaml_with_url(tmp_path, "http://[not-a-host", log=log)

    log.warning.assert_called()


def test_no_warning_is_logged_when_yaml_has_no_url(tmp_path):
    from unittest import mock
    from fundamentals.mysql import yaml_to_database

    yamlFile = tmp_path / "nourl.yaml"
    yamlFile.write_text("table: test_table\ntitle: a title\n")
    log = mock.Mock()
    yaml2db = yaml_to_database(log=log, dbConn=mock.Mock())

    with mock.patch(
        "fundamentals.mysql.yaml_to_database.convert_dictionary_to_mysql_table"
    ):
        yaml2db.add_yaml_file_content_to_database(filepath=str(yamlFile))

    log.warning.assert_not_called()


def test_url_lookup_ignores_proxy_environment_variables(tmp_path):
    head, dictionary = _ingest_yaml_with_url(
        tmp_path, "http://example.com/short", headReturn=_final_response()
    )

    assert head.session.trust_env is False


def test_url_lookup_closes_its_session(tmp_path):
    head, dictionary = _ingest_yaml_with_url(
        tmp_path, "http://example.com/short", headReturn=_final_response()
    )

    head.session.__exit__.assert_called_once()


@pytest.mark.parametrize("url", ["http://exämple.com/x", "http://例え.jp/"])
def test_no_request_is_made_for_a_non_ascii_hostname(tmp_path, url):
    from unittest import mock

    log = mock.Mock()

    head, dictionary = _ingest_yaml_with_url(
        tmp_path, url, headReturn=_final_response(), log=log
    )

    head.assert_not_called()
    log.warning.assert_called()
    assert dictionary["url"] == url
