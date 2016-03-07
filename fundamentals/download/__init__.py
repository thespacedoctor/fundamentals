

def _fetch(url,):
    import logging as log
    import socket
    from eventlet import Timeout
    from eventlet.green import urllib2
    import sys

    tries = 10
    count = 1
    downloaded = False
    while count < tries and downloaded == False:
        try:
            log.debug('downloading ' + url.get_full_url())
            body = urllib2.urlopen(url).read()
            downloaded = True
        except socket.timeout, e:
            print "timeout on URL, trying again"
            count += 1
        except Exception, e:
            if "[Errno 60]" in str(e):
                print "timeout on URL, trying again"
                count += 1
            if "Error 502" in str(e):
                print "proxy error on URL, trying again"
                count += 1
            else:
                log.warning(
                    "could not download " + url.get_full_url() + " : " + str(e) + "\n")
                url = None
                body = None
                downloaded = True

    return url, body


def _dump_files_to_local_drive(bodies, theseUrls, log):
    """takes the files stored in memory and dumps them to the local drive

        ****Key Arguments:****
          - ``bodies`` -- array of file data (currently stored in memory)
          - ``theseUrls`` -- array of local files paths to dump the file data into
          - ``log`` -- logger

        **Return:**
          - ``None``
    """
    ################ > IMPORTS ################

    ################ > VARIABLE SETTINGS ######

    ################ >ACTION(S) ################
    j = 0
    log.debug("attempting to write file data to local drive")
    log.debug('%s URLS = %s' % (len(theseUrls), str(theseUrls),))
    for body in bodies:
        try:
            if theseUrls[j]:
                with open(theseUrls[j], 'w') as f:
                    f.write(body)
                f.close()
            j += 1
        except Exception, e:
            log.error(
                "could not write downloaded file to local drive - failed with this error %s: " %
                (str(e),))
            return -1
    return


def append_now_datestamp_to_filename(log, filename, longTime=False):
    """append the current datestamp to the end of the filename (before the extension).

            **Key Arguments:**
                - ``filename`` -- the filename

            Return:
                - ``dsFilename`` -- datestamped filename
    """
    ## > IMPORTS ##
    ## >SETTINGS ##

    ###########################################################
    # >ACTION(S)                                              #
    ###########################################################
    try:
        #log.debug("appending date stamp to the filename : "+filename)
        sliced = filename.split('.')
        dsFilename = sliced[0] + '_' + \
            get_now_datetime_filestamp(longTime=longTime)
        if len(sliced) == 2:
            dsFilename += '.' + sliced[1]
        else:
            dsFilename += ".xhtml"
    except Exception as e:
        log.error("could not append date stamp to the filename : " +
                  filename + " : " + str(e) + "\n")

    return dsFilename


def extract_filename_from_url(log, url):
    """
        get the filename from a URL.
        Will return '*untitled.html*', if no filename is found.

        **Key Arguments:**
            - ``url`` -- the url to extract filename from

        Returns:
            - ``filename`` -- the filename
    """
    ## > IMPORTS ##
    import re
    ## >SETTINGS ##

    ###########################################################
    # >ACTION(S)                                              #
    ###########################################################
    # EXTRACT THE FILENAME FROM THE URL
    try:
        log.debug("extracting filename from url " + url)
        reEoURL = re.compile('([\w\.]*)$')
        filename = reEoURL.findall(url)[0]
        # log.debug(filename)
        if(len(filename) == 0):
            filename = 'untitled.html'
        if not (re.search('\.', filename)):
            filename = filename + '.html'
    except Exception as e:
        filename = None
        # print url
        log.error("could not extracting filename from url : " + str(e) + "\n")

    return filename


def get_now_datetime_filestamp(longTime=False):
    """A datetime stamp to be appended to the end of filenames:
        ``YYYYMMDDtHHMMSS``

        **Return:**
            - ``now`` -- current time and date in filename format
            - ``longTime`` -- make time string longer (more change of filenames being unique)
    """
    ## > IMPORTS ##
    from datetime import datetime, date, time

    ## >SETTINGS ##

    ###########################################################
    # >ACTION(S)                                              #
    ###########################################################
    now = datetime.now()
    if longTime:
        now = now.strftime("%Y%m%dt%H%M%S%f")
    else:
        now = now.strftime("%Y%m%dt%H%M%S")

    return now

from mutliobject_download import mutliobject_download
