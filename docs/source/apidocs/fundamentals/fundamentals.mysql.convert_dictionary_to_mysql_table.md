# {py:mod}`fundamentals.mysql.convert_dictionary_to_mysql_table`

```{py:module} fundamentals.mysql.convert_dictionary_to_mysql_table
```

```{autodoc2-docstring} fundamentals.mysql.convert_dictionary_to_mysql_table
:allowtitles:
```

## Module Contents

### Functions

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`convert_dictionary_to_mysql_table <fundamentals.mysql.convert_dictionary_to_mysql_table.convert_dictionary_to_mysql_table>`
  - ```{autodoc2-docstring} fundamentals.mysql.convert_dictionary_to_mysql_table.convert_dictionary_to_mysql_table
    :summary:
    ```
````

### Data

````{list-table}
:class: autosummary longtable
:align: left

* - {py:obj}`ALLOWED_VALUE_TYPES <fundamentals.mysql.convert_dictionary_to_mysql_table.ALLOWED_VALUE_TYPES>`
  - ```{autodoc2-docstring} fundamentals.mysql.convert_dictionary_to_mysql_table.ALLOWED_VALUE_TYPES
    :summary:
    ```
* - {py:obj}`ESCAPE_CHARSET <fundamentals.mysql.convert_dictionary_to_mysql_table.ESCAPE_CHARSET>`
  - ```{autodoc2-docstring} fundamentals.mysql.convert_dictionary_to_mysql_table.ESCAPE_CHARSET
    :summary:
    ```
* - {py:obj}`FIXED_VARCHAR_COLUMNS <fundamentals.mysql.convert_dictionary_to_mysql_table.FIXED_VARCHAR_COLUMNS>`
  - ```{autodoc2-docstring} fundamentals.mysql.convert_dictionary_to_mysql_table.FIXED_VARCHAR_COLUMNS
    :summary:
    ```
* - {py:obj}`LONG_STRING_BASE_WIDTH <fundamentals.mysql.convert_dictionary_to_mysql_table.LONG_STRING_BASE_WIDTH>`
  - ```{autodoc2-docstring} fundamentals.mysql.convert_dictionary_to_mysql_table.LONG_STRING_BASE_WIDTH
    :summary:
    ```
* - {py:obj}`LONG_STRING_MIN_LENGTH <fundamentals.mysql.convert_dictionary_to_mysql_table.LONG_STRING_MIN_LENGTH>`
  - ```{autodoc2-docstring} fundamentals.mysql.convert_dictionary_to_mysql_table.LONG_STRING_MIN_LENGTH
    :summary:
    ```
* - {py:obj}`SHORT_VARCHAR_DEFINITION <fundamentals.mysql.convert_dictionary_to_mysql_table.SHORT_VARCHAR_DEFINITION>`
  - ```{autodoc2-docstring} fundamentals.mysql.convert_dictionary_to_mysql_table.SHORT_VARCHAR_DEFINITION
    :summary:
    ```
* - {py:obj}`TINYINT_MAX_SIZE <fundamentals.mysql.convert_dictionary_to_mysql_table.TINYINT_MAX_SIZE>`
  - ```{autodoc2-docstring} fundamentals.mysql.convert_dictionary_to_mysql_table.TINYINT_MAX_SIZE
    :summary:
    ```
````

### API

````{py:data} ALLOWED_VALUE_TYPES
:canonical: fundamentals.mysql.convert_dictionary_to_mysql_table.ALLOWED_VALUE_TYPES
:value: >
   None

```{autodoc2-docstring} fundamentals.mysql.convert_dictionary_to_mysql_table.ALLOWED_VALUE_TYPES
```

````

````{py:data} ESCAPE_CHARSET
:canonical: fundamentals.mysql.convert_dictionary_to_mysql_table.ESCAPE_CHARSET
:value: >
   'utf8mb4'

```{autodoc2-docstring} fundamentals.mysql.convert_dictionary_to_mysql_table.ESCAPE_CHARSET
```

````

````{py:data} FIXED_VARCHAR_COLUMNS
:canonical: fundamentals.mysql.convert_dictionary_to_mysql_table.FIXED_VARCHAR_COLUMNS
:value: >
   ('updated_parsed', 'published_parsed', 'feedName', 'title')

```{autodoc2-docstring} fundamentals.mysql.convert_dictionary_to_mysql_table.FIXED_VARCHAR_COLUMNS
```

````

````{py:data} LONG_STRING_BASE_WIDTH
:canonical: fundamentals.mysql.convert_dictionary_to_mysql_table.LONG_STRING_BASE_WIDTH
:value: >
   450

```{autodoc2-docstring} fundamentals.mysql.convert_dictionary_to_mysql_table.LONG_STRING_BASE_WIDTH
```

````

````{py:data} LONG_STRING_MIN_LENGTH
:canonical: fundamentals.mysql.convert_dictionary_to_mysql_table.LONG_STRING_MIN_LENGTH
:value: >
   80

```{autodoc2-docstring} fundamentals.mysql.convert_dictionary_to_mysql_table.LONG_STRING_MIN_LENGTH
```

````

````{py:data} SHORT_VARCHAR_DEFINITION
:canonical: fundamentals.mysql.convert_dictionary_to_mysql_table.SHORT_VARCHAR_DEFINITION
:value: >
   'varchar(100) DEFAULT NULL'

```{autodoc2-docstring} fundamentals.mysql.convert_dictionary_to_mysql_table.SHORT_VARCHAR_DEFINITION
```

````

````{py:data} TINYINT_MAX_SIZE
:canonical: fundamentals.mysql.convert_dictionary_to_mysql_table.TINYINT_MAX_SIZE
:value: >
   9

```{autodoc2-docstring} fundamentals.mysql.convert_dictionary_to_mysql_table.TINYINT_MAX_SIZE
```

````

````{py:function} convert_dictionary_to_mysql_table(log, dictionary, dbTableName, uniqueKeyList=None, dbConn=False, createHelperTables=False, dateModified=False, returnInsertOnly=False, replace=False, batchInserts=True, reDatetime=False, skipChecks=False, dateCreated=True)
:canonical: fundamentals.mysql.convert_dictionary_to_mysql_table.convert_dictionary_to_mysql_table

```{autodoc2-docstring} fundamentals.mysql.convert_dictionary_to_mysql_table.convert_dictionary_to_mysql_table
```
````
