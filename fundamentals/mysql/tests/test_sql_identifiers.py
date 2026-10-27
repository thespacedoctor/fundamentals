import unittest


class test_quote_identifier(unittest.TestCase):

    def test_wraps_name_in_backticks(self):
        # ARRANGE
        from fundamentals.mysql.sql_identifiers import quote_identifier

        # ACT
        quoted = quote_identifier("order")

        # ASSERT
        self.assertEqual(quoted, "`order`")

    def test_doubles_backticks_inside_name(self):
        # ARRANGE
        from fundamentals.mysql.sql_identifiers import quote_identifier

        # ACT
        quoted = quote_identifier("a`b")

        # ASSERT
        self.assertEqual(quoted, "`a``b`")

    def test_rejects_empty_name(self):
        # ARRANGE
        from fundamentals.mysql.sql_identifiers import quote_identifier

        # ACT / ASSERT
        with self.assertRaises(ValueError):
            quote_identifier("")

    def test_rejects_name_containing_nul(self):
        # ARRANGE
        from fundamentals.mysql.sql_identifiers import quote_identifier

        # ACT / ASSERT
        with self.assertRaises(ValueError):
            quote_identifier("a\x00b")

    def test_rejects_name_that_is_not_a_string(self):
        # ARRANGE
        from fundamentals.mysql.sql_identifiers import quote_identifier

        # ACT / ASSERT
        with self.assertRaises(ValueError):
            quote_identifier(5)


if __name__ == "__main__":
    unittest.main()
