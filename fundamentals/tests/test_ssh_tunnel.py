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


FREE_PORT = 45678


class test_setup_ssh_tunnel(unittest.TestCase):
    def setUp(self):
        from fundamentals import ssh_tunnel

        patchers = {
            "sleepMock": mock.patch("fundamentals.ssh_tunnel.time.sleep"),
            "atexitMock": mock.patch("fundamentals.ssh_tunnel.atexit.register"),
            "portMock": mock.patch(
                "fundamentals.ssh_tunnel._find_free_port", return_value=FREE_PORT
            ),
            "popenMock": mock.patch("fundamentals.ssh_tunnel.Popen"),
        }
        for name, patcher in patchers.items():
            setattr(self, name, patcher.start())
            self.addCleanup(patcher.stop)
        self.processMock = self.popenMock.return_value
        self.processMock.poll.return_value = None
        self.addCleanup(ssh_tunnel.TUNNEL_PROCESSES.clear)
        self.log = mock.MagicMock()

    def test_starts_ssh_on_a_free_loopback_port_with_an_argv_list_and_no_shell(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel

        with mock.patch("fundamentals.ssh_tunnel.is_port_open", return_value=True):
            port = setup_ssh_tunnel(TUNNEL, self.log)

        argv = self.popenMock.call_args.args[0]
        self.assertEqual(
            argv,
            [
                "ssh",
                "-nN",
                "-o",
                "ExitOnForwardFailure=yes",
                "monster@psweb.example.ac.uk",
                "-L",
                f"127.0.0.1:{FREE_PORT}:dormammu:3306",
            ],
        )
        self.assertIsNot(self.popenMock.call_args.kwargs.get("shell"), True)
        self.assertEqual(port, FREE_PORT)

    def test_starts_its_own_ssh_even_when_the_configured_port_is_already_listening(
        self,
    ):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel

        with mock.patch(
            "fundamentals.ssh_tunnel.is_port_open", return_value=True
        ) as checkMock:
            port = setup_ssh_tunnel(TUNNEL, self.log)

        self.popenMock.assert_called_once()
        self.assertNotEqual(port, TUNNEL["port"])
        self.assertNotIn(
            TUNNEL["port"], [call.args[1] for call in checkMock.mock_calls]
        )
        self.assertNotIn("9006", " ".join(self.popenMock.call_args.args[0]))

    def test_returns_as_soon_as_the_connection_check_succeeds(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel

        with mock.patch(
            "fundamentals.ssh_tunnel.is_port_open", side_effect=[False, True]
        ) as checkMock:
            setup_ssh_tunnel(TUNNEL, self.log)

        self.assertEqual(checkMock.call_count, 2)
        self.sleepMock.assert_called_once()

    def test_checks_the_loopback_address_for_the_private_port(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel

        with mock.patch(
            "fundamentals.ssh_tunnel.is_port_open", return_value=True
        ) as checkMock:
            setup_ssh_tunnel(TUNNEL, self.log)

        checkMock.assert_called_once_with("127.0.0.1", FREE_PORT, self.log)

    def test_succeeds_when_only_the_last_attempt_connects(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, TUNNEL_CHECK_ATTEMPTS

        results = [False] * TUNNEL_CHECK_ATTEMPTS
        results[-1] = True
        with mock.patch("fundamentals.ssh_tunnel.is_port_open", side_effect=results):
            port = setup_ssh_tunnel(TUNNEL, self.log)

        self.assertEqual(port, FREE_PORT)

    def test_raises_tunnel_error_and_terminates_ssh_when_it_never_connects(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, tunnel_error

        with mock.patch("fundamentals.ssh_tunnel.is_port_open", return_value=False):
            with self.assertRaises(tunnel_error) as context:
                setup_ssh_tunnel(TUNNEL, self.log)

        self.assertIn(str(FREE_PORT), str(context.exception))
        self.processMock.terminate.assert_called_once()

    def test_raises_tunnel_error_when_ssh_exits_even_if_the_port_is_open(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, tunnel_error

        self.processMock.poll.return_value = 255
        with mock.patch("fundamentals.ssh_tunnel.is_port_open", return_value=True):
            with self.assertRaises(tunnel_error) as context:
                setup_ssh_tunnel(TUNNEL, self.log)

        self.assertIn("255", str(context.exception))

    def test_raises_tunnel_error_when_ssh_exits_after_the_port_check_passes(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, tunnel_error

        self.processMock.poll.side_effect = [None, 255, 255]
        with mock.patch("fundamentals.ssh_tunnel.is_port_open", return_value=True):
            with self.assertRaises(tunnel_error):
                setup_ssh_tunnel(TUNNEL, self.log)

    def test_registers_the_tunnel_for_closing_at_interpreter_exit(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, close_ssh_tunnel

        with mock.patch("fundamentals.ssh_tunnel.is_port_open", return_value=True):
            port = setup_ssh_tunnel(TUNNEL, self.log)

        self.atexitMock.assert_called_once_with(close_ssh_tunnel, port)

    def test_raises_tunnel_error_when_ssh_cannot_be_started(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, tunnel_error

        self.popenMock.side_effect = FileNotFoundError("ssh")
        with mock.patch("fundamentals.ssh_tunnel.is_port_open", return_value=False):
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

        self.assertEqual(port, FREE_PORT)


class test_close_ssh_tunnel(unittest.TestCase):
    def setUp(self):
        from fundamentals import ssh_tunnel

        self.processMock = mock.MagicMock()
        self.processMock.poll.return_value = None
        ssh_tunnel.TUNNEL_PROCESSES[FREE_PORT] = self.processMock
        self.addCleanup(ssh_tunnel.TUNNEL_PROCESSES.clear)

    def test_terminates_the_ssh_process_and_forgets_it(self):
        from fundamentals.ssh_tunnel import close_ssh_tunnel, TUNNEL_PROCESSES

        close_ssh_tunnel(FREE_PORT)

        self.processMock.terminate.assert_called_once()
        self.processMock.wait.assert_called_once()
        self.assertNotIn(FREE_PORT, TUNNEL_PROCESSES)

    def test_kills_the_ssh_process_when_it_ignores_terminate(self):
        import subprocess
        from fundamentals.ssh_tunnel import close_ssh_tunnel

        self.processMock.wait.side_effect = [subprocess.TimeoutExpired("ssh", 1), 0]

        close_ssh_tunnel(FREE_PORT)

        self.processMock.kill.assert_called_once()

    def test_does_not_signal_a_process_that_has_already_exited(self):
        from fundamentals.ssh_tunnel import close_ssh_tunnel

        self.processMock.poll.return_value = 0

        close_ssh_tunnel(FREE_PORT)

        self.processMock.terminate.assert_not_called()

    def test_does_nothing_for_an_unknown_or_already_closed_port(self):
        from fundamentals.ssh_tunnel import close_ssh_tunnel

        close_ssh_tunnel(FREE_PORT)
        close_ssh_tunnel(FREE_PORT)
        close_ssh_tunnel(1)

        self.processMock.terminate.assert_called_once()


class test_find_free_port(unittest.TestCase):
    def test_binds_a_loopback_socket_to_port_zero_and_returns_the_assigned_port(self):
        from fundamentals.ssh_tunnel import _find_free_port

        with mock.patch("socket.socket") as socketMock:
            sock = socketMock.return_value.__enter__.return_value
            sock.getsockname.return_value = ("127.0.0.1", FREE_PORT)
            port = _find_free_port()

        sock.bind.assert_called_once_with(("127.0.0.1", 0))
        self.assertEqual(port, FREE_PORT)

    def test_returns_a_usable_port_number_from_a_real_socket(self):
        from fundamentals.ssh_tunnel import _find_free_port

        port = _find_free_port()

        self.assertTrue(1 <= port <= 65535)


class test_is_port_open(unittest.TestCase):
    def test_returns_true_when_the_socket_connects(self):
        from fundamentals.ssh_tunnel import is_port_open

        with mock.patch("socket.socket") as socketMock:
            result = is_port_open("127.0.0.1", 9006, mock.MagicMock())

        socketMock.return_value.__enter__.return_value.connect.assert_called_once_with(
            ("127.0.0.1", 9006)
        )
        self.assertTrue(result)

    def test_sets_a_timeout_on_the_socket_before_connecting(self):
        from fundamentals.ssh_tunnel import is_port_open, TUNNEL_CONNECT_TIMEOUT

        with mock.patch("socket.socket") as socketMock:
            sock = socketMock.return_value.__enter__.return_value
            is_port_open("127.0.0.1", 9006, mock.MagicMock())

        self.assertEqual(
            [call[0] for call in sock.method_calls[:2]], ["settimeout", "connect"]
        )
        sock.settimeout.assert_called_once_with(TUNNEL_CONNECT_TIMEOUT)

    def test_returns_false_when_the_connection_times_out(self):
        import socket
        from fundamentals.ssh_tunnel import is_port_open

        with mock.patch("socket.socket") as socketMock:
            socketMock.return_value.__enter__.return_value.connect.side_effect = (
                socket.timeout("timed out")
            )
            result = is_port_open("127.0.0.1", 9006, mock.MagicMock())

        self.assertFalse(result)

    def test_returns_false_when_the_socket_cannot_connect(self):
        import socket
        from fundamentals.ssh_tunnel import is_port_open

        with mock.patch("socket.socket") as socketMock:
            socketMock.return_value.__enter__.return_value.connect.side_effect = (
                socket.error("refused")
            )
            result = is_port_open("127.0.0.1", 9006, mock.MagicMock())

        self.assertFalse(result)
