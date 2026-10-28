#!/usr/local/bin/python
# encoding: utf-8
"""
*Given a directory of MySQL scripts, execute the scripts and process the script files according to their success or failure*

Run the following code once to set a login-path for your mysql server:

    mysql_config_editor set --login-path=<uniqueLoginName> --host=localhost --user=<myUsername> --password

This store's your credentials in an encrypted file located at '~/.mylogin.cnf'.
Use `mysql_config_editor print --all` to see all of the login-paths set.

Usage:
    mysqlSucker <pathToDirectory> <loginPath> <databaseName> [-s successRule -f failureRule]

    pathToDirectory       path to the directory containing the sql scripts to run (scripts must have `.sql` extension)
    loginPath             the local-path as set with `mysql_config_editor` (`mysqlSucker -h` for more details)
    databaseName          the name of the database to execute the scripts within

Options:
    -h, --help                                  show this help message
    -s successRule, --success successRule       what to do if script succeeds. Default *None* [None|delete|subFolderName]
    -f failureRule, --failure failureRule       what to do if script fails. Default *None* [None|delete|subFolderName]

:Examples:

    To simply execute the scripts in a directory you can run:

        mysqlSucker /path/to/scriptdir myLoginPath myDatabaseName

    To delete script after thay have executed successfully:

        mysqlSucker /path/to/scriptdir myLoginPath myDatabaseName -s delete

    To move successful script to a `passed` sub-directory of `/path/to/scriptdir` and failed scripts to a `failed` sub-directory

        mysqlSucker /path/to/scriptdir myLoginPath myDatabaseName -s pass -f failed

Author
: David Young
"""

from builtins import str
import os
import time
import collections
import datetime
import tempfile
import queue
import threading
from subprocess import Popen, PIPE, DEVNULL

os.environ["TERM"] = "vt100"
from fundamentals import tools

# MOST MYSQL CLIENTS RUN AT ONCE IN BACKGROUND MODE (THE SERVER REFUSES CONNECTIONS PAST ITS max_connections)
MAX_PARALLEL_SCRIPTS = 8
# MOST BYTES OF A SCRIPT'S STDERR (TAKEN FROM THE END) THAT ARE WRITTEN TO THE LOG
MAX_LOGGED_STDERR_BYTES = 65536


