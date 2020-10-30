
## Release Notes

**v2.2.5 - October 30, 2020**

* **enhancement:** addition of port in database connection settings
* **fixed:** replacing depreciated 'is" syntax with ==

**v2.2.4 - May 28, 2020**

* **enhancement:** allowing '~' as home directory for filepaths in all settings file parameters - will be converted when initially read

**v2.2.3 - May 26, 2020**

* **fixed:** delimiters catered for in sql scripts

**v2.2.2 - May 25, 2020**

* **refactor:** `list_of_dictionaries` now returns bytes decoded into UTF-8 string when rendered to other mark-up flavour.
* **refactor:** moved module level numpy imports so that packages with fundamentals as a dependency do not have numpy as a needless dependency

**v2.2.1 - May 13, 2020**

* **fixed:** `directory_script_runner` function `databaseName` parameter changed to be optional

**v2.2.0 - May 13, 2020**

* **feature:** new `execute_mysql_script` function that allows execution of a sql script directly from file
* **refactor:** added a dbConn to the directory script runner

**v2.1.7 - May 4, 2020**

* **fixed:** inspect module depreciation warnings stopped
* **fixed:** MySQL error messages printed to stdout (previously hidden)

**v2.1.3 - April 17, 2020**

* **enhancement:** cleaned up docs theme and structure. More documentation to come.
