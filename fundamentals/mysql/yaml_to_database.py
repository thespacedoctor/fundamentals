#!/usr/local/bin/python
# encoding: utf-8
"""
*Take key-values from a yaml file including a tablename(s) and add them to a mysql database table*

Usage:
    yaml2db [-d] -s <pathToSettingsFile> <pathToYaml>
    yaml2db [-d] --host=<host> --user=<user> --passwd=<passwd> --dbName=<dbName> <pathToYaml>

Options:

    pathToYaml            path to a single yaml file or directory of yaml files
    pathToSettingsFile    path to a settings file with logging and database information (yaml file)
    --host=<host>         the database host
    --user=<user>         database user
    --passwd=<passwd>     database user password
    --dbName=<dbName>     name of the database to add the table content to

    -d, --delete          delete yaml open(s) once added to datbase
    -h, --help            show this help message
    -v, --version         show version
    -s, --settings        the settings file
"""

from __future__ import print_function

from builtins import object
import sys
import os
import yaml

import re
import glob
import ipaddress
import socket
from urllib.parse import urljoin, urlparse
import docopt
from fundamentals import tools, times
from fundamentals.mysql import convert_dictionary_to_mysql_table

URL_REQUEST_TIMEOUT = 10
URL_SCHEMES_ALLOWED = ("http", "https")
MAX_REDIRECT_HOPS = 5
REDIRECT_STATUS_CODES = (301, 302, 303, 307, 308)


def _is_public_address(address):
    """
    *return True only if the IP address string is a publicly routable address*
    """
    ip = ipaddress.ip_address(address.split("%")[0])
    # UNWRAP IPV4-MAPPED IPV6 ADDRESSES (E.G. ::ffff:127.0.0.1)
    if ip.version == 6 and ip.ipv4_mapped is not None:
        ip = ip.ipv4_mapped
    return not (
        ip.is_loopback
        or ip.is_link_local
        or ip.is_private
        or ip.is_multicast
        or ip.is_reserved
        or ip.is_unspecified
        or not ip.is_global
    )


def _url_rejection_reason(url):
    """
    *return why a URL must not be requested, or None if it is safe to request*

    **Residual risk:** the hostname is resolved here and again when ``requests`` connects. The check and the connection resolve separately, so a DNS server that changes its answer between the two lookups (DNS rebinding) can still direct the request to a non-public address. This is a known and accepted limit. The resolved address is not pinned.
    """
    parsed = urlparse(url)
    if parsed.scheme.lower() not in URL_SCHEMES_ALLOWED:
        return "scheme other than http/https"
    if parsed.username is not None or parsed.password is not None:
        return "credentials in url"
    if not parsed.hostname:
        return "missing hostname"
    # THE IDNA FORMS USED BY getaddrinfo AND requests CAN DIFFER FOR NON-ASCII HOSTNAMES
    if not parsed.hostname.isascii():
        return "non-ascii hostname"
    port = parsed.port or (443 if parsed.scheme.lower() == "https" else 80)
    for info in socket.getaddrinfo(parsed.hostname, port):
        if not _is_public_address(info[4][0]):
            return "host resolves to a non-public address"
    return None


def unshorten_url(url, log):
    """
    *follow redirects by hand and return the final URL, or the original URL if the lookup is unsafe or fails*

    **Key Arguments**

    - ``url`` -- the url to unshorten
    - ``log`` -- logger

    Every hop (including the first) must pass ``_url_rejection_reason`` before it is requested. At most ``MAX_REDIRECT_HOPS`` redirects are followed.
    """
    import requests

    currentUrl = url
    try:
        # IGNORE PROXY ENVIRONMENT VARIABLES SO THE LOCAL ADDRESS CHECK CANNOT BE BYPASSED
        with requests.Session() as session:
            session.trust_env = False
            for _ in range(MAX_REDIRECT_HOPS + 1):
                reason = _url_rejection_reason(currentUrl)
                if reason:
                    log.warning("not unshortening url (%s): %s" % (reason, currentUrl))
                    return url
                r = session.head(
                    currentUrl, allow_redirects=False, timeout=URL_REQUEST_TIMEOUT
                )
                location = r.headers.get("Location")
                if r.status_code not in REDIRECT_STATUS_CODES or not location:
                    return currentUrl
                currentUrl = urljoin(currentUrl, location)
    except (requests.RequestException, socket.gaierror, ValueError) as e:
        # VALUEERROR: MALFORMED URL REJECTED BY urlparse
        log.warning("could not unshorten url %s: %s" % (url, e))
        return url

    log.warning("not unshortening url (too many redirects): %s" % (url,))
    return url


