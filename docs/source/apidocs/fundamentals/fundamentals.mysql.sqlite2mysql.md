# {py:mod}`fundamentals.mysql.sqlite2mysql`

```{py:module} fundamentals.mysql.sqlite2mysql
```

```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql
:allowtitles:
```

## Module Contents

### Classes

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`sqlite2mysql <fundamentals.mysql.sqlite2mysql.sqlite2mysql>`
  - ```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.sqlite2mysql
    :summary:
    ```
````

### Functions

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`main <fundamentals.mysql.sqlite2mysql.main>`
  - ```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.main
    :summary:
    ```
* - {py:obj}`quote_sqlite_identifiers <fundamentals.mysql.sqlite2mysql.quote_sqlite_identifiers>`
  - ```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.quote_sqlite_identifiers
    :summary:
    ```
* - {py:obj}`remove_foreign_keys <fundamentals.mysql.sqlite2mysql.remove_foreign_keys>`
  - ```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.remove_foreign_keys
    :summary:
    ```
````

### Data

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`COLUMN_REFERENCES_REGEX <fundamentals.mysql.sqlite2mysql.COLUMN_REFERENCES_REGEX>`
  - ```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.COLUMN_REFERENCES_REGEX
    :summary:
    ```
* - {py:obj}`CREATE_TABLE_HEADER_REGEX <fundamentals.mysql.sqlite2mysql.CREATE_TABLE_HEADER_REGEX>`
  - ```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.CREATE_TABLE_HEADER_REGEX
    :summary:
    ```
* - {py:obj}`IDENTIFIER_PATTERN <fundamentals.mysql.sqlite2mysql.IDENTIFIER_PATTERN>`
  - ```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.IDENTIFIER_PATTERN
    :summary:
    ```
* - {py:obj}`REFERENCES_PATTERN <fundamentals.mysql.sqlite2mysql.REFERENCES_PATTERN>`
  - ```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.REFERENCES_PATTERN
    :summary:
    ```
* - {py:obj}`SQLITE_TOKEN_REGEX <fundamentals.mysql.sqlite2mysql.SQLITE_TOKEN_REGEX>`
  - ```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.SQLITE_TOKEN_REGEX
    :summary:
    ```
* - {py:obj}`TABLE_FOREIGN_KEY_REGEX <fundamentals.mysql.sqlite2mysql.TABLE_FOREIGN_KEY_REGEX>`
  - ```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.TABLE_FOREIGN_KEY_REGEX
    :summary:
    ```
````

### API

````{py:data} COLUMN_REFERENCES_REGEX
:canonical: fundamentals.mysql.sqlite2mysql.COLUMN_REFERENCES_REGEX
:value: >
   'compile(...)'

```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.COLUMN_REFERENCES_REGEX
```

````

````{py:data} CREATE_TABLE_HEADER_REGEX
:canonical: fundamentals.mysql.sqlite2mysql.CREATE_TABLE_HEADER_REGEX
:value: >
   'compile(...)'

```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.CREATE_TABLE_HEADER_REGEX
```

````

````{py:data} IDENTIFIER_PATTERN
:canonical: fundamentals.mysql.sqlite2mysql.IDENTIFIER_PATTERN
:value: >
   '(?:`(?:[^`]|``)+`|\\w+)'

```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.IDENTIFIER_PATTERN
```

````

````{py:data} REFERENCES_PATTERN
:canonical: fundamentals.mysql.sqlite2mysql.REFERENCES_PATTERN
:value: >
   None

```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.REFERENCES_PATTERN
```

````

````{py:data} SQLITE_TOKEN_REGEX
:canonical: fundamentals.mysql.sqlite2mysql.SQLITE_TOKEN_REGEX
:value: >
   'compile(...)'

```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.SQLITE_TOKEN_REGEX
```

````

````{py:data} TABLE_FOREIGN_KEY_REGEX
:canonical: fundamentals.mysql.sqlite2mysql.TABLE_FOREIGN_KEY_REGEX
:value: >
   'compile(...)'

```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.TABLE_FOREIGN_KEY_REGEX
```

````

````{py:function} main(arguments=None)
:canonical: fundamentals.mysql.sqlite2mysql.main

```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.main
```
````

````{py:function} quote_sqlite_identifiers(sqliteSql)
:canonical: fundamentals.mysql.sqlite2mysql.quote_sqlite_identifiers

```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.quote_sqlite_identifiers
```
````

````{py:function} remove_foreign_keys(createBody)
:canonical: fundamentals.mysql.sqlite2mysql.remove_foreign_keys

```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.remove_foreign_keys
```
````

`````{py:class} sqlite2mysql(log, pathToSqlite, tablePrefix='', settings=False, dbConn=None)
:canonical: fundamentals.mysql.sqlite2mysql.sqlite2mysql

Bases: {py:obj}`object`

```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.sqlite2mysql
```

```{rubric} Initialization
```

```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.sqlite2mysql.__init__
```

````{py:method} convert_sqlite_to_mysql()
:canonical: fundamentals.mysql.sqlite2mysql.sqlite2mysql.convert_sqlite_to_mysql

```{autodoc2-docstring} fundamentals.mysql.sqlite2mysql.sqlite2mysql.convert_sqlite_to_mysql
```

````

`````
