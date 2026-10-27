from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml
import sys
from unittest import mock
from fundamentals.utKit import utKit
from fundamentals import tools
from os.path import expanduser

home = expanduser("~")

packageDirectory = utKit("").get_project_root()
settingsFile = packageDirectory + "/test_settings.yaml"
# settingsFile = home + "/.config/soxspipe.recipes/soxspipe.recipes.yaml"
su = tools(
    arguments={"settingsFile": settingsFile},
    docString=__doc__,
    logLevel="DEBUG",
    options_first=False,
    projectName=None,
    defaultSettingsFile=False,
)
arguments, settings, log, dbConn = su.setup()

# SETUP AND TEARDOWN FIXTURE FUNCTIONS FOR THE ENTIRE MODULE
moduleDirectory = os.path.dirname(__file__)
utKit = utKit(moduleDirectory)
log, dbConn, pathToInputDir, pathToOutputDir = utKit.setupModule()
utKit.tearDownModule()

try:
    shutil.rmtree(pathToOutputDir)
except:
    pass
# COPY INPUT TO OUTPUT DIR
shutil.copytree(pathToInputDir, pathToOutputDir)

# Recursively create missing directories
if not os.path.exists(pathToOutputDir):
    os.makedirs(pathToOutputDir)

# xt-setup-unit-testing-files-and-folders

pathToSqlite = pathToInputDir + "/test.sqlite"


HEADJACK_DIRECTORY = "/tmp/headjack"


class test_sqlite2mysql(unittest.TestCase):

    def test_sqlite2mysql_does_not_create_tmp_headjack_directory(self):

        import fundamentals.mysql
        from fundamentals.mysql import sqlite2mysql

        realExists = os.path.exists
        realMakedirs = os.makedirs
        makedirsCalls = []

        def fakeExists(path):
            if str(path).startswith(HEADJACK_DIRECTORY):
                return False
            return realExists(path)

        def fakeMakedirs(path, *args, **kwargs):
            if str(path).startswith(HEADJACK_DIRECTORY):
                makedirsCalls.append(path)
                return None
            return realMakedirs(path, *args, **kwargs)

        this = sqlite2mysql(
            log=log,
            settings=settings,
            pathToSqlite=pathToSqlite,
            tablePrefix="Marvin",
            dbConn=dbConn,
        )
        sqliteModule = sys.modules["fundamentals.mysql.sqlite2mysql"]

        # PATCH ONLY THE MODULE'S OWN os REFERENCE, NOT THE GLOBAL os MODULE
        fakeOs = mock.Mock(wraps=os)
        fakeOs.path = mock.Mock(wraps=os.path)
        fakeOs.path.exists.side_effect = fakeExists
        fakeOs.makedirs.side_effect = fakeMakedirs

        with (
            mock.patch.object(sqliteModule, "writequery"),
            mock.patch.object(
                fundamentals.mysql, "insert_list_of_dictionaries_into_database_tables"
            ),
            mock.patch.object(sqliteModule, "os", fakeOs),
        ):
            this.convert_sqlite_to_mysql()

        self.assertEqual(makedirsCalls, [])

    def test_sqlite2mysql_function(self):

        from fundamentals.mysql import sqlite2mysql

        this = sqlite2mysql(
            log=log,
            settings=settings,
            pathToSqlite=pathToSqlite,
            tablePrefix="Marvin",
            dbConn=dbConn,
        )
        this.convert_sqlite_to_mysql()

    def test_sqlite2mysql_function_exception(self):

        from fundamentals.mysql import sqlite2mysql

        try:
            this = sqlite2mysql(
                log=log,
                settings=settings,
                pathToSqlite=pathToSqlite,
                fakeKey="break the code",
            )
            this.get()
            assert False
        except Exception as e:
            assert True
            # print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