def directory_script_runner(
    log,
    pathToScriptDirectory,
    dbConn=False,
    waitForResult=True,
    successRule=None,
    failureRule=None,
    loginPath=False,
    databaseName=False,
    force=True,
    maxParallelScripts=MAX_PARALLEL_SCRIPTS,
):
    """A function to run all mysql scripts in a given directory (in a modified date order, oldest first) and then act on the script files in accordance with the succcess or failure of their execution

    The function can be run with either with an established database connection (`dbConn`) or with a mysql generated `login-path` name (`loginPath`).

    **with `dbConn`**

    Simply pass the connection `dbConn` established elsewhere in your code.

    **with `loginPath`**

    As it's insecure to pass in mysql database credentials via the command-line, run the following command from the terminal

    ```bash
    mysql_config_editor set --login-path=<uniqueLoginName> --host=localhost --user=<myUsername> --password
    > Enter password:
    ```

    This will store your database credentials in an encrypted file located at '~/.mylogin.cnf'. Use `mysql_config_editor print --all` to see all of the login-paths set.

    The `directory_script_runner` function can work by taking advantage of mysql's `--login-path` argument so not to require knowledge of the database credentials.

    Pass the login-path name via the `loginPath` parameter to use `directory_script_runner` in this manner.

    If both `dbConn` and `loginPath` parameters are given, `dbConn` will be given precedent.

    **Key Arguments**

    - ``log`` -- logger
    - ``pathToScriptDirectory`` -- the path to the directory containing the sql script to be run
    - ``databaseName`` -- the name of the database
    - ``force`` -- force the script to run, skipping over lines with errors, Default *True*
    - ``loginPath`` -- the local-path as set with `mysql_config_editor`
    - ``dbConn`` -- the database connection
    - ``waitForResult`` -- wait for the mysql script to finish execution? If 'False' the MySQL scripts run in parallel, at most ``maxParallelScripts`` at a time, and the function returns at once (background threads start each script, wait for it and log any failure, but the success and failure rules are not applied; the interpreter waits for these threads, so program exit blocks until every queued script has finished, and a mysql process that hangs blocks the exit; there is no timeout), or if 'delete' the script will run then delete regardless of success status. Default *True*. [True|False|delete]
    - ``successRule`` -- what to do if script succeeds. Default *None* [None|delete|subFolderName]
    - ``failureRule`` -- what to do if script fails. Default *None* [None|delete|subFolderName]
    - ``maxParallelScripts`` -- the most mysql processes that run at once when ``waitForResult`` is 'False'. The limit applies to each call separately (every call has its own pool), not to the program as a whole. Must be a positive integer; any other value raises a `ValueError` in every mode, even when ``waitForResult`` is not 'False'. Default *8*


    **Return**

    - None


    **Usage**

    To run the scripts in the directroy and not act on the script file use something similar to:

    ```python
    from fundamentals.mysql import directory_script_runner
    directory_script_runner(
        log=log,
        pathToScriptDirectory="/path/to/mysql_scripts",
        databaseName="imports",
        loginPath="myLoginDetails"
    )
    ```

    To delete successful scripts and archive failed scripts for later inspection:

    ```python
    from fundamentals.mysql import directory_script_runner
    directory_script_runner(
        log=log,
        pathToScriptDirectory="/path/to/mysql_scripts",
        databaseName="imports",
        loginPath="myLoginDetails",
        successRule="delete",
        failureRule="failed"
    )
    ```

    This creates a folder at `/path/to/mysql_scripts/failed` and moves the failed scripts into that folder.

    Finally to execute the scripts within a directory in parallel (here four at a time), without applying the success and failure rules (faster, but failures are only logged):

    ```python
    from fundamentals.mysql import directory_script_runner
    directory_script_runner(
        log=log,
        pathToScriptDirectory="/path/to/mysql_scripts",
        databaseName="imports",
        loginPath="myLoginDetails",
        waitForResult=False,
        maxParallelScripts=4
    )
    ```

    Setting ``waitForResult`` = 'delete' will trash the script once it has run (or failed ... be very careful!)

    """
    log.debug("starting the ``directory_script_runner`` function")

    _validate_max_parallel_scripts(maxParallelScripts)

    # COMPILE A DICTIONARY OF SCRIPTS / MODIFIED TIMES
    scriptList = {}
    for d in os.listdir(pathToScriptDirectory):
        filePath = os.path.join(pathToScriptDirectory, d)
        filename = os.path.basename(filePath)
        extension = filePath.split(".")[-1]
        if os.path.isfile(filePath) and extension == "sql":
            modified = datetime.datetime.strptime(
                time.ctime(os.path.getmtime(filePath)), "%a %b %d %H:%M:%S %Y"
            )
            scriptList[str(modified) + filename] = filePath

    # ORDER THE DICTIONARY BY MODIFIED TIME - OLDEST FIRST
    scriptList = collections.OrderedDict(sorted(scriptList.items()))

    # FORCE MYSQL SCRIPT?
    forceArgs = ["--force"] if force else []

    if dbConn:
        for k, v in list(scriptList.items()):
            scriptname = os.path.basename(v)
            exception = execute_mysql_script(pathToScript=v, log=log, dbConn=dbConn)
            # FAILED SCRIPTS
            if exception:
                log.error(
                    'The script %(scriptname)s failed with the following exception: "%(exception)s"'
                    % locals()
                )
                rule = failureRule
                print(exception)
            else:
                rule = successRule
            _process_script_file(
                pathToScriptDirectory=pathToScriptDirectory,
                scriptname=scriptname,
                rule=rule,
                log=log,
            )
    else:
        # "--" ENDS OPTION PARSING SO A DATABASE NAME CANNOT BE READ AS A MYSQL OPTION
        mysqlCmd = [
            "mysql",
            "--login-path=%s" % (loginPath,),
            *forceArgs,
            "--",
            databaseName,
        ]
        mysqlEnv = _mysql_environment()
        isWaiting = waitForResult == True
        isDelete = waitForResult == "delete"
        if not (isWaiting or isDelete):
            _start_background_scripts(
                scriptPaths=list(scriptList.values()),
                mysqlCmd=mysqlCmd,
                mysqlEnv=mysqlEnv,
                maxParallelScripts=maxParallelScripts,
                log=log,
            )
            log.debug("completed the ``directory_script_runner`` function")
            return None

        for k, v in list(scriptList.items()):
            scriptname = os.path.basename(v)
            try:
                with open(v, "rb") as scriptFile:
                    p = Popen(
                        mysqlCmd,
                        stdin=scriptFile,
                        stdout=DEVNULL,
                        stderr=PIPE,
                        close_fds=True,
                        env=mysqlEnv,
                    )
                    # WAIT SO MYSQL HAS READ THE SCRIPT BEFORE IT IS PROCESSED
                    stderr = p.communicate()[1]
            except OSError as e:
                # MISSING MYSQL BINARY OR UNREADABLE SCRIPT
                log.error("MySQL Script `%s` could not be run: '%s'" % (scriptname, e))
                if isWaiting:
                    _process_script_file(
                        pathToScriptDirectory=pathToScriptDirectory,
                        scriptname=scriptname,
                        rule=failureRule,
                        log=log,
                    )
                continue

            if isDelete:
                if p.returncode:
                    log.error(
                        "MySQL Script `%s` failed with return code %s and was deleted: '%s'"
                        % (scriptname, p.returncode, stderr)
                    )
                os.remove(v)
            elif isWaiting:
                # A NON-ZERO RETURN CODE IS A FAILURE EVEN WHEN STDERR IS EMPTY
                if p.returncode or len(stderr):
                    log.error(
                        "MySQL Script `%s` Failed with return code %s: '%s'"
                        % (scriptname, p.returncode, stderr)
                    )
                    rule = failureRule
                else:
                    rule = successRule
                _process_script_file(
                    pathToScriptDirectory=pathToScriptDirectory,
                    scriptname=scriptname,
                    rule=rule,
                    log=log,
                )

    log.debug("completed the ``directory_script_runner`` function")
    return None


