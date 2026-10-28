from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml
import pickle
import pytest

pytestmark = pytest.mark.usefixtures("session_names")
# SET FOR THE MODULE BY THE session_names FIXTURE IN THE ROOT conftest.py
log = settings = None

# SETUP PATHS TO COMMON DIRECTORIES FOR TEST DATA
moduleDirectory = os.path.dirname(__file__)
pathToInputDir = moduleDirectory + "/input/"
pathToOutputDir = moduleDirectory + "/output/"

try:
    shutil.rmtree(pathToOutputDir)
except:
    pass
# COPY INPUT TO OUTPUT DIR
shutil.copytree(pathToInputDir, pathToOutputDir)

# Recursively create missing directories
if not os.path.exists(pathToOutputDir):
    os.makedirs(pathToOutputDir)

pathToPickleFile = pathToInputDir + "/list-of-dictionaries.p"

listOfDictionaries = pickle.load(open(pathToPickleFile, "rb"))


class test_list_of_dictionaries_to_mysql(unittest.TestCase):

    def test_list_of_dictionaries_to_mysql_function(self):

        from fundamentals.files.list_of_dictionaries_to_mysql_inserts import (
            list_of_dictionaries_to_mysql_inserts,
        )

        mysqlInserts = list_of_dictionaries_to_mysql_inserts(
            log=log, datalist=listOfDictionaries, tableName="my_new_table"
        )

    def test_list_of_dictionaries_to_mysql_function_exception(self):

        from fundamentals.files.list_of_dictionaries_to_mysql_inserts import (
            list_of_dictionaries_to_mysql_inserts,
        )

        try:
            this = list_of_dictionaries_to_mysql_inserts(
                log=log, settings=settings, fakeKey="break the code"
            )
            this.get()
            assert False
        except Exception as e:
            assert True
            print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