def main(arguments=None):
    """
    The main function used when ``yaml_to_database.py`` when installed as a cl tool
    """

    # setup the command-line util settings
    su = tools(
        arguments=arguments,
        docString=__doc__,
        logLevel="WARNING",
        options_first=False,
        projectName=False,
    )
    arguments, settings, log, dbConn = su.setup()

    # unpack remaining cl arguments using `exec` to setup the variable names
    # automatically
    for arg, val in list(arguments.items()):
        if arg[0] == "-":
            varname = arg.replace("-", "") + "Flag"
        else:
            varname = arg.replace("<", "").replace(">", "")
        if isinstance(val, str):
            exec(varname + " = '%s'" % (val,))
        else:
            exec(varname + " = %s" % (val,))
        if arg == "--dbConn":
            dbConn = val
        log.debug(
            "%s = %s"
            % (
                varname,
                val,
            )
        )

    if os.path.isfile(pathToYaml):
        from fundamentals.mysql import yaml_to_database

        # PARSE YAML FILE CONTENTS AND ADD TO DATABASE
        yaml2db = yaml_to_database(log=log, settings=settings, dbConn=dbConn)
        yaml2db.add_yaml_file_content_to_database(
            filepath=pathToYaml, deleteFile=deleteFlag
        )
        basename = os.path.basename(pathToYaml)
        print("Content of %(basename)s added to database" % locals())

    else:
        from fundamentals.mysql import yaml_to_database

        yaml2db = yaml_to_database(
            log=log,
            settings=settings,
            dbConn=dbConn,
            pathToInputDir=pathToYaml,
            deleteFiles=deleteFlag,
        )
        yaml2db.ingest()
        print("Content of %(pathToYaml)s directory added to database" % locals())

    return


