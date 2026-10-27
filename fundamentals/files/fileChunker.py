#!/usr/local/bin/python
# encoding: utf-8
"""
*Iterate through large line-based files in batches of lines*

Author
: David Young
"""

from builtins import range
from builtins import object
import sys
import os

os.environ["TERM"] = "vt100"
from fundamentals import tools
import codecs


class fileChunker(object):
    """
    *The fileChunker iterator - iterate over large line-based files to reduce memory footprint*

    **Key Arguments**

    - ``filepath`` -- path to the large file to iterate over
    - ``batchSize`` -- size of the chunks to return in lines


    **Usage**

    To setup your logger, settings and database connections, please use the ``fundamentals`` package (see tutorial here https://fundamentals.readthedocs.io/en/master/initialisation.html).

    To initiate a fileChunker iterator and then process the file in batches of 100000 lines, use the following (the file is closed when the ``with`` block exits):

    ```python
    from fundamentals.files import fileChunker
    with fileChunker(
        filepath="/path/to/large/file.csv",
        batchSize=100000
    ) as fc:
        for i in fc:
            print(len(i))
    ```

    The file is also closed once the iterator is exhausted, or when ``fc.close()`` is called.

    """

    def __init__(self, filepath, batchSize):
        self.filepath = filepath
        self.batchSize = batchSize

        try:
            self.readFile = codecs.open(self.filepath, encoding="utf-8", mode="r")
        except IOError as e:
            message = "could not open the file %s" % (self.filepath,)
            raise IOError(message) from e

    def __iter__(self):
        return self

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        self.close()

    def close(self):
        """*close the underlying file; safe to call more than once*"""
        self.readFile.close()

    def __next__(self):
        if self.readFile.closed:
            raise StopIteration
        batch = []
        for lines in range(self.batchSize):
            l = self.readFile.readline()
            if len(l):
                batch.append(l)
        if len(batch) == 0:
            self.close()
            raise StopIteration

        return batch
