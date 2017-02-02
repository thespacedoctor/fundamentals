#!/usr/bin/env python
# encoding: utf-8
"""
*A unit-testing kit to simplify my unit-tests*

:Author:
    David Young

:Date Created:
    April 16, 2014
"""
################# GLOBAL IMPORTS ####################
import sys
import os
import logging
import logging.config
import yaml


class utKit():

    """
    *Default setup for fundamentals style unit-testing workflow (all tests base on nose module)*

    **Key Arguments:**
        - ``moduleDirectory`` -- the directory to the unit-testing test file

    **Usage:**
        To use this kit within any of your unit-test modules add the following code before your test methods:

        .. code-block:: python 

            from fundamentals.utKit import utKit
            # SETUP AND TEARDOWN FIXTURE FUNCTIONS FOR THE ENTIRE MODULE
            moduleDirectory = os.path.dirname(__file__)
            utKit = utKit(moduleDirectory)
            log, dbConn, pathToInputDir, pathToOutputDir = utKit.setupModule()
            utKit.tearDownModule() 
    """
    # Initialisation

    def __init__(
            self,
            moduleDirectory
    ):
        self.moduleDirectory = moduleDirectory
        # x-self-arg-tmpx

        # SETUP PATHS TO COMMON DIRECTORIES FOR TEST DATA
        self.pathToInputDir = moduleDirectory + "/input/"
        self.pathToOutputDir = moduleDirectory + "/output/"

        # SETUP LOGGING
        self.loggerConfig = """
        version: 1
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
        db: dryx_unit_testing
        host: localhost
        user: unittesting
        password: utpass
        """

        return

    def setupModule(
            self):
        """
        *The setupModule method*

        **Return:**
            - ``log`` -- a logger
            - ``dbConn`` -- a database connection to a test database (details from yaml settings file)
            - ``pathToInputDir`` -- path to modules own test input directory
            - ``pathToOutputDir`` -- path to modules own test output directory
        """
        import MySQLdb as ms
        ## VARIABLES ##
        logging.config.dictConfig(yaml.load(self.loggerConfig))
        log = logging.getLogger(__name__)
        connDict = yaml.load(self.dbConfig)
        dbConn = ms.connect(
            host=connDict['host'],
            user=connDict['user'],
            passwd=connDict['password'],
            db=connDict['db'],
            use_unicode=True,
            charset='utf8'
        )
        dbConn.autocommit(True)

        return log, dbConn, self.pathToInputDir, self.pathToOutputDir

    def tearDownModule(
            self):
        """
        *The tearDownModule method*

        **Key Arguments:**
            # -

        **Return:**
            - None
        """

        return None


if __name__ == '__main__':
    main()
