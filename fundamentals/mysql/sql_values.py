#!/usr/local/bin/python
# encoding: utf-8
"""
*The rule for turning a Python value into the value stored in a MySQL column, shared by every insert path*

Author
: David Young
"""


def null_if_missing(value):
    """*Return None (stored as NULL) for a missing value, otherwise the value unchanged*

    **Key Arguments**

    - ``value`` -- the value to store

    **Return**

    - ``databaseValue`` -- None if ``value`` is None or the empty string, otherwise ``value``. The texts ``"None"`` and ``"null"`` are real text and are kept

    **Usage**

    ```python
    from fundamentals.mysql.sql_values import null_if_missing
    null_if_missing("")

    # OUTPUT: None
    ```
    """
    if value is None or (isinstance(value, str) and value == ""):
        return None
    return value
