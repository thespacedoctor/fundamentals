#!/usr/local/bin/python
# encoding: utf-8
"""
logs.py
=======
:Summary:
    Logger setup for python projects

:Author:
    David Young

:Date Created:
    October 10, 2012

:dryx syntax:
    - ``_someObject`` = a 'private' object that should only be changed for debugging

:Notes:
    - If you have any questions requiring this script/module please email me: d.r.young@qub.ac.uk
"""
import os
import sys
import logging
from logging import handlers


def console_logger(
    level="INFO"
):
    """Setup and return a console logger only.

    **Key Arguments:**
        - ``level`` -- the level of logging required

    **Return:**
        - ``logger`` -- the console logger
    """
    ################ > IMPORTS ################
    ## STANDARD LIB ##
    import logging
    import logging.config
    ## THIRD PARTY ##
    import yaml
    ## LOCAL APPLICATION ##

    # SETUP LOGGING
    loggerConfig = """
  version: 1
  formatters:
      console_style:
          format: '* %(asctime)s - %(levelname)s: %(pathname)s:%(funcName)s:%(lineno)d > %(message)s'
          datefmt: '%H:%M:%S'
  handlers:
      console:
          class: logging.StreamHandler
          level: """ + level + """
          formatter: console_style
          stream: ext://sys.stdout
  root:
      level: """ + level + """
      handlers: [console]"""

    logging.config.dictConfig(yaml.load(loggerConfig))
    logger = logging.getLogger(__name__)

    return logger


def setup_dryx_logging(yaml_file):
    """setup dryx style python logging

    """
    import logging
    import logging.config
    import yaml

    # IMPORT CUSTOM HANDLER THAT ALLOWS GROUP WRITING
    handlers.GroupWriteRotatingFileHandler = GroupWriteRotatingFileHandler

    # IMPORT YAML LOGGING DICTIONARY
    stream = file(yaml_file, 'r')
    yamlContent = yaml.load(stream)
    stream.close()

    # USE THE LOGGING SETTINGS SECTION OF THE SETTINGS DICTIONARY FILE IF THERE IS ONE
    # OTHERWISE ASSUME THE FILE CONTAINS ONLY LOGGING SETTINGS
    if "logging settings" in yamlContent:
        yamlContent = yamlContent["logging settings"]
        yamlContent["version"] = 1

    logging.config.dictConfig(yamlContent)
    # SET THE ROOT LOGGER
    logger = logging.getLogger(__name__)

    logging.captureWarnings(True)

    return logger


class GroupWriteRotatingFileHandler(handlers.RotatingFileHandler):

    """
    rotating file handler for logging
    """

    def doRollover(self):
        """
        Override base class method to make the new log file group writable.
        """
        # Rotate the file first.
        handlers.RotatingFileHandler.doRollover(self)

        # Add group write to the current permissions.
        currMode = os.stat(self.baseFilename).st_mode
        os.chmod(self.baseFilename, currMode | stat.S_IWGRP |
                 stat.S_IRGRP | stat.S_IWOTH | stat.S_IROTH)


class GroupWriteRotatingFileHandler(handlers.RotatingFileHandler):

    """
    rotating file handler for logging
    """

    def _open(self):
        prevumask = os.umask(0)
        rtv = logging.handlers.RotatingFileHandler._open(self)
        os.umask(prevumask)
        return rtv
