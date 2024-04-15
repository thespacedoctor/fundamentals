#!/usr/bin/env python
# encoding: utf-8
"""
*Toolset to setup the main function for a cl-util*

:Author:
    David Young
"""
from __future__ import print_function
from __future__ import absolute_import
from builtins import object
import sys
import os
import yaml
try:
    yaml.warnings({'YAMLLoadWarning': False})
except:
    pass
from collections import OrderedDict
import shutil
from subprocess import Popen, PIPE, STDOUT
from . import logs as dl
import time
from docopt import docopt
try:
    from StringIO import StringIO
except ImportError:
    from io import StringIO
from os.path import expanduser
import inspect
import psutil


###################################################################
# CLASSES                                                         #
###################################################################


class tools(object):
    """
    *common setup methods & attributes of the main function in cl-util*

    **Key Arguments**

    - ``dbConn`` -- mysql database connection
    - ``arguments`` -- the arguments read in from the command-line
    - ``docString`` -- pass the docstring from the host module so that docopt can work on the usage text to generate the required arguments
    - ``logLevel`` -- the level of the logger required. Default *DEBUG*. [DEBUG|INFO|WARNING|ERROR|CRITICAL]
    - ``options_first`` -- options come before commands in CL usage. Default *False*.
    - ``projectName`` -- the name of the project, used to create a default settings file in ``~/.config/projectName/projectName.yaml``. Default *False*.
    - ``distributionName`` -- the distribution name if different from the projectName (i.e. if the package is called by another name on PyPi). Default *False*
    - ``tunnel`` -- will setup a ssh tunnel (if the settings are found in the settings file). Default *False*.
    - ``defaultSettingsFile`` -- if no settings file is passed via the doc-string, look for a settings file first in the PWD or use the default settings file in ``~/.config/projectName/projectName.yaml`` (don't have to clutter command-line with settings)

    **Usage**

    Add this to the ``__main__`` function of your command-line module

    ```python
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
    ```

    Here is a template settings file content you could use:

    ```yaml
    version: 1
    database settings:
        db: unit_tests
        host: localhost
        user: utuser
        password: utpass
        tunnel: true

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
        ```
    """
    # Initialisation

    def __init__(
            self,
            arguments,
            docString,
            logLevel="WARNING",
            options_first=False,
            projectName=False,
            distributionName=False,
            orderedSettings=False,
            defaultSettingsFile=False,
            quitIfRunning=True
    ):
        self.arguments = arguments
        self.docString = docString
        self.logLevel = logLevel
        self.configSettingsPath = os.getenv("HOME") + f"/.config/{projectName}/{projectName}.yaml"
        self.projectName = projectName
        self.defaultSettingsFile = defaultSettingsFile

        if not distributionName:
            distributionName = projectName

        version = '0.0.1'
        try:
            import pkg_resources
            version = pkg_resources.get_distribution(distributionName).version
        except:
            pass

        ## ACTIONS BASED ON WHICH ARGUMENTS ARE RECIEVED ##
        # PRINT COMMAND-LINE USAGE IF NO ARGUMENTS PASSED
        if self.arguments == None:
            self.arguments = docopt(docString, version="v" + version,
                                    options_first=options_first)

        # BUILD A STRING FOR THE PROCESS TO MATCH RUNNING PROCESSES AGAINST
        lockname = "".join(sys.argv)

        # TEST IF THE PROCESS IS ALREADY RUNNING WITH THE SAME ARGUMENTS (e.g.
        # FROM CRON) - QUIT IF MATCH FOUND
        if quitIfRunning:
            for q in psutil.process_iter():
                try:
                    this = q.cmdline()
                except:
                    continue

                test = "".join(this[1:])
                if q.pid != os.getpid() and lockname == test and "--reload" not in test:
                    thisId = q.pid
                    print("This command is already running (see PID %(thisId)s)" % locals())
                    sys.exit(0)

        try:
            if "tests.test" in self.arguments["<pathToSettingsFile>"]:
                del self.arguments["<pathToSettingsFile>"]
        except:
            pass

        # GET ADVANCED SETTINGS IF AVAILABLE
        advs = os.getcwd() + "/rubbish.yaml"
        level = 0
        exists = False
        count = 1
        while not exists and len(advs) and count < 10:
            count += 1
            level -= 1
            exists = os.path.exists(advs)
            if not exists:
                advs = "/".join(inspect.stack()
                                [1][1].split("/")[:level]) + "/advanced_settings.yaml"
        if not exists:
            advs = {}
        else:
            with open(advs, 'r') as stream:
                advs = yaml.safe_load(stream)

        if defaultSettingsFile and "settingsFile" not in self.arguments and "--settings" not in self.arguments:
            cwdSettings = os.getcwd() + f"/{projectName}.yaml"
            if os.path.exists(cwdSettings):
                self.arguments["settingsFile"] = settingsFile = cwdSettings
            elif os.path.exists(os.getenv(
                    "HOME") + "/.config/%(projectName)s/%(projectName)s.yaml" % locals()):
                self.arguments["settingsFile"] = settingsFile = os.getenv(
                    "HOME") + "/.config/%(projectName)s/%(projectName)s.yaml" % locals()

        # UNPACK SETTINGS
        stream = False
        if "<settingsFile>" in self.arguments and self.arguments["<settingsFile>"]:
            stream = open(self.arguments["<settingsFile>"], 'r')
        elif "<pathToSettingsFile>" in self.arguments and self.arguments["<pathToSettingsFile>"]:
            stream = open(self.arguments["<pathToSettingsFile>"], 'r')
        elif "--settingsFile" in self.arguments and self.arguments["--settingsFile"]:
            stream = open(self.arguments["--settingsFile"], 'r')
        elif "--settings" in self.arguments and self.arguments["--settings"]:
            stream = open(self.arguments["--settings"], 'r')
        elif "pathToSettingsFile" in self.arguments and self.arguments["pathToSettingsFile"]:
            stream = open(self.arguments["pathToSettingsFile"], 'r')
        elif "settingsFile" in self.arguments and self.arguments["settingsFile"]:
            stream = open(self.arguments["settingsFile"], 'r')
        elif ("settingsFile" in self.arguments and self.arguments["settingsFile"] == None) or ("<pathToSettingsFile>" in self.arguments and self.arguments["<pathToSettingsFile>"] == None) or ("--settings" in self.arguments and self.arguments["--settings"] == None) or ("pathToSettingsFile" in self.arguments and self.arguments["pathToSettingsFile"] == None):

            init = False
            workspaceDirectory = False
            if "init" in self.arguments and self.arguments["init"]:
                init = True
                if "<workspaceDirectory>" in self.arguments and self.arguments["<workspaceDirectory>"]:
                    theseSettings = self.arguments["<workspaceDirectory>"] + f"/{projectName}.yaml"
                else:
                    theseSettings = self.configSettingsPath
                exists = self._create_or_verify_settings(pathToSettings=theseSettings, create=True)

            else:
                if projectName != False:
                    # FIRST CHECK FOR SETTINGS IN CWD
                    cwdSettings = os.getcwd() + f"/{projectName}.yaml"
                    exists = self._create_or_verify_settings(pathToSettings=cwdSettings, create=False)

                    # THEN CHECK FOR SETTINGS CONFIG DIRECTORY
                    if not exists:
                        exists = self._create_or_verify_settings(pathToSettings=self.configSettingsPath, create=False)

                    # CREATE SETTING IN DEFAULT SETTINGS LOCATION IF NONE EXIST
                    if not exists:
                        exists = self._create_or_verify_settings(pathToSettings=self.configSettingsPath, create=True)
            if "settingsFile" in self.arguments and self.arguments["settingsFile"]:
                stream = open(self.arguments["settingsFile"], 'r')
        else:
            pass

        # FOR SETTINGS FILE PATHS PASSED DIRECTORY VIA THE CL
        if stream is not False:
            astream = stream.read()
            home = expanduser("~")
            astream = astream.replace("~/", home + "/")

            if orderedSettings:
                settings = ordered_load(astream, yaml.SafeLoader)
            else:
                settings = yaml.safe_load(astream)

        # MERGE ADVANCED SETTINGS AND USER SETTINGS (USER SETTINGS OVERRIDE)
        if 'settings' not in locals():
            settings = advs
        else:
            settings = {**advs, **settings}

        # SETUP LOGGER -- DEFAULT TO CONSOLE LOGGER IF NONE PROVIDED IN
        # SETTINGS
        if 'settings' in locals() and "logging settings" in settings:
            if "settingsFile" in self.arguments:
                log = dl.setup_dryx_logging(
                    yaml_file=self.arguments["settingsFile"]
                )
            elif "<settingsFile>" in self.arguments:
                log = dl.setup_dryx_logging(
                    yaml_file=self.arguments["<settingsFile>"]
                )
            elif "<pathToSettingsFile>" in self.arguments:
                log = dl.setup_dryx_logging(
                    yaml_file=self.arguments["<pathToSettingsFile>"]
                )
            elif "--settingsFile" in self.arguments:
                log = dl.setup_dryx_logging(
                    yaml_file=self.arguments["--settingsFile"]
                )
            elif "pathToSettingsFile" in self.arguments:
                log = dl.setup_dryx_logging(
                    yaml_file=self.arguments["pathToSettingsFile"]
                )

            elif "--settings" in self.arguments:
                log = dl.setup_dryx_logging(
                    yaml_file=self.arguments["--settings"]
                )

        elif "--logger" not in self.arguments or self.arguments["--logger"] is None:
            log = dl.console_logger(
                level=self.logLevel
            )

        self.log = log

        # unpack remaining cl arguments using `exec` to setup the variable names
        # automatically
        for arg, val in list(self.arguments.items()):
            if arg[0] == "-":
                varname = arg.replace("-", "") + "Flag"
            else:
                varname = arg.replace("<", "").replace(">", "")
            if varname == "import":
                varname = "iimport"
            if isinstance(val, str):
                val = val.replace("'", "\\'")
                exec(varname + " = '%s'" % (val,))
            else:
                exec(varname + " = %s" % (val,))
            if arg == "--dbConn":
                dbConn = val

        # SETUP A DATABASE CONNECTION BASED ON WHAT ARGUMENTS HAVE BEEN PASSED
        dbConn = False
        tunnel = False

        if ("--host" in self.arguments and "--dbName" in self.arguments and self.arguments["--host"]):
            # SETUP DB CONNECTION
            dbConn = True
            host = self.arguments["--host"]
            user = self.arguments["--user"]
            passwd = self.arguments["--passwd"]
            dbName = self.arguments["--dbName"]
            port = False

        elif 'settings' in locals() and "database settings" in settings and "host" in settings["database settings"]:
            host = settings["database settings"]["host"]
            user = settings["database settings"]["user"]
            passwd = settings["database settings"]["password"]
            dbName = settings["database settings"]["db"]
            if "tunnel" in settings["database settings"] and settings["database settings"]["tunnel"]:
                tunnel = True
            dbConn = True
            port = False
            if "port" in settings["database settings"] and settings["database settings"]["port"]:
                port = int(settings["database settings"]["port"])
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
            import pymysql as ms
            dbConn = ms.connect(
                host=host,
                user=user,
                passwd=passwd,
                db=dbName,
                port=port,
                use_unicode=True,
                charset='utf8',
                local_infile=1,
                client_flag=ms.constants.CLIENT.MULTI_STATEMENTS,
                connect_timeout=36000,
                max_allowed_packet=51200000
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
        import pymysql as ms

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

        if "tunnel" in self.settings["database settings"] and self.settings["database settings"]["tunnel"]:
            # TEST TUNNEL DOES NOT ALREADY EXIST
            sshPort = self.settings["database settings"]["tunnel"]["port"]
            connected = self._checkServer(
                self.settings["database settings"]["host"], sshPort)
            if connected:
                pass
            else:
                # GRAB TUNNEL SETTINGS FROM SETTINGS FILE
                ru = self.settings["database settings"][
                    "tunnel"]["remote user"]
                rip = self.settings["database settings"]["tunnel"]["remote ip"]
                rh = self.settings["database settings"][
                    "tunnel"]["remote datbase host"]

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
            charset='utf8',
            local_infile=1,
            client_flag=ms.constants.CLIENT.MULTI_STATEMENTS,
            connect_timeout=36000,
            max_allowed_packet=51200000
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
        except socket.error as e:
            self.log.warning(
                """Connection to `%(address)s` on port `%(port)s` failed - try again: %(e)s""" % locals())
            return False

        return None

    def _create_or_verify_settings(
            self,
            pathToSettings,
            create=False):
        """*create and/or verify a settings file at a given path*

        **Key Arguments:**
            - ``pathToSettings`` -- path to create/verify
            - ``create`` -- create the file if it does not exist. Default *False*.

        **Return:**
            - ``exists`` -- does the setting file now exist?
        """

        import codecs

        exists = False

        absPath = os.path.abspath(pathToSettings)
        defaultLog = f"{os.getenv('HOME')}/.config/{self.projectName}/{self.projectName}.log".replace("//", "/")
        alternativeLogPath = absPath.replace(".yaml", ".log")

        if os.path.exists(pathToSettings):
            self.arguments["settingsFile"] = pathToSettings
            exists = True

        if exists and create:
            print(f"A settings file already exists at '{pathToSettings}' and has not been modified.")

        if not exists and create:
            # FIND THE DEAFULT SETTINGS FILE
            ds = os.getcwd() + "/rubbish.yaml"
            level = 0
            exists = False
            count = 1
            while not exists and len(ds) and count < 10:
                count += 1
                level -= 1
                exists = os.path.exists(ds)
                if not exists:
                    if isinstance(self.defaultSettingsFile, bool):
                        ds = "/".join(inspect.stack()[2][1].split("/")[:level]) + "/default_settings.yaml"
                    else:
                        ds = "/".join(inspect.stack()[2][1].split("/")[:level]) + "/" + self.defaultSettingsFile

            try:
                # COPY THE SETTINGS FILE TO THE REQUESTED LOCATION
                shutil.copyfile(ds, pathToSettings)
                try:
                    readFile = codecs.open(
                        pathToSettings, encoding='utf-8', mode='r')
                    thisData = readFile.read()
                    readFile.close()
                except IOError as e:
                    message = 'could not open the file %s' % (
                        pathToReadFile,)
                    raise IOError(message)

                # JUST INCASE!
                thisData = thisData.replace(
                    "/Users/Dave", os.getenv("HOME"))

                if defaultLog != alternativeLogPath:
                    thisData = thisData.replace(defaultLog, alternativeLogPath)

                # REWRITE CLEANED FILE
                try:
                    writeFile = codecs.open(
                        pathToSettings, encoding='utf-8', mode='w')
                except IOError as e:
                    message = 'could not open the file %s' % (
                        pathToSettings,)
                    raise IOError(message)
                writeFile.write(thisData)
                writeFile.close()
                print(
                    f"Default settings have been added to '{pathToSettings}'. Tailor these settings before proceeding to run {self.projectName}.")
            except:
                print(
                    f"Please add any require settings to file '{pathToSettings}' before proceeding to run {self.projectName}.")
            self.arguments["settingsFile"] = pathToSettings

        return exists

    # use the tab-trigger below for new method
    # xt-class-method


def ordered_load(stream, Loader=yaml.loader, object_pairs_hook=OrderedDict):
    class OrderedLoader(Loader):
        pass

    def construct_mapping(loader, node):
        loader.flatten_mapping(node)
        return object_pairs_hook(loader.construct_pairs(node))
    OrderedLoader.add_constructor(
        yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG,
        construct_mapping)
    return yaml.safe_load(stream, OrderedLoader)


if __name__ == '__main__':
    main()
