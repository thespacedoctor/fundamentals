#!/usr/local/bin/python
# encoding: utf-8
"""
*Append a datetime stamp to the end of a filename to ensure uniqueness*

:Author:
    David Young

:Date Created:
    March 16, 2016
"""
################# GLOBAL IMPORTS ####################
import sys
import os
os.environ['TERM'] = 'vt100'
from fundamentals import tools


def append_now_datestamp_to_filename(log, filename, longTime=False):
    """
    *append the current datestamp to the end of the filename (before the extension).*

    **Key Arguments:**
        - ``log`` -- logger
        - ``filename`` -- the filename
        - ``longTime`` -- use a longer time-stmap. Default *False*

    Return:
        - ``dsFilename`` -- datestamped filename

    **Usage:**
        .. code-block:: python 

            # APPEND TIMESTAMP TO THE FILENAME
            from fundamentals.download import append_now_datestamp_to_filename
            filename = append_now_datestamp_to_filename(
                    log=log,
                    filename="some_filename.html",
                    longTime=True
            )

            # OUTPUT
            # 'some_filename_20160316t154123749472.html'
    """
    ## > IMPORTS ##
    from fundamentals.download import get_now_datetime_filestamp

    try:
        #log.debug("appending date stamp to the filename : "+filename)
        sliced = filename.split('.')
        dsFilename = sliced[0] + '_' + \
            get_now_datetime_filestamp(longTime=longTime)
        if len(sliced) == 2:
            dsFilename += '.' + sliced[1]
        else:
            dsFilename += ".xhtml"
    except Exception as e:
        log.error("could not append date stamp to the filename : " +
                  filename + " : " + str(e) + "\n")

    return dsFilename
