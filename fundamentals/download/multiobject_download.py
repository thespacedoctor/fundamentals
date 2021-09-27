#!/usr/local/bin/python
# encoding: utf-8
"""
*Download resources from a list of URLs.

There are options to rename all the downloaded resource, index the files, set differing download locations and pass basic authentication credentials.*

:Author:
    David Young
"""
from __future__ import print_function
from future import standard_library
standard_library.install_aliases()
from builtins import zip
from builtins import str
import sys
import os
os.environ['TERM'] = 'vt100'
from fundamentals import tools
import urllib
import requests
from multiprocessing.pool import ThreadPool
gtimeout = 10.
llog = ""
import random
import time


def multiobject_download(
    urlList,
    downloadDirectory,
    log,
    timeStamp=True,
    timeout=180,
    concurrentDownloads=10,
    resetFilename=False,
    credentials=False,
    longTime=False,
    indexFilenames=False
):
    """
    *get multiple url documents and place them in specified download directory/directories*

    **Key Arguments**

      - ``urlList`` -- list of document urls
      - ``downloadDirectory`` -- directory(ies) to download the documents to - can be one directory path or a list of paths the same length as urlList
      - ``log`` -- the logger
      - ``timestamp`` -- append a timestamp the name of the URL (ensure unique filenames)
      - ``longTime`` -- use a longer timestamp when appending to the filename (greater uniqueness)
      - ``timeout`` -- the timeout limit for downloads (secs)
      - ``concurrentDownloads`` -- the number of concurrent downloads allowed at any one time
      - ``resetFilename`` -- a string to reset all filenames to
      - ``credentials`` -- basic http credentials { 'username' : "...", "password", "..." }
      - ``indexFilenames`` -- prepend filenames with index (where url appears in urllist)

    **Return**

      - list of timestamped documents (same order as the input urlList)

    **Usage**

    ```python
    # download the pages linked from the main list page
    from fundamentals.download import multiobject_download
    localUrls = multiobject_download(
        urlList=["https://www.python.org/dev/peps/pep-0257/","https://en.wikipedia.org/wiki/Docstring"],
        downloadDirectory="/tmp",
        log="log",
        timeStamp=True,
        timeout=180,
        concurrentDownloads=2,
        resetFilename=False,
        credentials=False,  # { 'username' : "...", "password", "..." }
        longTime=True
    )

    print localUrls
    # OUT: ['/tmp/untitled_20160316t160650610780.html',
    # '/tmp/Docstring_20160316t160650611136.html']
    ```

    .. image:: https://i.imgur.com/QYoMm24.png width=600px

    """
    import sys
    import os
    import re
    from fundamentals.download import append_now_datestamp_to_filename, extract_filename_from_url

    # TIMEOUT IN SECONDS
    global gtimeout
    global llog
    llog = log
    gtimeout = float(timeout)

    # BUILD THE 2D ARRAY FOR MULTI_THREADED DOWNLOADS
    thisArray = []
    bodies = []
    localUrls = []
    theseUrls = []
    requestList = []

    totalCount = len(urlList)

    # IF ONLY ONE DOWNLOAD DIRECORY
    if not isinstance(downloadDirectory, list):
        for i, url in enumerate(urlList):
            # EXTRACT THE FILENAME FROM THE URL
            if resetFilename and len(resetFilename):
                filename = resetFilename[i]
            else:
                filename = extract_filename_from_url(log, url)
                if indexFilenames:
                    filename = """%(i)03d_%(filename)s""" % locals()

            if not filename:
                from datetime import datetime, date, time
                now = datetime.now()
                filename = now.strftime("%Y%m%dt%H%M%S%f")

            if(timeStamp):
                # APPEND TIMESTAMP TO THE FILENAME
                filename = append_now_datestamp_to_filename(
                    log, filename, longTime=longTime)
            # GENERATE THE LOCAL FILE URL
            localFilepath = downloadDirectory + "/" + filename

            # ADD BASIC AUTH TO THE URLS
            if credentials != False:
                url_pass = f'{credentials["username"]}:{credentials["password"]}@'
                if "://" in url:
                    url = url.replace("://", "://" + url_pass)
                else:
                    url = url_pass + url
            thisArray.extend([[url, localFilepath]])

    else:
        for url, d in zip(urlList, downloadDirectory):
            # EXTRACT THE FILENAME FROM THE URL
            if resetFilename:
                filename = resetFilename
            else:
                filename = extract_filename_from_url(log, url)

            if not filename:
                continue

            if(timeStamp):
                # APPEND TIMESTAMP TO THE FILENAME
                filename = append_now_datestamp_to_filename(
                    log, filename)
            # GENERATE THE LOCAL FILE URL
            localFilepath = d + "/" + filename
            thisArray.extend([[url, localFilepath]])

            # ADD BASIC AUTH TO THE URLS
            if credentials != False:
                url_pass = f'{credentials["username"]}:{credentials["password"]}@'
                if "://" in url:
                    url = url.replace("://", "://" + url_pass)
                else:
                    url = url_pass + url

    # CONCURRENTLY DOWNLOAD URLS
    results = ThreadPool(concurrentDownloads).imap_unordered(
        fetch_url, thisArray)
    urlNum = 0
    returnPaths = []
    for path in results:
        returnPaths.append(path)
        urlNum += 1
        if urlNum > 1:
            # CURSOR UP ONE LINE AND CLEAR LINE
            sys.stdout.write("\x1b[1A\x1b[2K")
        percent = (float(urlNum) / float(totalCount)) * 100.
        print("  %(urlNum)s / %(totalCount)s (%(percent)1.1f%%) URLs downloaded" % locals())

    localPaths = []
    localPaths[:] = [o[1] for o in thisArray if o[1] in returnPaths]

    return localPaths


def fetch_url(entry):
    downloaded = False
    tries = 5
    count = 0
    uri, path = entry
    timeout = gtimeout

    randSleep = random.randint(1, 101) / 20.

    time.sleep(randSleep)

    while not downloaded and count < tries:
        try:
            r = requests.get(uri, stream=True, timeout=timeout)
        except:
            count += 1
            timeout *= 2
            llog.warning(f"timeout on attempt number {count}/{tries}. Increasing to {timeout}s")
            continue

        if r.status_code == 200:
            with open(path, 'wb') as f:
                for chunk in r:
                    f.write(chunk)
            return path
        else:
            count += 1
            llog.warning(f"Getting status code {r.status_code} on download attempt {count}/{tries}.")
            downloaded = False

    return None
