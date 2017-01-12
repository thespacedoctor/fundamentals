Tutorial
========

The most useful class of the fundamentals package is
:class:`fundamentals.tools`. The tools object, when added to the
``__main__`` function of your cl-utils module, will do a lot of heavy
lifting to set you up with some useful project tools. These include a
logger, a default settings file and abilities to setup database
connections and ssh tunnels.

For example, I can have a `cl-utils.py` module living at the root of my python package with the following content:


.. code-block:: python 
    
    #!/usr/local/bin/python
    # encoding: utf-8
    """
    *CL utils for myProject*

    Usage:
        myProjectCommand [-s <pathToSettingsFile>]

        -h, --help            show this help message
        -s, --settings        the settings file
    """
    ################# GLOBAL IMPORTS ####################
    import sys
    import os
    os.environ['TERM'] = 'vt100'
    import glob
    from docopt import docopt
    from fundamentals import tools, times


    def main(arguments=None):
        """
        *The main function used when ``cl_utils.py`` is run as a single script from the cl, or when installed as a cl command*
        """
        # SETUP THE COMMAND-LINE UTIL SETTINGS
        su = tools(
            arguments=arguments,
            docString=__doc__,
            logLevel="DEBUG",
            options_first=False,
            projectName="myProject"
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

        ## START LOGGING ##
        startTime = times.get_now_sql_datetime()
        log.info(
            '--- STARTING TO RUN THE cl_utils.py AT %s' %
            (startTime,))

        #########
        # DO STUFF HERE!
        #########

        if "dbConn" in locals() and dbConn:
            dbConn.commit()
            dbConn.close()
        ## FINISH LOGGING ##
        endTime = times.get_now_sql_datetime()
        runningTime = times.calculate_time_difference(startTime, endTime)
        log.info('-- FINISHED ATTEMPT TO RUN THE cl_utils.py AT %s (RUNTIME: %s) --' %
                 (endTime, runningTime, ))

        return

    if __name__ == '__main__':
        main()
 

And within ``setup.py`` I will include:

.. code-block:: python 
    
    entry_points={
        'console_scripts': ['myProjectCommand=myProject.cl_utils:main'],
    }

And finally I also have a ``default-settings.yaml`` file at the root of my python package with the content:

.. code-block:: yaml 
    
    version: 1
    database settings:
        db: dryx_unit_testing
        host: localhost
        user: unittesting
        password: utpass
        sshPort: False

    # SSH TUNNEL - if a tunnel is required to connect to the database(s) then add setup here
    # Note only one tunnel is setup - may need to change this to 2 tunnels in the future if 
    # code, static catalogue database and transient database are all on seperate machines.
    ssh tunnel:
        use tunnel: True   # True | False
        remote user: username
        remote ip: mydomain.co.uk
        remote datbase host: mydatabaseName
        port: 9002

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
                filename: /Users/Dave/.config/myProject/myProject.log
                mode: w+
                maxBytes: 102400
                backupCount: 1
        root:
            level: WARNING
            handlers: [file,console]
 
Once the package is installed, from the terminal I can now run:

.. code-block:: bash 
        
    myProjectCommand

The first time this command is run (no arguments), a dedicated project directory is setup at ``~/.config/myProject/``. The ``default-settings.yaml`` file is copied to ``~/.config/myProject/myProject.yaml`` and a log file created at ``~/.config/myProject/myProject.log``. Subsequent running of this command will read the settings from ``~/.config/myProject/myProject.yaml``, so any changes made to this file will be seen by the command. It's also possible to pass in alternate settings by running the command with the `-s` flag:

.. code-block:: bash 
        
    myProjectCommand -s /path/to/different-settings.yaml

I now have the following objects I can pass to the rest of my package:

- ``settings`` -- a dictionary of all the settings read from the yaml config file
- ``log`` -- a logger setup with the settings found in the yaml config file
- ``dbConn`` -- a database connect setup with the settings found in the yaml config file

.. note:: There are other usful trinkets within the code - read the docs to find out how to use them.

Command-Line Tools
==================

mysqlSucker
-----------

Given a directory of MySQL scripts, `mysqlSucker` can execute the script files and process them according to their success or failure status.

Before you begin you will need to run the following code once to set a login-path for your mysql server:

.. code-block:: bash 

    mysql_config_editor set --login-path=<uniqueLoginName> --host=localhost --user=<myUsername> --password

This stores your credentials in an encrypted file located at '~/.mylogin.cnf'.
Use `mysql_config_editor print --all` to see all of the login-paths set.

Usage
*****

.. code-block:: bash 
     
    Usage:
        mysqlSucker <pathToDirectory> <loginPath> <databaseName> [-s successRule -f failureRule]

        pathToDirectory       path to the directory containing the sql scripts to run (scripts must have `.sql` extension)
        loginPath             the local-path as set with `mysql_config_editor` (`mysqlSucker -h` for more details)
        databaseName          the name of the database to execute the scripts within

    Options:
        -h, --help                                  show this help message
        -s successRule, --success successRule       what to do if script succeeds. Default *None* [None|delete|subFolderName]
        -f failureRule, --failure failureRule       what to do if script fails. Default *None* [None|delete|subFolderName]

Examples
********

To simply execute the scripts in a directory run:

.. code-block:: bash 

    mysqlSucker /path/to/scriptdir myLoginPath myDatabaseName

To delete script after thay have executed successfully:

.. code-block:: bash 

    mysqlSucker /path/to/scriptdir myLoginPath myDatabaseName -s delete

To move successful script to a `passed` sub-directory of `/path/to/scriptdir` and failed scripts to a `failed` sub-directory

.. code-block:: bash 

    mysqlSucker /path/to/scriptdir myLoginPath myDatabaseName -s pass -f failed


yaml2db
-------

``yaml2db`` will take either a path to a single yaml file or to an entire directory of yaml files, parse the contents of those files and add the key-values to a mysql database. Here's the usages statement (printed by typing ``yaml2db -h`` from a terminal window):

.. code-block:: bash 

    Usage:
        yaml2db [-d] -s <pathToSettingsFile> <pathToYaml>
        yaml2db [-d] --host=<host> --user=<user> --passwd=<passwd> --dbName=<dbName> <pathToYaml>

    Options:

        pathToYaml            path to a single yaml file or directory of yaml files
        pathToSettingsFile    path to a settings file with logging and database information (yaml file)
        --host=<host>         the database host
        --user=<user>         database user
        --passwd=<passwd>     database user password
        --dbName=<dbName>     name of the database to add the table content to

        -d, --delete          delete yaml file(s) once added to datbase
        -h, --help            show this help message
        -s, --settings        path to a settings file with logging and database parameters

The yaml files requires a ``table`` value to indicate the name of the database table (or tables; comma-separated) to add the yaml key-values to. If the database tables do not exist, ``yaml2db`` will create them for you. Here's an example of the content of a yaml file:

.. code-block:: yaml 
    
    title: Why you should do most of your text editing in : Sublime Text | Sublime Text Tips
    url: http://sublimetexttips.com/why-you-should-do-most-of-your-text-editing-in-sublime-text/?utm_source=drip&utm_medium=email&utm_campaign=editor-proliferation
    kind: webpage
    subtype: article
    table: web_articles,podcasts 

``yaml2db`` will take the content of this file and it to both a ``web_articles`` and ``podcasts`` table.

.. image:: https://i.imgur.com/sfPUfNj.png
        :width: 1200px

To execute ``yaml2db`` on a single yaml file run:

.. code-block:: bash

    yaml2db -d --host=localhost --user=username --passwd=mypassword --dbName=myGreatDatabase /Users/Me/yaml/20161219105124.yaml 

Obviously replace the database parameters with your own. The ``-d`` flag indicates that you want to delete the yaml file once it's been parsed.

To run ``yaml2db`` on an entire directory of yaml files run:

    yaml2db -s /Users/Me/mydefault_settings.yaml /Users/Me/yaml/

where ``/Users/Me/mydefault_settings.yaml`` contains my database and logging parameters (see example at the start of this tutorial).

So, where would you need to add the content of a yaml file to a database? 


    
    


    

    
