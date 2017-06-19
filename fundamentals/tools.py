#!/usr/bin/env python
# encoding: utf-8
"""
*Toolset to setup the main function for a cl-util*

:Author:
    David Young

:Date Created:
    April 16, 2014
"""
################# GLOBAL IMPORTS ####################
import sys
import os
import yaml
from collections import OrderedDict
import shutil
from subprocess import Popen, PIPE, STDOUT
import logs as dl
import time
from docopt import docopt


###################################################################
# CLASSES                                                         #
###################################################################


class tools():
    """
    *common setup methods & attributes of the main function in cl-util*

    **Key Arguments:**
        - ``dbConn`` -- mysql database connection
        - ``arguments`` -- the arguments read in from the command-line
        - ``docString`` -- pass the docstring from the host module so that docopt can work on the usage text to generate the required arguments
        - ``logLevel`` -- the level of the logger required. Default *DEBUG*. [DEBUG|INFO|WARNING|ERROR|CRITICAL]
        - ``options_first`` -- options come before commands in CL usage. Default *False*.
        - ``projectName`` -- the name of the project, used to create a default settings file in ``~/.config/projectName/projectName.yaml``. Default *False*.
        - ``tunnel`` -- will setup a ssh tunnel (if the settings are found in the settings file). Default *False*.

    **Usage:**

        Add this to the ``__main__`` function of your command-line module

        .. code-block:: python 

            # setup the command-line util settings
            from fundamentals import tools
            su = tools(
                arguments=arguments,
                docString=__doc__,
                logLevel="DEBUG",
                options_first=False,
                projectName="myprojectName"
            )
            arguments, settings, log, dbConn = su.setup()

        Here is a template settings file content you could use:

        .. code-block:: yaml

            version: 1
            database settings:
                db: dryx_unit_testing
                host: localhost
                user: unittesting
                password: utpass
                tunnel: True

            # SSH TUNNEL - if a tunnel is required to connect to the database(s) then add setup here
            # Note only one tunnel is setup - may need to change this to 2 tunnels in the future if 
            # code, static catalogue database and transient database are all on seperate machines.
            ssh tunnel:
                remote user: username
                remote ip: mydomain.co.uk
                remote datbase host: mydatabaseName
                port: 9002

            logging settings:
                formatters:
                    file_style:
                        format: '* %(asctime)s - %(name)s - %(levelname)s (%(pathname)s > %(funcName)s > %(lineno)d) - %(message)s  '
                        datefmt: '%Y/%m/%d %H:%M:%S'
                    console_style:
                        format: '* %(asctime)s - %(levelname)s: %(pathname)s:%(funcName)s:%(lineno)d > %(message)s'
                        datefmt: '%H:%M:%S'
                    html_style:
                        format: '<div id="row" class="%(levelname)s"><span class="date">%(asctime)s</span>   <span class="label">file:</span><span class="filename">%(filename)s</span>   <span class="label">method:</span><span class="funcName">%(funcName)s</span>   <span class="label">line#:</span><span class="lineno">%(lineno)d</span> <span class="pathname">%(pathname)s</span>  <div class="right"><span class="message">%(message)s</span><span class="levelname">%(levelname)s</span></div></div>'
                        datefmt: '%Y-%m-%d <span class= "time">%H:%M <span class= "seconds">%Ss</span></span>'
                handlers:
                    console:
                        class: logging.StreamHandler
                        level: DEBUG
                        formatter: console_style
                        stream: ext://sys.stdout
                    file:
                        class: logging.handlers.GroupWriteRotatingFileHandler
                        level: WARNING
                        formatter: file_style
                        filename: /Users/Dave/.config/myprojectName/myprojectName.log
                        mode: w+
                        maxBytes: 102400
                        backupCount: 1
                root:
                    level: WARNING
                    handlers: [file,console]
    """
    # Initialisation

    def __init__(
            self,
            arguments,
            docString,
            logLevel="WARNING",
            options_first=False,
            projectName=False,
            orderedSettings=False
    ):
        self.arguments = arguments
        self.docString = docString
        self.logLevel = logLevel

        ## ACTIONS BASED ON WHICH ARGUMENTS ARE RECIEVED ##
        # PRINT COMMAND-LINE USAGE IF NO ARGUMENTS PASSED
        if arguments == None:
            arguments = docopt(docString, options_first=options_first)
        self.arguments = arguments

        try:
            if "tests.test" in arguments["<pathToSettingsFile>"]:
                del arguments["<pathToSettingsFile>"]
        except:
            pass

        # UNPACK SETTINGS
        stream = False
        if "<settingsFile>" in arguments and arguments["<settingsFile>"]:
            stream = file(arguments["<settingsFile>"], 'r')
        elif "<pathToSettingsFile>" in arguments and arguments["<pathToSettingsFile>"]:
            stream = file(arguments["<pathToSettingsFile>"], 'r')
        elif "--settingsFile" in arguments and arguments["--settingsFile"]:
            stream = file(arguments["--settingsFile"], 'r')
        elif "--settings" in arguments and arguments["--settings"]:
            stream = file(arguments["--settings"], 'r')
        elif "pathToSettingsFile" in arguments and arguments["pathToSettingsFile"]:
            stream = file(arguments["pathToSettingsFile"], 'r')
        elif "settingsFile" in arguments and arguments["settingsFile"]:
            stream = file(arguments["settingsFile"], 'r')
        elif ("settingsFile" in arguments and arguments["settingsFile"] == None) or ("<pathToSettingsFile>" in arguments and arguments["<pathToSettingsFile>"] == None) or ("--settings" in arguments and arguments["--settings"] == None):

            if projectName != False:
                os.getenv("HOME")
                projectDir = os.getenv(
                    "HOME") + "/.config/%(projectName)s" % locals()
                exists = os.path.exists(projectDir)
                if not exists:
                    # Recursively create missing directories
                    if not os.path.exists(projectDir):
                        os.makedirs(projectDir)
                settingsFile = os.getenv(
                    "HOME") + "/.config/%(projectName)s/%(projectName)s.yaml" % locals()
                exists = os.path.exists(settingsFile)

                if not exists:
                    import codecs
                    writeFile = codecs.open(
                        settingsFile, encoding='utf-8', mode='w')

                import yaml
                astream = file(settingsFile, 'r')
                if orderedSettings:
                    this = ordered_load(astream, yaml.SafeLoader)
                else:
                    this = yaml.load(astream)
                if this:

                    settings = this
                    arguments["<settingsFile>"] = settingsFile
                else:
                    import inspect
                    ds = os.getcwd() + "/rubbish.yaml"
                    level = 0
                    exists = False
                    count = 1
                    while not exists and len(ds) and count < 10:
                        count += 1
                        level -= 1
                        exists = os.path.exists(ds)
                        if not exists:
                            ds = "/".join(inspect.stack()
                                          [1][1].split("/")[:level]) + "/default_settings.yaml"

                    try:
                        shutil.copyfile(ds, settingsFile)
                        import codecs
                        pathToReadFile = settingsFile
                        try:
                            readFile = codecs.open(
                                pathToReadFile, encoding='utf-8', mode='r')
                            thisData = readFile.read()
                            readFile.close()
                        except IOError, e:
                            message = 'could not open the file %s' % (
                                pathToReadFile,)
                            raise IOError(message)
                        thisData = thisData.replace(
                            "/Users/Dave", os.getenv("HOME"))

                        pathToWriteFile = pathToReadFile
                        try:
                            writeFile = codecs.open(
                                pathToWriteFile, encoding='utf-8', mode='w')
                        except IOError, e:
                            message = 'could not open the file %s' % (
                                pathToWriteFile,)
                            raise IOError(message)
                        writeFile.write(thisData)
                        writeFile.close()
                        print "default settings have been added to '%(settingsFile)s'. Tailor these settings before proceeding to run %(projectName)s" % locals()
                        try:
                            cmd = """open %(pathToReadFile)s""" % locals()
                            p = Popen(cmd, stdout=PIPE,
                                      stderr=PIPE, shell=True)
                        except:
                            pass
                        try:
                            cmd = """start %(pathToReadFile)s""" % locals()
                            p = Popen(cmd, stdout=PIPE,
                                      stderr=PIPE, shell=True)
                        except:
                            pass
                    except:
                        print "please add settings to file '%(settingsFile)s'" % locals()
                    sys.exit(0)
        else:

            pass

        if stream is not False:
            import yaml
            if orderedSettings:
                settings = ordered_load(stream, yaml.SafeLoader)
            else:
                settings = yaml.load(stream)

        # SETUP LOGGER -- DEFAULT TO CONSOLE LOGGER IF NONE PROVIDED IN
        # SETTINGS
        if 'settings' in locals() and "logging settings" in settings:
            if "<settingsFile>" in arguments:
                log = dl.setup_dryx_logging(
                    yaml_file=arguments["<settingsFile>"]
                )
            elif "<pathToSettingsFile>" in arguments:
                log = dl.setup_dryx_logging(
                    yaml_file=arguments["<pathToSettingsFile>"]
                )
            elif "--settingsFile" in arguments:
                log = dl.setup_dryx_logging(
                    yaml_file=arguments["--settingsFile"]
                )
            elif "pathToSettingsFile" in arguments:
                log = dl.setup_dryx_logging(
                    yaml_file=arguments["pathToSettingsFile"]
                )

            elif "settingsFile" in arguments:
                log = dl.setup_dryx_logging(
                    yaml_file=arguments["settingsFile"]
                )
            elif "--settings" in arguments:
                log = dl.setup_dryx_logging(
                    yaml_file=arguments["--settings"]
                )

        elif "--logger" not in arguments or arguments["--logger"] is None:
            log = dl.console_logger(
                level=self.logLevel
            )

        self.log = log

        # unpack remaining cl arguments using `exec` to setup the variable names
        # automatically
        for arg, val in arguments.iteritems():
            if arg[0] == "-":
                varname = arg.replace("-", "") + "Flag"
            else:
                varname = arg.replace("<", "").replace(">", "")
            if varname == "import":
                varname = "iimport"
            if isinstance(val, str) or isinstance(val, unicode):
                val = val.replace("'", "\\'")
                exec(varname + " = '%s'" % (val,))
            else:
                exec(varname + " = %s" % (val,))
            if arg == "--dbConn":
                dbConn = val

        # SETUP A DATABASE CONNECTION BASED ON WHAT ARGUMENTS HAVE BEEN PASSED
        dbConn = False
        tunnel = False
        if ("hostFlag" in locals() and "dbNameFlag" in locals() and hostFlag):
            # SETUP DB CONNECTION
            dbConn = True
            host = arguments["--host"]
            user = arguments["--user"]
            passwd = arguments["--passwd"]
            dbName = arguments["--dbName"]
        elif 'settings' in locals() and "database settings" in settings and "host" in settings["database settings"]:
            host = settings["database settings"]["host"]
            user = settings["database settings"]["user"]
            passwd = settings["database settings"]["password"]
            dbName = settings["database settings"]["db"]
            if "tunnel" in settings["database settings"] and settings["database settings"]["tunnel"]:
                tunnel = True
            dbConn = True
        else:
            pass

        if not 'settings' in locals():
            settings = False
        self.settings = settings

        if tunnel:
            self._setup_tunnel()
            self.dbConn = self.remoteDBConn
            return None

        if dbConn:
            import MySQLdb as ms
            dbConn = ms.connect(
                host=host,
                user=user,
                passwd=passwd,
                db=dbName,
                use_unicode=True,
                charset='utf8'
            )
            dbConn.autocommit(True)

        self.dbConn = dbConn

        return None

    def setup(
            self):
        """
        **Summary:**
            *setup the attributes and return*
        """
        return self.arguments, self.settings, self.log, self.dbConn

    def _setup_tunnel(
            self):
        """
        *setup ssh tunnel if required*
        """
        from subprocess import Popen, PIPE, STDOUT
        import MySQLdb as ms

        # SETUP TUNNEL IF REQUIRED
        if "ssh tunnel" in self.settings:
            # TEST TUNNEL DOES NOT ALREADY EXIST
            sshPort = self.settings["ssh tunnel"]["port"]
            connected = self._checkServer(
                self.settings["database settings"]["host"], sshPort)
            if connected:
                pass
            else:
                # GRAB TUNNEL SETTINGS FROM SETTINGS FILE
                ru = self.settings["ssh tunnel"]["remote user"]
                rip = self.settings["ssh tunnel"]["remote ip"]
                rh = self.settings["ssh tunnel"]["remote datbase host"]

                cmd = "ssh -fnN %(ru)s@%(rip)s -L %(sshPort)s:%(rh)s:3306" % locals()
                p = Popen(cmd, shell=True, close_fds=True)
                output = p.communicate()[0]

                # TEST CONNECTION - QUIT AFTER SO MANY TRIES
                connected = False
                count = 0
                while not connected:
                    connected = self._checkServer(
                        self.settings["database settings"]["host"], sshPort)
                    time.sleep(1)
                    count += 1
                    if count == 5:
                        self.log.error(
                            'cound not setup tunnel to remote datbase' % locals())
                        sys.exit(0)

        # SETUP A DATABASE CONNECTION FOR THE remote database
        host = self.settings["database settings"]["host"]
        user = self.settings["database settings"]["user"]
        passwd = self.settings["database settings"]["password"]
        dbName = self.settings["database settings"]["db"]
        thisConn = ms.connect(
            host=host,
            user=user,
            passwd=passwd,
            db=dbName,
            port=sshPort,
            use_unicode=True,
            charset='utf8'
        )
        thisConn.autocommit(True)
        self.remoteDBConn = thisConn

        return None

    def _checkServer(self, address, port):
        """
        *Check that the TCP Port we've decided to use for tunnelling is available*
        """
        # CREATE A TCP SOCKET
        import socket
        s = socket.socket()

        try:
            s.connect((address, port))
            return True
        except socket.error, e:
            self.log.warning(
                """Connection to `%(address)s` on port `%(port)s` failed - try again: %(e)s""" % locals())
            return False

        return None

    # use the tab-trigger below for new method
    # xt-class-method


###################################################################
# PUBLIC FUNCTIONS                                                #
###################################################################
def ordered_load(stream, Loader=yaml.Loader, object_pairs_hook=OrderedDict):
    class OrderedLoader(Loader):
        pass

    def construct_mapping(loader, node):
        loader.flatten_mapping(node)
        return object_pairs_hook(loader.construct_pairs(node))
    OrderedLoader.add_constructor(
        yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG,
        construct_mapping)
    return yaml.load(stream, OrderedLoader)


if __name__ == '__main__':
    main()
