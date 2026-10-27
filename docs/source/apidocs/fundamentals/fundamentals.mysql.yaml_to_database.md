# {py:mod}`fundamentals.mysql.yaml_to_database`

```{py:module} fundamentals.mysql.yaml_to_database
```

```{autodoc2-docstring} fundamentals.mysql.yaml_to_database
:allowtitles:
```

## Module Contents

### Classes

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`yaml_to_database <fundamentals.mysql.yaml_to_database.yaml_to_database>`
  - ```{autodoc2-docstring} fundamentals.mysql.yaml_to_database.yaml_to_database
    :summary:
    ```
````

### Functions

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`main <fundamentals.mysql.yaml_to_database.main>`
  - ```{autodoc2-docstring} fundamentals.mysql.yaml_to_database.main
    :summary:
    ```
* - {py:obj}`unshorten_url <fundamentals.mysql.yaml_to_database.unshorten_url>`
  - ```{autodoc2-docstring} fundamentals.mysql.yaml_to_database.unshorten_url
    :summary:
    ```
````

### Data

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`MAX_REDIRECT_HOPS <fundamentals.mysql.yaml_to_database.MAX_REDIRECT_HOPS>`
  - ```{autodoc2-docstring} fundamentals.mysql.yaml_to_database.MAX_REDIRECT_HOPS
    :summary:
    ```
* - {py:obj}`REDIRECT_STATUS_CODES <fundamentals.mysql.yaml_to_database.REDIRECT_STATUS_CODES>`
  - ```{autodoc2-docstring} fundamentals.mysql.yaml_to_database.REDIRECT_STATUS_CODES
    :summary:
    ```
* - {py:obj}`URL_REQUEST_TIMEOUT <fundamentals.mysql.yaml_to_database.URL_REQUEST_TIMEOUT>`
  - ```{autodoc2-docstring} fundamentals.mysql.yaml_to_database.URL_REQUEST_TIMEOUT
    :summary:
    ```
* - {py:obj}`URL_SCHEMES_ALLOWED <fundamentals.mysql.yaml_to_database.URL_SCHEMES_ALLOWED>`
  - ```{autodoc2-docstring} fundamentals.mysql.yaml_to_database.URL_SCHEMES_ALLOWED
    :summary:
    ```
````

### API

````{py:data} MAX_REDIRECT_HOPS
:canonical: fundamentals.mysql.yaml_to_database.MAX_REDIRECT_HOPS
:value: >
   5

```{autodoc2-docstring} fundamentals.mysql.yaml_to_database.MAX_REDIRECT_HOPS
```

````

````{py:data} REDIRECT_STATUS_CODES
:canonical: fundamentals.mysql.yaml_to_database.REDIRECT_STATUS_CODES
:value: >
   (301, 302, 303, 307, 308)

```{autodoc2-docstring} fundamentals.mysql.yaml_to_database.REDIRECT_STATUS_CODES
```

````

````{py:data} URL_REQUEST_TIMEOUT
:canonical: fundamentals.mysql.yaml_to_database.URL_REQUEST_TIMEOUT
:value: >
   10

```{autodoc2-docstring} fundamentals.mysql.yaml_to_database.URL_REQUEST_TIMEOUT
```

````

````{py:data} URL_SCHEMES_ALLOWED
:canonical: fundamentals.mysql.yaml_to_database.URL_SCHEMES_ALLOWED
:value: >
   ('http', 'https')

```{autodoc2-docstring} fundamentals.mysql.yaml_to_database.URL_SCHEMES_ALLOWED
```

````

````{py:function} main(arguments=None)
:canonical: fundamentals.mysql.yaml_to_database.main

```{autodoc2-docstring} fundamentals.mysql.yaml_to_database.main
```
````

````{py:function} unshorten_url(url, log)
:canonical: fundamentals.mysql.yaml_to_database.unshorten_url

```{autodoc2-docstring} fundamentals.mysql.yaml_to_database.unshorten_url
```
````

`````{py:class} yaml_to_database(log, dbConn, pathToInputDir=False, settings=False, deleteFiles=False)
:canonical: fundamentals.mysql.yaml_to_database.yaml_to_database

Bases: {py:obj}`object`

```{autodoc2-docstring} fundamentals.mysql.yaml_to_database.yaml_to_database
```

```{rubric} Initialization
```

```{autodoc2-docstring} fundamentals.mysql.yaml_to_database.yaml_to_database.__init__
```

````{py:method} add_yaml_file_content_to_database(filepath, deleteFile=False)
:canonical: fundamentals.mysql.yaml_to_database.yaml_to_database.add_yaml_file_content_to_database

```{autodoc2-docstring} fundamentals.mysql.yaml_to_database.yaml_to_database.add_yaml_file_content_to_database
```

````

````{py:method} ingest()
:canonical: fundamentals.mysql.yaml_to_database.yaml_to_database.ingest

```{autodoc2-docstring} fundamentals.mysql.yaml_to_database.yaml_to_database.ingest
```

````

`````
