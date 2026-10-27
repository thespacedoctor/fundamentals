import unittest


class test_build_batch_insert_command(unittest.TestCase):

    def _build(self, **overrides):
        from fundamentals.mysql.sql_inserts import build_batch_insert_command

        arguments = {
            "insertVerb": "INSERT",
            "dbTableName": "t",
            "columns": ["a", "b"],
            "replace": False,
            "dateCreated": True,
        }
        arguments.update(overrides)
        return build_batch_insert_command(**arguments)

    def test_starts_with_the_given_verb_and_has_one_placeholder_per_column(self):
        command = self._build(insertVerb="INSERT IGNORE")

        self.assertEqual(
            command,
            "INSERT IGNORE INTO `t` (`a`,`b`, dateCreated) VALUES (%s, %s, NOW())",
        )

    def test_leaves_out_the_date_created_column_when_it_is_not_requested(self):
        command = self._build(dateCreated=False)

        self.assertEqual(command, "INSERT INTO `t` (`a`,`b`) VALUES (%s, %s)")

    def test_adds_the_extra_updates_after_the_column_updates_when_replacing(self):
        command = self._build(replace=True, extraUpdates=("updated=1",))

        self.assertTrue(
            command.endswith(
                " ON DUPLICATE KEY UPDATE `a`=VALUES(`a`), `b`=VALUES(`b`), updated=1"
            )
        )

    def test_adds_no_update_tail_when_not_replacing(self):
        command = self._build(extraUpdates=("updated=1",))

        self.assertNotIn("ON DUPLICATE", command)
