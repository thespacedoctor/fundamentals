#!/usr/local/bin/python
# encoding: utf-8
"""
*Logger setup for python projects*

Author
: David Young
"""

from builtins import object
import os
import stat
import sys
import logging
from logging import handlers


DEFAULT_LEVEL = "INFO"
CONSOLE_HANDLER_NAME = "consoleLog"
# THE CONSOLE HANDLER THRESHOLD IS LOWERED BY THIS AMOUNT SO THAT log.print() MESSAGES
# (INFO + 5) STILL SHOW WHEN THE CONSOLE LEVEL IS SET TO WARNING (INFO + 10)
PRINT_LEVEL_OFFSET = 6


def console_logger(level="WARNING"):
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
        yaml.warnings({"YAMLLoadWarning": False})
    except:
        pass
    ## LOCAL APPLICATION ##

    # SETUP LOGGING
    loggerConfig = (
        """
  version: 1
  formatters:
      console_style:
          format: '* %(asctime)s - %(levelname)s: %(pathname)s:%(funcName)s:%(lineno)d > %(message)s'
          datefmt: '%H:%M:%S'
  handlers:
      console:
          class: logging.StreamHandler
          level: """
        + level
        + """
          formatter: console_style
          stream: ext://sys.stdout
  root:
      level: """
        + level
        + """
      handlers: [console]"""
    )

    logging.config.dictConfig(yaml.safe_load(loggerConfig))
    logger = logging.getLogger(__name__)

    return logger


