#!/usr/local/bin/python
# encoding: utf-8
"""
*Convert a python list of dictionaries to pretty csv output*

:Author:
    David Young

:Date Created:
    June 28, 2016
"""
################# GLOBAL IMPORTS ####################
import sys
import os
import io
import csv
from decimal import Decimal
from datetime import datetime
os.environ['TERM'] = 'vt100'
from fundamentals import tools


def list_of_dictionaries_to_csv(
        log,
        datalist,
        csvType="human"):
    """Convert a python list of dictionaries to pretty csv output

    **Key Arguments:**
        - ``log`` -- logger
        - ``datalist`` -- a list of dictionaries
        - ``csvType`` -- human or machine

    **Return:**
        - ``output`` -- the contents of a CSV file

    **Usage:**

        .. code-block:: python 

            from fundamentals.files import list_of_dictionaries_to_csv
            csvOutput = list_of_dictionaries_to_csv(
                log=log,
                datalist=dataList
            )
            print csvOutput

        this output the following:

        .. code-block:: plain

            +--------+------------+--------------+
            | owner  | pet        | address      |
            +--------+------------+--------------+
            | daisy  | dog        | belfast, uk  |
            | john   | snake      | the moon     |
            | susan  | crocodile  | larne        |
            +--------+------------+--------------+ 

        whereas choosing a 'machine' output generates the traditional CSV file content:

        .. code-block:: python 

            from fundamentals.files import list_of_dictionaries_to_csv
            csvOutput = list_of_dictionaries_to_csv(
                log=log,
                datalist=dataList,
                csvType="machine"
            )
            print csvOutput

        .. code-block:: plain

            daisy  , dog        ," belfast, uk  "
            john   , snake      , the moon     
            susan  , crocodile  , larne
    """
    log.info('starting the ``list_of_dictionaries_to_csv`` function')

    if not len(datalist):
        return "NO MATCH"

    tableColumnNames = datalist[0].keys()
    columnWidths = []
    columnWidths[:] = [len(tableColumnNames[i])
                       for i in range(len(tableColumnNames))]

    output = io.BytesIO()
    # setup csv styles
    if csvType == "machine":
        delimiter = ","
    elif csvType == "human":
        delimiter = "|"
    writer = csv.writer(output, dialect='excel', delimiter=delimiter,
                        quotechar='"', quoting=csv.QUOTE_MINIMAL)
    dividerWriter = csv.writer(output, dialect='excel', delimiter="+",
                               quotechar='"', quoting=csv.QUOTE_MINIMAL)

    # add column names to csv
    header = []
    divider = []
    allRows = []

    # clean up data
    for row in datalist:
        for c in tableColumnNames:
            if isinstance(row[c], float) or isinstance(row[c], long) or isinstance(row[c], Decimal):
                row[c] = "%0.4f" % row[c]
            elif isinstance(row[c], datetime):
                thisDate = str(row[c])[:10]
                row[c] = "%(thisDate)s" % locals()

    # set the column widths
    for row in datalist:
        for i, c in enumerate(tableColumnNames):
            if len(str(row[c])) > columnWidths[i]:
                columnWidths[i] = len(str(row[c]))

    # fill in the data
    for row in datalist:
        thisRow = []
        # table border for human readable
        if csvType == "human":
            thisRow.append("")

        for i, c in enumerate(tableColumnNames):
            if csvType == "human":
                row[c] = str(str(row[c]).ljust(columnWidths[i] + 2)
                             .rjust(columnWidths[i] + 3))
            thisRow.append(row[c])
        # table border for human readable
        if csvType == "human":
            thisRow.append("")
        allRows.append(thisRow)

    # table borders for human readable
    if csvType == "human":
        header.append("")
        divider.append("")

    for i, c in enumerate(tableColumnNames):
        if csvType == "machine":
            header.append(c)
        elif csvType == "human":
            header.append(
                c.ljust(columnWidths[i] + 2).rjust(columnWidths[i] + 3))
            divider.append('-' * (columnWidths[i] + 3))

    # table border for human readable
    if csvType == "human":
        header.append("")
        divider.append("")

    if csvType == "machine":
        writer.writerow(header)
    elif csvType == "human":
        dividerWriter.writerow(divider)
        writer.writerow(header)
        dividerWriter.writerow(divider)

    # write out the data
    writer.writerows(allRows)
    # table border for human readable
    if csvType == "human":
        dividerWriter.writerow(divider)

    output = output.getvalue()
    output = output.strip()

    log.info('completed the ``list_of_dictionaries_to_csv`` function')
    return output
