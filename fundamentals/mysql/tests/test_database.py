from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml
import pytest

pytestmark = pytest.mark.usefixtures("session_names")
# INJECTED BY THE session_names FIXTURE IN THE ROOT conftest.py (PYTEST ONLY)
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


class test_database(unittest.TestCase):

    def setUp(self):
        self.dbSettings = settings["database settings"]["unit_tests"]

    # def test_tunnel(self):

    #     from fundamentals.mysql import database
    #     db = database(
    #         log=log,
    #         dbSettings=dbSettings
    #     )
    #     sshPort = db._setup_tunnel(
    #         tunnelParameters=dbSettings["tunnel"]
    #     )

    #     return

    def test_no_tunnel(self):

        from fundamentals.mysql import database

        db = database(log=log, dbSettings=self.dbSettings).connect()

        return

    def test_database_function(self):

        # SETUP ALL DATABASE CONNECTIONS
        from fundamentals.mysql import database

        dbConn = database(log=log, dbSettings=self.dbSettings).connect()

        from fundamentals.mysql import readquery

        sqlQuery = """
            SELECT VERSION();
        """ % locals()
        rows = readquery(log=log, sqlQuery=sqlQuery, dbConn=dbConn, quiet=False)
        # print(rows)

    def test_database_function_exception(self):

        from fundamentals.mysql import database

        try:
            this = database(
                log=log, dbSettings=self.dbSettings, fakeKey="break the code"
            )
            this.get()
            assert False
        except Exception as e:
            assert True
            # print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
