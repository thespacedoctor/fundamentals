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

        su = tools(
            arguments={"--logger": "x"}, docString="", quitIfRunning=False
        )

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

        settingsFile = os.path.dirname(os.path.dirname(__file__)) + "/test_settings.yaml"

        with mock.patch("fundamentals.tools.dl.setup_dryx_logging") as loggingMock:
            su = tools(
                arguments={"settingsFile": settingsFile},
                docString="",
                quitIfRunning=False,
            )

        loggingMock.assert_called_once_with(yaml_file=settingsFile)
        self.assertIs(su.setup()[2], loggingMock.return_value)
