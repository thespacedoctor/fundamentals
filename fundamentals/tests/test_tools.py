import unittest
from collections import OrderedDict


class test_ordered_load(unittest.TestCase):

    def test_returns_ordered_dict_with_keys_in_file_order(self):
        from fundamentals.tools import ordered_load

        stream = "zebra: 1\napple: 2\nmango: 3\n"

        settings = ordered_load(stream)

        self.assertIsInstance(settings, OrderedDict)
        self.assertEqual(list(settings.keys()), ["zebra", "apple", "mango"])

    def test_refuses_to_construct_python_objects(self):
        import yaml
        from fundamentals.tools import ordered_load

        stream = "x: !!python/object/apply:os.getcwd []\n"

        with self.assertRaises(yaml.constructor.ConstructorError):
            ordered_load(stream)


class test_tools_arguments(unittest.TestCase):

    def test_accepts_argument_values_with_backslashes_and_quotes(self):
        from fundamentals import tools

        arguments = {"--foo": "abc\\", "<x>": "a'b", "<path-to>": "c"}

        su = tools(
            arguments=arguments, docString="", quitIfRunning=False, createLogger=False
        )

        self.assertEqual(su.setup()[0], arguments)

    def test_does_not_execute_code_in_argument_names_or_values(self):
        import builtins
        from fundamentals import tools

        marker = "fundamentals_exec_marker"
        self.addCleanup(lambda: vars(builtins).pop(marker, None))
        arguments = {
            "x = 1; import builtins; setattr(builtins, '%s', 1) #" % marker: "v",
            "--bar": "'; import builtins; setattr(builtins, '%s', 1) #" % marker,
        }

        tools(
            arguments=arguments, docString="", quitIfRunning=False, createLogger=False
        )

        self.assertFalse(hasattr(builtins, marker))


class test_tools_logger(unittest.TestCase):

    def test_falls_back_to_console_logger_when_logger_argument_is_set(self):
        import logging
        from fundamentals import tools

        su = tools(arguments={"--logger": "x"}, docString="", quitIfRunning=False)

        log = su.setup()[2]

        self.assertIsInstance(log, logging.Logger)

    def test_falls_back_to_console_logger_when_no_argument_names_a_settings_file(
        self,
    ):
        import logging
        import tempfile
        from unittest import mock
        from fundamentals import tools

        with tempfile.TemporaryDirectory() as tmpDir:
            with open(tmpDir + "/advanced_settings.yaml", "w") as stream:
                stream.write("logging settings:\n    version: 1\n")
            callerFrame = (None, tmpDir + "/caller.py")

            with mock.patch("fundamentals.tools.inspect.stack") as stackMock:
                stackMock.return_value = [None, callerFrame]
                su = tools(arguments={}, docString="", quitIfRunning=False)

        log = su.setup()[2]
        self.assertIsInstance(log, logging.Logger)

    def test_builds_logger_from_settings_file_when_it_has_logging_settings(self):
        import os
        from unittest import mock
        from fundamentals import tools

        settingsFile = (
            os.path.dirname(os.path.dirname(__file__)) + "/test_settings.yaml"
        )

        with mock.patch("fundamentals.tools.dl.setup_dryx_logging") as loggingMock:
            su = tools(
                arguments={"settingsFile": settingsFile},
                docString="",
                quitIfRunning=False,
            )

        loggingMock.assert_called_once_with(yaml_file=settingsFile)
        self.assertIs(su.setup()[2], loggingMock.return_value)


class test_tools_settings_file_choice(unittest.TestCase):

    def _write_settings(self, tmpDir, name, marker):
        import os

        path = os.path.join(tmpDir, name)
        with open(path, "w") as stream:
            stream.write("logging settings:\n    version: 1\nmarker: %s\n" % marker)
        return path

    def test_reads_settings_and_builds_logger_from_the_same_file_when_two_keys_are_given(
        self,
    ):
        import tempfile
        from unittest import mock
        from fundamentals import tools

        with tempfile.TemporaryDirectory() as tmpDir:
            firstFile = self._write_settings(tmpDir, "first.yaml", "first")
            secondFile = self._write_settings(tmpDir, "second.yaml", "second")
            arguments = {"<settingsFile>": firstFile, "settingsFile": secondFile}

            with mock.patch("fundamentals.tools.dl.setup_dryx_logging") as loggingMock:
                su = tools(arguments=arguments, docString="", quitIfRunning=False)

        settingsUsed = su.setup()[1]["marker"]
        loggerFile = loggingMock.call_args.kwargs["yaml_file"]
        self.assertEqual(loggerFile, {"first": firstFile, "second": secondFile}[settingsUsed])


