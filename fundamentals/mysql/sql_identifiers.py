#!/usr/local/bin/python
# encoding: utf-8
"""
*Helpers for putting database identifiers (table and column names) into SQL safely*

Author
: David Young
"""


def quote_identifier(name):
    """*Return a MySQL identifier wrapped in backticks, ready to put in a SQL statement*

    **Key Arguments**

    - ``name`` -- the table or column name

    **Return**

    - ``quotedName`` -- the name wrapped in backticks, with any backtick inside the name doubled

    **Usage**

    ```python
    from fundamentals.mysql.sql_identifiers import quote_identifier
    quote_identifier("a`b")

    # OUTPUT: `a``b`
    ```

    Raises ``ValueError`` if the name is not a string, is empty, or contains a NUL character.
    """
    if not isinstance(name, str):
        raise ValueError("a database identifier must be a string, not %r" % (name,))
    if name == "":
        raise ValueError("a database identifier cannot be empty")
    if "\x00" in name:
        raise ValueError("a database identifier cannot contain a NUL character")
    return "`" + name.replace("`", "``") + "`"


def normalise_column_name(key):
    """*Return the database column name for a dictionary key*

    **Key Arguments**

    - ``key`` -- the dictionary key

    **Return**

    - ``columnName`` -- the key as a string, with spaces and hyphens replaced by underscores. The MySQL keywords ``dec`` and ``DEC`` are renamed ``decl`` and ``DECL``
    """
    columnName = str(key).replace(" ", "_").replace("-", "_")
    # DEC IS A KEYWORD IN MYSQL
    if columnName == "dec":
        columnName = "decl"
    if columnName == "DEC":
        columnName = "DECL"
    return columnName


def raise_on_duplicate_columns(keys):
    """*Raise a ValueError if two or more dictionary keys give the same column name*

    **Key Arguments**

    - ``keys`` -- the dictionary keys, before they are normalised

    **Usage**

    ```python
    from fundamentals.mysql.sql_identifiers import raise_on_duplicate_columns
    raise_on_duplicate_columns([1, "1"])

    # RAISES: ValueError: keys 1 and '1' both map to column '1'
    ```
    """
    keysByColumn = {}
    for key in keys:
        keysByColumn.setdefault(normalise_column_name(key), []).append(key)

    messages = []
    for columnName, clashingKeys in keysByColumn.items():
        if len(clashingKeys) < 2:
            continue
        names = [repr(k) for k in clashingKeys]
        joined = ", ".join(names[:-1]) + " and " + names[-1]
        quantifier = "both" if len(names) == 2 else "all"
        messages.append(
            "keys %s %s map to column %r" % (joined, quantifier, columnName)
        )
    if messages:
        raise ValueError("; ".join(messages))
