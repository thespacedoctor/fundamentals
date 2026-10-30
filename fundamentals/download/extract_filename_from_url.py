#!/usr/local/bin/python
# encoding: utf-8
"""
*Try and extract the name of the document located at the given URL*

Author
: David Young
"""

from builtins import str
import os
import re
from urllib.parse import urlparse

os.environ["TERM"] = "vt100"

# THE OPTIONAL SCHEME AND THE USER:PASSWORD@ PART THAT FOLLOWS IT
USERINFO_PATTERN = re.compile(r"^((?:[A-Za-z][A-Za-z0-9+.-]*://)?)[^/?#]*@")


def _remove_userinfo(url):
    """*return the url without any ``user:password@`` part, so it is safe to log*"""
    return USERINFO_PATTERN.sub(r"\1", url)


def extract_filename_from_url(log, url):
    """
    *get the filename from a URL.*

    *Will return 'untitled.html', if no filename is found.*

    **Key Arguments**

    - ``url`` -- the url to extract filename from


    Returns:
        - ``filename`` -- the filename

    **Usage**

    ```python
    from fundamentals.download import extract_filename_from_url
    name = extract_filename_from_url(
        log=log,
        url="https://en.wikipedia.org/wiki/Docstring"
    )
    print name
    # OUT: Docstring.html
    ```

    """
    # EXTRACT THE FILENAME FROM THE URL
    try:
        log.debug("extracting filename from url " + _remove_userinfo(url))
        reEoURL = re.compile(r"([\w\.\_\-]*)$")
        # USE THE PATH ONLY, IGNORING ANY QUERY STRING OR FRAGMENT
        urlPath = urlparse(url).path
        filename = reEoURL.findall(urlPath)[0]
        # log.debug(filename)
        if len(filename) == 0:
            filename = "untitled.html"
        if not (re.search(r"\.", filename)):
            filename = filename + ".html"
    except Exception as e:
        filename = None
        # print url
        log.warning("could not extracting filename from url : " + str(e) + "\n")

    return filename
