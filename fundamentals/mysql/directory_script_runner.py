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

:Author:
    David Young
"""
from builtins import str
import sys
import os
import time
import collections
import datetime
from subprocess import Popen, PIPE, STDOUT
os.environ['TERM'] = 'vt100'
from fundamentals import tools


def directory_script_runner(
        log,
        pathToScriptDirectory,
        dbConn=False,
        waitForResult=True,
        successRule=None,
        failureRule=None,
        loginPath=False,
        databaseName=False,
        force=True):
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
    - ``waitForResult`` -- wait for the mysql script to finish execution? If 'False' the MySQL script will run in background (do not wait for completion), or if 'delete' the script will run then delete regardless of success status. Default *True*. [True|False|delete]
    - ``successRule`` -- what to do if script succeeds. Default *None* [None|delete|subFolderName]
    - ``failureRule`` -- what to do if script fails. Default *None* [None|delete|subFolderName]


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

    Finally to execute the scripts within a directory but not wait for the results to return (much fast but you lose error checking in the MySQL scripts):

    ```python
    from fundamentals.mysql import directory_script_runner
    directory_script_runner(
        log=log,
        pathToScriptDirectory="/path/to/mysql_scripts",
        databaseName="imports",
        loginPath="myLoginDetails",
        waitForResults=False
    )
    ```

    Setting ``waitForResults`` = 'delete' will trash the script once it has run (or failed ... be very careful!)

    """
    log.debug('starting the ``directory_script_runner`` function')

    # COMPILE A DICTIONARY OF SCRIPTS / MODIFIED TIMES
    scriptList = {}
    for d in os.listdir(pathToScriptDirectory):
        filePath = os.path.join(pathToScriptDirectory, d)
        filename = os.path.basename(filePath)
        extension = filePath.split(".")[-1]
        if os.path.isfile(filePath) and extension == "sql":
            modified = datetime.datetime.strptime(time.ctime(
                os.path.getmtime(filePath)), "%a %b %d %H:%M:%S %Y")
            scriptList[str(modified) + filename] = filePath

    # ORDER THE DICTIONARY BY MODIFIED TIME - OLDEST FIRST
    scriptList = collections.OrderedDict(sorted(scriptList.items()))

    # FORCE MYSQL SCRIPT?
    if force:
        force = "--force"
    else:
        force = ""

    if dbConn:
        for k, v in list(scriptList.items()):
            scriptname = os.path.basename(v)
            exception = execute_mysql_script(
                pathToScript=v,
                log=log,
                dbConn=dbConn
            )
            # FAILED SCRIPTS
            if exception:
                log.error(
                    'The script %(scriptname)s failed with the following exception: "%(exception)s"' % locals())
                rule = failureRule
                print(exception)
            else:
                rule = successRule
            _process_script_file(
                pathToScriptDirectory=pathToScriptDirectory,
                scriptname=scriptname,
                rule=rule,
                log=log)
    else:
        for k, v in list(scriptList.items()):
            scriptname = os.path.basename(v)
            if waitForResult == True:
                cmd =  """mysql --login-path=%(loginPath)s %(force)s %(databaseName)s < "%(v)s" """ % locals(
                )
                p = Popen(cmd, stdout=PIPE, stderr=PIPE, close_fds=True,
                          env={'PATH': os.getenv('PATH') + ":/usr/local/bin:/usr/bin:/usr/bin:/usr/local/mysql/bin", "MYSQL_TEST_LOGIN_FILE": os.getenv('HOME') + "/.mylogin.cnf"}, shell=True)
                stdout, stderr = p.communicate()

                if len(stderr):
                    log.error(
                        "MySQL Script `%(scriptname)s` Failed: '%(stderr)s'" % locals())
                    rule = failureRule
                else:
                    rule = successRule
                _process_script_file(
                    pathToScriptDirectory=pathToScriptDirectory,
                    scriptname=scriptname,
                    rule=rule,
                    log=log)
            else:
                if waitForResult == "delete":
                    cmd =  """mysql --login-path=%(loginPath)s %(force)s  %(databaseName)s < "%(v)s" > /dev/null 2>&1 & rm "%(v)s" """ % locals()
                else:
                    cmd =  """mysql --login-path=%(loginPath)s %(force)s  %(databaseName)s < "%(v)s" > /dev/null 2>&1 """ % locals()
                p = Popen(cmd, close_fds=True,
                          env={'PATH': os.getenv('PATH') + ":/usr/local/bin:/usr/bin:", "MYSQL_TEST_LOGIN_FILE": os.getenv('HOME') + "/.mylogin.cnf"}, shell=True, stdin=None, stdout=None, stderr=None)

    log.debug('completed the ``directory_script_runner`` function')
    return None


def execute_mysql_script(
        pathToScript,
        dbConn,
        log):
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
    log.debug('starting the ``execute_mysql_script`` function')

    from fundamentals.mysql import writequery

    pathToScript = pathToScript.replace("//", "/")

    import codecs
    pathToReadFile = pathToScript
    try:
        log.debug("attempting to open the file %s" % (pathToReadFile,))
        readFile = codecs.open(pathToReadFile, encoding='utf-8', mode='r')
        thisData = readFile.read()
        readFile.close()
    except IOError as e:
        message = 'could not open the file %s' % (pathToReadFile,)
        log.critical(message)
        raise IOError(message)

    thisData = thisData.replace(";;", ";").replace("DELIMITER ;", "")

    # EXECUTE AND RETURN NONE IF SUCCESSFUL OR THE EXCEPTION IF NOT
    try:
        writequery(
            log=log,
            sqlQuery=thisData,
            dbConn=dbConn
        )
    except Exception as e:
        log.debug('completed the ``execute_mysql_script`` function - failure')
        return e

    log.debug('completed the ``execute_mysql_script`` function - successful')
    return None


def _process_script_file(
        pathToScriptDirectory,
        scriptname,
        rule,
        log):
    """*summary of function*

    **Key Arguments:**

    - `pathToScriptDirectory` -- the path to the directory containing the sql scripts
    - `scriptname` -- name to the sql script to be executed
    - `rule` -- how to process the script. Default *None* [None|delete|subFolderName]
    - `log` -- logger

    **Usage:**

    ```eval_rst
    .. todo::

            add usage info
            create a sublime snippet for usage
    ```

    ```python
    usage code 
    ```           
    """
    log.debug('starting the ``_process_script_file`` function')

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
            log.debug("attempting to rename file %s to %s" %
                      (scriptPath, moveTo))
            os.rename(scriptPath, moveTo)
        except Exception as e:
            log.error(
                "could not rename file %s to %s - failed with this error: %s " % (scriptPath, moveTo, str(e),))

    log.debug('completed the ``_process_script_file`` function')
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
        projectName="fundmentals"
    )
    arguments, settings, log, dbConn = su.setup()

    # UNPACK REMAINING CL ARGUMENTS USING `EXEC` TO SETUP THE VARIABLE NAMES
    # AUTOMATICALLY
    for arg, val in list(arguments.items()):
        if arg[0] == "-":
            varname = arg.replace("-", "") + "Flag"
        else:
            varname = arg.replace("<", "").replace(">", "")
        if isinstance(val, ("".__class__, u"".__class__)):
            exec(varname + " = '%s'" % (val,))
        else:
            exec(varname + " = %s" % (val,))
        if arg == "--dbConn":
            dbConn = val
        log.debug('%s = %s' % (varname, val,))

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
        failureRule=failureFlag
    )

    return

if __name__ == '__main__':
    main()
