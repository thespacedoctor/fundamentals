#!/usr/local/bin/python
# encoding: utf-8
"""
*Retrieve an HTML document or file from the web at a given URL*

:Author:
    David Young
"""
from __future__ import print_function
from future import standard_library
standard_library.install_aliases()
from builtins import str
import sys
import os
os.environ['TERM'] = 'vt100'
from fundamentals import tools


def _fetch(url,):
    """
    *Retrieve an HTML document or file from the web at a given URL*

    **Key Arguments**


      - ``url`` -- the URL of the document or file

    **Return**


      - ``url`` -- the URL of the document or file, or None if an error occured
      - ``body`` -- the text content of the HTML document.
    """
    import coloredlogs
    import logging as log
    import socket
    from eventlet import Timeout
    import urllib
    import sys

    # TRY AND DOWNLOAD X TIMES BEFORE QUITING
    tries = 10
    count = 1
    downloaded = False
    while count < tries and downloaded == False:
        try:
            log.debug('downloading ' + url.get_full_url())
            body = urllib.request.urlopen(url).read()
            downloaded = True
        except socket.timeout as e:
            print("timeout on URL, trying again")
            count += 1
        except Exception as e:
            if "[Errno 60]" in str(e):
                log.warning('timeout on URL, trying again' % locals())
                count += 1
            if "Error 502" in str(e):
                log.warning('proxy error on URL, trying again' % locals())
                count += 1
            else:
                log.warning(
                    "could not download " + url.get_full_url() + " : " + str(e) + "\n")
                url = None
                body = None
                downloaded = True

    return url, body
