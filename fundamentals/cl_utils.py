#!/usr/bin/env python
# encoding: utf-8
"""
Documentation for fundamentals can be found here: http://fundamentals.readthedocs.org

Usage:
    fundamentals init
    fundamentals [-s <pathToSettingsFile>]

Options:
    init                                   setup the fundamentals settings file for the first time
    -h, --help                             show this help message
    -v, --version                          show version
    -s, --settings <pathToSettingsFile>    the settings file
"""

import os
import subprocess
import sys

os.environ["TERM"] = "vt100"
try:
    import readline
except ImportError:
    # Windows: readline not available in stdlib Optionally use pyreadline3 if installed
    try:
        import pyreadline3 as readline
    except ImportError:
        readline = None  # or just pass — basic input() still works
import glob
from fundamentals import tools, times


def tab_complete(text, state):
    return (glob.glob(text + "*") + [None])[state]


def open_file(path, log):
    """*open a file with the operating system's default application, without a shell*

    **Key Arguments:**

    - ``path`` -- path to the file to open
    - ``log`` -- logger

    A failure to open the file is logged as a warning and never raised. Platforms other than macOS and Windows do nothing.
    """
    try:
        if sys.platform == "darwin":
            subprocess.run(["open", path], check=False)
        elif sys.platform == "win32":
            os.startfile(path)
    except OSError as e:
        log.warning("could not open `%s`: %s" % (path, e))
    return None


def main(arguments=None):
    """
    *The main function used when `cl_utils.py` is run as a single script from the cl, or when installed as a cl command*
    """
    # setup the command-line util settings
    su = tools(
        arguments=arguments,
        docString=__doc__,
        logLevel="WARNING",
        options_first=False,
        projectName="fundamentals",
        defaultSettingsFile=True,
    )
    arguments, settings, log, dbConn = su.setup()

    # tab completion for raw_input
    readline.set_completer_delims(" \t\n;")
    readline.parse_and_bind("tab: complete")
    readline.set_completer(tab_complete)

    # UNPACK REMAINING CL ARGUMENTS USING `EXEC` TO SETUP THE VARIABLE NAMES
    # AUTOMATICALLY
    a = {}
    for arg, val in list(arguments.items()):
        if arg[0] == "-":
            varname = arg.replace("-", "") + "Flag"
        else:
            varname = arg.replace("<", "").replace(">", "")
        a[varname] = val
        if arg == "--dbConn":
            dbConn = val
            a["dbConn"] = val
        log.debug(
            "%s = %s"
            % (
                varname,
                val,
            )
        )

    ## START LOGGING ##
    startTime = times.get_now_sql_datetime()
    log.info("--- STARTING TO RUN THE cl_utils.py AT %s" % (startTime,))

    if a["init"]:
        from os.path import expanduser

        open_file(expanduser("~/.config/fundamentals/fundamentals.yaml"), log)
        return

    # CALL FUNCTIONS/OBJECTS

    if "dbConn" in locals() and dbConn:
        dbConn.commit()
        dbConn.close()
    ## FINISH LOGGING ##
    endTime = times.get_now_sql_datetime()
    runningTime = times.calculate_time_difference(startTime, endTime)
    log.info(
        "-- FINISHED ATTEMPT TO RUN THE cl_utils.py AT %s (RUNTIME: %s) --"
        % (
            endTime,
            runningTime,
        )
    )

    return


if __name__ == "__main__":
    main()
