#!/usr/local/bin/python
# encoding: utf-8
"""
*Render a python list of dictionaries in various list and markup formats*

:Author:
    David Young

:Date Created:
    September 14, 2016
"""
################# GLOBAL IMPORTS ####################
import sys
import os
import io
import csv
import codecs
import copy
import json
import yaml
from decimal import Decimal
from datetime import datetime
os.environ['TERM'] = 'vt100'
from fundamentals import tools
from fundamentals.mysql import convert_dictionary_to_mysql_table


class list_of_dictionaries():
    """
    *The dataset object is a list of python dictionaries. Using this class, the data can be rendered as various list and markup formats*

    **Key Arguments:**
        - ``log`` -- logger
        - ``listOfDictionaries`` -- the list of dictionaries to render

    **Usage:**

        To initialise the dataset object:

        .. code-block:: python

            dataList = [
                {
                    "owner": "daisy",
                    "pet": "dog",
                    "address": "belfast, uk"
                },
                {
                    "owner": "john",
                    "pet": "snake",
                    "address": "the moon"
                },
                {
                    "owner": "susan",
                    "pet": "crocodile",
                    "address": "larne"
                }

            ]

            from fundamentals.renderer import list_of_dictionaries
            dataSet = list_of_dictionaries(
                log=log,
                listOfDictionaries=dataList
            )
    """

    def __init__(
            self,
            log,
            listOfDictionaries,
    ):
        self.log = log
        self.log.debug("instansiating a new 'list_of_dictionaries' object")
        self.listOfDictionaries = listOfDictionaries

        return None

    @property
    def list(
            self):
        """*Returns the original list of dictionaries*

        **Usage:**

            dataSet.list
        """
        return self.listOfDictionaries

    def csv(
        self,
        filepath=None
    ):
        """*Render the data in CSV format*

        **Key Arguments:**
            - ``filepath`` -- path to the file to write the csv content to. Default *None*

        **Return:**
            - ``renderedData`` -- the data rendered in csv format

        **Usage:**

            To render the data set as csv:

            .. code-block:: python

                print dataSet.csv()

            .. code-block:: text

                owner,pet,address
                daisy,dog,"belfast, uk"
                john,snake,the moon
                susan,crocodile,larne

            and to save the csv rendering to file:

            .. code-block:: python

                dataSet.csv("/path/to/myfile.csv")
        """
        self.log.info('starting the ``csv`` method')

        renderedData = self._list_of_dictionaries_to_csv("machine")

        if filepath and renderedData != "NO MATCH":

            writeFile = codecs.open(filepath, encoding='utf-8', mode='w')
            writeFile.write(renderedData)
            writeFile.close()

        self.log.info('completed the ``csv`` method')
        return renderedData

    def table(
        self,
        filepath=None
    ):
        """*Render the data as a  plain text table*

        **Key Arguments:**
            - ``filepath`` -- path to the file to write the table to. Default *None*

        **Return:**
            - ``renderedData`` -- the data rendered as a plain text table

        **Usage:**

            To render the data set as a plain text table:

            .. code-block:: python

                print dataSet.table()

            .. code-block:: text

                +--------+------------+--------------+
                | owner  | pet        | address      |
                +--------+------------+--------------+
                | daisy  | dog        | belfast, uk  |
                | john   | snake      | the moon     |
                | susan  | crocodile  | larne        |
                +--------+------------+--------------+

            and to save the table rendering to file:

            .. code-block:: python

                dataSet.table("/path/to/myfile.ascii")
        """
        self.log.info('starting the ``table`` method')

        self.filepath = filepath
        renderedData = self._list_of_dictionaries_to_csv("human")

        if filepath and len(self.listOfDictionaries):

            writeFile = codecs.open(filepath, encoding='utf-8', mode='w')
            writeFile.write(renderedData)
            writeFile.close()

        self.log.info('completed the ``table`` method')
        return renderedData

    def markdown(
        self,
        filepath=None
    ):
        """*Render the data as a markdown table*

        **Key Arguments:**
            - ``filepath`` -- path to the file to write the markdown to. Default *None*

        **Return:**
            - ``renderedData`` -- the data rendered as a markdown table

        **Usage:**

            To render the data set as a markdown table:

            .. code-block:: python

                print dataSet.markdown()

            .. code-block:: markdown

                | owner  | pet        | address      |
                |:-------|:-----------|:-------------|
                | daisy  | dog        | belfast, uk  |
                | john   | snake      | the moon     |
                | susan  | crocodile  | larne        |

            and to save the markdown table rendering to file:

            .. code-block:: python

                dataSet.table("/path/to/myfile.md")
        """
        self.log.info('starting the ``markdown`` method')

        self.filepath = filepath
        renderedData = self._list_of_dictionaries_to_csv("markdown")

        if filepath and len(self.listOfDictionaries):

            writeFile = codecs.open(filepath, encoding='utf-8', mode='w')
            writeFile.write(renderedData)
            writeFile.close()

        self.log.info('completed the ``markdown`` method')
        return renderedData

    def json(
        self,
        filepath=None
    ):
        """*Render the data in json format*

        **Key Arguments:**
            - ``filepath`` -- path to the file to write the json content to. Default *None*

        **Return:**
            - ``renderedData`` -- the data rendered as json

        **Usage:**

            To render the data set as json:

            .. code-block:: python

                print dataSet.json()

            .. code-block:: json

                [
                    {
                        "address": "belfast, uk",
                        "owner": "daisy",
                        "pet": "dog"
                    },
                    {
                        "address": "the moon",
                        "owner": "john",
                        "pet": "snake"
                    },
                    {
                        "address": "larne",
                        "owner": "susan",
                        "pet": "crocodile"
                    }
                ]

            and to save the json rendering to file:

            .. code-block:: python

                dataSet.json("/path/to/myfile.json")
        """
        self.log.info('starting the ``json`` method')

        dataCopy = copy.deepcopy(self.listOfDictionaries)
        for d in dataCopy:
            for k, v in d.iteritems():
                if isinstance(v,  datetime):
                    d[k] = v.strftime("%Y%m%dt%H%M%S")

        renderedData = json.dumps(
            dataCopy,
            separators=(',', ': '),
            sort_keys=True,
            indent=4
        )

        if filepath and len(self.listOfDictionaries):

            writeFile = codecs.open(filepath, encoding='utf-8', mode='w')
            writeFile.write(renderedData)
            writeFile.close()

        self.log.info('completed the ``json`` method')
        return renderedData

    def yaml(
        self,
        filepath=None
    ):
        """*Render the data in yaml format*

        **Key Arguments:**
            - ``filepath`` -- path to the file to write the yaml content to. Default *None*

        **Return:**
            - ``renderedData`` -- the data rendered as yaml

        **Usage:**

            To render the data set as yaml:

            .. code-block:: python

                print dataSet.yaml()

            .. code-block:: yaml

                - address: belfast, uk
                  owner: daisy
                  pet: dog
                - address: the moon
                  owner: john
                  pet: snake
                - address: larne
                  owner: susan
                  pet: crocodile

            and to save the yaml rendering to file:

            .. code-block:: python

                dataSet.json("/path/to/myfile.yaml")
        """
        self.log.info('starting the ``yaml`` method')

        dataCopy = []
        dataCopy[:] = [dict(l) for l in self.listOfDictionaries]
        renderedData = yaml.dump(dataCopy, default_flow_style=False)

        if filepath and len(self.listOfDictionaries):

            stream = file(filepath, 'w')
            yaml.dump(dataCopy, stream, default_flow_style=False)
            stream.close()

        self.log.info('completed the ``yaml`` method')
        return renderedData

    def mysql(
        self,
        tableName,
        filepath=None,
        createStatement=None
    ):
        """*Render the dataset as a series of mysql insert statements*

        **Key Arguments:**
            - ``tableName`` -- the name of the mysql db table to assign the insert statements to.
            - ``filepath`` -- path to the file to write the mysql inserts content to. Default *None*
            createStatement

        **Return:**
            - ``renderedData`` -- the data rendered mysql insert statements (string format)

        **Usage:**

            .. code-block:: python

                print dataSet.mysql("testing_table")

            this output the following:

            .. code-block:: plain

                INSERT INTO `testing_table` (address,dateCreated,owner,pet) VALUES ("belfast, uk" ,"2016-09-14T16:21:36" ,"daisy" ,"dog")  ON DUPLICATE KEY UPDATE  address="belfast, uk", dateCreated="2016-09-14T16:21:36", owner="daisy", pet="dog" ;
                INSERT INTO `testing_table` (address,dateCreated,owner,pet) VALUES ("the moon" ,"2016-09-14T16:21:36" ,"john" ,"snake")  ON DUPLICATE KEY UPDATE  address="the moon", dateCreated="2016-09-14T16:21:36", owner="john", pet="snake" ;
                INSERT INTO `testing_table` (address,dateCreated,owner,pet) VALUES ("larne" ,"2016-09-14T16:21:36" ,"susan" ,"crocodile")  ON DUPLICATE KEY UPDATE  address="larne", dateCreated="2016-09-14T16:21:36", owner="susan", pet="crocodile" ;

            To save this rendering to file use:

            .. code-block:: python

                dataSet.mysql("testing_table", "/path/to/myfile.sql")

        """
        self.log.info('starting the ``csv`` method')

        import re
        if createStatement and "create table if not exists" not in createStatement.lower():
            regex = re.compile(r'^\s*CREATE TABLE ', re.I | re.S)
            createStatement = regex.sub(
                "CREATE TABLE IF NOT EXISTS ", createStatement)

        renderedData = self._list_of_dictionaries_to_mysql_inserts(
            tableName=tableName,
            createStatement=createStatement
        )

        if filepath and len(self.listOfDictionaries):

            writeFile = codecs.open(filepath, encoding='utf-8', mode='w')
            writeFile.write(renderedData)
            writeFile.close()

        self.log.info('completed the ``csv`` method')
        return renderedData

    def _list_of_dictionaries_to_csv(
            self,
            csvType="human"):
        """Convert a python list of dictionaries to pretty csv output

        **Key Arguments:**
            - ``csvType`` -- human or machine

        **Return:**
            - ``output`` -- the contents of a CSV file
        """
        self.log.info('starting the ``_list_of_dictionaries_to_csv`` function')

        if not len(self.listOfDictionaries):
            return "NO MATCH"

        dataCopy = copy.deepcopy(self.listOfDictionaries)

        tableColumnNames = dataCopy[0].keys()
        columnWidths = []
        columnWidths[:] = [len(tableColumnNames[i])
                           for i in range(len(tableColumnNames))]

        output = io.BytesIO()
        # setup csv styles
        if csvType == "machine":
            delimiter = ","
        elif csvType in ["human", "markdown"]:
            delimiter = "|"
        writer = csv.writer(output, dialect='excel', delimiter=delimiter,
                            quotechar='"', quoting=csv.QUOTE_MINIMAL)

        if csvType in ["markdown"]:
            dividerWriter = csv.writer(output, dialect='excel', delimiter="|",
                                       quotechar='"', quoting=csv.QUOTE_MINIMAL)
        else:
            dividerWriter = csv.writer(output, dialect='excel', delimiter="+",
                                       quotechar='"', quoting=csv.QUOTE_MINIMAL)
        # add column names to csv
        header = []
        divider = []
        allRows = []

        # clean up data
        for row in dataCopy:
            for c in tableColumnNames:
                if isinstance(row[c], float) or isinstance(row[c], Decimal):
                    row[c] = "%0.4f" % row[c]
                elif isinstance(row[c], datetime):
                    thisDate = str(row[c])[:10]
                    row[c] = "%(thisDate)s" % locals()

        # set the column widths
        for row in dataCopy:
            for i, c in enumerate(tableColumnNames):
                if len(str(row[c])) > columnWidths[i]:
                    columnWidths[i] = len(str(row[c]))

        # fill in the data
        for row in dataCopy:
            thisRow = []
            # table border for human readable
            if csvType in ["human", "markdown"]:
                thisRow.append("")

            for i, c in enumerate(tableColumnNames):
                if csvType in ["human", "markdown"]:
                    if row[c] == None:
                        row[c] = ""
                    row[c] = str(str(row[c]).ljust(columnWidths[i] + 2)
                                 .rjust(columnWidths[i] + 3))
                thisRow.append(row[c])
            # table border for human readable
            if csvType in ["human", "markdown"]:
                thisRow.append("")
            allRows.append(thisRow)

        # table borders for human readable
        if csvType in ["human", "markdown"]:
            header.append("")
            divider.append("")

        for i, c in enumerate(tableColumnNames):
            if csvType == "machine":
                header.append(c)
            elif csvType in ["human", "markdown"]:
                header.append(
                    c.ljust(columnWidths[i] + 2).rjust(columnWidths[i] + 3))
                divider.append('-' * (columnWidths[i] + 3))

        # table border for human readable
        if csvType in ["human", "markdown"]:
            header.append("")
            divider.append("")

        if csvType == "machine":
            writer.writerow(header)
        if csvType in ["human"]:
            dividerWriter.writerow(divider)
            writer.writerow(header)
            dividerWriter.writerow(divider)
        elif csvType in ["markdown"]:
            writer.writerow(header)
            dividerWriter.writerow(divider)

        # write out the data
        writer.writerows(allRows)
        # table border for human readable
        if csvType in ["human"]:
            dividerWriter.writerow(divider)

        output = output.getvalue()
        output = output.strip()

        if csvType in ["markdown"]:
            output = output.replace("|--", "|:-")

        self.log.info(
            'completed the ``_list_of_dictionaries_to_csv`` function')

        return output

    def _list_of_dictionaries_to_mysql_inserts(
            self,
            tableName,
            createStatement=None):
        """Convert a python list of dictionaries to pretty csv output

        **Key Arguments:**
            - ``tableName`` -- the name of the table to create the insert statements for
            - ``createStatement`` -- add this create statement to the top of the file. Will only be executed if no table of that name exists in database. Default *None*

        **Return:**
            - ``output`` -- the mysql insert statements (as a string)
        """
        self.log.info(
            'starting the ``_list_of_dictionaries_to_mysql_inserts`` function')

        if not len(self.listOfDictionaries):
            return "NO MATCH"

        dataCopy = copy.deepcopy(self.listOfDictionaries)

        if createStatement:
            output = createStatement + "\n"
        else:
            output = ""

        for d in dataCopy:
            insertCommand = convert_dictionary_to_mysql_table(
                log=self.log,
                dictionary=d,
                dbTableName=tableName,
                uniqueKeyList=[],
                dateModified=False,
                returnInsertOnly=True,
                replace=True,
                batchInserts=False
            )
            output += insertCommand + ";\n"

        self.log.info(
            'completed the ``_list_of_dictionaries_to_mysql_inserts`` function')
        return output