TUNNEL_YAML = """
database settings:
    db: d
    host: 127.0.0.1
    user: u
    password: p
    tunnel: %s
"""

TUNNEL_DICT_YAML = """
        remote user: monster
        remote ip: psweb.example.ac.uk
        remote datbase host: dormammu
        port: 9006
"""


class test_tools_tunnel(unittest.TestCase):

    def _build_tools(self, tunnelValue):
        import os
        import tempfile
        from unittest import mock
        from fundamentals import tools

        with tempfile.TemporaryDirectory() as tmpDir:
            settingsFile = os.path.join(tmpDir, "settings.yaml")
            with open(settingsFile, "w") as stream:
                stream.write(TUNNEL_YAML % tunnelValue)
            with mock.patch("pymysql.connect") as connectMock:
                su = tools(
                    arguments={"settingsFile": settingsFile},
                    docString="",
                    quitIfRunning=False,
                )
        return su, connectMock

    def test_connects_through_the_nested_tunnel_port(self):
        from unittest import mock

        with mock.patch(
            "fundamentals.tools.setup_ssh_tunnel", return_value=9006
        ) as tunnelMock:
            su, connectMock = self._build_tools("\n" + TUNNEL_DICT_YAML)

        self.assertEqual(tunnelMock.call_args.kwargs["tunnelParameters"]["port"], 9006)
        self.assertEqual(connectMock.call_args.kwargs["port"], 9006)
        self.assertIs(su.setup()[3], connectMock.return_value)

    def test_does_not_start_a_tunnel_when_tunnel_is_false(self):
        from unittest import mock

        with mock.patch("fundamentals.tools.setup_ssh_tunnel") as tunnelMock:
            su, connectMock = self._build_tools("false")

        tunnelMock.assert_not_called()
        connectMock.assert_called_once()

    def test_raises_tunnel_error_when_tunnel_is_true_without_a_config(self):
        from fundamentals.ssh_tunnel import tunnel_error

        with self.assertRaises(tunnel_error):
            self._build_tools("true")

    def test_raises_tunnel_error_rather_than_exiting_when_tunnel_never_connects(self):
        from unittest import mock
        from fundamentals.ssh_tunnel import tunnel_error

        with (
            mock.patch("fundamentals.ssh_tunnel.Popen"),
            mock.patch("fundamentals.ssh_tunnel.is_port_open", return_value=False),
            mock.patch("fundamentals.ssh_tunnel.time.sleep"),
        ):
            with self.assertRaises(tunnel_error):
                self._build_tools("\n" + TUNNEL_DICT_YAML)


class test_tools_settings_files(unittest.TestCase):

    def test_closes_the_settings_file_it_reads(self):
        import gc
        import os
        import warnings
        from fundamentals import tools

        settingsFile = (
            os.path.dirname(os.path.dirname(__file__)) + "/test_settings.yaml"
        )

        with warnings.catch_warnings(record=True) as caught:
            warnings.simplefilter("always", ResourceWarning)
            tools(
                arguments={"settingsFile": settingsFile},
                docString="",
                quitIfRunning=False,
                createLogger=False,
            )
            gc.collect()

        unclosed = [w for w in caught if issubclass(w.category, ResourceWarning)]
        self.assertEqual(unclosed, [])

    def _create_default_settings(self, copyEffect):
        import os
        import tempfile
        from unittest import mock
        from fundamentals import tools

        with tempfile.TemporaryDirectory() as tmpDir:
            self.settingsPath = tmpDir + "/.config/proj/proj.yaml"
            previousDirectory = os.getcwd()
            os.chdir(tmpDir)
            try:
                with (
                    mock.patch.dict(os.environ, {"HOME": tmpDir}),
                    mock.patch(
                        "fundamentals.tools.shutil.copyfile", side_effect=copyEffect
                    ),
                ):
                    tools(
                        arguments={"settingsFile": None},
                        docString="",
                        projectName="proj",
                        quitIfRunning=False,
                        createLogger=False,
                    )
            finally:
                os.chdir(previousDirectory)

    def test_raises_oserror_and_logs_the_path_when_settings_cannot_be_created(self):
        with self.assertLogs("fundamentals.tools", level="ERROR") as logged:
            with self.assertRaises(OSError):
                self._create_default_settings(PermissionError(13, "Permission denied"))

        self.assertIn(self.settingsPath, "\n".join(logged.output))
        self.assertIn("Permission denied", "\n".join(logged.output))

    def test_does_not_swallow_errors_that_are_not_oserrors(self):
        with self.assertRaises(ValueError):
            self._create_default_settings(ValueError("not an os error"))