def _validate_max_parallel_scripts(maxParallelScripts):
    """*raise a ValueError unless the process limit is a positive integer*

    **Key Arguments:**

    - ``maxParallelScripts`` -- the value to check
    """
    isInteger = isinstance(maxParallelScripts, int) and not isinstance(
        maxParallelScripts, bool
    )
    if not isInteger or maxParallelScripts < 1:
        raise ValueError(
            "maxParallelScripts must be a positive integer, got %r"
            % (maxParallelScripts,)
        )
    return None


def _start_background_scripts(scriptPaths, mysqlCmd, mysqlEnv, maxParallelScripts, log):
    """*run the scripts on worker threads, so no more than ``maxParallelScripts`` mysql processes run at once*

    Returns as soon as the workers have started. Each worker takes the next script (oldest first), runs it and waits for it to finish before taking another, so every process is reaped and the caller is never kept waiting. The workers are not daemon threads, so program exit blocks until every queued script has finished. A mysql process that hangs therefore blocks the exit, and there is no timeout.

    **Key Arguments:**

    - ``scriptPaths`` -- the paths of the scripts to run, in the order to start them
    - ``mysqlCmd`` -- the mysql command (list of arguments)
    - ``mysqlEnv`` -- the environment to give the mysql processes
    - ``maxParallelScripts`` -- the most mysql processes to run at once
    - ``log`` -- logger
    """
    pendingScripts = queue.SimpleQueue()
    for scriptPath in scriptPaths:
        pendingScripts.put(scriptPath)

    queuedCount = len(scriptPaths) - maxParallelScripts
    if queuedCount > 0:
        log.info(
            "%s %s queued behind the limit of %s parallel mysql scripts"
            % (
                queuedCount,
                "script" if queuedCount == 1 else "scripts",
                maxParallelScripts,
            )
        )

    for _ in range(min(maxParallelScripts, len(scriptPaths))):
        threading.Thread(
            target=_run_pending_scripts,
            args=(pendingScripts, mysqlCmd, mysqlEnv, log),
        ).start()
    return None


