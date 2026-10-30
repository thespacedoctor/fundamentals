from __future__ import print_function
from builtins import str
import unittest
import unittest
import yaml
import pytest


@pytest.mark.usefixtures("session_attributes")
class test_database(unittest.TestCase):

    def setUp(self):
        self.dbSettings = self.settings["database settings"]["unit_tests"]

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

        db = database(log=self.log, dbSettings=self.dbSettings).connect()

        return

    def test_database_function(self):

        # SETUP ALL DATABASE CONNECTIONS
        from fundamentals.mysql import database

        dbConn = database(log=self.log, dbSettings=self.dbSettings).connect()

        from fundamentals.mysql import readquery

        sqlQuery = """
            SELECT VERSION();
        """ % locals()
        rows = readquery(log=self.log, sqlQuery=sqlQuery, dbConn=dbConn, quiet=False)
        # print(rows)

    def test_database_function_exception(self):

        from fundamentals.mysql import database

        try:
            this = database(
                log=self.log, dbSettings=self.dbSettings, fakeKey="break the code"
            )
            this.get()
            assert False
        except Exception as e:
            assert True
            # print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
