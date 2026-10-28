from __future__ import print_function
import os
import unittest
import shutil
from fundamentals import cl_utils
import pytest
from fundamentals.utKit import SESSION_PLACEHOLDER
from os.path import expanduser

doc = cl_utils.__doc__
home = expanduser("~")

pytestmark = pytest.mark.usefixtures("session_names")
# SET FOR THE MODULE BY THE session_names FIXTURE IN THE ROOT conftest.py
log = SESSION_PLACEHOLDER

# SETUP PATHS TO COMMON DIRECTORIES FOR TEST DATA
moduleDirectory = os.path.dirname(__file__)
pathToInputDir = moduleDirectory + "/input/"
pathToOutputDir = moduleDirectory + "/output/"

try:
    shutil.rmtree(pathToOutputDir)
except:
    pass
# COPY INPUT TO OUTPUT DIR
shutil.copytree(pathToInputDir, pathToOutputDir)

# Recursively create missing directories
if not os.path.exists(pathToOutputDir):
    os.makedirs(pathToOutputDir)


class test_cl_utils(unittest.TestCase):

    def test_init(self):
        # TEST CL-OPTIONS
        # command = "fundamentals init"
        # args = docopt(doc, command.split(" ")[1:])
        # cl_utils.main(args)
        return

    def test_init_opens_the_settings_file(self):
        from unittest import mock

        fakeSetup = mock.MagicMock()
        fakeSetup.setup.return_value = ({"init": True}, {}, mock.MagicMock(), None)

        with mock.patch.object(
            cl_utils, "tools", return_value=fakeSetup
        ), mock.patch.object(cl_utils, "open_file") as openFile:
            result = cl_utils.main({"init": True})

        self.assertIsNone(result)
        openFile.assert_called_once_with(
            os.path.join(home, ".config", "fundamentals", "fundamentals.yaml"),
            fakeSetup.setup.return_value[2],
        )

    def test_open_file_runs_open_without_a_shell_on_macos(self):
        from unittest import mock

        with mock.patch.object(cl_utils.sys, "platform", "darwin"), mock.patch.object(
            cl_utils.subprocess, "run"
        ) as run:
            cl_utils.open_file("/tmp/a b.yaml", mock.MagicMock())

        run.assert_called_once_with(["open", "/tmp/a b.yaml"], check=False)

    def test_open_file_uses_startfile_on_windows(self):
        from unittest import mock

        with mock.patch.object(cl_utils.sys, "platform", "win32"), mock.patch.object(
            cl_utils.os, "startfile", create=True
        ) as startfile, mock.patch.object(cl_utils.subprocess, "run") as run:
            cl_utils.open_file("C:\\a.yaml", mock.MagicMock())

        startfile.assert_called_once_with("C:\\a.yaml")
        run.assert_not_called()

    def test_open_file_does_nothing_on_other_platforms(self):
        from unittest import mock

        with mock.patch.object(cl_utils.sys, "platform", "linux"), mock.patch.object(
            cl_utils.subprocess, "run"
        ) as run:
            cl_utils.open_file("/tmp/a.yaml", mock.MagicMock())

        run.assert_not_called()

    def test_open_file_logs_warning_instead_of_raising_when_open_fails(self):
        from unittest import mock

        log = mock.MagicMock()
        with mock.patch.object(cl_utils.sys, "platform", "darwin"), mock.patch.object(
            cl_utils.subprocess, "run", side_effect=FileNotFoundError("open")
        ):
            cl_utils.open_file("/tmp/a.yaml", log)

        log.warning.assert_called_once()
        self.assertIn("/tmp/a.yaml", log.warning.call_args[0][0])

    # x-class-to-test-named-worker-function
