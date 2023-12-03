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

    # ADD log.print() LEVEL
    exists = addLoggingLevel('PRINT', logging.INFO + 5)

    if exists:
        # SET THE ROOT LOGGER
        logger = logging.getLogger(__name__)
        return logger
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
    if "handlers" in yamlContent and "console" in yamlContent["handlers"] and "level" in yamlContent["handlers"]["console"]:
        level = logging.getLevelName(yamlContent["handlers"]["console"]["level"]) - 6
    if "formatters" in yamlContent and "console_style" in yamlContent["formatters"]:
        format = yamlContent["formatters"]["console_style"]["format"]
        dateFmt = yamlContent["formatters"]["console_style"]["datefmt"]
    else:
        format = '%(levelname)s: "%(pathname)s", line %(lineno)d, in %(funcName)s > %(message)s'
        dateFmt = '%H:%M:%S'

    addConsole = False
    if "root" in yamlContent and "handlers" in yamlContent["root"]:
        if "console" in yamlContent["root"]["handlers"]:
            addConsole = True
            yamlContent["root"]["handlers"].remove('console')

    if len(yamlContent["root"]["handlers"]):
        logging.config.dictConfig(yamlContent)

    # SET THE ROOT LOGGER
    logger = logging.getLogger(__name__)

    if addConsole:
        consoleLog = logging.StreamHandler()
        consoleLog.set_name("consoleLog")
        consoleLog.setLevel(level)
        cf = ColorFormatter()
        cf.setFormat(format, dateFmt)
        consoleLog.setFormatter(cf)
        logger.addHandler(consoleLog)

    logging.captureWarnings(True)

    return logger


def addLoggingLevel(levelName, levelNum, methodName=None):
    """
    FROM https://stackoverflow.com/questions/2183233/how-to-add-a-custom-loglevel-to-pythons-logging-facility/35804945#35804945

    Comprehensively adds a new logging level to the `logging` module and the
    currently configured logging class.

    `levelName` becomes an attribute of the `logging` module with the value
    `levelNum`. `methodName` becomes a convenience method for both `logging`
    itself and the class returned by `logging.getLoggerClass()` (usually just
    `logging.Logger`). If `methodName` is not specified, `levelName.lower()` is
    used.

    To avoid accidental clobberings of existing attributes, this method will
    raise an `AttributeError` if the level name is already an attribute of the
    `logging` module or if the method name is already present 

    Example
    -------
    >>> addLoggingLevel('TRACE', logging.DEBUG - 5)
    >>> logging.getLogger(__name__).setLevel("TRACE")
    >>> logging.getLogger(__name__).trace('that worked')
    >>> logging.trace('so did this')
    >>> logging.TRACE
    5

    """
    if not methodName:
        methodName = levelName.lower()

    if hasattr(logging, levelName):
        return 1
    if hasattr(logging, methodName):
        return 1
    if hasattr(logging.getLoggerClass(), methodName):
        return 1

    # This method was inspired by the answers to Stack Overflow post
    # http://stackoverflow.com/q/2183233/2988730, especially
    # http://stackoverflow.com/a/13638084/2988730
    def logForLevel(self, message, *args, **kwargs):
        if self.isEnabledFor(levelNum):
            self._log(levelNum, message, args, **kwargs)

    def logToRoot(message, *args, **kwargs):
        logging.log(levelNum, message, *args, **kwargs)

    logging.addLevelName(levelNum, levelName)
    setattr(logging, levelName, levelNum)
    setattr(logging.getLoggerClass(), methodName, logForLevel)
    setattr(logging, methodName, logToRoot)
    return 0


class ColorFormatter(logging.Formatter):

    format = "%(asctime)s - %(name)s - %(levelname)s - %(message)s (%(filename)s:%(lineno)d)"

    def setFormat(self, format="%(asctime)s - %(name)s - %(levelname)s - %(message)s (%(filename)s:%(lineno)d)", dateFmt='%H:%M:%S'):
        reset = "\u001b[0m"
        bold = "\u001b[1m"
        white = "\u001b[38;5;15m"
        green = "\u001b[38;5;76m"
        red = "\u001b[38;5;196m"
        yellow = "\u001b[38;5;226m"
        blue = "\u001b[38;5;39m"
        purple = "\u001b[38;5;56m"
        grey = "\u001b[38;5;245m"
        ul = "\u001b[4m"

        self.FORMATS = {
            logging.PRINT: f"%(message)s",
            logging.DEBUG: format.replace("%(levelname)s", f"{yellow}%(levelname)s{reset}").replace("%(message)s", f"%(message)s").replace("%(pathname)s", f"{ul}%(pathname)s{reset}") + reset,
            logging.INFO: format.replace("%(levelname)s", f"{blue}%(levelname)s{reset}").replace("%(message)s", f"%(message)s").replace("%(pathname)s", f"{ul}%(pathname)s{reset}") + reset,
            logging.WARNING: format.replace("%(levelname)s", f"{green}%(levelname)s{reset}").replace("%(message)s", f"%(message)s").replace("%(pathname)s", f"{ul}%(pathname)s{reset}") + reset,
            logging.ERROR: format.replace("%(levelname)s", f"{red}%(levelname)s{reset}").replace("%(message)s", f"%(message)s").replace("%(pathname)s", f"{ul}%(pathname)s{reset}") + reset,
            logging.CRITICAL: format.replace("%(levelname)s", f"{bold}{ul}{red}%(levelname)s{reset}").replace("%(message)s", f"%(message)s").replace("%(pathname)s", f"{ul}%(pathname)s{reset}") + reset,
        }
        self.dateFmt = dateFmt

    def format(self, record):
        log_fmt = self.FORMATS.get(record.levelno)
        formatter = logging.Formatter(log_fmt, self.dateFmt)
        return formatter.format(record)


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
