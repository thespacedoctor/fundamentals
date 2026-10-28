#!/usr/local/bin/python
# encoding: utf-8
"""
*Helpers that keep data values and forged lines out of log messages*

Author
: David Young
"""

LITERAL_PLACEHOLDER = "?"
QUOTE_CHARACTERS = "'\""
LITERAL_PREFIXES = "xXbB"
LINE_ENDINGS = "\r\n"


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


def describe_error(error):
    """*Return the class of an exception and its MySQL error code, never its message*

    MySQL error messages repeat data values (``Duplicate entry 'X'``, ``near '...'``), so they must not be logged.

    **Key Arguments**

    - ``error`` -- the exception

    **Return**

    - ``description`` -- for example ``IntegrityError (MySQL error 1062)``, or just the class name when the first argument is not an integer error code
    """
    name = type(error).__name__
    code = error.args[0] if error.args else None
    if isinstance(code, int) and not isinstance(code, bool):
        return "%s (MySQL error %d)" % (name, code)
    return name


def _is_word_character(char):
    """*return True if the character can be part of an unquoted SQL name or number*"""
    return char.isalnum() or char in "_$"


def _scan_quoted(sql, start):
    """*return the index after the quoted string that starts at ``start``, or None if it is unterminated or ambiguous*

    A backslash before the quote character is ambiguous because the server may or may not treat a backslash as an escape (``NO_BACKSLASH_ESCAPES``), so it is treated like an unterminated string.
    """
    quote = sql[start]
    end = len(sql)
    index = start + 1
    while index < end:
        char = sql[index]
        if char == "\\":
            if index + 1 >= end or sql[index + 1] == quote:
                return None
            index += 2
        elif char == quote and sql[index + 1 : index + 2] == quote:
            index += 2
        elif char == quote:
            return index + 1
        else:
            index += 1
    return None


def _scan_string(sql, index):
    """*return the replacement text and next index for a quoted string, or None if there is none here*"""
    if sql[index] not in QUOTE_CHARACTERS:
        return None
    end = _scan_quoted(sql, index)
    return (LITERAL_PLACEHOLDER, len(sql) if end is None else end)


def _scan_quoted_name(sql, index):
    """*return the text and next index for a backtick-quoted name, with control characters escaped, or None if there is none here*"""
    if sql[index] != "`":
        return None
    end = index + 1
    while end < len(sql):
        if sql[end] == "`" and sql[end + 1 : end + 2] == "`":
            end += 2
        elif sql[end] == "`":
            return ("`" + escape_for_log(sql[index + 1 : end]) + "`", end + 1)
        else:
            end += 1
    return ("`" + LITERAL_PLACEHOLDER, len(sql))


def _scan_comment(sql, index):
    """*return the text and next index for a comment, with the comment body replaced, or None if there is none here*"""
    if sql.startswith("/*", index):
        end = sql.find("*/", index + 2)
        if end == -1:
            return ("/*" + LITERAL_PLACEHOLDER, len(sql))
        return ("/*" + LITERAL_PLACEHOLDER + "*/", end + 2)
    if sql.startswith("--", index) or sql[index] == "#":
        opener = sql[index : index + 2] if sql[index] == "-" else "#"
        end = index
        while end < len(sql) and sql[end] not in LINE_ENDINGS:
            end += 1
        return (opener + " " + LITERAL_PLACEHOLDER, end)
    return None


def _scan_word_end(sql, index):
    """*return the index after the run of word characters that starts at ``index``*"""
    while index < len(sql) and _is_word_character(sql[index]):
        index += 1
    return index


def _scan_number_end(sql, index):
    """*return the index after the number or number-like word that starts at ``index``, including any fraction and exponent*"""
    end = _scan_word_end(sql, index)
    isDecimal = sql[end : end + 1] == "." and sql[end + 1 : end + 2].isdigit()
    if isDecimal:
        end = _scan_word_end(sql, end + 1)
    isExponent = sql[end - 1] in "eE" and sql[end : end + 1] in ("+", "-")
    if isExponent and sql[end + 1 : end + 2].isdigit():
        end = _scan_word_end(sql, end + 1)
    return end


def _scan_word(sql, index):
    """*return the text and next index for a word or number, or None if there is none here*

    Names are kept. Numbers, hex and binary literals (``0x..``, ``0b..``, ``X'..'``, ``b'..'``) are replaced.
    """
    if not _is_word_character(sql[index]):
        return None
    end = _scan_word_end(sql, index)
    word = sql[index:end]
    isPrefixedLiteral = word in tuple(LITERAL_PREFIXES) and sql[end : end + 1] in (
        "'",
        '"',
    )
    if isPrefixedLiteral:
        literalEnd = _scan_quoted(sql, end)
        return (LITERAL_PLACEHOLDER, len(sql) if literalEnd is None else literalEnd)
    if word[0].isdigit():
        return (LITERAL_PLACEHOLDER, _scan_number_end(sql, index))
    return (word, end)


def _scan_leading_dot_number(sql, index):
    """*return the text and next index for a number such as ``.5``, or None if there is none here*"""
    isNumber = sql[index] == "." and sql[index + 1 : index + 2].isdigit()
    if not isNumber:
        return None
    follows = sql[index - 1] if index > 0 else " "
    if _is_word_character(follows) or follows == "`":
        return None
    return (LITERAL_PLACEHOLDER, _scan_number_end(sql, index + 1))


SCANNERS = (
    _scan_string,
    _scan_quoted_name,
    _scan_comment,
    _scan_word,
    _scan_leading_dot_number,
)


def redact_sql_literals(sql):
    """*Return the SQL text with every literal value and comment body replaced by a question mark*

    The scanner reads the statement one token at a time and fails closed: a string, name or comment that is unterminated, and a string with a backslash before its quote character (where the server's backslash setting changes where it ends), is replaced to the end of the text.

    **Key Arguments**

    - ``sql`` -- the SQL statement

    **Return**

    - ``redactedSql`` -- the statement with string, number, hex, binary and comment text removed. Names, keywords and ``%s`` placeholders are kept, and control characters inside backtick-quoted names are escaped

    **Usage**

    ```python
    from fundamentals.mysql._log_safety import redact_sql_literals
    redact_sql_literals("INSERT INTO `t` (`a`) VALUES ('secret')")

    # OUTPUT: INSERT INTO `t` (`a`) VALUES (?)
    ```
    """
    pieces = []
    index = 0
    while index < len(sql):
        for scanner in SCANNERS:
            result = scanner(sql, index)
            if result:
                break
        else:
            result = (sql[index], index + 1)
        pieces.append(result[0])
        index = result[1]
    return "".join(pieces)
