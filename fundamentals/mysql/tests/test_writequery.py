import os
import nose2
import nose2
import unittest
import shutil
import yaml
from fundamentals.mysql import writequery
from fundamentals.utKit import utKit

from fundamentals import tools

su = tools(
    arguments={"settingsFile": None},
    docString=__doc__,
    logLevel="DEBUG",
    options_first=False,
    projectName="fundamentals"
)
arguments, settings, log, dbConn = su.setup()

# load settings
stream = file(
    "/Users/Dave/.config/fundamentals/fundamentals.yaml", 'r')
settings = yaml.load(stream)
stream.close()

# SETUP AND TEARDOWN FIXTURE FUNCTIONS FOR THE ENTIRE MODULE
moduleDirectory = os.path.dirname(__file__)
utKit = utKit(moduleDirectory)
log, dbConn, pathToInputDir, pathToOutputDir = utKit.setupModule()
utKit.tearDownModule()


class test_writequery(unittest.TestCase):

    def test_writequery_function(self):

        from fundamentals.mysql import writequery
        sqlQuery = "CREATE TABLE `testing_table` (`id` INT NOT NULL, PRIMARY KEY (`id`))"
        writequery(
            log=log,
            sqlQuery=sqlQuery,
            dbConn=dbConn,
            Force=False,
            manyValueList=False
        )

    def test_manyvalue_insert(self):
        from fundamentals.mysql import writequery
        sqlQuery = "CREATE TABLE `testing_table` (`id` INT NOT NULL, PRIMARY KEY (`id`))"
        writequery(
            log=log,
            sqlQuery=sqlQuery,
            dbConn=dbConn,
            Force=False,
            manyValueList=False
        )

        from fundamentals.mysql import writequery
        sqlQuery = """INSERT INTO testing_table (id) values (%s)"""
        writequery(
            log=log,
            sqlQuery=sqlQuery,
            dbConn=dbConn,
            Force=False,
            manyValueList=[(1,), (2,), (3,), (4,), (5,), (6,), (7,),
                           (8,), (9,), (10,), (11,), (12,), ]
        )

    def test_writequery_function_delete(self):

        from fundamentals.mysql import writequery
        sqlQuery = "DROP TABLE `testing_table`;"
        writequery(
            log=log,
            sqlQuery=sqlQuery,
            dbConn=dbConn,
            Force=False,
            manyValueList=False
        )

    def test_writequery_error_force(self):

        from fundamentals.mysql import writequery
        sqlQuery = "rubbish query;"
        writequery(
            log=log,
            sqlQuery=sqlQuery,
            dbConn=dbConn,
            Force=True,
            manyValueList=False
        )

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
