Tutorial
========

The most useful class of the fundamentals package is `fundamentals.tools`. The tools object, when added to the `__main__` function of your cl-utils module, will do a lot of heavy lifting to set you up with some useful project tools. These include a logger, a default settings file and abilities to setup database connections and ssh tunnels.

For example, I can have a `cl-utils.py` module living at the root of my python package with the following content:

```python
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
        if isinstance(val, str):
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
```

And within `setup.py` I will include:

``` python
entry_points={
    'console_scripts': ['myProjectCommand=myProject.cl_utils:main'],
}
```

And finally I also have a `default-settings.yaml` file at the root of my
python package with the content:

``` yaml
version: 1
database settings:
    db: unit_tests
    host: localhost
    user: utuser
    password: utpass
    sshPort: False
    loginPath: unittesting

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
```

Once the package is installed, from the terminal I can now run:

``` bash
myProjectCommand
```

The first time this command is run (no arguments), a dedicated project
directory is setup at `~/.config/myProject/`. The
`default-settings.yaml` file is copied to
`~/.config/myProject/myProject.yaml` and a log file created at
`~/.config/myProject/myProject.log`. Subsequent running of this command
will read the settings from `~/.config/myProject/myProject.yaml`, so any
changes made to this file will be seen by the command. It's also
possible to pass in alternate settings by running the command with the
<span class="title-ref">-s</span> flag:

``` bash
myProjectCommand -s /path/to/different-settings.yaml
```

I now have the following objects I can pass to the rest of my package:

-   `settings` -- a dictionary of all the settings read from the yaml
    config file
-   `log` -- a logger setup with the settings found in the yaml config
    file
-   `dbConn` -- a database connect setup with the settings found in the
    yaml config file

<div class="note" markdown="1">

<div class="admonition-title" markdown="1">

Note

</div>

There are other usful trinkets within the code - read the docs to find
out how to use them.

</div>

Command-Line Tools
==================

mysqlSucker
-----------

Given a directory of MySQL scripts, <span
class="title-ref">mysqlSucker</span> can execute the script files and
process them according to their success or failure status.

Before you begin you will need to run the following code once to set a
login-path for your mysql server:

``` bash
mysql_config_editor set --login-path=<uniqueLoginName> --host=localhost --user=<myUsername> --password
```

This stores your credentials in an encrypted file located at
'\~/.mylogin.cnf'. Use <span class="title-ref">mysql\_config\_editor
print --all</span> to see all of the login-paths set.

### Usage

``` bash
Usage:
    mysqlSucker <pathToDirectory> <loginPath> <databaseName> [-s successRule -f failureRule]

    pathToDirectory       path to the directory containing the sql scripts to run (scripts must have `.sql` extension)
    loginPath             the local-path as set with `mysql_config_editor` (`mysqlSucker -h` for more details)
    databaseName          the name of the database to execute the scripts within

Options:
    -h, --help                                  show this help message
    -s successRule, --success successRule       what to do if script succeeds. Default *None* [None|delete|subFolderName]
    -f failureRule, --failure failureRule       what to do if script fails. Default *None* [None|delete|subFolderName]
```

### Examples

To simply execute the scripts in a directory run:

``` bash
mysqlSucker /path/to/scriptdir myLoginPath myDatabaseName
```

To delete script after thay have executed successfully:

``` bash
mysqlSucker /path/to/scriptdir myLoginPath myDatabaseName -s delete
```

To move successful script to a <span class="title-ref">passed</span>
sub-directory of <span class="title-ref">/path/to/scriptdir</span> and
failed scripts to a <span class="title-ref">failed</span> sub-directory

``` bash
mysqlSucker /path/to/scriptdir myLoginPath myDatabaseName -s pass -f failed
```

yaml2db
-------

