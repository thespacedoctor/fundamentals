#!/usr/local/bin/python
# encoding: utf-8
"""
*Add tags and ratings to your macOS files and folders*

:Author:
    David Young

:Date Created:
    June 16, 2017
"""
################# GLOBAL IMPORTS ####################
import sys
import os
os.environ['TERM'] = 'vt100'
from fundamentals import tools
from subprocess import Popen, PIPE, STDOUT
from datetime import datetime, date, time
import codecs


def tag(
        log,
        filepath,
        tags=False,
        rating=False,
        wherefrom=False):
    """Add tags and ratings to your macOS files and folders

    **Key Arguments:**
        - ``log`` -- logger
        - ``filepath`` -- the path to the file needing tagged
        - ``tags`` -- comma or space-separated string, or list of tags. Use `False` to leave file tags as they are. Use "" or [] to remove tags. Default *False*.
        - ``rating`` -- a rating to add to the file. Use 0 to remove rating or `False` to leave file rating as it is. Default *False*.
        - ``wherefrom`` -- add a URL to indicate where the file come from. Use `False` to leave file location as it is. Use "" to remove location. Default *False*.

    **Return:**
        - None

    **Usage:**

        To add any combination of tags, rating and a source URL to a file on macOS, use the following:

        .. code-block:: python 

            from fundamentals.files.tag import tag
            tag(
                log=log,
                filepath="/path/to/my.file",
                tags="test,tags, fundamentals",
                rating=3,
                wherefrom="http://www.thespacedoctor.co.uk"
            )
    """
    log.info('starting the ``tag`` function')

    if isinstance(tags, list):
        tags = (" ").join(tags)

    if len(tags):
        tags = tags.replace(",", " ")
        tags = "<string>" + tags.replace("  ", " ").replace(
            "  ", " ").replace(" ", "</string><string>") + "</string>"

    if tags != False:
        now = datetime.now()
        now = now.strftime("%Y%m%dt%H%M%S%f")
        tagPlist = "/tmp/fund-%(now)s-tags.plist" % locals()
        # GENERATE THE TAGS PLIST FILE
        try:
            writeFile = codecs.open(
                tagPlist, encoding='utf-8', mode='w')
        except IOError, e:
            message = 'could not open the file %s' % (tagPlist,)
            raise IOError(message)
        writeFile.write("""
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
%(tags)s 
</array>
</plist>""" % locals())
        writeFile.close()

        # CONVERT PLIST TO BINARY
        cmd = """plutil -convert binary1 %(tagPlist)s""" % locals(
        )
        p = Popen(cmd, stdout=PIPE, stderr=PIPE, shell=True)
        stdout, stderr = p.communicate()
        log.debug('output: %(stdout)s' % locals())
        log.debug('output: %(stderr)s' % locals())

        # ASSIGN TAGS TO FILE
        cmd = 'xattr -wx "com.apple.metadata:_kMDItemUserTags" "`xxd -ps %(tagPlist)s`" %(filepath)s' % locals(
        )
        p = Popen(cmd, stdout=PIPE, stderr=PIPE, shell=True)
        stdout, stderr = p.communicate()
        log.debug('output: %(stdout)s' % locals())
        log.debug('output: %(stderr)s' % locals())

        # DELETE PLIST
        os.remove(tagPlist)

    if rating != False:

        ratingsContainer = os.path.dirname(__file__) + "/resources/ratings/"
        ratingPlist = "%(ratingsContainer)s%(rating)s.plist" % locals(
        )

        # ASSIGN RATING TO FILE
        cmd = 'xattr -wx "com.apple.metadata:kMDItemStarRating" "`xxd -ps %(ratingPlist)s`" %(filepath)s' % locals(
        )
        p = Popen(cmd, stdout=PIPE, stderr=PIPE, shell=True)
        stdout, stderr = p.communicate()
        log.debug('output: %(stdout)s' % locals())
        log.debug('output: %(stderr)s' % locals())
        cmd = 'xattr -wx "org.openmetainfo:kMDItemStarRating" "`xxd -ps %(ratingPlist)s`" %(filepath)s' % locals(
        )
        p = Popen(cmd, stdout=PIPE, stderr=PIPE, shell=True)
        stdout, stderr = p.communicate()
        log.debug('output: %(stdout)s' % locals())
        log.debug('output: %(stderr)s' % locals())

    if wherefrom != False:

        if len(wherefrom):
            wherefrom = "<string>%(wherefrom)s</string>" % locals()

        # DAYONE LINK
        now = datetime.now()
        now = now.strftime("%Y%m%dt%H%M%S%f")
        urlPlist = "/tmp/fund-%(now)s-url.plist" % locals()
        # GENERATE THE WHEREFROM PLIST FILE
        try:
            writeFile = codecs.open(
                urlPlist, encoding='utf-8', mode='w')
        except IOError, e:
            message = 'could not open the file %s' % (urlPlist,)
            raise IOError(message)
        writeFile.write("""
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
%(wherefrom)s
</plist>""" % locals())
        writeFile.close()

        # ASSIGN WHEREFORM TO FILE
        cmd = 'xattr -wx "com.apple.metadata:kMDItemURL" "`xxd -ps %(urlPlist)s`" %(filepath)s' % locals(
        )
        p = Popen(cmd, stdout=PIPE, stderr=PIPE, shell=True)
        stdout, stderr = p.communicate()
        log.debug('output URL: %(stdout)s' % locals())
        log.debug('output URL: %(stderr)s' % locals())

        # ASSIGN WHEREFORM TO FILE
        cmd = 'xattr -wx "com.apple.metadata:kMDItemWhereFroms" "`xxd -ps %(urlPlist)s`" %(filepath)s' % locals(
        )
        p = Popen(cmd, stdout=PIPE, stderr=PIPE, shell=True)
        stdout, stderr = p.communicate()
        log.debug('output URL: %(stdout)s' % locals())
        log.debug('output URL: %(stderr)s' % locals())

        # DELETE PLIST
        os.remove(urlPlist)

    log.info('completed the ``tag`` function')
    return None
