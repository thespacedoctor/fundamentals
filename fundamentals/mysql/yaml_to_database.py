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

    -d, --delete          delete yaml file(s) once added to datbase
    -h, --help            show this help message
    -v, --version         show version
    -s, --settings        the settings file
"""

import sys
import os
import yaml
import requests
import re
import glob
import docopt
from fundamentals import tools, times
from fundamentals.mysql import convert_dictionary_to_mysql_table
import requests.packages.urllib3
requests.packages.urllib3.disable_warnings()


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
        projectName=False
    )
    arguments, settings, log, dbConn = su.setup()

    # unpack remaining cl arguments using `exec` to setup the variable names
    # automatically
    for arg, val in arguments.iteritems():
        if arg[0] == "-":
            varname = arg.replace("-", "") + "Flag"
        else:
            varname = arg.replace("<", "").replace(">", "")
        if isinstance(val, str) or isinstance(val, unicode):
            exec(varname + " = '%s'" % (val,))
        else:
            exec(varname + " = %s" % (val,))
        if arg == "--dbConn":
            dbConn = val
        log.debug('%s = %s' % (varname, val,))

    if os.path.isfile(pathToYaml):
        from fundamentals.mysql import yaml_to_database
        # PARSE YAML FILE CONTENTS AND ADD TO DATABASE
        yaml2db = yaml_to_database(
            log=log,
            settings=settings,
            dbConn=dbConn
        )
        yaml2db.add_yaml_file_content_to_database(
            filepath=pathToYaml,
            deleteFile=deleteFlag
        )
        basename = os.path.basename(pathToYaml)
        print "Content of %(basename)s added to database" % locals()

    else:
        from fundamentals.mysql import yaml_to_database
        yaml2db = yaml_to_database(
            log=log,
            settings=settings,
            dbConn=dbConn,
            pathToInputDir=pathToYaml,
            deleteFiles=deleteFlag
        )
        yaml2db.ingest()
        print "Content of %(pathToYaml)s directory added to database" % locals()

    return


class yaml_to_database():
    """
    *Take key-values from yaml files including a tablename(s) and add them to a mysql database table*

    **Key Arguments:**
        - ``log`` -- logger
        - ``settings`` -- the settings dictionary
        - ``pathToInputDir`` -- path to the directory containing the yaml files that will be added to the database table(s). Default *False*
        - ``dbConn`` -- connection to database to add the content to
        - ``deleteFiles`` - - delete the yamls files once their content has been added to the database. Default * False*

    **Usage:**

        To setup your logger, settings and database connections, please use the ``fundamentals`` package (`see tutorial here <http://fundamentals.readthedocs.io/en/latest/#tutorial>`_). 

        To initiate a ``yaml2db`` object, use the following:

        .. code-block:: python 

            from fundamentals.mysql import yaml_to_database
            yaml2db = yaml_to_database(
                log=log,
                settings=settings,
                dbConn=dbConn,
                pathToInputDir="/path/to/yaml/directory",
                deleteFiles=False
            ) 

        And here's an example of the content in a yaml file that this ``yaml2db`` object can parse:

        .. code-block:: yaml

            title: Why you should do most of your text editing in : Sublime Text | Sublime Text Tips
            url: http://sublimetexttips.com/why-you-should-do-most-of-your-text-editing-in-sublime-text/?utm_source=drip&utm_medium=email&utm_campaign=editor-proliferation
            kind: webpage
            subtype: article
            table: web_articles,podcasts 
    """
    # Initialisation

    def __init__(
            self,
            log,
            dbConn,
            pathToInputDir=False,
            settings=False,
            deleteFiles=False

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

        **Return:**
            - None

        **Usage:**

            To import an entire directory of yaml files into a database, use the following:

        .. code-block:: python 

            from fundamentals.mysql import yaml_to_database
            yaml2db = yaml_to_database(
                log=log,
                settings=settings,
                dbConn=dbConn,
                pathToInputDir="/path/to/yaml/directory",
                deleteFiles=False
            ) 
            yaml2db.ingest() 
        """
        self.log.info('starting the ``ingest`` method')

        for d in os.listdir(self.pathToInputDir):
            if os.path.isfile(os.path.join(self.pathToInputDir, d)) and "yaml" in d.lower():
                self.add_yaml_file_content_to_database(
                    filepath=os.path.join(self.pathToInputDir, d),
                    deleteFile=self.deleteFiles
                )

        self.log.info('completed the ``ingest`` method')
        return None

    def add_yaml_file_content_to_database(
        self,
        filepath,
        deleteFile=False
    ):
        """*given a file to a yaml file, add yaml file content to database*

        **Key Arguments:**
            - ``filepath`` -- the path to the yaml file
            - ``deleteFile`` -- delete the yaml file when its content has been added to the database. Default *False*

        **Return:**
            - None

        **Usage:**

            To parse and import the contents of a single yaml file into the database, use the following:

            .. code-block:: python 

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
        """
        self.log.info(
            'starting the ``add_yaml_file_content_to_database`` method')

        import codecs
        try:
            self.log.debug("attempting to open the file %s" % (filepath,))
            readFile = codecs.open(filepath, encoding='utf-8', mode='r')
            thisData = readFile.read()
            readFile.close()
        except IOError, e:
            message = 'could not open the file %s' % (filepath,)
            self.log.critical(message)
            raise IOError(message)
        readFile.close()

        matchObject = re.finditer(
            r'(^|\n)(?P<key>[^\:]*)\:\s(?P<value>.*?)(\n|$)',
            thisData,
            flags=re.M | re.S  # re.S
        )

        yamlContent = {}
        for match in matchObject:
            if match.group("value")[0] == '"' and match.group("value")[-1] == '"':
                v = match.group("value")[1:-1]
            elif match.group("value")[0] == "'" and match.group("value")[-1] == "'":
                v = match.group("value")[1:-1]
            else:
                v = match.group("value")
            yamlContent[match.group("key")] = v

        if "table" not in yamlContent:
            self.log.warning(
                'A table value is need in the yaml content to indicate which database table to add the content to: %(filepath)s' % locals())
            return None

        # NOTE THERE MAY BE MORE THAN ONE DATABASE TABLE
        dbTablesTmp = yamlContent["table"].split(",")
        del yamlContent["table"]
        dbTables = []
        dbTables[:] = [d.strip() for d in dbTablesTmp]

        # UNSHORTEN URL
        try:
            r = requests.head(yamlContent["url"], allow_redirects=True)
            yamlContent["url"] = r.url
        except:
            pass

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
                replace=True
            )
        if deleteFile:
            os.remove(filepath)

        self.log.info(
            'completed the ``add_yaml_file_content_to_database`` method')
        return None

    # use the tab-trigger below for new method
    # xt-class-method


if __name__ == '__main__':
    main()
