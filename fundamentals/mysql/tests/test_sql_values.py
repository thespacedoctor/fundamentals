import unittest


class test_null_if_missing(unittest.TestCase):

    def test_returns_none_for_none_and_the_empty_string(self):
        from fundamentals.mysql.sql_values import null_if_missing

        for missing in (None, ""):
            with self.subTest(value=missing):
                self.assertIsNone(null_if_missing(missing))

    def test_keeps_none_and_null_text_as_text(self):
        from fundamentals.mysql.sql_values import null_if_missing

        for text in ("None", "null"):
            with self.subTest(value=text):
                self.assertEqual(null_if_missing(text), text)

    def test_keeps_zero_false_and_other_values_unchanged(self):
        from fundamentals.mysql.sql_values import null_if_missing

        for kept in (0, 0.0, False, "abc", 1.5):
            with self.subTest(value=kept):
                self.assertIs(null_if_missing(kept), kept)
