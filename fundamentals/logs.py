#!/usr/local/bin/python
# encoding: utf-8
"""
*Logger setup for python projects*

:Author:
    David Young

:Date Created:
    October 10, 2012
"""
import os
import sys
import logging
from logging import handlers


def console_logger(
    level="INFO"
):
    """
    *Setup and return a console logger*

    **Key Arguments:**
        - ``level`` -- the level of logging required

    **Return:**
        - ``logger`` -- the console logger

    **Usage:**
        .. code-block:: python 

            from fundamentals import logs
            log = logs.console_logger(
                level="DEBUG"
            )
            log.debug("Testing console logger")
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
    """
    *setup dryx style python logging*

    **Key Arguments:**
        - ``level`` -- the level of logging required

    **Return:**
        - ``logger`` -- the console logger

    **Usage:**
        .. code-block:: python 

            from fundamentals import logs
            log = logs.setup_dryx_logging(
                yaml_file="/Users/Dave/.config/fundamentals/fundamentals.yaml"
            )
            log.error("test error")

        Here is an example of the settings in the yaml file:

        .. code-block:: yaml

            version: 1

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
                        filename: /Users/Dave/.config/fundamentals/fundamentals.log
                        mode: w+
                        maxBytes: 102400
                        backupCount: 1
                root:
                    level: WARNING
                    handlers: [file,console]

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
    *rotating file handler for logging*
    """

    def doRollover(self):
        """
        *Override base class method to make the new log file group writable.*
        """
        # Rotate the file first.
        handlers.RotatingFileHandler.doRollover(self)

        # Add group write to the current permissions.
        currMode = os.stat(self.baseFilename).st_mode
        os.chmod(self.baseFilename, currMode | stat.S_IWGRP |
                 stat.S_IRGRP | stat.S_IWOTH | stat.S_IROTH)


class GroupWriteRotatingFileHandler(handlers.RotatingFileHandler):

    """
    *rotating file handler for logging*
    """

    def _open(self):
        prevumask = os.umask(0)
        rtv = logging.handlers.RotatingFileHandler._open(self)
        os.umask(prevumask)
        return rtv


class emptyLogger:
    """
    *A fake logger object so user can set ``log=False`` if required*

    **Usage:**
        .. code-block:: python 

            if log == False:
                from fundamentals.logs import emptyLogger
                log = emptyLogger()
    """

    def info(self, argu):
        pass

    def error(self, argu):
        pass

    def debug(self, argu):
        pass

    def critical(self, argu):
        pass

    def warning(self, argu):
        pass
