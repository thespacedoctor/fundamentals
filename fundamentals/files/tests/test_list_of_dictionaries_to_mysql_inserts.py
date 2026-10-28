from __future__ import print_function
from builtins import str
import os
import unittest
import unittest
import yaml
import pickle
import pytest

# SETUP PATHS TO COMMON DIRECTORIES FOR TEST DATA
moduleDirectory = os.path.dirname(__file__)
pathToInputDir = moduleDirectory + "/input/"

pathToPickleFile = pathToInputDir + "/list-of-dictionaries.p"

listOfDictionaries = pickle.load(open(pathToPickleFile, "rb"))


@pytest.mark.usefixtures("session_attributes")
class test_list_of_dictionaries_to_mysql(unittest.TestCase):

    def test_list_of_dictionaries_to_mysql_function(self):

        from fundamentals.files.list_of_dictionaries_to_mysql_inserts import (
            list_of_dictionaries_to_mysql_inserts,
        )

        mysqlInserts = list_of_dictionaries_to_mysql_inserts(
            log=self.log, datalist=listOfDictionaries, tableName="my_new_table"
        )

    def test_list_of_dictionaries_to_mysql_function_exception(self):

        from fundamentals.files.list_of_dictionaries_to_mysql_inserts import (
            list_of_dictionaries_to_mysql_inserts,
        )

        try:
            this = list_of_dictionaries_to_mysql_inserts(
                log=self.log, settings=self.settings, fakeKey="break the code"
            )
            this.get()
            assert False
        except Exception as e:
            assert True
            print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
