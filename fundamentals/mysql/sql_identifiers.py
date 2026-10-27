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
