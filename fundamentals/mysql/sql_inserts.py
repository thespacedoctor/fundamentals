#!/usr/local/bin/python
# encoding: utf-8
"""
*Build the multi-row insert command shared by the dictionary insert paths*

Author
: David Young
"""

from fundamentals.mysql.sql_identifiers import (
    quote_identifier,
    quote_identifier_for_format,
)


def build_batch_insert_command(
    insertVerb, dbTableName, columns, replace, dateCreated, extraUpdates=()
):
    """*Build an insert command with ``%s`` placeholders, to be run with ``executemany``*

    Every identifier is quoted, and ``%`` inside an identifier is doubled because pymysql formats the command afterwards.
    The exception is the ``ON DUPLICATE KEY UPDATE`` tail when the values are only placeholders: pymysql then batches the rows and sends that tail as it is, so ``%`` stays single.

    **Key Arguments**

    - ``insertVerb`` -- the start of the command, e.g. ``INSERT`` or ``INSERT IGNORE``
    - ``dbTableName`` -- the table to insert into
    - ``columns`` -- the column names, in the order of the values
    - ``replace`` -- update the row if a duplicate key is found?
    - ``dateCreated`` -- also fill the dateCreated column with ``NOW()``?
    - ``extraUpdates`` -- more assignments for the ``ON DUPLICATE KEY UPDATE`` tail, e.g. ``("updated=1",)``

    **Return**

    - ``insertCommand`` -- the command to hand to writequery
    """
    quotedColumns = [quote_identifier_for_format(c) for c in columns]
    placeholders = ", ".join(["%s"] * len(columns))
    insertCommand = "%s INTO %s (%s%s) VALUES (%s%s)" % (
        insertVerb,
        quote_identifier_for_format(dbTableName),
        ",".join(quotedColumns),
        ", dateCreated" if dateCreated else "",
        placeholders,
        ", NOW()" if dateCreated else "",
    )
    if replace:
        # PYMYSQL ONLY FORMATS THE TAIL WHEN IT CANNOT BATCH THE ROWS (NOW() IN THE VALUES)
        tailColumns = quotedColumns
        if not dateCreated:
            tailColumns = [quote_identifier(c) for c in columns]
        assignments = ["%s=VALUES(%s)" % (c, c) for c in tailColumns]
        assignments += list(extraUpdates)
        insertCommand += " ON DUPLICATE KEY UPDATE " + ", ".join(assignments)
    return insertCommand
