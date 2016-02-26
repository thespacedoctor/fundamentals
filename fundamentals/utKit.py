#!/usr/bin/env python
# encoding: utf-8
"""
utKit.py
========
:Summary:
    A unit-testing kit to simplify my unit-tests

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
import logging
import logging.config
import MySQLdb as ms
import yaml


class utKit():

    """
    My unit-testing kit
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
        db: pessto_marshall_sandbox
        host: localhost
        user: root
        password: root
        """

        return

    def setupModule(
            self):
        """The setupModule method

        **Return:**
            - log, dbConn, pathToInputDir, pathToOutputDir
        """
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

    # use the tab-trigger below for new method
    # method-tmpx


if __name__ == '__main__':
    main()
