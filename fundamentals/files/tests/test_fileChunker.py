from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml
from fundamentals.utKit import utKit
from fundamentals import tools
from os.path import expanduser

home = expanduser("~")

packageDirectory = utKit("").get_project_root()
settingsFile = packageDirectory + "/test_settings.yaml"
# settingsFile = home + "/.config/soxspipe.recipes/soxspipe.recipes.yaml"
su = tools(
    arguments={"settingsFile": settingsFile},
    docString=__doc__,
    logLevel="DEBUG",
    options_first=False,
    projectName=None,
    defaultSettingsFile=False,
)
arguments, settings, log, dbConn = su.setup()

# SETUP AND TEARDOWN FIXTURE FUNCTIONS FOR THE ENTIRE MODULE
moduleDirectory = os.path.dirname(__file__)
utKit = utKit(moduleDirectory)
log, dbConn, pathToInputDir, pathToOutputDir = utKit.setupModule()
utKit.tearDownModule()

try:
    shutil.rmtree(pathToOutputDir)
except:
    pass
# COPY INPUT TO OUTPUT DIR
shutil.copytree(pathToInputDir, pathToOutputDir)

# Recursively create missing directories
if not os.path.exists(pathToOutputDir):
    os.makedirs(pathToOutputDir)

largeFile = pathToInputDir + "/ppmxl-head.csv"


class test_fileChunker(unittest.TestCase):

    def test_fileChunker_function(self):

        from fundamentals.files import fileChunker

        fileIterator = fileChunker(filepath=largeFile, batchSize=93840)
        for i in fileIterator:
            print(len(i))

    def test_fileChunker_closes_file_after_full_iteration(self):

        from fundamentals.files import fileChunker

        fileIterator = fileChunker(filepath=largeFile, batchSize=93840)
        for i in fileIterator:
            pass

        self.assertTrue(fileIterator.readFile.closed)

    def test_fileChunker_closes_file_when_with_block_exits_early(self):

        from fundamentals.files import fileChunker

        with fileChunker(filepath=largeFile, batchSize=10) as fileIterator:
            next(fileIterator)
            self.assertFalse(fileIterator.readFile.closed)

        self.assertTrue(fileIterator.readFile.closed)

    def test_fileChunker_close_is_idempotent(self):

        from fundamentals.files import fileChunker

        fileIterator = fileChunker(filepath=largeFile, batchSize=10)
        fileIterator.close()
        fileIterator.close()

        self.assertTrue(fileIterator.readFile.closed)

    def test_fileChunker_chains_original_error_when_file_missing(self):

        from fundamentals.files import fileChunker

        with self.assertRaises(IOError) as context:
            fileChunker(filepath=pathToOutputDir + "/does-not-exist.csv", batchSize=10)

        self.assertIsInstance(context.exception.__cause__, IOError)

    # def test_fileChunker_function_exception(self):

    #     from fundamentals.files import fileChunker
    #     try:
    #         this = fileChunker(
    #             log=log,
    #             settings=settings,
    #             fakeKey="break the code"
    #         )
    #         this.get()
    #         assert False
    #     except Exception as e:
    #         assert True
    #         print(str(e))

    # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
