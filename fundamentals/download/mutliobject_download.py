#!/usr/local/bin/python
# encoding: utf-8
"""
mutliobject_download.py
=======================
:Summary:
    Download resources from a list of URLs. There are options to rename all the downloaded resource, index the files, set differing download locations and pass basic authentication credentials.

:Author:
    David Young

:Date Created:
    March  3, 2016

:dryx syntax:
    - ``_someObject`` = a 'private' object that should only be changed for debugging

:Notes:
    - If you have any questions requiring this script/module please email me: davidrobertyoung@gmail.com

:Tasks:
    @review: when complete pull all general functions and classes into dryxPython
"""
################# GLOBAL IMPORTS ####################
import sys
import os
os.environ['TERM'] = 'vt100'
from fundamentals import tools


def mutliobject_download(
    urlList,
    downloadDirectory,
    log,
    timeStamp=1,
    timeout=180,
    concurrentDownloads=10,
    resetFilename=False,
    credentials=False,
    longTime=False,
    indexFilenames=False
):
    """get multiple url documents and place in specified download directory

        ****Key Arguments:****
          - ``urlList`` -- list of document urls
          - ``downloadDirectory`` -- directory(ies) to download the documents to - can be one url or a list of urls the same length as urlList
          - ``resetFilename`` -- a string to reset all filenames to
          - ``credentials`` -- basic http credentials { 'username' : "...", "password", "..." }
          - ``indexFilenames`` -- prepend filenames with index (where url appears in urllist)

        **Return:**
          - list of timestamped documents (same order as the input urlList)
    """
    ## > IMPORTS ##
    import sys
    import os
    import eventlet
    from eventlet.green import urllib2
    import socket
    import re
    import base64
    from fundamentals.download import _fetch, _dump_files_to_local_drive, append_now_datestamp_to_filename, extract_filename_from_url

    ## >SETTINGS ##
    # timeout in seconds
    timeout = float(timeout)
    socket.setdefaulttimeout(timeout)

    ###########################################################
    # >ACTION(S)                                              #
    ###########################################################
    # BUILD THE 2D ARRAY FOR MULTI_THREADED DOWNLOADS
    thisArray = []
    bodies = []
    localUrls = []
    theseUrls = []
    requestList = []

    totalCount = len(urlList)

    # if only one download direcory
    if isinstance(downloadDirectory, str):
        for i, url in enumerate(urlList):
            # EXTRACT THE FILENAME FROM THE URL
            if len(resetFilename):
                filename = resetFilename[i]
            else:
                filename = extract_filename_from_url(log, url)
                if indexFilenames:
                    filename = """%(i)03d_%(filename)s""" % locals()

            if not filename:
                continue

            if(timeStamp):
                # APPEND TIMESTAMP TO THE FILENAME
                filename = append_now_datestamp_to_filename(
                    log, filename, longTime=longTime)
            # GENERATE THE LOCAL FILE URL
            localFilepath = downloadDirectory + "/" + filename
            thisArray.extend([[url, localFilepath]])

            # GENERATE THE REQUESTS
            request = urllib2.Request(url)
            if credentials != False:
                username = credentials["username"]
                password = credentials["password"]
                base64string = base64.encodestring(
                    '%s:%s' % (username, password)).replace('\n', '')
                request.add_header("Authorization", "Basic %s" % base64string)
            requestList.append(request)

    elif isinstance(downloadDirectory, list):
        for u, d in zip(urlList, downloadDirectory):
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
            thisArray.extend([[u, localFilepath]])
            log.debug(" about to download %s" % (u,))

            # GENERATE THE REQUESTS
            request = urllib2.Request(u)
            if credentials != False:
                log.debug('adding the credentials')
                username = credentials["username"]
                password = credentials["password"]
                base64string = base64.encodestring(
                    '%s:%s' % (username, password)).replace('\n', '')
                request.add_header("Authorization", "Basic %s" % base64string)
            requestList.append(request)

    pool = eventlet.GreenPool(concurrentDownloads)
    i = 0
    try:

        log.debug(
            "starting mutli-threaded download batch - %s concurrent downloads" %
            (concurrentDownloads,))
        log.debug('len(requestList): %s' % (len(requestList),))
        for url, body in pool.imap(_fetch, requestList):
            urlNum = i + 1
            if urlNum > 1:
                # Cursor up one line and clear line
                sys.stdout.write("\x1b[1A\x1b[2K")
            percent = (float(urlNum) / float(totalCount)) * 100.
            print "  %(urlNum)s / %(totalCount)s (%(percent)1.1f%%) URLs downloaded" % locals()

            if(body):
                bodies.extend([body])
                theseUrls.extend([thisArray[i][1]])
            else:
                theseUrls.extend([None])
                bodies.extend([None])

            # DUMP THE FILES FROM MEMORY EVERY CONCURRENT DOWNLOAD CYCLE
            if i % concurrentDownloads == 0:
                _dump_files_to_local_drive(bodies, theseUrls, log)
                localUrls.extend(theseUrls)
                # RESET THE TMP ARRAYS
                bodies = []
                theseUrls = []
            i += 1
    except eventlet.Timeout, e:
        log.error(
            "something went wrong with the mutli-threaded download : " + str(e) + "\n")

    # DUMP REMAINING FILES TO THE LOCAL DRIVE
    _dump_files_to_local_drive(bodies, theseUrls, log)
    localUrls.extend(theseUrls)

    return localUrls

    # xt-class-method

    # 5. @flagged: what actions of the base class(es) need ammending? ammend them here
    # Override Method Attributes
    # method-override-tmpx
