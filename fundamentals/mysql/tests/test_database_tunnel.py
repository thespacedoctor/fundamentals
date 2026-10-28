import unittest
from unittest import mock

TUNNEL = {
    "remote user": "monster",
    "remote ip": "psweb.example.ac.uk",
    "remote datbase host": "dormammu",
    "port": 9006,
}


def _settings(**overrides):
    return {
        "host": "127.0.0.1",
        "user": "u",
        "password": "p",
        "db": "d",
        **overrides,
    }


def _connect(dbSettings):
    from fundamentals.mysql import database

    with mock.patch("pymysql.connect") as connectMock:
        database(log=mock.MagicMock(), dbSettings=dbSettings).connect()
    return connectMock


class test_database_tunnel(unittest.TestCase):
    def test_connects_through_the_tunnel_unix_socket(self):
        with mock.patch(
            "fundamentals.mysql.database.setup_ssh_tunnel",
            return_value="/tmp/t/mysql.sock",
        ) as tunnelMock:
            connectMock = _connect(_settings(tunnel=TUNNEL))

        self.assertEqual(tunnelMock.call_args.kwargs["tunnelParameters"], TUNNEL)
        self.assertEqual(
            connectMock.call_args.kwargs["unix_socket"], "/tmp/t/mysql.sock"
        )
        self.assertFalse(connectMock.call_args.kwargs["port"])

    def _connect_with_failure(self, configureConnect):
        from fundamentals.mysql import database

        with (
            mock.patch(
                "fundamentals.mysql.database.setup_ssh_tunnel",
                return_value="/tmp/t/mysql.sock",
            ),
            mock.patch("fundamentals.mysql.database.close_ssh_tunnel") as closeMock,
            mock.patch("pymysql.connect") as connectMock,
        ):
            configureConnect(connectMock)
            log = mock.MagicMock()
            with self.assertRaises(RuntimeError):
                database(log=log, dbSettings=_settings(tunnel=TUNNEL)).connect()
        return closeMock, log

    def test_closes_the_tunnel_when_the_database_connection_fails(self):
        def failToConnect(connectMock):
            connectMock.side_effect = RuntimeError("refused")

        closeMock, log = self._connect_with_failure(failToConnect)

        closeMock.assert_called_once_with("/tmp/t/mysql.sock", log)

    def test_closes_the_tunnel_when_setting_autocommit_fails(self):
        def failAutocommit(connectMock):
            connectMock.return_value.autocommit.side_effect = RuntimeError("boom")

        closeMock, log = self._connect_with_failure(failAutocommit)

        closeMock.assert_called_once_with("/tmp/t/mysql.sock", log)

    def test_leaves_the_tunnel_open_when_the_connection_succeeds(self):
        with (
            mock.patch(
                "fundamentals.mysql.database.setup_ssh_tunnel",
                return_value="/tmp/t/mysql.sock",
            ),
            mock.patch("fundamentals.mysql.database.close_ssh_tunnel") as closeMock,
        ):
            _connect(_settings(tunnel=TUNNEL))

        closeMock.assert_not_called()

    def test_does_not_use_a_unix_socket_without_a_tunnel(self):
        connectMock = _connect(_settings(port=3307))

        self.assertIsNone(connectMock.call_args.kwargs["unix_socket"])
        self.assertEqual(connectMock.call_args.kwargs["port"], 3307)

    def test_does_not_start_a_tunnel_when_tunnel_is_false(self):
        with mock.patch("fundamentals.mysql.database.setup_ssh_tunnel") as tunnelMock:
            _connect(_settings(tunnel=False, port=3307))

        tunnelMock.assert_not_called()

    def test_does_not_start_a_tunnel_when_tunnel_key_is_missing(self):
        with mock.patch("fundamentals.mysql.database.setup_ssh_tunnel") as tunnelMock:
            connectMock = _connect(_settings())

        tunnelMock.assert_not_called()
        connectMock.assert_called_once()

    def test_raises_tunnel_error_when_tunnel_is_true_without_a_config(self):
        from fundamentals.ssh_tunnel import tunnel_error

        with self.assertRaises(tunnel_error):
            _connect(_settings(tunnel=True))

    def test_raises_tunnel_error_rather_than_exiting_when_tunnel_never_connects(self):
        from fundamentals.ssh_tunnel import tunnel_error

        with (
            mock.patch("fundamentals.ssh_tunnel.Popen"),
            mock.patch(
                "fundamentals.ssh_tunnel.is_unix_socket_open", return_value=False
            ),
            mock.patch("fundamentals.ssh_tunnel.time.sleep"),
        ):
            with self.assertRaises(tunnel_error):
                _connect(_settings(tunnel=TUNNEL))
