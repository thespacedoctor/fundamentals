#!/usr/local/bin/python
# encoding: utf-8
"""
*Write the contents of HTML documents from memory to individual files*

:Author:
    David Young
"""
from builtins import str
import sys
import os
os.environ['TERM'] = 'vt100'
from fundamentals import tools

def _dump_files_to_local_drive(bodies, theseUrls, log):
    """
    *takes the files stored in memory and dumps them to the local drive*

    **Key Arguments**

    
      - ``bodies`` -- array of file data (currently stored in memory)
      - ``theseUrls`` -- array of local files paths to dump the file data into
      - ``log`` -- the logger

    **Return**

    
      - ``None``
    """
    j = 0
    log.debug("attempting to write file data to local drive")
    log.debug('%s URLS = %s' % (len(theseUrls), str(theseUrls),))
    for body in bodies:
        try:
            if theseUrls[j]:
                with open(theseUrls[j], 'wb') as f:
                    f.write(body)
                f.close()
            j += 1
        except Exception as e:
            log.error(
                "could not write downloaded file to local drive - failed with this error %s: " %
                (str(e),))
            return -1
    return