def _run_pending_scripts(pendingScripts, mysqlCmd, mysqlEnv, log):
    """*run queued scripts one after another until none are left*

    **Key Arguments:**

    - ``pendingScripts`` -- queue of script paths shared by the workers
    - ``mysqlCmd`` -- the mysql command (list of arguments)
    - ``mysqlEnv`` -- the environment to give the mysql processes
    - ``log`` -- logger
    """
    while True:
        try:
            scriptPath = pendingScripts.get_nowait()
        except queue.Empty:
            return None
        scriptname = os.path.basename(scriptPath)
        try:
            _run_background_script(scriptPath, mysqlCmd, mysqlEnv, log)
        except OSError as e:
            # MISSING MYSQL BINARY OR UNREADABLE SCRIPT
            log.error("MySQL Script `%s` could not be run: '%s'" % (scriptname, e))
        except Exception:
            log.exception("MySQL Script `%s` could not be run" % (scriptname,))


def _run_background_script(scriptPath, mysqlCmd, mysqlEnv, log):
    """*run one script through mysql, wait for the process and log a failure*

    The stderr temp file is read, then closed (which deletes it). A temp file cannot fill up and stall a process nobody is reading yet. Only the last ``MAX_LOGGED_STDERR_BYTES`` of stderr are logged. If waiting fails, a process that is still running is killed and reaped.

    **Key Arguments:**

    - ``scriptPath`` -- path to the sql script
    - ``mysqlCmd`` -- the mysql command (list of arguments)
    - ``mysqlEnv`` -- the environment to give the mysql process
    - ``log`` -- logger
    """
    with open(scriptPath, "rb") as scriptFile, tempfile.TemporaryFile() as stderrFile:
        p = Popen(
            mysqlCmd,
            stdin=scriptFile,
            stdout=DEVNULL,
            stderr=stderrFile,
            close_fds=True,
            env=mysqlEnv,
        )
        try:
            p.wait()
        finally:
            if p.poll() is None:
                _kill_and_reap(p, os.path.basename(scriptPath), log)
        stderr = _read_stderr_tail(stderrFile)
    if p.returncode:
        log.error(
            "MySQL Script `%s` failed with return code %s: '%s'"
            % (os.path.basename(scriptPath), p.returncode, stderr)
        )
    return None


def _kill_and_reap(p, scriptname, log):
    """*kill a mysql process and wait for it, logging (not raising) any OS error*

    Used while another exception is in flight, so an error here must not replace it.

    **Key Arguments:**

    - ``p`` -- the running Popen process
    - ``scriptname`` -- name of the script the process is running, for the log
    - ``log`` -- logger
    """
    try:
        p.kill()
        p.wait()
    except OSError as e:
        log.warning(
            "MySQL Script `%s` process could not be killed and reaped: '%s'"
            % (scriptname, e)
        )
    return None


def _read_stderr_tail(stderrFile):
    """*return the last ``MAX_LOGGED_STDERR_BYTES`` of a stderr file as text*

    **Key Arguments:**

    - ``stderrFile`` -- the open stderr temp file

    **Return:**

    - `stderr` -- the decoded text (undecodable bytes are replaced)
    """
    size = stderrFile.seek(0, os.SEEK_END)
    stderrFile.seek(max(0, size - MAX_LOGGED_STDERR_BYTES))
    return stderrFile.read().decode("utf-8", errors="replace")


def _mysql_environment():
    """*return a copy of the current environment extended with the paths the mysql client needs*

    **Return:**

    - `env` -- the environment dictionary to pass to the mysql subprocess
    """
    env = os.environ.copy()
    extraPaths = "/usr/local/bin:/usr/bin:/usr/local/mysql/bin"
    currentPath = env.get("PATH")
    env["PATH"] = currentPath + ":" + extraPaths if currentPath else extraPaths
    env["MYSQL_TEST_LOGIN_FILE"] = os.path.join(os.path.expanduser("~"), ".mylogin.cnf")
    return env