def setup_dryx_logging(yaml_file):
    """
    *setup dryx style python logging*

    Each call applies the logging settings in ``yaml_file``, replacing the configuration from any earlier call.

    **Key Arguments**

    - ``yaml_file`` -- path to the yaml file holding the logging settings


    **Return**

    - ``logger`` -- the configured logger

    If the settings have no ``root`` section, or no root ``level``, the level defaults to ``INFO``. A level name that logging does not know raises ``ValueError``.


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

    # ADD log.print() LEVEL (NO-OP IF IT ALREADY EXISTS)
    addLoggingLevel("PRINT", logging.INFO + 5)

    yamlContent = _load_logging_yaml(yaml_file)
    _create_log_directory(yamlContent)

    rootSettings = yamlContent.setdefault("root", {})
    rootSettings.setdefault("level", DEFAULT_LEVEL)
    rootSettings.setdefault("handlers", [])
    rootLevel = _resolve_level(rootSettings["level"])
    consoleLevel = rootLevel
    consoleHandler = yamlContent.get("handlers", {}).get("console", {})
    if "level" in consoleHandler:
        consoleLevel = _resolve_level(consoleHandler["level"]) - PRINT_LEVEL_OFFSET

    consoleStyle = yamlContent.get("formatters", {}).get("console_style")
    if consoleStyle:
        format = consoleStyle["format"]
        dateFmt = consoleStyle["datefmt"]
    else:
        format = '%(levelname)s: "%(pathname)s", line %(lineno)d, in %(funcName)s > %(message)s'
        dateFmt = "%H:%M:%S"

    # THE CONSOLE HANDLER IS ADDED BELOW WITH COLOUR FORMATTING INSTEAD
    addConsole = "console" in rootSettings["handlers"]
    if addConsole:
        rootSettings["handlers"].remove("console")

    # KEEP LOGGERS THAT ALREADY EXIST SO REPEAT CALLS DO NOT SILENCE THEM
    yamlContent.setdefault("disable_existing_loggers", False)

    if len(rootSettings["handlers"]):
        logging.config.dictConfig(yamlContent)

    logger = logging.getLogger(__name__)
    logger.setLevel(rootLevel)

    # DROP THE CONSOLE HANDLER FROM ANY PREVIOUS CALL SO HANDLERS ARE NOT DUPLICATED
    for handler in logger.handlers[:]:
        if handler.get_name() == CONSOLE_HANDLER_NAME:
            logger.removeHandler(handler)

    if addConsole:
        consoleLog = logging.StreamHandler()
        consoleLog.set_name(CONSOLE_HANDLER_NAME)
        consoleLog.setLevel(consoleLevel)
        cf = ColorFormatter()
        cf.setFormat(format, dateFmt)
        consoleLog.setFormatter(cf)
        logger.addHandler(consoleLog)

    logging.captureWarnings(True)

    return logger


def _load_logging_yaml(yaml_file):
    """
    *Read the logging settings from a yaml file, expanding ``~/`` to the home directory*

    **Key Arguments**

    - ``yaml_file`` -- path to the yaml settings file

    **Return**

    - ``yamlContent`` -- the logging settings as a dictionary (the ``logging settings`` section if the file has one)
    """
    import yaml
    from os.path import expanduser

    with open(yaml_file) as f:
        content = f.read()
    content = content.replace("~/", expanduser("~") + "/")
    yamlContent = yaml.safe_load(content)

    # USE THE LOGGING SETTINGS SECTION OF THE SETTINGS DICTIONARY FILE IF THERE IS ONE
    # OTHERWISE ASSUME THE FILE CONTAINS ONLY LOGGING SETTINGS
    if "logging settings" in yamlContent:
        yamlContent = yamlContent["logging settings"]
        yamlContent["version"] = 1

    return yamlContent


def _create_log_directory(yamlContent):
    """
    *Create the directory of the file handler's log file if it is missing*

    **Key Arguments**

    - ``yamlContent`` -- the logging settings dictionary
    """
    fileHandler = yamlContent.get("handlers", {}).get("file", {})
    if "filename" not in fileHandler:
        return
    loggingDir = os.path.dirname(fileHandler["filename"])
    if not os.path.exists(loggingDir):
        os.makedirs(loggingDir)


def _resolve_level(levelName):
    """
    *Convert a logging level name (or number) to its numeric value*

    **Key Arguments**

    - ``levelName`` -- a level name such as ``WARNING``, or a level number

    **Return**

    - ``levelNumber`` -- the numeric level

    Raises ``ValueError`` naming the value if it is not a known level.
    """
    if isinstance(levelName, int):
        return levelName
    levelNumber = logging.getLevelName(levelName)
    if not isinstance(levelNumber, int):
        raise ValueError(f"Unknown logging level {levelName!r}")
    return levelNumber


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

    def setFormat(
        self,
        format="%(asctime)s - %(name)s - %(levelname)s - %(message)s (%(filename)s:%(lineno)d)",
        dateFmt="%H:%M:%S",
    ):
        reset = "\u001b[0m"
        bold = "\u001b[1m"
        green = "\u001b[38;5;76m"
        red = "\u001b[38;5;196m"
        yellow = "\u001b[38;5;226m"
        blue = "\u001b[38;5;39m"
        ul = "\u001b[4m"

        self.FORMATS = {
            logging.PRINT: "%(message)s",
            logging.DEBUG: format.replace(
                "%(levelname)s", f"{yellow}%(levelname)s{reset}"
            )
            .replace("%(message)s", "%(message)s")
            .replace("%(pathname)s", f"{ul}%(pathname)s{reset}")
            + reset,
            logging.INFO: format.replace("%(levelname)s", f"{blue}%(levelname)s{reset}")
            .replace("%(message)s", "%(message)s")
            .replace("%(pathname)s", f"{ul}%(pathname)s{reset}")
            + reset,
            logging.WARNING: format.replace(
                "%(levelname)s", f"{green}%(levelname)s{reset}"
            )
            .replace("%(message)s", "%(message)s")
            .replace("%(pathname)s", f"{ul}%(pathname)s{reset}")
            + reset,
            logging.ERROR: format.replace("%(levelname)s", f"{red}%(levelname)s{reset}")
            .replace("%(message)s", "%(message)s")
            .replace("%(pathname)s", f"{ul}%(pathname)s{reset}")
            + reset,
            logging.CRITICAL: format.replace(
                "%(levelname)s", f"{bold}{ul}{red}%(levelname)s{reset}"
            )
            .replace("%(message)s", "%(message)s")
            .replace("%(pathname)s", f"{ul}%(pathname)s{reset}")
            + reset,
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

    def _open(self):
        # NOTE: os.umask IS PROCESS-WIDE AND NOT THREAD-SAFE
        # 0o002 GIVES 0664: GROUP CAN WRITE, OTHERS CAN ONLY READ
        prevumask = os.umask(0o002)
        try:
            return handlers.RotatingFileHandler._open(self)
        finally:
            os.umask(prevumask)

    def doRollover(self):
        """
        *Override base class method to make the new log file group writable.*
        """
        # ROTATE THE FILE FIRST
        handlers.RotatingFileHandler.doRollover(self)

        # ADD GROUP READ/WRITE AND WORLD READ; NEVER WORLD WRITE
        currMode = os.stat(self.baseFilename).st_mode
        os.chmod(
            self.baseFilename,
            (currMode | stat.S_IWGRP | stat.S_IRGRP | stat.S_IROTH) & ~stat.S_IWOTH,
        )


# REGISTER THE HANDLER AT IMPORT SO dictConfig CAN RESOLVE
# logging.handlers.GroupWriteRotatingFileHandler WHATEVER THE IMPORT ORDER
handlers.GroupWriteRotatingFileHandler = GroupWriteRotatingFileHandler


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

    def info(self, *args, **kwargs):
        pass

    def error(self, *args, **kwargs):
        pass

    def debug(self, *args, **kwargs):
        pass

    def critical(self, *args, **kwargs):
        pass

    def warning(self, *args, **kwargs):
        pass

    def print(self, *args, **kwargs):
        pass
