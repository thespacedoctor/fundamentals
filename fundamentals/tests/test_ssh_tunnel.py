import os
import shutil
import stat
import tempfile
import unittest
from unittest import mock

TUNNEL = {
    "remote user": "monster",
    "remote ip": "psweb.example.ac.uk",
    "remote datbase host": "dormammu",
    "port": 9006,
}

SOCKET_CHECK = "fundamentals.ssh_tunnel.is_unix_socket_open"


def _tunnel(**overrides):
    return {**TUNNEL, **overrides}


class test_setup_ssh_tunnel(unittest.TestCase):
    def setUp(self):
        from fundamentals import ssh_tunnel

        patchers = {
            "sleepMock": mock.patch("fundamentals.ssh_tunnel.time.sleep"),
            "atexitMock": mock.patch("fundamentals.ssh_tunnel.atexit.register"),
            "popenMock": mock.patch("fundamentals.ssh_tunnel.Popen"),
        }
        for name, patcher in patchers.items():
            setattr(self, name, patcher.start())
            self.addCleanup(patcher.stop)
        self.processMock = self.popenMock.return_value
        self.processMock.poll.return_value = None
        self.createdDirs = []
        realMkdtemp = tempfile.mkdtemp

        def recordingMkdtemp(*args, **kwargs):
            self.createdDirs.append(realMkdtemp(*args, **kwargs))
            return self.createdDirs[-1]

        patcher = mock.patch(
            "fundamentals.ssh_tunnel.tempfile.mkdtemp", side_effect=recordingMkdtemp
        )
        patcher.start()
        self.addCleanup(patcher.stop)
        self.addCleanup(self._close_all_tunnels, ssh_tunnel)
        self.addCleanup(self._remove_created_dirs)
        self.log = mock.MagicMock()

    def _remove_created_dirs(self):
        for socketDir in self.createdDirs:
            shutil.rmtree(socketDir, ignore_errors=True)

    @staticmethod
    def _close_all_tunnels(ssh_tunnel):
        for socketPath in list(ssh_tunnel.TUNNEL_PROCESSES):
            ssh_tunnel.close_ssh_tunnel(socketPath)

    def test_forwards_to_a_private_unix_socket_with_an_argv_list_and_no_shell(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel

        with mock.patch(SOCKET_CHECK, return_value=True):
            socketPath = setup_ssh_tunnel(TUNNEL, self.log)

        argv = self.popenMock.call_args.args[0]
        self.assertEqual(
            argv,
            [
                "ssh",
                "-nN",
                "-o",
                "ExitOnForwardFailure=yes",
                "-o",
                "IgnoreUnknown=ForkAfterAuthentication",
                "-o",
                "ForkAfterAuthentication=no",
                "-o",
                "ControlMaster=no",
                "-o",
                "ControlPath=none",
                "monster@psweb.example.ac.uk",
                "-L",
                f"{socketPath}:dormammu:3306",
            ],
        )
        self.assertIsNot(self.popenMock.call_args.kwargs.get("shell"), True)
        self.assertEqual(os.path.basename(socketPath), "mysql.sock")

    def test_creates_the_socket_directory_readable_only_by_the_owner(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel

        with mock.patch(SOCKET_CHECK, return_value=True):
            socketPath = setup_ssh_tunnel(TUNNEL, self.log)

        socketDir = os.path.dirname(socketPath)
        self.assertTrue(os.path.basename(socketDir).startswith("fundamentals-tunnel-"))
        self.assertEqual(stat.S_IMODE(os.stat(socketDir).st_mode), 0o700)

    def test_starts_a_new_socket_directory_for_every_tunnel(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel

        with mock.patch(SOCKET_CHECK, return_value=True):
            first = setup_ssh_tunnel(TUNNEL, self.log)
            second = setup_ssh_tunnel(TUNNEL, self.log)

        self.assertNotEqual(first, second)
        self.assertEqual(self.popenMock.call_count, 2)

    def test_does_not_use_the_configured_port(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel

        with mock.patch(SOCKET_CHECK, return_value=True):
            setup_ssh_tunnel(TUNNEL, self.log)

        self.assertNotIn("9006", " ".join(self.popenMock.call_args.args[0]))

    def test_returns_as_soon_as_the_socket_accepts_connections(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel

        with mock.patch(SOCKET_CHECK, side_effect=[False, True]) as checkMock:
            socketPath = setup_ssh_tunnel(TUNNEL, self.log)

        self.assertEqual(checkMock.call_count, 2)
        checkMock.assert_called_with(socketPath, self.log)
        self.sleepMock.assert_called_once()

    def test_succeeds_when_only_the_last_attempt_connects(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, TUNNEL_CHECK_ATTEMPTS

        results = [False] * TUNNEL_CHECK_ATTEMPTS
        results[-1] = True
        with mock.patch(SOCKET_CHECK, side_effect=results):
            socketPath = setup_ssh_tunnel(TUNNEL, self.log)

        self.assertTrue(socketPath)

    def test_raises_tunnel_error_terminates_ssh_and_removes_the_directory_on_timeout(
        self,
    ):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, tunnel_error

        with mock.patch(SOCKET_CHECK, return_value=False):
            with self.assertRaises(tunnel_error):
                setup_ssh_tunnel(TUNNEL, self.log)

        self.processMock.terminate.assert_called_once()
        self.assertEqual(len(self.createdDirs), 1)
        self.assertFalse(os.path.exists(self.createdDirs[0]))

    def test_raises_tunnel_error_when_ssh_exits_even_if_the_socket_is_open(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, tunnel_error

        self.processMock.poll.return_value = 255
        with mock.patch(SOCKET_CHECK, return_value=True):
            with self.assertRaises(tunnel_error) as context:
                setup_ssh_tunnel(TUNNEL, self.log)

        self.assertIn("255", str(context.exception))

    def test_raises_tunnel_error_when_ssh_exits_after_the_socket_check_passes(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, tunnel_error

        self.processMock.poll.side_effect = [None, 255, 255]
        with mock.patch(SOCKET_CHECK, return_value=True):
            with self.assertRaises(tunnel_error):
                setup_ssh_tunnel(TUNNEL, self.log)

    def test_closes_registered_tunnels_whose_ssh_process_has_exited(self):
        from fundamentals import ssh_tunnel

        deadDir = tempfile.mkdtemp(prefix="fundamentals-tunnel-")
        self.addCleanup(shutil.rmtree, deadDir, True)
        deadPath = os.path.join(deadDir, "mysql.sock")
        deadProcess = mock.MagicMock()
        deadProcess.poll.return_value = 1
        ssh_tunnel.TUNNEL_PROCESSES[deadPath] = deadProcess

        with mock.patch(SOCKET_CHECK, return_value=True):
            livePath = ssh_tunnel.setup_ssh_tunnel(TUNNEL, self.log)

        self.assertNotIn(deadPath, ssh_tunnel.TUNNEL_PROCESSES)
        self.assertFalse(os.path.exists(deadDir))
        self.assertIn(livePath, ssh_tunnel.TUNNEL_PROCESSES)

    def test_leaves_registered_tunnels_whose_ssh_process_is_alive(self):
        from fundamentals import ssh_tunnel

        aliveProcess = mock.MagicMock()
        aliveProcess.poll.return_value = None
        ssh_tunnel.TUNNEL_PROCESSES["/alive/mysql.sock"] = aliveProcess

        with mock.patch(SOCKET_CHECK, return_value=True):
            ssh_tunnel.setup_ssh_tunnel(TUNNEL, self.log)

        self.assertIn("/alive/mysql.sock", ssh_tunnel.TUNNEL_PROCESSES)
        aliveProcess.terminate.assert_not_called()

    def test_registers_the_tunnel_for_closing_at_interpreter_exit(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, close_ssh_tunnel

        with mock.patch(SOCKET_CHECK, return_value=True):
            socketPath = setup_ssh_tunnel(TUNNEL, self.log)

        self.atexitMock.assert_called_once_with(close_ssh_tunnel, socketPath)

    def test_raises_tunnel_error_and_removes_the_directory_when_ssh_cannot_start(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, tunnel_error

        self.popenMock.side_effect = FileNotFoundError("ssh")
        with self.assertRaises(tunnel_error):
            setup_ssh_tunnel(TUNNEL, self.log)

        self.assertEqual(len(self.createdDirs), 1)
        self.assertFalse(os.path.exists(self.createdDirs[0]))

    def test_rejects_a_socket_path_too_long_for_a_unix_socket_without_starting_ssh(
        self,
    ):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, tunnel_error

        longDir = tempfile.mkdtemp(prefix="x" * 150)
        self.addCleanup(shutil.rmtree, longDir, True)
        with mock.patch(
            "fundamentals.ssh_tunnel.tempfile.mkdtemp", return_value=longDir
        ):
            with self.assertRaises(tunnel_error):
                setup_ssh_tunnel(TUNNEL, self.log)

        self.popenMock.assert_not_called()

    def test_rejects_a_socket_path_containing_a_colon_without_starting_ssh(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel, tunnel_error

        colonDir = tempfile.mkdtemp(prefix="a:b")
        self.addCleanup(shutil.rmtree, colonDir, True)
        with mock.patch(
            "fundamentals.ssh_tunnel.tempfile.mkdtemp", return_value=colonDir
        ):
            with self.assertRaises(tunnel_error):
                setup_ssh_tunnel(TUNNEL, self.log)

        self.popenMock.assert_not_called()

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
                self.popenMock.reset_mock()
                with mock.patch(SOCKET_CHECK, return_value=False):
                    with self.assertRaises(tunnel_error):
                        setup_ssh_tunnel(parameters, self.log)
                self.popenMock.assert_not_called()

    def test_accepts_port_given_as_a_numeric_string(self):
        from fundamentals.ssh_tunnel import setup_ssh_tunnel

        with mock.patch(SOCKET_CHECK, return_value=True):
            socketPath = setup_ssh_tunnel(_tunnel(port="9006"), self.log)

        self.assertTrue(socketPath)


class test_close_ssh_tunnel(unittest.TestCase):
    def setUp(self):
        from fundamentals import ssh_tunnel

        self.socketDir = tempfile.mkdtemp(prefix="fundamentals-tunnel-")
        self.addCleanup(shutil.rmtree, self.socketDir, True)
        self.socketPath = os.path.join(self.socketDir, "mysql.sock")
        self.processMock = mock.MagicMock()
        self.processMock.poll.return_value = None
        ssh_tunnel.TUNNEL_PROCESSES[self.socketPath] = self.processMock
        self.addCleanup(ssh_tunnel.TUNNEL_PROCESSES.clear)

    def test_terminates_the_ssh_process_and_forgets_it(self):
        from fundamentals.ssh_tunnel import close_ssh_tunnel, TUNNEL_PROCESSES

        close_ssh_tunnel(self.socketPath)

        from fundamentals.ssh_tunnel import TUNNEL_CLOSE_TIMEOUT

        self.processMock.terminate.assert_called_once()
        self.processMock.wait.assert_called_once_with(timeout=TUNNEL_CLOSE_TIMEOUT)
        self.assertNotIn(self.socketPath, TUNNEL_PROCESSES)

    def test_removes_the_socket_directory(self):
        from fundamentals.ssh_tunnel import close_ssh_tunnel

        close_ssh_tunnel(self.socketPath)

        self.assertFalse(os.path.exists(self.socketDir))

    def test_kills_the_ssh_process_when_it_ignores_terminate(self):
        import subprocess
        from fundamentals.ssh_tunnel import close_ssh_tunnel, TUNNEL_CLOSE_TIMEOUT

        self.processMock.wait.side_effect = [subprocess.TimeoutExpired("ssh", 1), 0]

        close_ssh_tunnel(self.socketPath)

        self.processMock.kill.assert_called_once()
        self.assertEqual(
            self.processMock.wait.call_args_list,
            [mock.call(timeout=TUNNEL_CLOSE_TIMEOUT)] * 2,
        )

    def test_still_removes_the_directory_when_the_killed_process_cannot_be_reaped(
        self,
    ):
        import subprocess
        from fundamentals.ssh_tunnel import close_ssh_tunnel, TUNNEL_PROCESSES

        self.processMock.wait.side_effect = subprocess.TimeoutExpired("ssh", 1)
        log = mock.MagicMock()

        close_ssh_tunnel(self.socketPath, log)

        self.assertFalse(os.path.exists(self.socketDir))
        self.assertNotIn(self.socketPath, TUNNEL_PROCESSES)
        log.warning.assert_called()

    def test_still_removes_the_directory_when_the_process_has_vanished(self):
        from fundamentals.ssh_tunnel import close_ssh_tunnel, TUNNEL_PROCESSES

        self.processMock.terminate.side_effect = ProcessLookupError()

        close_ssh_tunnel(self.socketPath)

        self.assertFalse(os.path.exists(self.socketDir))
        self.assertNotIn(self.socketPath, TUNNEL_PROCESSES)

    def test_still_removes_the_directory_when_kill_finds_no_process(self):
        import subprocess
        from fundamentals.ssh_tunnel import close_ssh_tunnel

        self.processMock.wait.side_effect = subprocess.TimeoutExpired("ssh", 1)
        self.processMock.kill.side_effect = ProcessLookupError()

        close_ssh_tunnel(self.socketPath)

        self.assertFalse(os.path.exists(self.socketDir))

    def test_does_not_signal_a_process_that_has_already_exited(self):
        from fundamentals.ssh_tunnel import close_ssh_tunnel

        self.processMock.poll.return_value = 0

        close_ssh_tunnel(self.socketPath)

        self.processMock.terminate.assert_not_called()
        self.assertFalse(os.path.exists(self.socketDir))

    def test_logs_instead_of_raising_when_the_socket_directory_cannot_be_removed(self):
        from fundamentals.ssh_tunnel import close_ssh_tunnel

        log = mock.MagicMock()
        with mock.patch(
            "fundamentals.ssh_tunnel.shutil.rmtree", side_effect=PermissionError("no")
        ):
            close_ssh_tunnel(self.socketPath, log)

        log.warning.assert_called_once()

    def test_does_nothing_for_an_unknown_or_already_closed_tunnel(self):
        from fundamentals.ssh_tunnel import close_ssh_tunnel

        close_ssh_tunnel(self.socketPath)
        close_ssh_tunnel(self.socketPath)
        close_ssh_tunnel("/nonexistent/mysql.sock")

        self.processMock.terminate.assert_called_once()


class test_is_unix_socket_open(unittest.TestCase):
    def setUp(self):
        self.socketDir = tempfile.mkdtemp(prefix="fundamentals-test-")
        self.addCleanup(shutil.rmtree, self.socketDir, True)
        self.socketPath = os.path.join(self.socketDir, "mysql.sock")

    def test_returns_true_when_a_listener_accepts_connections(self):
        import socket
        from fundamentals.ssh_tunnel import is_unix_socket_open

        with socket.socket(socket.AF_UNIX) as listener:
            listener.bind(self.socketPath)
            listener.listen(1)
            result = is_unix_socket_open(self.socketPath, mock.MagicMock())

        self.assertTrue(result)

    def test_returns_false_when_the_socket_does_not_exist(self):
        from fundamentals.ssh_tunnel import is_unix_socket_open

        self.assertFalse(is_unix_socket_open(self.socketPath, mock.MagicMock()))

    def test_returns_false_when_nothing_is_listening_on_the_socket(self):
        import socket
        from fundamentals.ssh_tunnel import is_unix_socket_open

        with socket.socket(socket.AF_UNIX) as bound:
            bound.bind(self.socketPath)
        self.assertFalse(is_unix_socket_open(self.socketPath, mock.MagicMock()))

    def test_sets_a_timeout_before_connecting(self):
        from fundamentals.ssh_tunnel import is_unix_socket_open, TUNNEL_CONNECT_TIMEOUT

        with mock.patch("socket.socket") as socketMock:
            sock = socketMock.return_value.__enter__.return_value
            is_unix_socket_open(self.socketPath, mock.MagicMock())

        self.assertEqual(
            [call[0] for call in sock.method_calls[:2]], ["settimeout", "connect"]
        )
        sock.settimeout.assert_called_once_with(TUNNEL_CONNECT_TIMEOUT)


@unittest.skipUnless(hasattr(os, "fork"), "needs os.fork")
class test_fork_safety(unittest.TestCase):
    def test_a_forked_child_does_not_close_the_tunnels_of_its_parent(self):
        from fundamentals import ssh_tunnel

        socketDir = tempfile.mkdtemp(prefix="fundamentals-tunnel-")
        self.addCleanup(shutil.rmtree, socketDir, True)
        socketPath = os.path.join(socketDir, "mysql.sock")
        processMock = mock.MagicMock()
        processMock.poll.return_value = None
        ssh_tunnel.TUNNEL_PROCESSES[socketPath] = processMock
        self.addCleanup(ssh_tunnel.TUNNEL_PROCESSES.clear)

        pid = os.fork()
        if pid == 0:
            exitCode = 1
            try:
                ssh_tunnel.close_ssh_tunnel(socketPath)
                exitCode = 0 if not processMock.terminate.called else 2
            finally:
                os._exit(exitCode)
        _, status = os.waitpid(pid, 0)

        self.assertEqual(os.waitstatus_to_exitcode(status), 0)
        self.assertIn(socketPath, ssh_tunnel.TUNNEL_PROCESSES)
        self.assertTrue(os.path.isdir(socketDir))
        processMock.terminate.assert_not_called()


STUB_SSH = """#!{python}
import os, signal, socket, sys, time
args = sys.argv[1:]
forward = args[args.index("-L") + 1]
socketPath = forward.rsplit(":", 2)[0]
server = socket.socket(socket.AF_UNIX)
server.bind(socketPath)
server.listen(5)
time.sleep(60)
"""


@unittest.skipUnless(os.name == "posix", "needs a POSIX system")
class test_tunnel_with_a_real_process(unittest.TestCase):
    def setUp(self):
        import sys
        from fundamentals import ssh_tunnel

        binDir = tempfile.mkdtemp(prefix="fundamentals-stub-")
        self.addCleanup(shutil.rmtree, binDir, True)
        stubPath = os.path.join(binDir, "ssh")
        with open(stubPath, "w") as stream:
            stream.write(STUB_SSH.format(python=sys.executable))
        os.chmod(stubPath, 0o755)
        patchers = [
            mock.patch.dict(
                os.environ, {"PATH": binDir + os.pathsep + os.environ["PATH"]}
            ),
            mock.patch("fundamentals.ssh_tunnel.atexit.register"),
        ]
        for patcher in patchers:
            patcher.start()
            self.addCleanup(patcher.stop)
        self.addCleanup(self._close_all_tunnels, ssh_tunnel)

    @staticmethod
    def _close_all_tunnels(ssh_tunnel):
        for socketPath in list(ssh_tunnel.TUNNEL_PROCESSES):
            ssh_tunnel.close_ssh_tunnel(socketPath)

    def test_opens_a_connectable_socket_and_close_removes_process_and_directory(self):
        import socket
        from fundamentals import ssh_tunnel

        socketPath = ssh_tunnel.setup_ssh_tunnel(TUNNEL, mock.MagicMock())
        process = ssh_tunnel.TUNNEL_PROCESSES[socketPath]

        with socket.socket(socket.AF_UNIX) as client:
            client.connect(socketPath)
        self.assertIsNone(process.poll())

        ssh_tunnel.close_ssh_tunnel(socketPath)

        self.assertIsNotNone(process.poll())
        self.assertFalse(os.path.exists(os.path.dirname(socketPath)))
