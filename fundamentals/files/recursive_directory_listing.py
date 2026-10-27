#!/usr/local/bin/python
# encoding: utf-8
"""
*List the contents of a directory recursively*

Author
: David Young
"""

import os

os.environ["TERM"] = "vt100"
from fundamentals import tools

VALID_WHAT_TO_LIST = ("all", "dirs", "files")


def recursive_directory_listing(log, baseFolderPath, whatToList="all"):
    """*list directory contents recursively.*

    Options to list only files or only directories.

    **Key Arguments**

    - ``log`` -- logger
    - ``baseFolderPath`` -- path to the base folder to list contained files and folders recursively
    - ``whatToList`` -- list files only, directories only or all [ "files" | "dirs" | "all" ]


    **Return**

    - ``matchedPathList`` -- the matched paths


    **Usage**

    ```python
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
    ```
    """
    log.debug("starting the ``recursive_directory_listing`` function")

    if whatToList not in VALID_WHAT_TO_LIST:
        raise ValueError(
            'could not list files in %s, `whatToList` variable incorrect: [ "files" | "dirs" | "all" ]'
            % (baseFolderPath,)
        )

    def _log_unreadable(error):
        # A BAD BASE FOLDER IS A CALLER MISTAKE; ONLY SUBDIRECTORIES ARE SKIPPED
        if error.filename == baseFolderPath:
            raise error
        log.warning("skipping unreadable directory: %s" % (error,))

    matchedPathList = []
    for parentDir, dirNames, fileNames in os.walk(
        baseFolderPath, followlinks=False, onerror=_log_unreadable
    ):
        # SYMLINKED DIRECTORIES APPEAR IN dirNames BUT ARE NOT DESCENDED INTO
        if whatToList in ("all", "dirs"):
            matchedPathList.extend(os.path.join(parentDir, d) for d in dirNames)
        if whatToList == "all":
            matchedPathList.extend(os.path.join(parentDir, f) for f in fileNames)
        elif whatToList == "files":
            # EXCLUDE BROKEN SYMLINKS AND SPECIAL FILES, AS BEFORE
            matchedPathList.extend(
                fullPath
                for fullPath in (os.path.join(parentDir, f) for f in fileNames)
                if os.path.isfile(fullPath)
            )

    log.debug("completed the ``recursive_directory_listing`` function")
    return matchedPathList
