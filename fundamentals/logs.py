#!/usr/local/bin/python
# encoding: utf-8
"""
*Logger setup for python projects*

:Author:
    David Young
"""
from builtins import object
import os
import sys
import logging
import coloredlogs
from logging import handlers


def console_logger(
    level="WARNING"
):
    """
    *Setup and return a console logger*

    **Key Arguments**

    - ``level`` -- the level of logging required


    **Return**

    - ``logger`` -- the console logger


    **Usage**

    ```python
    from fundamentals import logs
    log = logs.console_logger(
        level="DEBUG"
    )
    log.debug("Testing console logger")
    ```

    """
    ## STANDARD LIB ##

    import logging
    import logging.config
    import coloredlogs
    ## THIRD PARTY ##
    import yaml
    try:
        yaml.warnings({'YAMLLoadWarning': False})
    except:
        pass
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

    logging.config.dictConfig(yaml.safe_load(loggerConfig))
    logger = logging.getLogger(__name__)

    return logger


def setup_dryx_logging(yaml_file):
    """
    *setup dryx style python logging*

    **Key Arguments**

    - ``level`` -- the level of logging required


    **Return**

    - ``logger`` -- the console logger


    **Usage**

    ```python
    from fundamentals import logs
    log = logs.setup_dryx_logging(
        yaml_file="/Users/Dave/.config/fundamentals/fundamentals.yaml"
    )
    log.error("test error")
    ```

    Here is an example of the settings in the yaml file:

    ```yaml
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
    ```

    """
    import logging
    import coloredlogs
    import logging.config
    import yaml
    try:
        from StringIO import StringIO
    except ImportError:
        from io import StringIO
    from os.path import expanduser

    # IMPORT CUSTOM HANDLER THAT ALLOWS GROUP WRITING
    handlers.GroupWriteRotatingFileHandler = GroupWriteRotatingFileHandler

    # GET CONTENT OF YAML FILE AND REPLACE ~ WITH HOME DIRECTORY PATH
    with open(yaml_file) as f:
        content = f.read()
    home = expanduser("~")
    content = content.replace("~/", home + "/")
    stream = StringIO(content)
    yamlContent = yaml.safe_load(stream)
    stream.close()

    # USE THE LOGGING SETTINGS SECTION OF THE SETTINGS DICTIONARY FILE IF THERE IS ONE
    # OTHERWISE ASSUME THE FILE CONTAINS ONLY LOGGING SETTINGS
    if "logging settings" in yamlContent:
        yamlContent = yamlContent["logging settings"]
        yamlContent["version"] = 1

    if "handlers" in yamlContent and "file" in yamlContent["handlers"] and "filename" in yamlContent["handlers"]["file"]:
        loggingDir = os.path.dirname(
            yamlContent["handlers"]["file"]["filename"])
        # Recursively create missing directories
        if not os.path.exists(loggingDir):
            os.makedirs(loggingDir)

    if "root" in yamlContent and "level" in yamlContent["root"]:
        level = yamlContent["root"]["level"]

    logging.config.dictConfig(yamlContent)
    # SET THE ROOT LOGGER
    logger = logging.getLogger(__name__)

    logging.captureWarnings(True)

    coloredlogs.DEFAULT_FIELD_STYLES = {
        'asctime': {'color': 'green', 'faint': True},
        'levelname': {'color': 'white'},
        'pathname': {'color': 'cyan', 'faint': True},
        'funcName': {'color': 'magenta', },
        'lineno': {'color': 'cyan', 'faint': True}
    }
    coloredlogs.DEFAULT_LEVEL_STYLES = {
        'debug': {'color': 'black', 'bright': True},
        'info': {'color': 'white', 'bright': True},
        'warning': {'color': 'yellow'},
        'error': {'color': 'red'},
        'critical': {'color': 'white', 'background': 'red'}}
    coloredlogs.install(level=level, logger=logger, fmt=yamlContent[
                        "formatters"]["console_style"]["format"], datefmt=yamlContent[
                        "formatters"]["console_style"]["datefmt"])

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


class emptyLogger(object):
    """
    *A fake logger object so user can set ``log=False`` if required*

    **Usage**

    ```python
    if log == False:
        from fundamentals.logs import emptyLogger
        log = emptyLogger()
    ```

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
