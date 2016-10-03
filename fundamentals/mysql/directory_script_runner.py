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

:Date Created:
    September 22, 2016
"""
################# GLOBAL IMPORTS ####################
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
        databaseName,
        loginPath,
        successRule=None,
        failureRule=None):
    """A function to run all of the mysql scripts in a given directory (in a modified date order, oldest first) and then act on the script file in accordance with the succcess or failure of its execution

    As it's insecure to pass in mysql database credentials via the command-line, run the following command from the terminal 

    .. code-block:: bash

        mysql_config_editor set --login-path=<uniqueLoginName> --host=localhost --user=<myUsername> --password
        > Enter password:

    This will store your credentials in an encrypted file located at '~/.mylogin.cnf'. This function takes advantage of the `--login-path` so as not to compromise the user's credentials. Use `mysql_config_editor print --all` to see all of the login-paths set.

    **Key Arguments:**
        - ``log`` -- logger
        - ``pathToScriptDirectory`` -- the path to the directory containing the sql script to be run
        - ``databaseName`` -- the name of the database 
        - ``loginPath`` -- the local-path as set with `mysql_config_editor`
        - ``successRule`` -- what to do if script succeeds. Default *None* [None|delete|subFolderName]
        - ``failureRule`` -- what to do if script fails. Default *None* [None|delete|subFolderName]

    **Return:**
        - None

    **Usage:**

        To run the scripts in the directroy and not act on the script file use something similar to:

        .. code-block:: python 

            from fundamentals.mysql import directory_script_runner
            directory_script_runner(
                log=log,
                pathToScriptDirectory="/path/to/mysql_scripts",
                databaseName="imports",
                loginPath="myLoginDetails"
            )

        To delete successful scripts and archive failed scripts for later inspection:

        .. code-block:: python 

            from fundamentals.mysql import directory_script_runner
            directory_script_runner(
                log=log,
                pathToScriptDirectory="/path/to/mysql_scripts",
                databaseName="imports",
                loginPath="myLoginDetails",
                successRule="delete",
                failureRule="failed"
            )

        This creates a folder at `/path/to/mysql_scripts/failed` and moves the failed scripts into that folder.
    """
    log.info('starting the ``directory_script_runner`` function')

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
    for k, v in scriptList.iteritems():
        scriptname = os.path.basename(v)
        cmd =  """mysql --login-path=%(loginPath)s %(databaseName)s < "%(v)s" """ % locals(
        )
        p = Popen(cmd, stdout=PIPE, stderr=PIPE, close_fds=True,
                  env={'PATH': os.getenv('PATH') + ":/usr/local/bin:/usr/bin:", "MYSQL_TEST_LOGIN_FILE": os.getenv('HOME') + "/.mylogin.cnf"}, shell=True)
        stdout, stderr = p.communicate()

        if len(stderr):
            log.error(
                "MySQL Script `%(scriptname)s` Failed: '%(stderr)s'" % locals())
            if failureRule == None or failureRule == False:
                pass
            elif failureRule == "delete":
                os.remove(v)
            elif "/" not in failureRule:
                moveTo = pathToScriptDirectory + "/" + failureRule
                # Recursively create missing directories
                if not os.path.exists(moveTo):
                    os.makedirs(moveTo)
                moveTo = moveTo + "/" + scriptname
                try:
                    log.debug("attempting to rename file %s to %s" %
                              (v, moveTo))
                    os.rename(v, moveTo)
                except Exception, e:
                    log.error(
                        "could not rename file %s to %s - failed with this error: %s " % (v, moveTo, str(e),))
        else:
            if successRule == None or successRule == False:
                pass
            elif successRule == "delete":
                os.remove(v)
            elif "/" not in successRule:
                moveTo = pathToScriptDirectory + "/" + successRule
                # Recursively create missing directories
                if not os.path.exists(moveTo):
                    os.makedirs(moveTo)
                moveTo = moveTo + "/" + scriptname
                try:
                    log.debug("attempting to rename file %s to %s" %
                              (v, moveTo))
                    os.rename(v, moveTo)
                except Exception, e:
                    log.error(
                        "could not rename file %s to %s - failed with this error: %s " % (v, moveTo, str(e),))

    log.info('completed the ``directory_script_runner`` function')
    return None


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
        tunnel=False
    )
    arguments, settings, log, dbConn = su.setup()

    # UNPACK REMAINING CL ARGUMENTS USING `EXEC` TO SETUP THE VARIABLE NAMES
    # AUTOMATICALLY
    for arg, val in arguments.iteritems():
        if arg[0] == "-":
            varname = arg.replace("-", "") + "Flag"
        else:
            varname = arg.replace("<", "").replace(">", "")
        if isinstance(val, str) or isinstance(val, unicode):
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
