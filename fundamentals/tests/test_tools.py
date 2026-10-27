import unittest
from collections import OrderedDict


class test_ordered_load(unittest.TestCase):

    def test_returns_ordered_dict_with_keys_in_file_order(self):
        from fundamentals.tools import ordered_load

        stream = "zebra: 1\napple: 2\nmango: 3\n"

        settings = ordered_load(stream)

        self.assertIsInstance(settings, OrderedDict)
        self.assertEqual(list(settings.keys()), ["zebra", "apple", "mango"])
