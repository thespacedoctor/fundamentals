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

    def test_connects_through_the_tunnel_port(self):
        with mock.patch(
            "fundamentals.mysql.database.setup_ssh_tunnel", return_value=9006
        ) as tunnelMock:
            connectMock = _connect(_settings(tunnel=TUNNEL))

        self.assertEqual(tunnelMock.call_args.kwargs["tunnelParameters"], TUNNEL)
        self.assertEqual(connectMock.call_args.kwargs["port"], 9006)

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
            mock.patch("fundamentals.ssh_tunnel.is_port_open", return_value=False),
            mock.patch("fundamentals.ssh_tunnel.time.sleep"),
        ):
            with self.assertRaises(tunnel_error):
                _connect(_settings(tunnel=TUNNEL))
