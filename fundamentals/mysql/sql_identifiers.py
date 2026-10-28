#!/usr/local/bin/python
# encoding: utf-8
"""
*Helpers for putting database identifiers (table and column names) into SQL safely*

Author
: David Young
"""

import hashlib

# LONGEST NAME, IN CHARACTERS, MYSQL ACCEPTS FOR A COLUMN OR INDEX
MYSQL_MAX_IDENTIFIER_LENGTH = 64

# HEX DIGITS OF THE NAME HASH KEPT WHEN A LONG NAME IS SHORTENED
IDENTIFIER_HASH_LENGTH = 16


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


def quote_identifier_for_format(name):
    """*Return a quoted MySQL identifier for a statement that pymysql later fills in with ``%s`` placeholders*

    **Key Arguments**

    - ``name`` -- the table or column name

    **Return**

    - ``quotedName`` -- the name wrapped in backticks, with backticks doubled and each ``%`` written as ``%%``

    Raises ``ValueError`` in the same cases as ``quote_identifier``.
    """
    return quote_identifier(name).replace("%", "%%")


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


def cap_identifier(name, maxLength=MYSQL_MAX_IDENTIFIER_LENGTH):
    """*Return the name shortened to fit the MySQL identifier length limit*

    **Key Arguments**

    - ``name`` -- the identifier, for example an index name
    - ``maxLength`` -- the longest length allowed, in characters

    **Return**

    - ``cappedName`` -- the name unchanged if it fits, otherwise the start of the name, an underscore and 16 hex characters of a hash of the whole name, ``maxLength`` characters in total. The same name always gives the same result, and long names that share a start give different results

    Raises ``TypeError`` if the name is not a string, and ``ValueError`` if a name that is too long cannot be shortened because ``maxLength`` leaves no room for a prefix, the underscore and the hash.
    """
    if not isinstance(name, str):
        raise TypeError("a database identifier must be a string, not %r" % (name,))
    if len(name) <= maxLength:
        return name
    prefixLength = maxLength - IDENTIFIER_HASH_LENGTH - 1
    if prefixLength < 1:
        raise ValueError(
            "maxLength %d is too small to shorten a name: it needs at least %d"
            % (maxLength, IDENTIFIER_HASH_LENGTH + 2)
        )
    digest = hashlib.sha1(name.encode("utf-8")).hexdigest()[:IDENTIFIER_HASH_LENGTH]
    return name[:prefixLength] + "_" + digest
