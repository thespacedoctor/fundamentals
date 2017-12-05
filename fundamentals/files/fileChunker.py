#!/usr/local/bin/python
# encoding: utf-8
"""
*Iterate through large line-based files in batches of lines*

:Author:
    David Young

:Date Created:
    December  4, 2017
"""
################# GLOBAL IMPORTS ####################
import sys
import os
os.environ['TERM'] = 'vt100'
from fundamentals import tools
import codecs


class fileChunker(object):
    """
    *The fileChunker iterator - iterate over large line-based files to reduce memory footprint*

    **Key Arguments:**
        - ``filepath`` -- path to the large file to iterate over
        - ``batchSize`` -- size of the chunks to return in lines

    **Usage:**

        To setup your logger, settings and database connections, please use the ``fundamentals`` package (`see tutorial here <http://fundamentals.readthedocs.io/en/latest/#tutorial>`_). 

        To initiate a fileChunker iterator and then process the file in batches of 100000 lines, use the following:

        .. code-block:: python 

            from fundamentals.files import fileChunker
            fc = fileChunker(
                filepath="/path/to/large/file.csv",
                batchSize=100000
            )
            for i in fc:
                print len(i)
    """

    def __init__(self, filepath, batchSize):
        self.filepath = filepath
        self.batchSize = batchSize

        try:
            self.readFile = codecs.open(
                self.filepath, encoding='utf-8', mode='r')
        except IOError, e:
            message = 'could not open the file %s' % (self.filepath,)
            raise IOError(message)

    def __iter__(self): return self

    def next(self):
        batch = []
        for lines in range(self.batchSize):
            l = self.readFile.readline()
            if len(l):
                batch.append(l)
        if len(batch) == 0:
            raise StopIteration

        return batch
