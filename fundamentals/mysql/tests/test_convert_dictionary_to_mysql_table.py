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


class test_convert_dictionary_to_mysql_table():

    def test_convert_dictionary_to_mysql_table_function(self):
        dictionary = {"a newKey": "cool", "and another": "super cool",
                      "uniquekey1": "cheese", "uniqueKey2": "burgers"}
        from fundamentals.mysql import convert_dictionary_to_mysql_table
        message = convert_dictionary_to_mysql_table(
            dbConn=dbConn,
            log=log,
            dictionary=dictionary,
            dbTableName="testing_table",
            uniqueKeyList=["uniquekey1", "uniqueKey2"],
            createHelperTables=False,
            dateModified=False,
            returnInsertOnly=False
        )

    def test_return_inserts(self):
        dictionary = {"a newKey": "cool", "and another": "super cool",
                      "uniquekey1": "cheese", "uniqueKey2": "burgers"}
        from fundamentals.mysql import convert_dictionary_to_mysql_table
        message = convert_dictionary_to_mysql_table(
            dbConn=dbConn,
            log=log,
            dictionary=dictionary,
            dbTableName="testing_table",
            uniqueKeyList=["uniquekey1", "uniqueKey2"],
            createHelperTables=False,
            dateModified=False,
            returnInsertOnly=True
        )

        print message

    def test_return_inserts_non_batch(self):
        dictionary = {"a newKey": "cool", "and another": "super cool",
                      "uniquekey1": "cheese", "uniqueKey2": "burgers"}
        from fundamentals.mysql import convert_dictionary_to_mysql_table
        inserts = convert_dictionary_to_mysql_table(
            dbConn=dbConn,
            log=log,
            dictionary=dictionary,
            dbTableName="testing_table",
            uniqueKeyList=["uniquekey1", "uniqueKey2"],
            dateModified=False,
            returnInsertOnly=True,
            replace=True,
            batchInserts=False
        )

        print inserts

    # def test_convert_dictionary_to_mysql_table_function_exception(self):

    #     from fundamentals import convert_dictionary_to_mysql_table
    #     try:
    #         this = convert_dictionary_to_mysql_table(
    #             log=log,
    #             settings=settings,
    #             fakeKey="break the code"
    #         )
    #         this.get()
    #         assert False
    #     except Exception, e:
    #         assert True
    #         print str(e)

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
