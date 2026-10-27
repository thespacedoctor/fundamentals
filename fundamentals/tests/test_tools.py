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
