# {py:mod}`fundamentals.mysql.writequery`

```{py:module} fundamentals.mysql.writequery
```

```{autodoc2-docstring} fundamentals.mysql.writequery
:allowtitles:
```

## Module Contents

### Functions

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`writequery <fundamentals.mysql.writequery.writequery>`
  - ```{autodoc2-docstring} fundamentals.mysql.writequery.writequery
    :summary:
    ```
````

### Data

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`DUPLICATE_ENTRY_ERROR_CODE <fundamentals.mysql.writequery.DUPLICATE_ENTRY_ERROR_CODE>`
  - ```{autodoc2-docstring} fundamentals.mysql.writequery.DUPLICATE_ENTRY_ERROR_CODE
    :summary:
    ```
* - {py:obj}`DUPLICATE_KEY_NAME_ERROR_CODE <fundamentals.mysql.writequery.DUPLICATE_KEY_NAME_ERROR_CODE>`
  - ```{autodoc2-docstring} fundamentals.mysql.writequery.DUPLICATE_KEY_NAME_ERROR_CODE
    :summary:
    ```
* - {py:obj}`INSERT_BATCH_SIZE <fundamentals.mysql.writequery.INSERT_BATCH_SIZE>`
  - ```{autodoc2-docstring} fundamentals.mysql.writequery.INSERT_BATCH_SIZE
    :summary:
    ```
* - {py:obj}`TABLE_EXISTS_ERROR_CODE <fundamentals.mysql.writequery.TABLE_EXISTS_ERROR_CODE>`
  - ```{autodoc2-docstring} fundamentals.mysql.writequery.TABLE_EXISTS_ERROR_CODE
    :summary:
    ```
````

### API

````{py:data} DUPLICATE_ENTRY_ERROR_CODE
:canonical: fundamentals.mysql.writequery.DUPLICATE_ENTRY_ERROR_CODE
:value: >
   1062

```{autodoc2-docstring} fundamentals.mysql.writequery.DUPLICATE_ENTRY_ERROR_CODE
```

````

````{py:data} DUPLICATE_KEY_NAME_ERROR_CODE
:canonical: fundamentals.mysql.writequery.DUPLICATE_KEY_NAME_ERROR_CODE
:value: >
   1061

```{autodoc2-docstring} fundamentals.mysql.writequery.DUPLICATE_KEY_NAME_ERROR_CODE
```

````

````{py:data} INSERT_BATCH_SIZE
:canonical: fundamentals.mysql.writequery.INSERT_BATCH_SIZE
:value: >
   100000

```{autodoc2-docstring} fundamentals.mysql.writequery.INSERT_BATCH_SIZE
```

````

````{py:data} TABLE_EXISTS_ERROR_CODE
:canonical: fundamentals.mysql.writequery.TABLE_EXISTS_ERROR_CODE
:value: >
   1050

```{autodoc2-docstring} fundamentals.mysql.writequery.TABLE_EXISTS_ERROR_CODE
```

````

````{py:function} writequery(log, sqlQuery, dbConn, Force=False, manyValueList=False)
:canonical: fundamentals.mysql.writequery.writequery

```{autodoc2-docstring} fundamentals.mysql.writequery.writequery
```
````
