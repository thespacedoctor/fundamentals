#!/usr/local/bin/python
# encoding: utf-8
"""
*Add tags and ratings to your macOS files and folders*

Author
: David Young
"""

import sys
import os
import shlex
import tempfile

os.environ["TERM"] = "vt100"
from fundamentals import tools
from subprocess import Popen, PIPE
import codecs


def tag(log, filepath, tags=False, rating=False, wherefrom=False):
    """Add tags and ratings to your macOS files and folders

    **Key Arguments**

    - ``log`` -- logger
    - ``filepath`` -- the path to the file needing tagged
    - ``tags`` -- comma or space-separated string, or list of tags. Use `False` to leave file tags as they are. Use "" or [] to remove tags. Default *False*.
    - ``rating`` -- a rating to add to the file. Use 0 to remove rating or `False` to leave file rating as it is. Default *False*.
    - ``wherefrom`` -- add a URL to indicate where the file come from. Use `False` to leave file location as it is. Use "" to remove location. Default *False*.


    **Return**

    - None


    **Usage**

    To add any combination of tags, rating and a source URL to a file on macOS, use the following:

    ```python
    from fundamentals.files.tag import tag
    tag(
        log=log,
        filepath="/path/to/my.file",
        tags="test,tags, fundamentals",
        rating=3,
        wherefrom="http://www.thespacedoctor.co.uk"
    )
    ```

    """
    log.debug("starting the ``tag`` function")

    if isinstance(tags, list):
        tags = (" ").join(tags)

    if tags and len(tags):
        tags = tags.replace(",", " ")
        tags = (
            "<string>"
            + tags.replace("  ", " ")
            .replace("  ", " ")
            .replace(" ", "</string><string>")
            + "</string>"
        )

    # SCRATCH PLISTS LIVE IN A PRIVATE TEMP DIRECTORY, REMOVED EVEN ON ERROR
    with tempfile.TemporaryDirectory(prefix="fundamentals-tag-") as tmpDir:

        if tags != False:
            tagPlistPath = os.path.join(tmpDir, "tags.plist")
            tagPlist = shlex.quote(tagPlistPath)
            _write_plist(
                path=tagPlistPath,
                body="<array>\n%(tags)s \n</array>" % locals(),
            )

            # CONVERT PLIST TO BINARY
            cmd = """plutil -convert binary1 %(tagPlist)s""" % locals()
            p = Popen(cmd, stdout=PIPE, stderr=PIPE, shell=True)
            stdout, stderr = p.communicate()
            log.debug("output: %(stdout)s" % locals())
            log.debug("output: %(stderr)s" % locals())

            # ASSIGN TAGS TO FILE
            cmd = (
                'xattr -wx "com.apple.metadata:_kMDItemUserTags" "$(xxd -ps %(tagPlist)s)" "%(filepath)s"'
                % locals()
            )
            p = Popen(cmd, stdout=PIPE, stderr=PIPE, shell=True)
            stdout, stderr = p.communicate()
            log.debug("output: %(stdout)s" % locals())
            log.debug("output: %(stderr)s" % locals())

        if rating != False:

            ratingsContainer = os.path.dirname(__file__) + "/resources/ratings/"
            ratingPlist = "%(ratingsContainer)s%(rating)s.plist" % locals()

            # ASSIGN RATING TO FILE
            cmd = (
                'xattr -wx "com.apple.metadata:kMDItemStarRating" "`xxd -ps %(ratingPlist)s`" "%(filepath)s"'
                % locals()
            )
            p = Popen(cmd, stdout=PIPE, stderr=PIPE, shell=True)
            stdout, stderr = p.communicate()
            log.debug("output: %(stdout)s" % locals())
            log.debug("output: %(stderr)s" % locals())
            cmd = (
                'xattr -wx "org.openmetainfo:kMDItemStarRating" "`xxd -ps %(ratingPlist)s`" "%(filepath)s"'
                % locals()
            )
            p = Popen(cmd, stdout=PIPE, stderr=PIPE, shell=True)
            stdout, stderr = p.communicate()
            log.debug("output: %(stdout)s" % locals())
            log.debug("output: %(stderr)s" % locals())

        if wherefrom != False:

            if len(wherefrom):
                wherefrom = "<string>%(wherefrom)s</string>" % locals()

            urlPlistPath = os.path.join(tmpDir, "url.plist")
            urlPlist = shlex.quote(urlPlistPath)
            _write_plist(path=urlPlistPath, body=wherefrom)

            # ASSIGN WHEREFROM TO FILE
            cmd = (
                'xattr -wx "com.apple.metadata:kMDItemURL" "$(xxd -ps %(urlPlist)s)" "%(filepath)s"'
                % locals()
            )
            p = Popen(cmd, stdout=PIPE, stderr=PIPE, shell=True)
            stdout, stderr = p.communicate()
            log.debug("output URL: %(stdout)s" % locals())
            log.debug("output URL: %(stderr)s" % locals())

            wherefromsPlistPath = os.path.join(tmpDir, "wherefroms.plist")
            wherefromsPlist = shlex.quote(wherefromsPlistPath)
            _write_plist(
                path=wherefromsPlistPath,
                body="<array>\n%(wherefrom)s\n</array>" % locals(),
            )

            # ASSIGN WHEREFROMS TO FILE
            cmd = (
                'xattr -wx "com.apple.metadata:kMDItemWhereFroms" "$(xxd -ps %(wherefromsPlist)s)" "%(filepath)s"'
                % locals()
            )
            p = Popen(cmd, stdout=PIPE, stderr=PIPE, shell=True)
            stdout, stderr = p.communicate()
            log.debug("output URL: %(stdout)s" % locals())
            log.debug("output URL: %(stderr)s" % locals())

    log.debug("completed the ``tag`` function")
    return None


def _write_plist(path, body):
    """*write an XML plist file wrapping the given body*

    **Key Arguments**

    - ``path`` -- path of the plist file to write
    - ``body`` -- XML content to place inside the ``<plist>`` element
    """
    with codecs.open(path, encoding="utf-8", mode="w") as writeFile:
        writeFile.write("""
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
%(body)s
</plist>""" % locals())
