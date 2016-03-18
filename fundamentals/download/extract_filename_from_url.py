#!/usr/local/bin/python
# encoding: utf-8
"""
*Try and extract the name of the document located at the given URL*

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


def extract_filename_from_url(log, url):
    """
    *get the filename from a URL.*

    *Will return 'untitled.html', if no filename is found.*

    **Key Arguments:**
        - ``url`` -- the url to extract filename from

    Returns:
        - ``filename`` -- the filename

    **Usage:**
        .. code-block:: python 

            from fundamentals.download import extract_filename_from_url
            name = extract_filename_from_url(
                log=log,
                url="https://en.wikipedia.org/wiki/Docstring"
            )
            print name
            # OUT: Docstring.html
    """
    ## > IMPORTS ##
    import re
    # EXTRACT THE FILENAME FROM THE URL
    try:
        log.debug("extracting filename from url " + url)
        reEoURL = re.compile('([\w\.]*)$')
        filename = reEoURL.findall(url)[0]
        # log.debug(filename)
        if(len(filename) == 0):
            filename = 'untitled.html'
        if not (re.search('\.', filename)):
            filename = filename + '.html'
    except Exception as e:
        filename = None
        # print url
        log.error("could not extracting filename from url : " + str(e) + "\n")

    return filename
