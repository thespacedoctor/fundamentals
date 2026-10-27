#!/usr/local/bin/python
# encoding: utf-8
"""
*Append a datetime stamp to the end of a filename to ensure uniqueness*

Author
: David Young
"""

from builtins import str
import sys
import os

os.environ["TERM"] = "vt100"
from fundamentals import tools


def append_now_datestamp_to_filename(log, filename, longTime=False):
    """
    *append the current datestamp to the end of the filename (before the extension).*

    **Key Arguments**

    - ``log`` -- logger
    - ``filename`` -- the filename
    - ``longTime`` -- use a longer time-stmap. Default *False*

    **Return**

    - ``dsFilename`` -- datestamped filename. Only the last extension is kept (`a.tar.gz` becomes `a.tar_<stamp>.gz`) and a name with no extension gets none added (`noext` becomes `noext_<stamp>`)

    **Raises**

    - ``TypeError`` -- if ``filename`` is not a string

    **Usage**

    ```python
    # APPEND TIMESTAMP TO THE FILENAME
    from fundamentals.download import append_now_datestamp_to_filename
    filename = append_now_datestamp_to_filename(
            log=log,
            filename="some_filename.html",
            longTime=True
    )

    # OUTPUT
    # 'some_filename_20160316t154123749472.html'
    ```
    """
    from fundamentals.download import get_now_datetime_filestamp

    if not isinstance(filename, str):
        message = "filename must be a string, not %s" % (type(filename).__name__,)
        log.error("could not append date stamp to the filename : %s", message)
        raise TypeError(message)

    root, extension = os.path.splitext(filename)
    dsFilename = root + "_" + get_now_datetime_filestamp(longTime=longTime) + extension

    return dsFilename
