
## Release Notes

**v2.3.9 - November 8, 2021**

* **FIXED:** moved depreciated calls to yaml `load` to `safe_load`

**v2.3.8 - September 29, 2021**

* **ENHANCEMENT:** fundamentals is now on conda-forge

**v2.3.7 - September 27, 2021**

* **ENHANCEMENT:** some speed improvements in multi-downloads

**v2.3.6 - August 16, 2021**

* **FIXED:** no longer crashing for scripts where no settings file is passed in via CL arguments
* **FIXED:** database credentials can now be passed to the command-line again

**v2.3.5 - July 30, 2021**

* **FEATURE:** code bases using fundamentals can now include a 'advanced_settings.yaml' file at the root of the project which will be read before the user settings file. User settings trump settings in this 'advanced\_settings.yaml' file. The purpose is to be able to have hidden/development settings.

**v2.3.4 - March 16, 2021**

* **ENHANCEMENT:** added loop to reattempt timed-out queries (up to 60 times)

**v2.3.2 - February 23, 2021**

* **FIXED:** Logger was being set from default settings file even if a custom settings file given from command line

**v2.3.1 - January 6, 2021**

* **FIXED:** astropy import causing grief with other package installs. Move to with function instead of module level import.

**v2.3.0 - January 1, 2021**

* **FEATURE:** added a stats subpackage with a `rolling_window_sigma_clip` function 

**v2.2.9 - December 3, 2020**

* **FIXED:** relative time reporting (python 2>3ism)

**v2.2.8 - November 12, 2020**

* **fixed:** logging levels

**v2.2.7 - November 10, 2020**

* **fixed:** mysql port connection issue (with MaxScale proxy)

**v2.2.6 - November 9, 2020**

* **fixed:** syntax error

**v2.2.5 - November 2, 2020**

* **enhancement:** adding colour to logs
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