You may be thinking why would you ever need to dump the contents of a
yaml file into a database. Well ... [IFTTT](https://ifttt.com)! With the
IFTTT service you have quick and super easy access to the APIs of dozens
of your favourite web-services. You can use any of the IFTTT channels as
an input for an applet that then writes a yaml file with the data you
wish to capture to a directory in your Dropbox account. Pointing
`yaml2db` at this Dropbox directory in your filesystem then sucks all
this lovely data into a MySQL database. It's up to you then what you
want to do with the data, the point is you now have a simple,
homogenised way of pouring content from all those APIs into a local
database.

You could grab the URLs for videos you ‘like’ on youtube or add to your
watch-later list on vimeo. Or how about your sleep log from your fitbit,
or a new contact added to your iOS device.

How about [this applet](https://ifttt.com/applets/30164914d) that logs
URLs moved into my instapaper *read-work-projects* folder:

<img src="https://i.imgur.com/oDSgBhQ.png" alt="image" width="400" />

So how does it work? `yaml2db` will take either a path to a single yaml
file or to an entire directory of yaml files, parse the contents of
those files and add the key-values to a mysql database. Here's the
usages statement (printed by typing `yaml2db -h` from a terminal
window):

``` bash
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
```

The yaml files require a `table` value to indicate the name of the
database table (or tables; comma-separated) to add the yaml key-values
to. If the database tables do not exist, `yaml2db` will create them for
you. Here's an example of the content of a yaml file:

``` yaml
title: Why you should do most of your text editing in : Sublime Text | Sublime Text Tips
url: http://sublimetexttips.com/why-you-should-do-most-of-your-text-editing-in-sublime-text/?utm_source=drip&utm_medium=email&utm_campaign=editor-proliferation
kind: webpage
subtype: article
table: web_articles,podcasts 
```

`yaml2db` will take the content of this file and add it to both a
`web_articles` and `podcasts` table.

<img src="https://i.imgur.com/sfPUfNj.png" alt="image" width="1200" />

To execute `yaml2db` on a single yaml file run:

``` bash
yaml2db -d --host=localhost --user=username --passwd=mypassword --dbName=myGreatDatabase /Users/Me/yaml/20161219105124.yaml 
```

Obviously replace the database parameters with your own. The `-d` flag
indicates that you want to delete the yaml file once it's been parsed.

To run `yaml2db` on an entire directory of yaml files run:

``` bash
yaml2db -s /Users/Me/mydefault_settings.yaml /Users/Me/yaml/
```

where `/Users/Me/mydefault_settings.yaml` contains my database and
logging parameters (see example at the start of this tutorial).

sqlite2mysql
------------

The `sqlite2mysql` tool does exactly what you would expect it to do; it
takes the path to a sqlite database file and copies the tables found in
the database to a MySQL database of your choosing.

For the usage run `sqlite2mysql -h` from the command-line:

``` bash
Take a sqlite database file and copy the tables within it to a MySQL database

Usage:
    sqlite2mysql -s <pathToSettingsFile> <pathToSqliteDB> [<tablePrefix>]

Options:

    pathToSqliteDB        path to the sqlite database file
    tablePrefix           a string to prefix the table names when copying to mysql database
    pathToSettingsFile    path to a settings file with logging and database information (yaml file)

    -h, --help            show this help message
    -v, --version         show version
    -s, --settings        the settings file
```

As usual `pathToSettingsFile` contains your MySQL database settings (see
example at the start of this tutorial). To convert a sqlite databse I
could run something like:

``` bash
sqlite2mysql -s /Users/Me/mydefault_settings.yaml /Users/Me/ebooks.sqlite imported
```

This command takes the tables in the `/Users/Me/ebooks.sqlite` database,
prepends the names of the tables with *'imported\_'* and imports the
tables into the MySQL database whose settings are found in the
`/Users/Me/mydefault_settings.yaml` file. Here are the resulting MySQL
database tables as listed in MySQLWorkbench:

<img src="https://i.imgur.com/0UJ9eDH.png" alt="imported tables in MySQL database" width="800" />
