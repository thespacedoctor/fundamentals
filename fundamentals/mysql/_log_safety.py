#!/usr/local/bin/python
# encoding: utf-8
"""
*Helpers that keep data values and forged lines out of log messages*

Author
: David Young
"""

import re

# QUOTED NAMES ARE KEPT, QUOTED STRINGS (TO THE END OF THE TEXT IF NOT CLOSED) AND NUMBERS ARE REPLACED
SQL_TOKEN_PATTERN = re.compile(
    r"""
    (?P<identifier>`(?:[^`]|``)*`)
    |'(?:[^'\\]|\\.|'')*(?:'|$)
    |"(?:[^"\\]|\\.|"")*(?:"|$)
    |\b(?:0[xX][0-9a-fA-F]+|\d+(?:\.\d+)?(?:[eE][+-]?\d+)?)\b
    """,
    re.VERBOSE | re.DOTALL,
)

LITERAL_PLACEHOLDER = "?"


def escape_for_log(value):
    """*Return the value as text with control characters written as escape sequences, so it cannot start a new log line*

    **Key Arguments**

    - ``value`` -- the table name, column name or other text to put in a log message

    **Return**

    - ``text`` -- the value as a string, with newlines and other non-printable characters escaped. Printable characters, including non-ASCII ones, are unchanged
    """
    return "".join(
        char if char.isprintable() else char.encode("unicode_escape").decode("ascii")
        for char in str(value)
    )


def redact_sql_literals(sql):
    """*Return the SQL text with every string and number literal replaced by a question mark*

    **Key Arguments**

    - ``sql`` -- the SQL statement

    **Return**

    - ``redactedSql`` -- the statement with the data values removed. Backtick-quoted names, keywords and ``%s`` placeholders are unchanged

    **Usage**

    ```python
    from fundamentals.mysql._log_safety import redact_sql_literals
    redact_sql_literals("INSERT INTO `t` (`a`) VALUES ('secret')")

    # OUTPUT: INSERT INTO `t` (`a`) VALUES (?)
    ```
    """

    def replace(match):
        if match.group("identifier"):
            return match.group(0)
        return LITERAL_PLACEHOLDER

    return SQL_TOKEN_PATTERN.sub(replace, sql)
