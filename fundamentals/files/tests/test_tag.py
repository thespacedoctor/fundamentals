from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml
import sys
import glob
import tempfile
import plistlib
from subprocess import Popen, PIPE
from unittest import mock
import pytest

# xt-setup-unit-testing-files-and-folders


STRAY_PLIST_PATTERN = "/tmp/fund-*.plist"


@pytest.mark.usefixtures("session_attributes", "output_dir_attribute")
class test_tag(unittest.TestCase):

    def setUp(self):
        self.originalTempdir = tempfile.tempdir
        self.redirectedTmp = os.path.join(self.pathToOutputDir, "redirected_tmp")
        shutil.rmtree(self.redirectedTmp, ignore_errors=True)
        os.makedirs(self.redirectedTmp)
        tempfile.tempdir = self.redirectedTmp
        self.strayPlistsBefore = set(glob.glob(STRAY_PLIST_PATTERN))
        self.tagModule = sys.modules["fundamentals.files.tag"]

    def tearDown(self):
        tempfile.tempdir = self.originalTempdir
        shutil.rmtree(self.redirectedTmp, ignore_errors=True)

    def _new_stray_plists(self):
        return set(glob.glob(STRAY_PLIST_PATTERN)) - self.strayPlistsBefore

    def _list_tree(self, directory):
        return [
            os.path.join(root, name)
            for root, dirs, files in os.walk(directory)
            for name in dirs + files
        ]

    def test_tag_writes_scratch_plists_inside_tempdir_and_removes_them(self):

        from fundamentals.files.tag import tag

        seenDuringCalls = []

        def spyPopen(*args, **kwargs):
            seenDuringCalls.extend(self._list_tree(self.redirectedTmp))
            return Popen(*args, **kwargs)

        with mock.patch.object(self.tagModule, "Popen", side_effect=spyPopen):
            tag(
                log=self.log,
                filepath=self.pathToOutputDir + "/file_needing_tagged.dat",
                tags="test,tags, fundamentals",
                rating=3,
                wherefrom="http://www.thespacedoctor.co.uk",
            )

        plistNames = {os.path.basename(p) for p in seenDuringCalls}
        self.assertTrue({"tags.plist", "url.plist", "wherefroms.plist"} <= plistNames)
        self.assertEqual(self._list_tree(self.redirectedTmp), [])
        self.assertEqual(self._new_stray_plists(), set())

    def test_tag_leaves_no_scratch_files_when_command_raises(self):

        from fundamentals.files.tag import tag

        with mock.patch.object(self.tagModule, "Popen", side_effect=OSError("boom")):
            with self.assertRaises(OSError):
                tag(
                    log=self.log,
                    filepath=self.pathToOutputDir + "/file_needing_tagged.dat",
                    tags="test,tags",
                    wherefrom="http://www.thespacedoctor.co.uk",
                )

        self.assertEqual(self._list_tree(self.redirectedTmp), [])
        self.assertEqual(self._new_stray_plists(), set())

    @pytest.mark.skipif(sys.platform != "darwin", reason="needs the macOS xattr command")
    def test_tag_handles_shell_characters_in_tempdir_path(self):

        from fundamentals.files.tag import tag

        # A TEMP DIR NAME THAT WOULD BREAK OR INJECT INTO AN UNQUOTED SHELL COMMAND
        oddTmp = os.path.join(self.redirectedTmp, "o'brien `touch INJECTED` $HOME")
        os.makedirs(oddTmp)
        tempfile.tempdir = oddTmp
        taggedFile = self.pathToOutputDir + "/file_needing_tagged.dat"

        # CLEAR EXISTING TAGS SO THE ASSERTION BELOW PROVES THIS CALL WROTE THEM
        Popen(
            ["xattr", "-d", "com.apple.metadata:_kMDItemUserTags", taggedFile],
            stdout=PIPE,
            stderr=PIPE,
        ).communicate()

        tag(log=self.log, filepath=taggedFile, tags="quoted,path")

        self.assertFalse(os.path.exists("INJECTED"))
        self.assertEqual(self._list_tree(oddTmp), [])
        p = Popen(
            ["xattr", "-px", "com.apple.metadata:_kMDItemUserTags", taggedFile],
            stdout=PIPE,
            stderr=PIPE,
        )
        stdout, stderr = p.communicate()
        self.assertEqual(p.returncode, 0, stderr)
        writtenTags = plistlib.loads(
            bytes.fromhex(stdout.decode().replace(" ", "").replace("\n", ""))
        )
        self.assertEqual(writtenTags, ["quoted", "path"])

    def test_tag_function(self):

        from fundamentals.files.tag import tag

        tag(
            log=self.log,
            filepath=self.pathToOutputDir + "/file_needing_tagged.dat",
            tags="test,tags, fundamentals",
            rating=3,
            wherefrom="http://www.thespacedoctor.co.uk",
        )

    def test_tag_function_exception(self):

        from fundamentals.files import tag

        try:
            this = tag(log=self.log, fakeKey="break the code")
            assert False
        except Exception as e:
            assert True
            print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