class yaml_to_database(object):
    """
    *Take key-values from yaml files including a tablename(s) and add them to a mysql database table*

    **Key Arguments**

    - ``log`` -- logger
    - ``settings`` -- the settings dictionary
    - ``pathToInputDir`` -- path to the directory containing the yaml files that will be added to the database table(s). Default *False*
    - ``dbConn`` -- connection to database to add the content to
    - ``deleteFiles`` - - delete the yamls files once their content has been added to the database. Default * False*


    **Usage**

    To setup your logger, settings and database connections, please use the ``fundamentals`` package (see tutorial here https://fundamentals.readthedocs.io/en/master/initialisation.html).

    To initiate a ``yaml2db`` object, use the following:

    ```python
    from fundamentals.mysql import yaml_to_database
    yaml2db = yaml_to_database(
        log=log,
        settings=settings,
        dbConn=dbConn,
        pathToInputDir="/path/to/yaml/directory",
        deleteFiles=False
    )
    ```

    And here's an example of the content in a yaml file that this ``yaml2db`` object can parse:

    ```yaml
    title: Why you should do most of your text editing in : Sublime Text | Sublime Text Tips
    url: http://sublimetexttips.com/why-you-should-do-most-of-your-text-editing-in-sublime-text/?utm_source=drip&utm_medium=email&utm_campaign=editor-proliferation
    kind: webpage
    subtype: article
    table: web_articles,podcasts
    ```

    """

    # Initialisation

    def __init__(
        self, log, dbConn, pathToInputDir=False, settings=False, deleteFiles=False
    ):
        self.log = log
        log.debug("instansiating a new 'yaml_to_database' object")
        self.settings = settings
        self.pathToInputDir = pathToInputDir
        self.dbConn = dbConn
        self.deleteFiles = deleteFiles
        # xt-self-arg-tmpx

        return None

    def ingest(self):
        """
        *ingest the contents of the directory of yaml files into a database*

        **Return**

        - None


        **Usage**

        To import an entire directory of yaml files into a database, use the following:


        ```python
        from fundamentals.mysql import yaml_to_database
        yaml2db = yaml_to_database(
            log=log,
            settings=settings,
            dbConn=dbConn,
            pathToInputDir="/path/to/yaml/directory",
            deleteFiles=False
        )
        yaml2db.ingest()
        ```
        """
        self.log.debug("starting the ``ingest`` method")

        for d in os.listdir(self.pathToInputDir):
            if (
                os.path.isfile(os.path.join(self.pathToInputDir, d))
                and "yaml" in d.lower()
            ):
                self.add_yaml_file_content_to_database(
                    filepath=os.path.join(self.pathToInputDir, d),
                    deleteFile=self.deleteFiles,
                )

        self.log.debug("completed the ``ingest`` method")
        return None

    def add_yaml_file_content_to_database(self, filepath, deleteFile=False):
        """*given a file to a yaml file, add yaml file content to database*

        **Key Arguments**

        - ``filepath`` -- the path to the yaml file
        - ``deleteFile`` -- delete the yaml file when its content has been added to the database. Default *False*


        **Return**

        - None


        **Usage**

        To parse and import the contents of a single yaml file into the database, use the following:

        ```python
        from fundamentals.mysql import yaml_to_database
        # PARSE YAML FILE CONTENTS AND ADD TO DATABASE
        yaml2db = yaml_to_database(
            log=log,
            settings=settings,
            dbConn=dbConn
        )
        yaml2db.add_yaml_file_content_to_database(
            filepath=${1:"/path/to/file.yaml"},
            deleteFile=True
        )
        ```

        """
        self.log.debug("completed the ````add_yaml_file_content_to_database`` method")

        import codecs

        try:
            self.log.debug("attempting to open the file %s" % (filepath,))
            with codecs.open(filepath, encoding="utf-8", mode="r") as readFile:
                thisData = readFile.read()
        except IOError as e:
            message = "could not open the file %s" % (filepath,)
            self.log.critical(message)
            raise IOError(message) from e

        matchObject = re.finditer(
            r"(^|\n)(?P<key>[^\:]*)\:\s(?P<value>.*?)(\n|$)",
            thisData,
            flags=re.M | re.S,  # re.S
        )

        yamlContent = {}
        for match in matchObject:
            v = match.group("value")
            if len(v) >= 2 and v[0] == v[-1] and v[0] in "\"'":
                v = v[1:-1]
            yamlContent[match.group("key")] = v

        if "table" not in yamlContent:
            self.log.warning(
                "A table value is need in the yaml content to indicate which database table to add the content to: %(filepath)s"
                % locals()
            )
            return None

        # NOTE THERE MAY BE MORE THAN ONE DATABASE TABLE
        dbTablesTmp = yamlContent["table"].split(",")
        del yamlContent["table"]
        dbTables = []
        dbTables[:] = [d.strip() for d in dbTablesTmp]

        # UNSHORTEN URL (REDIRECTS ARE NEEDED TO FIND THE FINAL URL)
        if "url" in yamlContent:
            yamlContent["url"] = unshorten_url(yamlContent["url"], self.log)

        yamlContent["original_yaml_path"] = filepath

        if "url" in yamlContent:
            uniqueKeyList = ["url"]
        else:
            uniqueKeyList = []

        for t in dbTables:
            convert_dictionary_to_mysql_table(
                dbConn=self.dbConn,
                log=self.log,
                dictionary=yamlContent,
                dbTableName=t,
                uniqueKeyList=uniqueKeyList,
                dateModified=True,
                returnInsertOnly=False,
                replace=True,
            )
        if deleteFile:
            os.remove(filepath)

        self.log.debug("completed the ``add_yaml_file_content_to_database`` method")
        return None

    # use the tab-trigger below for new method
    # xt-class-method


if __name__ == "__main__":
    main()
