# {py:mod}`fundamentals.mysql.directory_script_runner`

```{py:module} fundamentals.mysql.directory_script_runner
```

```{autodoc2-docstring} fundamentals.mysql.directory_script_runner
:allowtitles:
```

## Module Contents

### Functions

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`directory_script_runner <fundamentals.mysql.directory_script_runner.directory_script_runner>`
  - ```{autodoc2-docstring} fundamentals.mysql.directory_script_runner.directory_script_runner
    :summary:
    ```
* - {py:obj}`execute_mysql_script <fundamentals.mysql.directory_script_runner.execute_mysql_script>`
  - ```{autodoc2-docstring} fundamentals.mysql.directory_script_runner.execute_mysql_script
    :summary:
    ```
* - {py:obj}`main <fundamentals.mysql.directory_script_runner.main>`
  - ```{autodoc2-docstring} fundamentals.mysql.directory_script_runner.main
    :summary:
    ```
````

### Data

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`MAX_LOGGED_STDERR_BYTES <fundamentals.mysql.directory_script_runner.MAX_LOGGED_STDERR_BYTES>`
  - ```{autodoc2-docstring} fundamentals.mysql.directory_script_runner.MAX_LOGGED_STDERR_BYTES
    :summary:
    ```
* - {py:obj}`MAX_PARALLEL_SCRIPTS <fundamentals.mysql.directory_script_runner.MAX_PARALLEL_SCRIPTS>`
  - ```{autodoc2-docstring} fundamentals.mysql.directory_script_runner.MAX_PARALLEL_SCRIPTS
    :summary:
    ```
````

### API

````{py:data} MAX_LOGGED_STDERR_BYTES
:canonical: fundamentals.mysql.directory_script_runner.MAX_LOGGED_STDERR_BYTES
:value: >
   65536

```{autodoc2-docstring} fundamentals.mysql.directory_script_runner.MAX_LOGGED_STDERR_BYTES
```

````

````{py:data} MAX_PARALLEL_SCRIPTS
:canonical: fundamentals.mysql.directory_script_runner.MAX_PARALLEL_SCRIPTS
:value: >
   8

```{autodoc2-docstring} fundamentals.mysql.directory_script_runner.MAX_PARALLEL_SCRIPTS
```

````

````{py:function} directory_script_runner(log, pathToScriptDirectory, dbConn=False, waitForResult=True, successRule=None, failureRule=None, loginPath=False, databaseName=False, force=True, maxParallelScripts=MAX_PARALLEL_SCRIPTS)
:canonical: fundamentals.mysql.directory_script_runner.directory_script_runner

```{autodoc2-docstring} fundamentals.mysql.directory_script_runner.directory_script_runner
```
````

````{py:function} execute_mysql_script(pathToScript, dbConn, log)
:canonical: fundamentals.mysql.directory_script_runner.execute_mysql_script

```{autodoc2-docstring} fundamentals.mysql.directory_script_runner.execute_mysql_script
```
````

````{py:function} main(arguments=None)
:canonical: fundamentals.mysql.directory_script_runner.main

```{autodoc2-docstring} fundamentals.mysql.directory_script_runner.main
```
````
