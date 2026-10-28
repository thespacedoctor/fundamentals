#!/usr/bin/env python
# encoding: utf-8
"""
*A unit-testing kit to simplify my unit-tests*

Author
: David Young
"""

from builtins import object
import os
import logging
import logging.config
import yaml

try:
    yaml.warnings({"YAMLLoadWarning": False})
except:
    pass


PLACEHOLDER_MESSAGE = "run these tests under pytest; the root conftest.py injects log, settings and dbConn"


class _SessionPlaceholder(object):
    """
    *Stand-in for the ``log``, ``settings`` and ``dbConn`` names of a test module*

    The root ``conftest.py`` replaces it with the real objects when pytest runs the module. Any use outside pytest raises a ``RuntimeError`` instead of failing later with an unclear error.
    """

    def _fail(self, *args, **kwargs):
        raise RuntimeError(PLACEHOLDER_MESSAGE)

    __call__ = __getitem__ = __iter__ = __bool__ = _fail

    def __getattr__(self, name):
        # SPECIAL NAMES ARE PROBED BY TOOLS SUCH AS inspect AND pytest, SO THEY MUST LOOK ABSENT
        if name.startswith("__"):
            raise AttributeError(name)
        raise RuntimeError(PLACEHOLDER_MESSAGE)


SESSION_PLACEHOLDER = _SessionPlaceholder()


class utKit(object):
    """
    *Default setup for fundamentals style unit-testing workflow (all tests base on nose module)*

    **Key Arguments**

    - ``moduleDirectory`` -- the directory to the unit-testing test file


    **Usage**

    To use this kit within any of your unit-test modules add the following code before your test methods:

    ```python
    from fundamentals.utKit import utKit
    # SETUP AND TEARDOWN FIXTURE FUNCTIONS FOR THE ENTIRE MODULE
    moduleDirectory = os.path.dirname(__file__)
    utKit = utKit(moduleDirectory)
    log, dbConn, pathToInputDir, pathToOutputDir = utKit.setupModule()
    utKit.tearDownModule()
    ```

    """

    # Initialisation

    def __init__(self, moduleDirectory):
        self.moduleDirectory = moduleDirectory
        # x-self-arg-tmpx

        # SETUP PATHS TO COMMON DIRECTORIES FOR TEST DATA
        self.pathToInputDir = moduleDirectory + "/input/"
        self.pathToOutputDir = moduleDirectory + "/output/"

        # SETUP LOGGING
        self.loggerConfig = """
        version: 1
        disable_existing_loggers: False
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
        root:
            level: DEBUG
            handlers: [console]"""

        self.dbConfig = """
        version: 1
        db: unit_tests
        host: localhost
        user: utuser
        password: utpass
        """

        return

    def setupModule(self):
        """
        *The setupModule method*

        **Return**

        - ``log`` -- a logger
        - ``dbConn`` -- a database connection to a test database (details from yaml settings file)
        - ``pathToInputDir`` -- path to modules own test input directory
        - ``pathToOutputDir`` -- path to modules own test output directory

        """

        ## VARIABLES ##
        logging.config.dictConfig(yaml.safe_load(self.loggerConfig))
        log = logging.getLogger(__name__)
        if self.dbConfig:
            import pymysql as ms

            connDict = yaml.safe_load(self.dbConfig)
            dbConn = ms.connect(
                host=connDict["host"],
                user=connDict["user"],
                passwd=connDict["password"],
                db=connDict["db"],
                use_unicode=True,
                charset="utf8",
                local_infile=1,
                client_flag=ms.constants.CLIENT.MULTI_STATEMENTS,
                connect_timeout=3600,
            )
            dbConn.autocommit(True)
        else:
            dbConn = False

        return log, dbConn, self.pathToInputDir, self.pathToOutputDir

    def tearDownModule(self):
        """
        *The tearDownModule method*
        """

        return None

    def get_project_root(self):
        """
        *Get the root of the `python` package - useful for getting files in the root directory of a project*

        **Return**

        - ``rootPath`` -- the root path of a project

        """
        rootPath = os.path.dirname(__file__)

        return rootPath

    def refresh_database(self):
        """
        *Refresh the unit test database*
        """
        from fundamentals.mysql import directory_script_runner
        from fundamentals import tools

        packageDirectory = self.get_project_root()
        su = tools(
            arguments={"settingsFile": packageDirectory + "/test_settings.yaml"},
            docString=__doc__,
            logLevel="DEBUG",
            options_first=False,
            projectName=None,
            defaultSettingsFile=False,
        )
        arguments, settings, log, dbConn = su.setup()
        directory_script_runner(
            log=log,
            pathToScriptDirectory=packageDirectory + "/tests/input",
            dbConn=dbConn,
            successRule=None,
            failureRule=None,
        )
