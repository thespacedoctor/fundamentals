import unittest
from unittest import mock

TUNNEL = {
    "remote user": "monster",
    "remote ip": "psweb.example.ac.uk",
    "remote datbase host": "dormammu",
    "port": 9006,
}


def _tunnel(**overrides):
    return {**TUNNEL, **overrides}


class test_setup_ssh_tunnel(unittest.TestCase):

    def setUp(self):
        patcher = mock.patch("fundamentals.ssh_tunnel.time.sleep")
        self.sleepMock = patcher.start()
        self.addCleanup(patcher.stop)
        self.log = mock.MagicMock()

    def test_starts_ssh_with_an_argv_list_and_no_shell(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel

        with (
            mock.patch("fundamentals.ssh_tunnel.Popen") as popenMock,
            mock.patch(
                "fundamentals.ssh_tunnel.is_port_open", side_effect=[False, True]
            ),
        ):
            port = setup_ssh_tunnel(TUNNEL, self.log)

        argv = popenMock.call_args.args[0]
        self.assertEqual(
            argv,
            ["ssh", "-fnN", "monster@psweb.example.ac.uk", "-L", "9006:dormammu:3306"],
        )
        self.assertIsNot(popenMock.call_args.kwargs.get("shell"), True)
        self.assertEqual(port, 9006)

    def test_does_not_start_ssh_when_the_tunnel_already_exists(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel

        with (
            mock.patch("fundamentals.ssh_tunnel.Popen") as popenMock,
            mock.patch("fundamentals.ssh_tunnel.is_port_open", return_value=True),
        ):
            port = setup_ssh_tunnel(TUNNEL, self.log)

        popenMock.assert_not_called()
        self.assertEqual(port, 9006)

    def test_returns_as_soon_as_the_connection_check_succeeds(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel

        with (
            mock.patch("fundamentals.ssh_tunnel.Popen"),
            mock.patch(
                "fundamentals.ssh_tunnel.is_port_open", side_effect=[False, True]
            ) as checkMock,
        ):
            setup_ssh_tunnel(TUNNEL, self.log)

        self.assertEqual(checkMock.call_count, 2)
        self.sleepMock.assert_not_called()

    def test_succeeds_when_only_the_last_attempt_connects(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, TUNNEL_CHECK_ATTEMPTS

        results = [False] * TUNNEL_CHECK_ATTEMPTS
        results[-1] = True
        with (
            mock.patch("fundamentals.ssh_tunnel.Popen"),
            mock.patch(
                "fundamentals.ssh_tunnel.is_port_open", side_effect=[False] + results
            ),
        ):
            port = setup_ssh_tunnel(TUNNEL, self.log)

        self.assertEqual(port, 9006)

    def test_raises_tunnel_error_not_system_exit_when_it_never_connects(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, tunnel_error

        with (
            mock.patch("fundamentals.ssh_tunnel.Popen"),
            mock.patch("fundamentals.ssh_tunnel.is_port_open", return_value=False),
        ):
            with self.assertRaises(tunnel_error) as context:
                setup_ssh_tunnel(TUNNEL, self.log)

        self.assertIn("9006", str(context.exception))

    def test_raises_tunnel_error_when_ssh_cannot_be_started(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, tunnel_error

        with (
            mock.patch(
                "fundamentals.ssh_tunnel.Popen", side_effect=FileNotFoundError("ssh")
            ),
            mock.patch("fundamentals.ssh_tunnel.is_port_open", return_value=False),
        ):
            with self.assertRaises(tunnel_error):
                setup_ssh_tunnel(TUNNEL, self.log)

    def test_raises_tunnel_error_when_tunnel_is_true_without_a_config(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, tunnel_error

        with self.assertRaises(tunnel_error):
            setup_ssh_tunnel(True, self.log)

    def test_raises_tunnel_error_naming_a_missing_key(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, tunnel_error

        parameters = {k: v for k, v in TUNNEL.items() if k != "remote ip"}

        with self.assertRaises(tunnel_error) as context:
            setup_ssh_tunnel(parameters, self.log)

        self.assertIn("remote ip", str(context.exception))

    def test_rejects_unsafe_setting_values_without_starting_ssh(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, tunnel_error

        unsafe = [
            _tunnel(**{"remote user": "monster; rm -rf ~"}),
            _tunnel(**{"remote user": "-oProxyCommand=evil"}),
            _tunnel(**{"remote user": "monster\n"}),
            _tunnel(**{"remote ip": "host -oProxyCommand=evil"}),
            _tunnel(**{"remote ip": "-oProxyCommand=evil"}),
            _tunnel(**{"remote datbase host": "db:22:evil"}),
            _tunnel(**{"remote datbase host": "$(evil)"}),
            _tunnel(port="9006; evil"),
            _tunnel(port=0),
            _tunnel(port=70000),
            _tunnel(port=True),
        ]
        for parameters in unsafe:
            with self.subTest(parameters=parameters):
                with (
                    mock.patch("fundamentals.ssh_tunnel.Popen") as popenMock,
                    mock.patch(
                        "fundamentals.ssh_tunnel.is_port_open", return_value=False
                    ),
                ):
                    with self.assertRaises(tunnel_error):
                        setup_ssh_tunnel(parameters, self.log)
                popenMock.assert_not_called()

    def test_accepts_port_given_as_a_numeric_string(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel

        with mock.patch("fundamentals.ssh_tunnel.is_port_open", return_value=True):
            port = setup_ssh_tunnel(_tunnel(port="9006"), self.log)

        self.assertEqual(port, 9006)


class test_is_port_open(unittest.TestCase):

    def test_returns_true_when_the_socket_connects(self):
        from fundamentals.ssh_tunnel import is_port_open

        with mock.patch("socket.socket") as socketMock:
            result = is_port_open("127.0.0.1", 9006, mock.MagicMock())

        socketMock.return_value.__enter__.return_value.connect.assert_called_once_with(
            ("127.0.0.1", 9006)
        )
        self.assertTrue(result)

    def test_returns_false_when_the_socket_cannot_connect(self):
        import socket
        from fundamentals.ssh_tunnel import is_port_open

        with mock.patch("socket.socket") as socketMock:
            socketMock.return_value.__enter__.return_value.connect.side_effect = (
                socket.error("refused")
            )
            result = is_port_open("127.0.0.1", 9006, mock.MagicMock())

        self.assertFalse(result)
