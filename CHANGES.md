
## Release Notes

**Unreleased**

* **ENHANCEMENT:** `directory_script_runner` background mode (`waitForResult=False`) runs at most `maxParallelScripts` mysql scripts at once (default 8, per call) and still returns at once; scripts queued behind the limit always run, so the program waits for them before it exits, and mysql error output in the log is capped to its last 64 KB (DY-2046)
* **REFACTOR:** the SQL helpers (`sql_identifiers`, `sql_values`, `sql_inserts`) and the MySQL retry loop are now shared modules, and unused imports are removed
* **REFACTOR:** `convert_dictionary_to_mysql_table` is split into small private functions, one for each step (argument checks, table creation, column types, unique keys, insert), with no change in behaviour except that a `uniqueKeyList` that is not a list is now ignored when `returnInsertOnly=True` (DY-2047)
* **DOCS:** the Sphinx build has no warnings or errors: stale autosummary pages are removed, broken docstring code blocks are fixed, the API pages are regenerated, and the examples show the nested tunnel settings (DY-1598)
* **FIXED:** `exec()` on command-line arguments is removed from `tools` and from the `sqlite2mysql`, `mysqlSucker` and `yaml2db` commands, so the commands work again and an argument with a backslash or quote no longer crashes or runs code (DY-2004)
* **FIXED:** `tools` always gets a logger, falling back to a console logger, and reads the settings file and the logger config from the same argument key (DY-2005)
* **FIXED:** SSH tunnels use one shared helper and one settings layout, `database settings: tunnel:` with remote user, ip, host and port; `ssh` starts without a shell, the settings values are validated, the connection check stops as soon as it connects and each check times out after 5 s; a failure raises `tunnel_error` instead of exiting with status 0; the old top-level `ssh tunnel` key is no longer read (DY-2006)
* **FIXED:** the ssh tunnel no longer trusts whatever is already listening on the local port: each run starts its own ssh process, forwards to a unix socket in a private temporary folder, and connects through that socket; `setup_ssh_tunnel` now returns the socket path (pass it to `pymysql.connect(unix_socket=...)`), the `checkHost` argument is removed, the `port` tunnel setting is still accepted but no longer used, and the tunnel is closed if the database connection fails, at normal exit, and is never closed by a forked child (DY-2044)
* **FIXED:** `tools` closes the settings files it opens, and a failure to create the default settings file logs the path and raises `OSError` (DY-2007)
* **FIXED:** `setup_dryx_logging` applies the YAML on every call, defaults to INFO when there is no root level, and raises `ValueError` for an unknown level (DY-2008)
* **FIXED:** dead pickle and shell code is removed from the CLI template; `fundamentals init` still opens the settings file, without a shell (DY-2010)
* **FIXED:** `multiobject_download` adds percent-encoded credentials and applies `longTime`, `indexFilenames` and `resetFilename` when `downloadDirectory` is a list, and a list of the wrong length raises `ValueError`; credentials never appear in logs, including in `extract_filename_from_url` (DY-2015)
* **FIXED:** one failed download no longer aborts a `multiobject_download` batch; results line up with `urlList` with `None` for a failure, partial files are removed, responses and threads are closed, and only network errors are retried (DY-2016)
* **FIXED:** `unicodecsv`, `pymysql`, `multiprocess`, `six`, `numpy` and `pandas` are now declared dependencies, a new `[stats]` extra holds `astropy`, the self-dependency is removed, and `rolling_window_sigma_clip` raises an `ImportError` naming `fundamentals[stats]` when it is missing (DY-2020)
* **FIXED:** `writequery` and `readquery` retry only deadlock (1213) and lock wait timeout (1205), with backoff; "already exists" errors (1050, 1061) are handled at once, other errors raise straight away instead of being retried 60 times, a lost connection is not retried, and a MySQL error with no arguments no longer causes `IndexError` (DY-2022)
* **FIXED:** `table_exists`, `get_database_table_column_names`, `convert_dictionary_to_mysql_table` and `sqlite2mysql` bind values and quote identifiers, closing SQL injection holes; `table_exists` checks only the current database, `get_database_table_column_names` works on empty tables, and the `sqlite2mysql` table prefix is quoted while double quotes inside SQL strings are kept (DY-2024)
* **FIXED:** the LOAD DATA path of `insert_list_of_dictionaries_into_database_tables` honours `replace=False`, cleans up keys like the batch path, quotes names, always closes its connection and uses the caller's logger; the batch path also quotes table and column names (DY-2026)
* **FIXED:** `convert_dictionary_to_mysql_table` writes valid SQL for values ending in "null", values containing " ," and reserved column names; every insert path now turns `None` and `""` into NULL and stores the texts "None" and "null" as text (DY-2027)
* **FIXED:** `sqlite2mysql` requires `dbConn` (it raises `ValueError` without one) and no longer fails when `settings` is left out (DY-2029)
* **FIXED:** `sqlite2mysql` no longer copies foreign-key constraints, which MariaDB rejected with errno 150 (DY-2032)
* **FIXED:** with only a `dbConn`, `insert_list_of_dictionaries_into_database_tables` runs batches serially on that connection instead of sharing it across forked workers (DY-2036)
* **FIXED:** two dictionary keys that map to the same column name raise a `ValueError` that names them (DY-2038)
* **FIXED:** `daemonise status` keeps the pidfile when the daemon belongs to another user (DY-2039)
* **FIXED:** `directory_script_runner` background mode returns at once again, and a background thread waits for the mysql processes and logs failed scripts with their stderr, so finished processes no longer pile up (DY-2040)
* **FIXED:** `_dump_files_to_local_drive` skips missing downloads, keeps writing the other files, and returns the list of paths that failed (DY-2041)
* **FIXED:** `pytest --cov` works again, and the test logging setup no longer turns off existing loggers (DY-2042)
* **TEST:** the MySQL tests create the tables they need (DY-2032)
* **TEST:** test modules no longer set up logging, settings and a MySQL connection when imported; session fixtures in the root `conftest.py` provide `log`, `settings` and one shared `dbConn`, which is rolled back after each test, and a guard test checks that importing the test modules opens no database connection (DY-2045)
* **TEST:** test classes get `log`, `settings`, `dbConn` and the output folder from fixtures (`session_attributes`, `output_dir_attribute`) and test functions take them as arguments, so the `session_names` injection is gone; each test module now gets its output folder as a copy of `input` in the pytest temporary directory (`output_dir`), so two test runs in the same checkout no longer delete each other's files (DY-2049)
* **FIXED:** `directory_script_runner` runs `mysql` without a shell, so script filenames, `loginPath` and `databaseName` can no longer inject shell commands, and `--` now comes before the database name; delete mode waits for `mysql` to finish before removing each script and logs an error on failure; wait mode treats a non-zero exit as a failure; a missing `mysql` binary or unreadable script is logged and counts as a failure; it keeps the caller's environment and no longer crashes when `PATH` or `HOME` is unset (DY-2031)
* **FIXED:** the `yaml_to_database` URL lookup has a 10 s timeout, follows only http/https, checks every redirect hop, and refuses private, loopback, link-local and other non-public addresses, URLs with credentials, and non-ASCII hostnames; it ignores proxy environment variables, keeps the original URL and logs a warning when the lookup fails, and no longer turns off urllib3 warnings for the whole process (DY-2030)
* **FIXED:** `convert_dictionary_to_mysql_table` no longer changes the caller's `dictionary` or `uniqueKeyList`, raises when the column check or an `ALTER TABLE` add-column fails, and accepts mixed-type keys (DY-2028)
* **FIXED:** `insert_list_of_dictionaries_into_database_tables` no longer raises `IndexError` when the row count leaves an empty last batch; keys with spaces or `-` work, rows with different keys are filled with NULL, write errors raise instead of being lost, the fallback inserts each row with its own columns, and the caller's autocommit setting is restored (DY-2025)
* **FIXED:** `writequery` and `readquery` raise the original exception instead of calling `sys.exit(0)`, always close the cursor, change the warnings filter only during the call, and no longer raise `IndexError` on an empty query; a failed `cursor.close()` is logged, not retried for 10 s (DY-2021)
* **FIXED:** `setup_database_connection` raises the real connection error, not `UnboundLocalError`, and a missing, malformed or non-dictionary settings file raises `OSError`, `yaml.YAMLError` or `ValueError` instead of exiting with status 1 (DY-2023)
* **FIXED:** the `list_of_dictionaries` renderer takes columns from every row, not just the first; `json()` handles `Decimal` (as a string) and `date`; `|--` inside data cells is no longer changed; `bytes` cells are decoded; the yaml and mysql writers write UTF-8 (DY-2019)
* **FIXED:** `download._fetch` retries on a timeout (Errno 60), makes exactly 10 attempts, and returns `(None, None)` when they run out instead of raising `UnboundLocalError` (DY-2011)
* **FIXED:** `daemonise` keeps the pidfile when the daemon runs as another user (`PermissionError`) or a stop fails for any reason other than the process being gone, and `restart` logs its own name (DY-2009)
* **FIXED:** `logs` merges the duplicate `GroupWriteRotatingFileHandler` so the rollover permission fix runs; log files are now created and rolled over as 0664 (group can write, others can only read) instead of world-writable 0666 (DY-2003)
* **FIXED:** `rolling_window_sigma_clip` returns a mask the same length as the input array, including when the array is exactly one window long; an even `windowSize` now raises `ValueError` (DY-2013)
* **FIXED:** `fileChunker` closes its file when reading ends, and adds `close()` and `with` support (DY-2018)
* **FIXED:** `append_now_datestamp_to_filename` puts the datestamp before the last extension (`a.tar.gz` gives `a.tar_<stamp>.gz`) and no longer adds `.xhtml` to a name with no extension; a filename that is not a string raises `TypeError` (DY-2014)
* **FIXED:** `recursive_directory_listing` no longer hangs on an unreadable subfolder or loops on a symlink to a parent folder; it now lists with `os.walk`, so the order changes (each folder's subfolders, then its files, depth first), and an invalid `whatToList` raises `ValueError` instead of calling `sys.exit(0)` (DY-2012)
* **FIXED:** `extract_filename_from_url` takes the filename from the URL path only, so a query string or fragment no longer ends up in the name; a URL with no path now gives `untitled.html` (DY-2017)
* **FIXED:** `tag` and the `LOAD DATA` path of `insert_list_of_dictionaries_into_database_tables` now write their scratch files to a private temporary folder that is removed afterwards, even on error, instead of leaving files in `/tmp`; `sqlite2mysql` no longer creates an unused `/tmp/headjack/` folder
* **FIXED:** `fmultiprocess` now terminates and joins its worker pool when a task raises, the timeout is reached or the call is interrupted with Ctrl-C, instead of leaving workers running (DY-1701)
* **FIXED:** removed the unused `docs/requirements.txt`, which pinned vulnerable docs packages (mistune, Jinja2, Markdown) and raised 16 Dependabot alerts
* **FIXED:** `datetime_relative_to_now` now reports minutes correctly; everything under an hour used to show `+0min`
* **FIXED:** `emptyLogger` methods now accept format arguments and keyword arguments such as `exc_info`
* **FIXED:** the `list_of_dictionaries` file writers (csv, table, reST, markdown, json, yaml, mysql) no longer crash when given a filename without a folder
* **FIXED:** `tools.ordered_load` (used by `orderedSettings=True`) works again and now uses the safe YAML loader
* **FIXED:** `yaml_to_database` no longer crashes on an empty value
* **FIXED:** `download._fetch` no longer imports the undeclared `eventlet` package, which made every call fail when it was not installed

**v2.8.3 - May 21, 2026**

* **FIXED:** removing pyreadline3 dependency

**v2.8.2 - May 20, 2026**

* **FIXED:** fixing readline import issues on windows 

**v2.8.1 - May 20, 2026**

* **FIXED:** adding `tqdm` to the conda requirements

**v2.8.0 - May 20, 2026**

* **ENHANCEMENT:** adding github actions for automatic release
* **REFACTOR:** updating readthedocs settings
* **REFACTOR:** upgrading to `pyproject.toml` from `setup.py`
* **DOCS**: updating docs to use furo theme

**v2.7.8 - November 3, 2025**

* **REFACTOR:** adding some db.commits()

**v2.7.7 - October 2, 2025**

* **REFACTOR:** updates to multiprocessing code

**v2.7.6 - September 25, 2025**

* **FIXED:** adding tqdm to setup

**v2.7.5 - September 22, 2025**

* **FIXED:** small fix to writing mysql tables to tmp tables with multiprocessing

**v2.7.4 - September 3, 2025**

* **FIXED:** adding a fix to read version of new codebases (more robust).

**v2.7.3 - September 2, 2025**

* **FIXED:** adding a fix to read version of new codebases.

**v2.7.2 - October 29, 2024**

* **REFACTOR:** allow for 'tools' to optionally create a logger
* **REFACTOR:** better messaging for daemon start/stop/status

**v2.7.1 - October 28, 2024**

* **FIXED** daemon PID file remaining even if code had crashed	

**v2.7.0 - May 31, 2024**

* **FEATURE:** progress bar added to multiprocessing

**v2.6.3 - April 6, 2024**

* **FIXED** fixing 'insert_list_of_dictionaries_into_database_tables' for MySQL 8

**v2.6.2 - January 19, 2024**

* **FIXED** bug fix in collecting settings files from the default location

**v2.6.1 - December 3, 2023**

* **FIXED** fixing logging colours for white terminal backgrounds

**v2.6.0 - October 10, 2023**

* **ENHANCEMENT:** a print logger level has been added (lives between info and warning logs). To convert a `print()` statement, simply prefix it with `log.`, i.e. `log.print()`.
* **REFACTOR:** logging in now coloured 'in house' without the need of the coloredlogs package

**v2.5.1 - September 29, 2023**

* **ENHANCEMENT:** reworking the `init` command so a user can create/use a settings file in the CWD (instead of the default `~/.config` directory)

**v2.4.1 - May 24, 2023**

* **FIXED** small bug fixes to daemonise code

**v2.4.0 - May 24, 2023**

* **FEATURE** added a class to help daemonise code

**v2.3.12 - May 10, 2022**

* **FIXED** doc fixes


**v2.3.11 - March 17, 2022**  

* **FIXED**: deadlocked connections now attempt to reconnect.

**v2.3.10 - March 7, 2022**  

* **ENHANCEMENT:** can now turn off multiprocessing with the `turnOffMP` parameter of `fmultiprocessing`. Needed for full profiling of code.  

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
