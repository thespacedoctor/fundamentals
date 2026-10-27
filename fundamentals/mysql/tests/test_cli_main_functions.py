import importlib
import unittest
from unittest import mock

from docopt import docopt

import fundamentals.mysql


def _run_main(moduleName, argv, workOwner, workName):
    """
    *run a cl ``main`` with real docopt arguments, the settings setup and the work object mocked*

    Returns the mocked work object, the settings, the logger and the db connection handed to ``main``.
    """
    module = importlib.import_module(moduleName)
    arguments = docopt(module.__doc__, argv=argv)
    log = mock.MagicMock()
    dbConn = mock.sentinel.dbConn
    settings = {"database settings": {}}
    with (
        mock.patch.object(module, "tools") as toolsMock,
        mock.patch.object(workOwner or module, workName) as workMock,
    ):
        toolsMock.return_value.setup.return_value = (arguments, settings, log, dbConn)
        module.main(arguments=arguments)
    return workMock, settings, log, dbConn


class test_sqlite2mysql_main(unittest.TestCase):

    def test_passes_docopt_values_to_the_converter(self):
        workMock, settings, log, dbConn = _run_main(
            "fundamentals.mysql.sqlite2mysql",
            ["-s", "settings.yaml", "my.sqlite", "pfx"],
            fundamentals.mysql,
            "sqlite2mysql",
        )

        workMock.assert_called_once_with(
            log=log,
            settings=settings,
            pathToSqlite="my.sqlite",
            tablePrefix="pfx",
            dbConn=dbConn,
        )
        workMock.return_value.convert_sqlite_to_mysql.assert_called_once_with()


class test_directory_script_runner_main(unittest.TestCase):

    def test_passes_docopt_values_to_the_runner(self):
        workMock, _, log, _ = _run_main(
            "fundamentals.mysql.directory_script_runner",
            ["/scripts", "myLogin", "myDb", "-s", "delete", "-f", "NONE"],
            None,
            "directory_script_runner",
        )

        workMock.assert_called_once_with(
            log=log,
            pathToScriptDirectory="/scripts",
            databaseName="myDb",
            loginPath="myLogin",
            successRule="delete",
            failureRule=None,
        )

    def test_defaults_rules_to_none_when_flags_omitted(self):
        workMock, _, _, _ = _run_main(
            "fundamentals.mysql.directory_script_runner",
            ["/scripts", "myLogin", "myDb"],
            None,
            "directory_script_runner",
        )

        kwargs = workMock.call_args.kwargs
        self.assertIsNone(kwargs["successRule"])
        self.assertIsNone(kwargs["failureRule"])


class test_yaml_to_database_main(unittest.TestCase):

    def test_adds_a_single_file_and_honours_the_delete_flag(self):
        with (
            mock.patch("os.path.isfile", return_value=True),
            mock.patch("builtins.print"),
        ):
            workMock, settings, log, dbConn = _run_main(
                "fundamentals.mysql.yaml_to_database",
                ["-d", "-s", "settings.yaml", "/data/one.yaml"],
                fundamentals.mysql,
                "yaml_to_database",
            )

        workMock.assert_called_once_with(log=log, settings=settings, dbConn=dbConn)
        workMock.return_value.add_yaml_file_content_to_database.assert_called_once_with(
            filepath="/data/one.yaml", deleteFile=True
        )

    def test_ingests_a_directory_when_path_is_not_a_file(self):
        with (
            mock.patch("os.path.isfile", return_value=False),
            mock.patch("builtins.print"),
        ):
            workMock, settings, log, dbConn = _run_main(
                "fundamentals.mysql.yaml_to_database",
                ["-s", "settings.yaml", "/data/dir"],
                fundamentals.mysql,
                "yaml_to_database",
            )

        workMock.assert_called_once_with(
            log=log,
            settings=settings,
            dbConn=dbConn,
            pathToInputDir="/data/dir",
            deleteFiles=False,
        )
        workMock.return_value.ingest.assert_called_once_with()
