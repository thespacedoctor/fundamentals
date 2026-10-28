from __future__ import print_function
from builtins import str
import os
import unittest
import pytest
import unittest
import yaml

# SETUP PATHS TO COMMON DIRECTORIES FOR TEST DATA
moduleDirectory = os.path.dirname(__file__)
pathToInputDir = moduleDirectory + "/input/"

largeFile = pathToInputDir + "/ppmxl-head.csv"


@pytest.mark.usefixtures("output_dir_attribute")
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

    def test_fileChunker_raises_stop_iteration_when_next_called_after_exhaustion(self):

        from fundamentals.files import fileChunker

        fileIterator = fileChunker(filepath=largeFile, batchSize=93840)
        for i in fileIterator:
            pass

        with self.assertRaises(StopIteration):
            next(fileIterator)

    def test_fileChunker_raises_stop_iteration_when_closed_mid_iteration(self):

        from fundamentals.files import fileChunker

        fileIterator = fileChunker(filepath=largeFile, batchSize=10)
        next(fileIterator)
        fileIterator.close()

        with self.assertRaises(StopIteration):
            next(fileIterator)

    def test_fileChunker_chains_original_error_when_file_missing(self):

        from fundamentals.files import fileChunker

        with self.assertRaises(IOError) as context:
            fileChunker(
                filepath=self.pathToOutputDir + "/does-not-exist.csv", batchSize=10
            )

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
