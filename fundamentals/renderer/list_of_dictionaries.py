#!/usr/local/bin/python
# encoding: utf-8
"""
*Render a python list of dictionaries in various list and markup formats*

:Author:
    David Young
"""
from builtins import str
from builtins import range
from builtins import object
import sys
import os
import io
import re
import codecs
import copy
import json
import yaml
from decimal import Decimal
from datetime import datetime
os.environ['TERM'] = 'vt100'
from fundamentals import tools
from fundamentals.mysql import convert_dictionary_to_mysql_table


class list_of_dictionaries(object):
    """
    *The dataset object is a list of python dictionaries. Using this class, the data can be rendered as various list and markup formats*

    **Key Arguments**

    - ``log`` -- logger
    - ``listOfDictionaries`` -- the list of dictionaries to render
    - ``reDatetime`` -- a pre-compiled datetime regex. Default *False*fss 


    **Usage**

    To initialise the dataset object:

    ```python
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
    ```

    """

    def __init__(
            self,
            log,
            listOfDictionaries,
            reDatetime=False
    ):
        self.log = log
        self.log.debug("instansiating a new 'list_of_dictionaries' object")
        self.listOfDictionaries = listOfDictionaries
        self.reDatetime = reDatetime

        return None

    @property
    def list(
            self):
        """*Returns the original list of dictionaries*

        **Usage**

        dataSet.list

        """
        return self.listOfDictionaries

    def csv(
        self,
        filepath=None
    ):
        """*Render the data in CSV format*

        **Key Arguments**

        - ``filepath`` -- path to the file to write the csv content to. Default *None*


        **Return**

        - ``renderedData`` -- the data rendered in csv format


        **Usage**

        To render the data set as csv:

        ```python
        print(dataSet.csv())
        ```

        ```text
        owner,pet,address
        daisy,dog,"belfast, uk"
        john,snake,the moon
        susan,crocodile,larne
        ```

        and to save the csv rendering to file:

        ```python
        dataSet.csv("/path/to/myfile.csv")
        ```

        """
        self.log.debug('starting the ``csv`` method')

        renderedData = self._list_of_dictionaries_to_csv("machine")

        if filepath and renderedData != "NO MATCH":

            # RECURSIVELY CREATE MISSING DIRECTORIES
            if not os.path.exists(os.path.dirname(filepath)):
                os.makedirs(os.path.dirname(filepath))

            writeFile = codecs.open(filepath, encoding='utf-8', mode='w')
            writeFile.write(renderedData)
            writeFile.close()

        self.log.debug('completed the ``csv`` method')
        return renderedData

    def table(
        self,
        filepath=None
    ):
        """*Render the data as a  plain text table*

        **Key Arguments**

        - ``filepath`` -- path to the file to write the table to. Default *None*


        **Return**

        - ``renderedData`` -- the data rendered as a plain text table


        **Usage**

        To render the data set as a plain text table:

        ```python
        print(dataSet.table())
        ```

        ```text
        +--------+------------+--------------+
        | owner  | pet        | address      |
        +========+============+==============+
        | daisy  | dog        | belfast, uk  |
        | john   | snake      | the moon     |
        | susan  | crocodile  | larne        |
        +--------+------------+--------------+
        ```

        and to save the table rendering to file:

        ```python
        dataSet.table("/path/to/myfile.ascii")
        ```

        """
        self.log.debug('starting the ``table`` method')

        self.filepath = filepath
        renderedData = self._list_of_dictionaries_to_csv("human")

        if filepath and len(self.listOfDictionaries):

            # RECURSIVELY CREATE MISSING DIRECTORIES
            if not os.path.exists(os.path.dirname(filepath)):
                os.makedirs(os.path.dirname(filepath))

            writeFile = codecs.open(filepath, encoding='utf-8', mode='w')
            writeFile.write(renderedData)
            writeFile.close()

        self.log.debug('completed the ``table`` method')
        return renderedData

    def reST(
        self,
        filepath=None
    ):
        """*Render the data as a  resturcturedText table*

        **Key Arguments**

        - ``filepath`` -- path to the file to write the table to. Default *None*


        **Return**

        - ``renderedData`` -- the data rendered as a resturcturedText table


        **Usage**

        To render the data set as a resturcturedText table:

        ```python
        print(dataSet.reST())
        ```

        ```text
        +--------+------------+--------------+
        | owner  | pet        | address      |
        +========+============+==============+
        | daisy  | dog        | belfast, uk  |
        +--------+------------+--------------+
        | john   | snake      | the moon     |
        +--------+------------+--------------+
        | susan  | crocodile  | larne        |
        +--------+------------+--------------+
        ```

        and to save the table rendering to file:

        ```python
        dataSet.reST("/path/to/myfile.rst")
        ```

        """
        self.log.debug('starting the ``table`` method')

        self.filepath = filepath
        renderedData = self._list_of_dictionaries_to_csv("reST")

        if filepath and len(self.listOfDictionaries):

            # RECURSIVELY CREATE MISSING DIRECTORIES
            if not os.path.exists(os.path.dirname(filepath)):
                os.makedirs(os.path.dirname(filepath))

            writeFile = codecs.open(filepath, encoding='utf-8', mode='w')
            writeFile.write(renderedData)
            writeFile.close()

        self.log.debug('completed the ``table`` method')
        return renderedData

    def markdown(
        self,
        filepath=None
    ):
        """*Render the data as a markdown table*

        **Key Arguments**

        - ``filepath`` -- path to the file to write the markdown to. Default *None*


        **Return**

        - ``renderedData`` -- the data rendered as a markdown table


        **Usage**

        To render the data set as a markdown table:

        ```python
        print(dataSet.markdown())
        ```

        ```markdown
        | owner  | pet        | address      |
        |:-------|:-----------|:-------------|
        | daisy  | dog        | belfast, uk  |
        | john   | snake      | the moon     |
        | susan  | crocodile  | larne        |
        ```

        and to save the markdown table rendering to file:

        ```python
        dataSet.table("/path/to/myfile.md")
        ```

        """
        self.log.debug('starting the ``markdown`` method')

        self.filepath = filepath
        renderedData = self._list_of_dictionaries_to_csv("markdown")

        if filepath and len(self.listOfDictionaries):

            # RECURSIVELY CREATE MISSING DIRECTORIES
            if not os.path.exists(os.path.dirname(filepath)):
                os.makedirs(os.path.dirname(filepath))

            writeFile = codecs.open(filepath, encoding='utf-8', mode='w')
            writeFile.write(renderedData)
            writeFile.close()

        self.log.debug('completed the ``markdown`` method')
        return renderedData

    def json(
        self,
        filepath=None
    ):
        """*Render the data in json format*

        **Key Arguments**

        - ``filepath`` -- path to the file to write the json content to. Default *None*


        **Return**

        - ``renderedData`` -- the data rendered as json


        **Usage**

        To render the data set as json:

        ```python
        print(dataSet.json())
        ```

        ```json
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
        ```

        and to save the json rendering to file:

        ```python
        dataSet.json("/path/to/myfile.json")
        ```

        """
        self.log.debug('starting the ``json`` method')

        dataCopy = copy.deepcopy(self.listOfDictionaries)
        for d in dataCopy:
            for k, v in list(d.items()):
                if isinstance(v,  datetime):
                    d[k] = v.strftime("%Y%m%dt%H%M%S")

        renderedData = json.dumps(
            dataCopy,
            separators=(',', ': '),
            sort_keys=True,
            indent=4
        )

        if filepath and len(self.listOfDictionaries):

            # RECURSIVELY CREATE MISSING DIRECTORIES
            if not os.path.exists(os.path.dirname(filepath)):
                os.makedirs(os.path.dirname(filepath))

            writeFile = codecs.open(filepath, encoding='utf-8', mode='w')
            writeFile.write(renderedData)
            writeFile.close()

        self.log.debug('completed the ``json`` method')
        return renderedData

    def yaml(
        self,
        filepath=None
    ):
        """*Render the data in yaml format*

        **Key Arguments**

        - ``filepath`` -- path to the file to write the yaml content to. Default *None*


        **Return**

        - ``renderedData`` -- the data rendered as yaml


        **Usage**

        To render the data set as yaml:

        ```python
        print(dataSet.yaml())
        ```

        ```yaml
        - address: belfast, uk
          owner: daisy
          pet: dog
        - address: the moon
          owner: john
          pet: snake
        - address: larne
          owner: susan
          pet: crocodile
        ```

        and to save the yaml rendering to file:

        ```python
        dataSet.json("/path/to/myfile.yaml")
        ```

        """
        self.log.debug('starting the ``yaml`` method')

        dataCopy = []
        dataCopy[:] = [dict(l) for l in self.listOfDictionaries]
        renderedData = yaml.dump(dataCopy, default_flow_style=False)

        if filepath and len(self.listOfDictionaries):

            # RECURSIVELY CREATE MISSING DIRECTORIES
            if not os.path.exists(os.path.dirname(filepath)):
                os.makedirs(os.path.dirname(filepath))

            stream = open(filepath, 'w')
            yaml.dump(dataCopy, stream, default_flow_style=False)
            stream.close()

        self.log.debug('completed the ``yaml`` method')
        return renderedData

    def mysql(
        self,
        tableName,
        filepath=None,
        createStatement=None
    ):
        """*Render the dataset as a series of mysql insert statements*

        **Key Arguments**

        - ``tableName`` -- the name of the mysql db table to assign the insert statements to.
        - ``filepath`` -- path to the file to write the mysql inserts content to. Default *None*
        createStatement


        **Return**

        - ``renderedData`` -- the data rendered mysql insert statements (string format)


        **Usage**

        ```python
        print(dataSet.mysql("testing_table"))
        ```

        this output the following:

        ```plain
        INSERT INTO `testing_table` (address,dateCreated,owner,pet) VALUES ("belfast, uk" ,"2016-09-14T16:21:36" ,"daisy" ,"dog")  ON DUPLICATE KEY UPDATE  address="belfast, uk", dateCreated="2016-09-14T16:21:36", owner="daisy", pet="dog" ;
        INSERT INTO `testing_table` (address,dateCreated,owner,pet) VALUES ("the moon" ,"2016-09-14T16:21:36" ,"john" ,"snake")  ON DUPLICATE KEY UPDATE  address="the moon", dateCreated="2016-09-14T16:21:36", owner="john", pet="snake" ;
        INSERT INTO `testing_table` (address,dateCreated,owner,pet) VALUES ("larne" ,"2016-09-14T16:21:36" ,"susan" ,"crocodile")  ON DUPLICATE KEY UPDATE  address="larne", dateCreated="2016-09-14T16:21:36", owner="susan", pet="crocodile" ;
        ```

        To save this rendering to file use:

        ```python
        dataSet.mysql("testing_table", "/path/to/myfile.sql")
        ```

        """
        self.log.debug('starting the ``mysql`` method')

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

            # RECURSIVELY CREATE MISSING DIRECTORIES
            if not os.path.exists(os.path.dirname(filepath)):
                os.makedirs(os.path.dirname(filepath))

            writeFile = open(filepath, mode='w')
            writeFile.write(renderedData)
            writeFile.close()

        self.log.debug('completed the ``mysql`` method')
        return renderedData

    def _list_of_dictionaries_to_csv(
            self,
            csvType="human"):
        """Convert a python list of dictionaries to pretty csv output

        **Key Arguments**

        - ``csvType`` -- human, machine or reST


        **Return**

        - ``output`` -- the contents of a CSV file

        """
        self.log.debug(
            'starting the ``_list_of_dictionaries_to_csv`` function')
        import unicodecsv as csv

        if not len(self.listOfDictionaries):
            return "NO MATCH"

        dataCopy = copy.deepcopy(self.listOfDictionaries)

        tableColumnNames = list(dataCopy[0].keys())
        columnWidths = []
        columnWidths[:] = [len(tableColumnNames[i])
                           for i in range(len(tableColumnNames))]

        output = io.BytesIO()
        # setup csv styles
        if csvType == "machine":
            delimiter = ","
        elif csvType in ["human", "markdown"]:
            delimiter = "|"
        elif csvType in ["reST"]:
            delimiter = "|"
        if csvType in ["markdown"]:
            writer = csv.writer(output, delimiter=delimiter,
                                quoting=csv.QUOTE_NONE, doublequote=False, quotechar='"', escapechar="\\", lineterminator="\n")
        else:
            writer = csv.writer(output, dialect='excel', delimiter=delimiter,
                                quotechar='"', quoting=csv.QUOTE_MINIMAL, lineterminator="\n")

        if csvType in ["markdown"]:
            dividerWriter = csv.writer(
                output, delimiter="|", quoting=csv.QUOTE_NONE, doublequote=False, quotechar='"', escapechar="\\", lineterminator="\n")
        else:
            dividerWriter = csv.writer(output, dialect='excel', delimiter="+",
                                       quotechar='"', quoting=csv.QUOTE_MINIMAL, lineterminator="\n")
        # add column names to csv
        header = []
        divider = []
        rstDivider = []
        allRows = []

        # clean up data
        for row in dataCopy:
            for c in tableColumnNames:
                if isinstance(row[c], float) or isinstance(row[c], Decimal):
                    row[c] = "%0.9g" % row[c]
                elif isinstance(row[c], datetime):
                    thisDate = str(row[c])[:10]
                    row[c] = "%(thisDate)s" % locals()

        # set the column widths
        for row in dataCopy:
            for i, c in enumerate(tableColumnNames):
                if len(str(row[c])) > columnWidths[i]:
                    columnWidths[i] = len(str(row[c]))

        # table borders for human readable
        if csvType in ["human", "markdown", "reST"]:
            header.append("")
            divider.append("")
            rstDivider.append("")

        for i, c in enumerate(tableColumnNames):
            if csvType == "machine":
                header.append(c)
            elif csvType in ["human", "markdown", "reST"]:
                header.append(
                    c.ljust(columnWidths[i] + 2).rjust(columnWidths[i] + 3))
                divider.append('-' * (columnWidths[i] + 3))
                rstDivider.append('=' * (columnWidths[i] + 3))

        # table border for human readable
        if csvType in ["human", "markdown", "reST"]:
            header.append("")
            divider.append("")
            rstDivider.append("")

        # fill in the data
        for row in dataCopy:
            thisRow = []
            # table border for human readable
            if csvType in ["human", "markdown", "reST"]:
                thisRow.append("")

            for i, c in enumerate(tableColumnNames):
                if csvType in ["human", "markdown", "reST"]:
                    if row[c] == None:
                        row[c] = ""
                    row[c] = str(str(row[c]).ljust(columnWidths[i] + 2)
                                 .rjust(columnWidths[i] + 3))
                thisRow.append(row[c])
            # table border for human readable
            if csvType in ["human", "markdown", "reST"]:
                thisRow.append("")
            allRows.append(thisRow)
            if csvType in ["reST"]:
                allRows.append(divider)

        if csvType == "machine":
            writer.writerow(header)
        if csvType in ["reST"]:
            dividerWriter.writerow(divider)
            writer.writerow(header)
            dividerWriter.writerow(rstDivider)
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
        try:
            output = output.decode("UTF-8")
        except:
            output = str(output)

        if csvType in ["markdown"]:
            output = output.replace("|--", "|:-")
        if csvType in ["reST"]:
            output = output.replace("|--", "+--").replace("--|", "--+")

        self.log.debug(
            'completed the ``_list_of_dictionaries_to_csv`` function')

        return output

    def _list_of_dictionaries_to_mysql_inserts(
            self,
            tableName,
            createStatement=None):
        """Convert a python list of dictionaries to pretty csv output

        **Key Arguments**

        - ``tableName`` -- the name of the table to create the insert statements for
        - ``createStatement`` -- add this create statement to the top of the file. Will only be executed if no table of that name exists in database. Default *None*


        **Return**

        - ``output`` -- the mysql insert statements (as a string)

        """
        self.log.debug(
            'completed the ````_list_of_dictionaries_to_mysql_inserts`` function')

        if not len(self.listOfDictionaries):
            return "NO MATCH"

        dataCopy = copy.deepcopy(self.listOfDictionaries)

        if createStatement:
            output = createStatement + "\n"
        else:
            output = ""

        inserts = []

        inserts = []
        inserts[:] = [convert_dictionary_to_mysql_table(log=self.log, dictionary=d, dbTableName=tableName, uniqueKeyList=[
        ], dateModified=False, returnInsertOnly=True, replace=True, batchInserts=False, reDatetime=self.reDatetime) for d in dataCopy]
        output += ";\n".join(inserts) + ";"

        self.log.debug(
            'completed the ``_list_of_dictionaries_to_mysql_inserts`` function')
        return output
