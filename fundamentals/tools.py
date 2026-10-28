#!/usr/bin/env python
# encoding: utf-8
"""
*Toolset to setup the main function for a cl-util*

Author
: David Young
"""

from __future__ import print_function
from __future__ import absolute_import
from builtins import object
import sys
import os
import yaml

try:
    yaml.warnings({"YAMLLoadWarning": False})
except:
    pass
from collections import OrderedDict
import logging
import shutil
from . import logs as dl
from .ssh_tunnel import setup_ssh_tunnel
from docopt import docopt

from os.path import expanduser
import inspect
import psutil

# IN ORDER OF PRECEDENCE: THE FIRST KEY WITH A VALUE NAMES THE SETTINGS FILE
SETTINGS_FILE_ARGUMENT_KEYS = (
    "<settingsFile>",
    "<pathToSettingsFile>",
    "--settingsFile",
    "--settings",
    "pathToSettingsFile",
    "settingsFile",
)


def find_settings_path(arguments):
    """*Return the settings file named in the arguments, or None if no argument names one*

    **Key Arguments**

    - ``arguments`` -- the command-line arguments dictionary

    **Return**

    - ``settingsPath`` -- the value of the first key in ``SETTINGS_FILE_ARGUMENT_KEYS`` that has a value
    """
    for key in SETTINGS_FILE_ARGUMENT_KEYS:
        if arguments.get(key):
            return arguments[key]
    return None


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
    - ``createLogger`` -- create a logger for the project (Default is True)

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
        tunnel:
            remote user: username
            remote ip: mydomain.co.uk
            remote datbase host: mydatabaseName
            port: 9002

    # SSH TUNNEL - set `tunnel: false` (or leave the key out) if no tunnel is required
    # A private ssh process forwards a unix socket in a new 0700 directory, and the database
    # connection is made through that socket. `port` must still be a valid port number, but it is
    # no longer used: nothing listens on a TCP port, so no other process can take the tunnel's place.
    # Note only one tunnel is setup - may need to change this to 2 tunnels in the future if
    # code, static catalogue database and transient database are all on seperate machines.

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
        quitIfRunning=True,
        createLogger=True,
    ):
        self.arguments = arguments
        self.docString = docString
        self.logLevel = logLevel
        self.configSettingsPath = (
            os.getenv("HOME") + f"/.config/{projectName}/{projectName}.yaml"
        )
        self.projectName = projectName
        self.defaultSettingsFile = defaultSettingsFile
        self.createLogger = createLogger

        if not distributionName:
            distributionName = projectName

        version = "0.0.1"
        try:
            from importlib.metadata import version as get_version
        except ImportError:  # For Python < 3.8
            from importlib_metadata import version as get_version
        try:
            version = get_version(distributionName)
        except:
            version = "?"

        ## ACTIONS BASED ON WHICH ARGUMENTS ARE RECIEVED ##
        # PRINT COMMAND-LINE USAGE IF NO ARGUMENTS PASSED
        if self.arguments == None:
            self.arguments = docopt(
                docString, version="v" + version, options_first=options_first
            )

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
                    print(
                        "This command is already running (see PID %(thisId)s)"
                        % locals()
                    )
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
                advs = (
                    "/".join(inspect.stack()[1][1].split("/")[:level])
                    + "/advanced_settings.yaml"
                )
        if not exists:
            advs = {}
        else:
            with open(advs, "r") as stream:
                advs = yaml.safe_load(stream)

        if (
            defaultSettingsFile
            and "settingsFile" not in self.arguments
            and "--settings" not in self.arguments
        ):
            cwdSettings = os.getcwd() + f"/{projectName}.yaml"
            if os.path.exists(cwdSettings):
                self.arguments["settingsFile"] = settingsFile = cwdSettings
            elif os.path.exists(
                os.getenv("HOME")
                + "/.config/%(projectName)s/%(projectName)s.yaml" % locals()
            ):
                self.arguments["settingsFile"] = settingsFile = (
                    os.getenv("HOME")
                    + "/.config/%(projectName)s/%(projectName)s.yaml" % locals()
                )

        # UNPACK SETTINGS
        settingsPath = find_settings_path(self.arguments) or False
        if settingsPath is False and (
            (
                "settingsFile" in self.arguments
                and self.arguments["settingsFile"] == None
            )
            or (
                "<pathToSettingsFile>" in self.arguments
                and self.arguments["<pathToSettingsFile>"] == None
            )
            or ("--settings" in self.arguments and self.arguments["--settings"] == None)
            or (
                "pathToSettingsFile" in self.arguments
                and self.arguments["pathToSettingsFile"] == None
            )
        ):

            init = False
            workspaceDirectory = False
            if "init" in self.arguments and self.arguments["init"]:
                init = True
                if (
                    "<workspaceDirectory>" in self.arguments
                    and self.arguments["<workspaceDirectory>"]
                ):
                    theseSettings = (
                        self.arguments["<workspaceDirectory>"] + f"/{projectName}.yaml"
                    )
                else:
                    theseSettings = self.configSettingsPath
                exists = self._create_or_verify_settings(
                    pathToSettings=theseSettings, create=True
                )

            else:
                if projectName != False:
                    # FIRST CHECK FOR SETTINGS IN CWD
                    cwdSettings = os.getcwd() + f"/{projectName}.yaml"
                    exists = self._create_or_verify_settings(
                        pathToSettings=cwdSettings, create=False
                    )

                    # THEN CHECK FOR SETTINGS CONFIG DIRECTORY
                    if not exists:
                        exists = self._create_or_verify_settings(
                            pathToSettings=self.configSettingsPath, create=False
                        )

                    # CREATE SETTING IN DEFAULT SETTINGS LOCATION IF NONE EXIST
                    if not exists:
                        exists = self._create_or_verify_settings(
                            pathToSettings=self.configSettingsPath, create=True
                        )
            if "settingsFile" in self.arguments and self.arguments["settingsFile"]:
                settingsPath = self.arguments["settingsFile"]

        # FOR SETTINGS FILE PATHS PASSED DIRECTORY VIA THE CL
        if settingsPath is not False:
            with open(settingsPath, "r") as stream:
                astream = stream.read()
            home = expanduser("~")
            astream = astream.replace("~/", home + "/")

            if orderedSettings:
                settings = ordered_load(astream, yaml.SafeLoader)
            else:
                settings = yaml.safe_load(astream)

        # MERGE ADVANCED SETTINGS AND USER SETTINGS (USER SETTINGS OVERRIDE)
        if "settings" not in locals():
            settings = advs
        else:
            settings = {**advs, **settings}

        if self.createLogger:
            self.log = self._build_logger(settings)

        else:
            self.log = None

        # SETUP A DATABASE CONNECTION BASED ON WHAT ARGUMENTS HAVE BEEN PASSED
        dbConn = False
        tunnel = False

        if (
            "--host" in self.arguments
            and "--dbName" in self.arguments
            and self.arguments["--host"]
        ):
            # SETUP DB CONNECTION
            dbConn = True
            host = self.arguments["--host"]
            user = self.arguments["--user"]
            passwd = self.arguments["--passwd"]
            dbName = self.arguments["--dbName"]
            port = False

        elif (
            "settings" in locals()
            and "database settings" in settings
            and "host" in settings["database settings"]
        ):
            host = settings["database settings"]["host"]
            user = settings["database settings"]["user"]
            passwd = settings["database settings"]["password"]
            dbName = settings["database settings"]["db"]
            if (
                "tunnel" in settings["database settings"]
                and settings["database settings"]["tunnel"]
            ):
                tunnel = True
            dbConn = True
            port = False
            if (
                "port" in settings["database settings"]
                and settings["database settings"]["port"]
            ):
                port = int(settings["database settings"]["port"])
        else:
            pass

        if not "settings" in locals():
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
                charset="utf8",
                local_infile=1,
                client_flag=ms.constants.CLIENT.MULTI_STATEMENTS,
                connect_timeout=36000,
                max_allowed_packet=51200000,
            )
            dbConn.autocommit(True)

        self.dbConn = dbConn

        return None

    def setup(self):
        """
        **Summary:**
            *setup the attributes and return*
        """

        return self.arguments, self.settings, self.log, self.dbConn

    def _build_logger(self, settings):
        """
        *build the logger from the settings file named in the arguments, falling back to a console logger*

        **Key Arguments**

        - ``settings`` -- the merged settings dictionary

        **Return**

        - ``log`` -- the logger
        """
        settingsPath = find_settings_path(self.arguments)
        if "logging settings" in settings and settingsPath:
            return dl.setup_dryx_logging(yaml_file=settingsPath)

        return dl.console_logger(level=self.logLevel)

    def _setup_tunnel(self):
        """
        *setup the ssh tunnel described by ``database settings: tunnel`` and connect to the remote database through it*

        Raises ``fundamentals.ssh_tunnel.tunnel_error`` if the tunnel settings are invalid or the tunnel cannot be set up.
        """
        import pymysql as ms

        databaseSettings = self.settings["database settings"]
        socketPath = setup_ssh_tunnel(
            tunnelParameters=databaseSettings["tunnel"],
            log=self.log,
        )

        # SETUP A DATABASE CONNECTION FOR THE remote database
        thisConn = ms.connect(
            host=databaseSettings["host"],
            user=databaseSettings["user"],
            passwd=databaseSettings["password"],
            db=databaseSettings["db"],
            unix_socket=socketPath,
            use_unicode=True,
            charset="utf8",
            local_infile=1,
            client_flag=ms.constants.CLIENT.MULTI_STATEMENTS,
            connect_timeout=36000,
            max_allowed_packet=51200000,
        )
        thisConn.autocommit(True)
        self.remoteDBConn = thisConn

        return None

    def _create_or_verify_settings(self, pathToSettings, create=False):
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
        defaultLog = f"{os.getenv('HOME')}/.config/{self.projectName}/{self.projectName}.log".replace(
            "//", "/"
        )
        alternativeLogPath = absPath.replace(".yaml", ".log")

        if os.path.exists(pathToSettings):
            self.arguments["settingsFile"] = pathToSettings
            exists = True

        if exists and create:
            print(
                f"A settings file already exists at '{pathToSettings}' and has not been modified."
            )

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
                        ds = (
                            "/".join(inspect.stack()[2][1].split("/")[:level])
                            + "/default_settings.yaml"
                        )
                    else:
                        ds = (
                            "/".join(inspect.stack()[2][1].split("/")[:level])
                            + "/"
                            + self.defaultSettingsFile
                        )

            try:
                # COPY THE SETTINGS FILE TO THE REQUESTED LOCATION
                shutil.copyfile(ds, pathToSettings)
                with codecs.open(
                    pathToSettings, encoding="utf-8", mode="r"
                ) as readFile:
                    thisData = readFile.read()

                # JUST INCASE!
                thisData = thisData.replace("/Users/Dave", os.getenv("HOME"))

                if defaultLog != alternativeLogPath:
                    thisData = thisData.replace(defaultLog, alternativeLogPath)

                # REWRITE CLEANED FILE
                with codecs.open(
                    pathToSettings, encoding="utf-8", mode="w"
                ) as writeFile:
                    writeFile.write(thisData)
            except OSError as e:
                logging.getLogger(__name__).error(
                    f"could not create the settings file '{pathToSettings}': {e}"
                )
                raise
            print(
                f"Default settings have been added to '{pathToSettings}'. Tailor these settings before proceeding to run {self.projectName}."
            )
            self.arguments["settingsFile"] = pathToSettings

        return exists

    # use the tab-trigger below for new method
    # xt-class-method


def ordered_load(stream, Loader=yaml.SafeLoader, object_pairs_hook=OrderedDict):
    class OrderedLoader(Loader):
        pass

    def construct_mapping(loader, node):
        loader.flatten_mapping(node)
        return object_pairs_hook(loader.construct_pairs(node))

    OrderedLoader.add_constructor(
        yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG, construct_mapping
    )
    return yaml.load(stream, OrderedLoader)
