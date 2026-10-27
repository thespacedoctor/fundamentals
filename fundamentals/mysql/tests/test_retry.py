import unittest
from unittest import mock

import pymysql


def _deadlock():
    return pymysql.err.OperationalError(1213, "deadlock")


class test_run_with_retries(unittest.TestCase):

    def test_returns_the_result_of_the_operation(self):
        from fundamentals.mysql._retry import run_with_retries

        result = run_with_retries(mock.Mock(), lambda: "rows")

        self.assertEqual(result, "rows")

    def test_retries_a_transient_error_after_sleeping_and_logs_a_warning(self):
        from fundamentals.mysql._retry import RETRY_DELAYS, run_with_retries

        log = mock.Mock()
        operation = mock.Mock(side_effect=[_deadlock(), "rows"])

        with mock.patch("time.sleep") as sleep:
            result = run_with_retries(log, operation)

        self.assertEqual(result, "rows")
        sleep.assert_called_once_with(RETRY_DELAYS[0])
        self.assertEqual(log.warning.call_count, 1)

    def test_raises_an_error_that_is_not_transient_without_retrying(self):
        from fundamentals.mysql._retry import run_with_retries

        operation = mock.Mock(side_effect=pymysql.err.OperationalError(1064, "syntax"))

        with mock.patch("time.sleep") as sleep:
            with self.assertRaises(pymysql.err.OperationalError):
                run_with_retries(mock.Mock(), operation)

        self.assertEqual(operation.call_count, 1)
        sleep.assert_not_called()

    def test_raises_a_transient_error_once_the_backoff_is_used_up(self):
        from fundamentals.mysql._retry import RETRY_DELAYS, run_with_retries

        operation = mock.Mock(side_effect=_deadlock())

        with mock.patch("time.sleep"):
            with self.assertRaises(pymysql.err.OperationalError):
                run_with_retries(mock.Mock(), operation)

        self.assertEqual(operation.call_count, len(RETRY_DELAYS) + 1)
