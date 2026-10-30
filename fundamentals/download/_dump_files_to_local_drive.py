#!/usr/local/bin/python
# encoding: utf-8
"""
*Write the contents of HTML documents from memory to individual files*

Author
: David Young
"""

from builtins import str
import os

os.environ["TERM"] = "vt100"


def _dump_files_to_local_drive(bodies, theseUrls, log):
    """
    *takes the files stored in memory and dumps them to the local drive*

    **Key Arguments**


    - ``bodies`` -- array of file data (currently stored in memory)
    - ``theseUrls`` -- array of local files paths to dump the file data into
    - ``log`` -- the logger

    **Return**


    - ``failedPaths`` -- list of the target paths that were not written (body was ``None`` or the write failed). An empty list means every file was written
    """
    log.debug("attempting to write file data to local drive")
    log.debug(
        "%s URLS = %s"
        % (
            len(theseUrls),
            str(theseUrls),
        )
    )
    failedPaths = []
    for body, path in zip(bodies, theseUrls):
        if not path:
            continue
        if body is None:
            log.warning(
                "no data was downloaded for %s, so no file was written" % (path,)
            )
            failedPaths.append(path)
            continue
        try:
            with open(path, "wb") as f:
                f.write(body)
        except Exception as e:
            log.error(
                "could not write downloaded file %s to local drive - failed with this error %s: "
                % (path, str(e))
            )
            failedPaths.append(path)
    return failedPaths
