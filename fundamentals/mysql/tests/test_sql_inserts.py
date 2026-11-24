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


class test_batch_insert_command_through_pymysql_executemany(unittest.TestCase):
    """The command is run through the installed pymysql ``executemany``, so the test follows how that version formats ``%``."""

    AWKWARD_TABLE = "ut_dy2026_de75ee71426b`_%t"
    AWKWARD_COLUMNS = ("select", "we`ird", "100%")

    def _statements_sent(self, dateCreated):
        from types import SimpleNamespace

        from pymysql.cursors import Cursor

        from fundamentals.mysql.sql_inserts import build_batch_insert_command

        # STUBS PYMYSQL INTERNALS (__init__, _get_db, _mogrify, max_stmt_length) SO THE REAL executemany
        # REGEX AND BATCHING RUN WITHOUT A CONNECTION; A PYMYSQL UPGRADE MAY NEED THESE STUBS UPDATED
        class RecordingCursor(Cursor):
            def __init__(self):
                self.max_stmt_length = 1024000
                self.sent = []

            def _get_db(self):
                return SimpleNamespace(encoding="utf8")

            def _mogrify(self, query, args=None):
                return query % tuple(repr(a) for a in args)

            def execute(self, query, args=None):
                if args is not None:
                    query = query % tuple(repr(a) for a in args)
                self.sent.append(
                    query.decode("utf8")
                    if isinstance(query, (bytes, bytearray))
                    else query
                )
                return 1

        command = build_batch_insert_command(
            "INSERT IGNORE",
            self.AWKWARD_TABLE,
            self.AWKWARD_COLUMNS,
            True,
            dateCreated,
            extraUpdates=("updated=1",),
        )
        cursor = RecordingCursor()
        cursor.executemany(command, [(1, 2, 3), (4, 5, 6)])
        return cursor.sent

    def test_sends_the_percent_sign_once_in_every_part_when_rows_are_batched(self):
        sent = self._statements_sent(dateCreated=False)

        self.assertEqual(len(sent), 1)
        self.assertIn("INTO `ut_dy2026_de75ee71426b``_%t`", sent[0])
        self.assertIn("`100%`=VALUES(`100%`)", sent[0])

    def test_sends_the_percent_sign_once_in_every_part_when_rows_are_sent_one_by_one(
        self,
    ):
        sent = self._statements_sent(dateCreated=True)

        self.assertEqual(len(sent), 2)
        for statement in sent:
            self.assertIn("INTO `ut_dy2026_de75ee71426b``_%t`", statement)
            self.assertIn("`100%`=VALUES(`100%`)", statement)