def execute_mysql_script(pathToScript, dbConn, log):
    """*execute a mysql script given its file path and return the success or failure status of the execution*

    **Key Arguments:**

    - `pathToScript` -- path to the sql script to be executed
    - `dbConn` -- mysql database connection
    - `log` -- logger

    **Return:**

    - `exception` -- None or the exception thrown during execution of the sql script.

    **Usage:**

    To execute a mysql script file located on your local file system:

    ```python
    from fundamentals.mysql import execute_mysql_script
    exception = execute_mysql_script(
        pathToScript="/path/to/my/script.sql",
        log=log,
        dbConn=dbConn
    )

    if exception:
        ...
    ```
    """
    log.debug("starting the ``execute_mysql_script`` function")

    from fundamentals.mysql import writequery

    pathToScript = pathToScript.replace("//", "/")

    import codecs

    pathToReadFile = pathToScript
    try:
        log.debug("attempting to open the file %s" % (pathToReadFile,))
        with codecs.open(pathToReadFile, encoding="utf-8", mode="r") as readFile:
            thisData = readFile.read()
    except IOError as e:
        message = "could not open the file %s" % (pathToReadFile,)
        log.critical(message)
        raise IOError(message) from e

    thisData = thisData.replace(";;", ";").replace("DELIMITER ;", "")

    # EXECUTE AND RETURN NONE IF SUCCESSFUL OR THE EXCEPTION IF NOT
    try:
        writequery(log=log, sqlQuery=thisData, dbConn=dbConn)
    except Exception as e:
        log.debug("completed the ``execute_mysql_script`` function - failure")
        return e

    log.debug("completed the ``execute_mysql_script`` function - successful")
    return None


def _process_script_file(pathToScriptDirectory, scriptname, rule, log):
    """*summary of function*

    **Key Arguments:**

    - `pathToScriptDirectory` -- the path to the directory containing the sql scripts
    - `scriptname` -- name to the sql script to be executed
    - `rule` -- how to process the script. Default *None* [None|delete|subFolderName]
    - `log` -- logger

    **Usage:**

    :::{todo}
            add usage info
            create a sublime snippet for usage
    :::

    ```python
    usage code
    ```
    """
    log.debug("starting the ``_process_script_file`` function")

    scriptPath = pathToScriptDirectory + "/" + scriptname

    if rule == None or rule == False:
        pass
    elif rule == "delete":
        os.remove(scriptPath)
    elif "/" not in rule:
        moveTo = pathToScriptDirectory + "/" + rule
        # Recursively create missing directories
        if not os.path.exists(moveTo):
            os.makedirs(moveTo)
        moveTo = moveTo + "/" + scriptname
        try:
            log.debug("attempting to rename file %s to %s" % (scriptPath, moveTo))
            os.rename(scriptPath, moveTo)
        except Exception as e:
            log.error(
                "could not rename file %s to %s - failed with this error: %s "
                % (
                    scriptPath,
                    moveTo,
                    str(e),
                )
            )

    log.debug("completed the ``_process_script_file`` function")
    return None


# use the tab-trigger below for new function
# xt-def-function


def main(arguments=None):
    """
    The main function used when ``directory_script_runner.py`` is run as a single script from the cl, or when installed as a cl command
    """

    # setup the command-line util settings
    su = tools(
        arguments=arguments,
        docString=__doc__,
        logLevel="WARNING",
        options_first=False,
        projectName="fundmentals",
    )
    arguments, settings, log, dbConn = su.setup()

    pathToDirectory = arguments["<pathToDirectory>"]
    loginPath = arguments["<loginPath>"]
    databaseName = arguments["<databaseName>"]
    successFlag = arguments["--success"]
    failureFlag = arguments["--failure"]

    if successFlag and successFlag.lower() == "none":
        successFlag = None
    if failureFlag and failureFlag.lower() == "none":
        failureFlag = None

    directory_script_runner(
        log=log,
        pathToScriptDirectory=pathToDirectory,
        databaseName=databaseName,
        loginPath=loginPath,
        successRule=successFlag,
        failureRule=failureFlag,
    )

    return


if __name__ == "__main__":
    main()
