#!/usr/local/bin/python
# encoding: utf-8
"""
*Retrieve an HTML document or file from the web at a given URL*

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


def _fetch(url,):
    """
    *Retrieve an HTML document or file from the web at a given URL*

    **Key Arguments:**
      - ``url`` -- the URL of the document or file

    **Return:**
      - ``url`` -- the URL of the document or file, or None if an error occured
      - ``body`` -- the text content of the HTML document.
    """
    import logging as log
    import socket
    from eventlet import Timeout
    from eventlet.green import urllib2
    import sys

    # TRY AND DOWNLOAD X TIMES BEFORE QUITING
    tries = 10
    count = 1
    downloaded = False
    while count < tries and downloaded == False:
        try:
            log.debug('downloading ' + url.get_full_url())
            body = urllib2.urlopen(url).read()
            downloaded = True
        except socket.timeout, e:
            print "timeout on URL, trying again"
            count += 1
        except Exception, e:
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
