#!/usr/local/bin/python
# encoding: utf-8
"""
*Download resources from a list of URLs.

There are options to rename all the downloaded resource, index the files, set differing download locations and pass basic authentication credentials.*

Author
: David Young
"""

from __future__ import print_function
from future import standard_library

standard_library.install_aliases()
from builtins import zip
from builtins import str
import sys
import os

os.environ["TERM"] = "vt100"
from fundamentals import tools
from urllib.parse import quote
from datetime import datetime
import requests
from multiprocessing.pool import ThreadPool

import random
import time

CHUNK_SIZE = 65536
MAX_TRIES = 5


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
    indexFilenames=False,
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
    - ``resetFilename`` -- a string to reset all filenames to, or a list of filenames the same length as urlList (one per URL). ``indexFilenames`` does not apply to reset filenames
    - ``credentials`` -- basic http credentials { 'username' : "...", "password", "..." }
    - ``indexFilenames`` -- prepend filenames with index (where url appears in urllist)

    **Return**

    - list of local file paths, the same length and order as the input urlList. A download that fails (after retries) gives ``None`` in its slot and leaves no partial file

    **Raises**

    - ``ValueError`` -- if ``downloadDirectory`` or ``resetFilename`` is a list that is not the same length as ``urlList``

    **Usage**

    ```python
    # download the pages linked from the main list page
    from fundamentals.download import multiobject_download
    localUrls = multiobject_download(
        urlList=["https://www.python.org/dev/peps/pep-0257/","https://en.wikipedia.org/wiki/Docstring"],
        downloadDirectory="/tmp",
        log=log,
        timeStamp=True,
        timeout=180,
        concurrentDownloads=2,
        resetFilename=False,
        credentials=False,  # { 'username' : "...", "password", "..." }
        longTime=True
    )

    print(localUrls)
    # OUT: ['/tmp/untitled_20160316t160650610780.html',
    # '/tmp/Docstring_20160316t160650611136.html']
    ```

    .. image:: https://i.imgur.com/QYoMm24.png width=600px

    """
    timeout = float(timeout)
    totalCount = len(urlList)
    downloadDirectories = _expand_to_list(
        downloadDirectory, totalCount, "downloadDirectory"
    )
    resetFilenames = _expand_to_list(resetFilename, totalCount, "resetFilename")

    # BUILD THE 2D ARRAY FOR MULTI_THREADED DOWNLOADS
    thisArray = []
    for i, (url, d, resetName) in enumerate(
        zip(urlList, downloadDirectories, resetFilenames)
    ):
        filename = _local_filename(
            log, url, i, resetName, timeStamp, longTime, indexFilenames
        )
        # ADD BASIC AUTH TO THE URLS (AFTER THE FILENAME IS EXTRACTED SO CREDENTIALS ARE NEVER LOGGED)
        if credentials != False:
            url = _add_credentials_to_url(url, credentials)
        thisArray.append([url, d + "/" + filename, timeout, log])

    # CONCURRENTLY DOWNLOAD URLS - RESULTS COME BACK IN THE ORDER OF urlList
    localPaths = []
    with ThreadPool(concurrentDownloads) as pool:
        for urlNum, path in enumerate(pool.imap(fetch_url, thisArray), start=1):
            localPaths.append(path)
            if urlNum > 1:
                # CURSOR UP ONE LINE AND CLEAR LINE
                sys.stdout.write("\x1b[1A\x1b[2K")
            percent = (float(urlNum) / float(totalCount)) * 100.0
            print(
                "  %(urlNum)s / %(totalCount)s (%(percent)1.1f%%) URLs downloaded"
                % locals()
            )

    return localPaths


def _expand_to_list(value, length, name):
    """
    *return ``value`` as a list of ``length`` items - a single value is repeated and a list must already be the right length*

    **Raises**

    - ``ValueError`` -- if ``value`` is a list of the wrong length
    """
    if isinstance(value, list):
        if len(value) != length:
            raise ValueError(
                "%s has %s items but urlList has %s" % (name, len(value), length)
            )
        return value
    return [value] * length


def _add_credentials_to_url(url, credentials):
    """
    *return the url with percent-encoded basic-auth credentials embedded*
    """
    userInfo = "%s:%s@" % (
        quote(credentials["username"], safe=""),
        quote(credentials["password"], safe=""),
    )
    if "://" in url:
        return url.replace("://", "://" + userInfo, 1)
    return userInfo + url


def _local_filename(log, url, index, resetName, timeStamp, longTime, indexFilenames):
    """
    *work out the local filename for the url at position ``index`` in the url list*
    """
    from fundamentals.download import (
        append_now_datestamp_to_filename,
        extract_filename_from_url,
    )

    if resetName:
        filename = resetName
    else:
        filename = extract_filename_from_url(log, url)
        if filename and indexFilenames:
            filename = "%03d_%s" % (index, filename)

    if not filename:
        filename = datetime.now().strftime("%Y%m%dt%H%M%S%f")

    if timeStamp:
        # APPEND TIMESTAMP TO THE FILENAME
        filename = append_now_datestamp_to_filename(log, filename, longTime=longTime)
    return filename


def fetch_url(entry):
    """
    *download one url to a local file, retrying on failure*

    **Key Arguments**

    - ``entry`` -- a (url, local path, timeout in seconds, logger) tuple

    **Return**

    - the local path, or ``None`` if every attempt failed. Failed attempts never leave a partial file behind and the url (which may hold credentials) is never logged
    """
    uri, path, timeout, log = entry

    time.sleep(random.randint(1, 101) / 20.0)

    for attempt in range(1, MAX_TRIES + 1):
        r = None
        try:
            r = requests.get(uri, stream=True, timeout=timeout)
            if r.status_code == 200:
                with open(path, "wb") as f:
                    for chunk in r.iter_content(CHUNK_SIZE):
                        f.write(chunk)
                return path
            log.warning(
                f"Getting status code {r.status_code} on download attempt {attempt}/{MAX_TRIES}."
            )
        except Exception as e:
            # ONLY THE EXCEPTION TYPE IS LOGGED AS ITS MESSAGE CAN HOLD THE URL
            timeout *= 2
            log.warning(
                f"{type(e).__name__} on attempt number {attempt}/{MAX_TRIES}. Increasing timeout to {timeout}s"
            )
            _remove_file(path)
        finally:
            if r is not None:
                r.close()

    return None


def _remove_file(path):
    """
    *delete a file, ignoring the case where it was never created*
    """
    try:
        os.remove(path)
    except FileNotFoundError:
        pass
