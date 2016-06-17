#!/usr/local/bin/python
# encoding: utf-8
"""
*List the contents of a directory recursively*

:Author:
    David Young

:Date Created:
    June 17, 2016
"""
################# GLOBAL IMPORTS ####################
import sys
import os
os.environ['TERM'] = 'vt100'
from fundamentals import tools


def recursive_directory_listing(
    log,
    baseFolderPath,
    whatToList="all"
):
    """*list directory contents recursively.*

    Options to list only files or only directories.

    **Key Arguments:**
        - ``log`` -- logger
        - ``baseFolderPath`` -- path to the base folder to list contained files and folders recursively
        - ``whatToList`` -- list files only, durectories only or all [ "files" | "dirs" | "all" ]

    **Return:**
        - ``matchedPathList`` -- the matched paths

    **Usage:**

        .. code-block:: python 

            from fundamentals.files import recursive_directory_listing
            theseFiles = recursive_directory_listing(
                log,
                baseFolderPath="/tmp"
            )

            # OR JUST FILE  

            from fundamentals.files import recursive_directory_listing
            theseFiles = recursive_directory_listing(
                log,
                baseFolderPath="/tmp",
                whatToList="files"
            )


            # OR JUST FOLDERS   

            from fundamentals.files import recursive_directory_listing
            theseFiles = recursive_directory_listing(
                log,
                baseFolderPath="/tmp",
                whatToList="dirs"
            )
            print theseFiles        
    """
    log.info('starting the ``recursive_directory_listing`` function')

    ## VARIABLES ##
    matchedPathList = []
    parentDirectoryList = [baseFolderPath, ]

    count = 0
    while os.listdir(baseFolderPath) and count < 20:
        count += 1

        while len(parentDirectoryList) != 0:
            childDirList = []
            for parentDir in parentDirectoryList:
                try:
                    thisDirList = os.listdir(parentDir)
                except Exception, e:
                    log.error(e)
                    continue

                for d in thisDirList:
                    fullPath = os.path.join(parentDir, d)

                    if whatToList is "all":
                        matched = True
                    elif whatToList is "dirs":
                        matched = os.path.isdir(fullPath)
                    elif whatToList is "files":
                        matched = os.path.isfile(fullPath)
                    else:
                        log.error(
                            'cound not list files in %s, `whatToList` variable incorrect: [ "files" | "dirs" | "all" ]' % (baseFolderPath,))
                        sys.exit(0)

                    if matched:
                        matchedPathList.append(fullPath)

                    # UPDATE DIRECTORY LISTING
                    if os.path.isdir(fullPath):
                        childDirList.append(fullPath)

                parentDirectoryList = childDirList

    log.info('completed the ``recursive_directory_listing`` function')
    return matchedPathList
