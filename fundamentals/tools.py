#!/usr/bin/env python
# encoding: utf-8
"""
tools.py
=========
:Summary:
    Toolset to setup the main function for a cl-util

:Author:
    David Young

:Date Created:
    April 16, 2014

:dryx syntax:
    - ``_someObject`` = a 'private' object that should only be changed for debugging

:Notes:
    - If you have any questions requiring this script/module please email me: d.r.young@qub.ac.uk
"""
################# GLOBAL IMPORTS ####################
import sys
import os
import yaml
from collections import OrderedDict
import shutil
import MySQLdb as ms
import logs as dl
import time


###################################################################
# CLASSES                                                         #
###################################################################


class tools():

    """
    common setup methods & attributes of the main function in cl-util

    **Key Arguments:**
        - ``dbConn`` -- mysql database connection
    """
    # Initialisation

    def __init__(
            self,
            arguments,
            docString,
            logLevel="DEBUG",
            options_first=False,
            projectName=False,
            orderedSettings=False,
            tunnel=False
    ):
        self.arguments = arguments
        self.docString = docString
        self.logLevel = logLevel
        self.tunnel = tunnel

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
        elif "pathToSettingsFile" in arguments and arguments["pathToSettingsFile"]:
            stream = file(arguments["pathToSettingsFile"], 'r')
        elif "settingsFile" in arguments and arguments["settingsFile"]:
            stream = file(arguments["settingsFile"], 'r')
        elif ("settingsFile" in arguments and arguments["settingsFile"] == None) or ("<pathToSettingsFile>" in arguments and arguments["<pathToSettingsFile>"] == None):

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
                    ds = "/".join(inspect.stack()
                                  [1][1].split("/")[:-2]) + "/default_settings.yaml"
                    shutil.copyfile(ds, settingsFile)
                    try:
                        shutil.copyfile(ds, settingsFile)
                        print "default settings have been added to '%(settingsFile)s'" % locals()
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

        elif "--logger" not in arguments or arguments["--logger"] is None:
            log = dl.console_logger(
                level=self.logLevel
            )
            log.debug('logger setup')

        self.log = log

        # unpack remaining cl arguments using `exec` to setup the variable names
        # automatically
        for arg, val in arguments.iteritems():
            if arg[0] == "-":
                varname = arg.replace("-", "") + "Flag"
            else:
                varname = arg.replace("<", "").replace(">", "")
            if isinstance(val, str) or isinstance(val, unicode):
                val = val.replace("'", "\\'")
                exec(varname + " = '%s'" % (val,))
            else:
                exec(varname + " = %s" % (val,))
            if arg == "--dbConn":
                dbConn = val
            log.debug('%s = %s' % (varname, val,))

        # SETUP A DATABASE CONNECTION BASED ON WHAT ARGUMENTS HAVE BEEN PASSED
        dbConn = False
        if 'settings' in locals() and "database settings" in settings and "host" in settings["database settings"]:
            host = settings["database settings"]["host"]
            user = settings["database settings"]["user"]
            passwd = settings["database settings"]["password"]
            dbName = settings["database settings"]["db"]
            dbConn = True
        elif "hostFlag" in locals() and "dbNameFlag" in locals():
            # SETUP DB CONNECTION
            dbConn = True
            host = arguments["--host"]
            user = arguments["--user"]
            passwd = arguments["--passwd"]
            dbName = arguments["--dbName"]
        else:
            pass
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
            log.debug('dbConn: %s' % (dbConn,))

        self.dbConn = dbConn

        if not 'settings' in locals():
            settings = False
        self.settings = settings

        if tunnel:
            self._setup_tunnel()

        return None

    def setup(
            self):
        """setup the attributes and return
        """
        if self.tunnel:
            return self.arguments, self.settings, self.log, self.dbConn, self.remoteDBConn
        else:
            return self.arguments, self.settings, self.log, self.dbConn

    def _setup_tunnel(
            self):
        """ setup ssh tunnel if required
        """
        self.log.debug('starting the ``_setup_tunnel`` method')

        from subprocess import Popen, PIPE, STDOUT

        # SETUP TUNNEL IF REQUIRED
        if "ssh tunnel" in self.settings and "use tunnel" in self.settings["ssh tunnel"] and self.settings["ssh tunnel"]["use tunnel"] is True:
            # TEST TUNNEL DOES NOT ALREADY EXIST
            sshPort = self.settings["ssh tunnel"]["port"]
            connected = self._checkServer(
                self.settings["database settings"]["remote database"]["host"], sshPort)
            if connected:
                self.log.debug('ssh tunnel already exists - moving on')
            else:
                # GRAB TUNNEL SETTINGS FROM SETTINGS FILE
                ru = self.settings["ssh tunnel"]["remote user"]
                rip = self.settings["ssh tunnel"]["remote ip"]
                rh = self.settings["ssh tunnel"]["remote datbase host"]

                cmd = "ssh -fnN %(ru)s@%(rip)s -L %(sshPort)s:%(rh)s:3306" % locals()
                p = Popen(cmd, shell=True, close_fds=True)
                output = p.communicate()[0]
                self.log.debug('output: %(output)s' % locals())

                # TEST CONNECTION - QUIT AFTER SO MANY TRIES
                connected = False
                count = 0
                while not connected:
                    connected = self._checkServer(
                        self.settings["database settings"]["remote database"]["host"], sshPort)
                    time.sleep(1)
                    count += 1
                    if count == 5:
                        self.log.error(
                            'cound not setup tunnel to remote datbase' % locals())
                        sys.exit(0)

        # SETUP A DATABASE CONNECTION FOR THE remote database
        host = self.settings["database settings"]["remote database"]["host"]
        user = self.settings["database settings"]["remote database"]["user"]
        passwd = self.settings["database settings"][
            "remote database"]["password"]
        dbName = self.settings["database settings"]["remote database"]["db"]
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
        self.log.debug('cataloguesDbConn: %s' % (thisConn,))
        self.remoteDBConn = thisConn

        self.log.debug('completed the ``_setup_tunnel`` method')
        return None

    def _checkServer(self, address, port):
        """Check that the TCP Port we've decided to use for tunnelling is available
        """
        self.log.debug('starting the ``_checkServer`` method')

        # CREATE A TCP SOCKET
        import socket
        s = socket.socket()
        self.log.debug(
            """Attempting to connect to `%(address)s` on port `%(port)s`""" % locals())
        try:
            s.connect((address, port))
            self.log.debug(
                """Connected to `%(address)s` on port `%(port)s`""" % locals())
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
