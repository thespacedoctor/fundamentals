import os
import nose
import shutil
import yaml
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


class test_table_exists():

    def test_table_exists_function(self):

        from fundamentals.mysql import writequery
        sqlQuery = "CREATE TABLE `testing_table` (`id` INT NOT NULL, PRIMARY KEY (`id`))"
        writequery(
            log=log,
            sqlQuery=sqlQuery,
            dbConn=dbConn,
            Force=False,
            manyValueList=False
        )

        from fundamentals.mysql import table_exists
        tableName = "testing_table"
        this = table_exists(
            dbConn=dbConn,
            log=log,
            dbTableName=tableName
        )
        print "%(tableName)s exists: %(this)s" % locals()

        from fundamentals.mysql import writequery
        sqlQuery = "DROP TABLE `testing_table`;"
        writequery(
            log=log,
            sqlQuery=sqlQuery,
            dbConn=dbConn,
            Force=False,
            manyValueList=False
        )

    def test_table_exists_function02(self):

        from fundamentals.mysql import table_exists
        tableName = "stupid_named_table"
        this = table_exists(
            dbConn=dbConn,
            log=log,
            dbTableName=tableName
        )
        print "%(tableName)s exists: %(this)s" % locals()

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
