from __future__ import print_function
import os
import unittest
import shutil
import sys
import uuid
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



class test_batch_insert_statement(unittest.TestCase):
    """The SQL built by the batch insert worker, with writequery mocked."""

    TABLE = "ba`d%table"
    ROWS = [
        {"select": 1, "we`ird": 2, "100%": 3},
        {"select": 4, "we`ird": 5, "100%": 6},
    ]

    def setUp(self):
        self.insertModule = sys.modules[
            "fundamentals.mysql.insert_list_of_dictionaries_into_database_tables"
        ]

    def _build_sql(self, rows=None, replace=False, dateCreated=True):
        writequeryMock = mock.Mock(return_value="")
        with mock.patch.object(
            self.insertModule, "sharedList", [(rows or self.ROWS, 2)]
        ):
            with mock.patch.object(self.insertModule, "totalCount", 2):
                with mock.patch.object(self.insertModule, "globalDbConn", dbConn):
                    with mock.patch.object(
                        self.insertModule, "writequery", writequeryMock
                    ):
                        self.insertModule._insert_single_batch_into_database(
                            batchIndex=0,
                            log=log,
                            dbTableName=self.TABLE,
                            uniqueKeyList=[],
                            dateModified=False,
                            replace=replace,
                            batchSize=2500,
                            reDatetime=False,
                            dateCreated=dateCreated,
                        )
        return writequeryMock.call_args.kwargs

    def test_quotes_the_table_and_columns_and_doubles_percent_signs(self):
        # ACT
        sqlQuery = self._build_sql()["sqlQuery"]

        # ASSERT
        self.assertEqual(
            sqlQuery,
            "INSERT IGNORE INTO `ba``d%%table` (`100%%`,`select`,`we``ird`, dateCreated)"
            " VALUES (%s, %s, %s, NOW())",
        )

    def test_quotes_every_column_in_the_on_duplicate_key_update_clause(self):
        # ACT
        sqlQuery = self._build_sql(replace=True)["sqlQuery"]

        # ASSERT
        self.assertTrue(
            sqlQuery.endswith(
                " ON DUPLICATE KEY UPDATE `100%%`=VALUES(`100%%`),"
                " `select`=VALUES(`select`), `we``ird`=VALUES(`we``ird`),"
                " updated=1, dateLastModified=NOW()"
            ),
            sqlQuery,
        )

    def test_keeps_percent_signs_single_in_the_update_tail_when_pymysql_batches_the_rows(
        self,
    ):
        # ACT
        sqlQuery = self._build_sql(replace=True, dateCreated=False)["sqlQuery"]

        # ASSERT
        self.assertEqual(
            sqlQuery,
            "INSERT IGNORE INTO `ba``d%%table` (`100%%`,`select`,`we``ird`)"
            " VALUES (%s, %s, %s) ON DUPLICATE KEY UPDATE `100%`=VALUES(`100%`),"
            " `select`=VALUES(`select`), `we``ird`=VALUES(`we``ird`),"
            " updated=1, dateLastModified=NOW()",
        )

    def test_leaves_identifiers_untouched_when_they_contain_double_quotes(self):
        # ARRANGE
        rows = [{'a""b': 1, 'c"None"d': 2}]

        # ACT
        sqlQuery = self._build_sql(rows=rows)["sqlQuery"]

        # ASSERT
        self.assertIn('(`a""b`,`c"None"d`', sqlQuery)

    def test_binds_none_and_empty_values_as_null_and_keeps_none_and_null_text(self):
        # ARRANGE
        rows = [{"a": None, "b": "None", "c": "", "d": 0, "e": "null"}]

        # ACT
        values = self._build_sql(rows=rows)["manyValueList"]

        # ASSERT
        self.assertEqual(values, [(None, "None", None, 0, "null")])

    def test_raises_when_a_column_name_contains_a_nul_character(self):
        # ARRANGE
        rows = [{"a\x00b": 1}]

        # ACT / ASSERT
        with self.assertRaises(ValueError):
            self._build_sql(rows=rows)


class test_batch_insert_round_trip(unittest.TestCase):
    """Rows with awkward table and column names go through the real test database."""

    def setUp(self):
        from fundamentals.mysql import writequery

        self.tableName = "ut_dy2026_%s`_%%t" % uuid.uuid4().hex[:12]
        self.quotedTable = "`" + self.tableName.replace("`", "``") + "`"
        self.originalAutocommit = dbConn.get_autocommit()
        self.addCleanup(
            writequery,
            log=log,
            sqlQuery="DROP TABLE IF EXISTS %s;" % self.quotedTable,
            dbConn=dbConn,
        )
        self.addCleanup(dbConn.autocommit, self.originalAutocommit)

    def _insert(self, rows, replace, dateCreated):
        from fundamentals.mysql import insert_list_of_dictionaries_into_database_tables

        insert_list_of_dictionaries_into_database_tables(
            dbConn=dbConn,
            log=log,
            dictList=rows,
            dbTableName=self.tableName,
            uniqueKeyList=["select"],
            dateModified=True,
            dateCreated=dateCreated,
            batchSize=2,
            replace=replace,
        )

    def _select(self):
        from fundamentals.mysql import readquery

        dbConn.commit()
        return readquery(
            log=log,
            sqlQuery="SELECT `select`, `we``ird`, `100%` FROM "
            + self.quotedTable
            + " ORDER BY `select`;",
            dbConn=dbConn,
        )

    def test_inserts_rows_into_awkward_names_and_skips_duplicates_when_replace_is_false(
        self,
    ):
        for dateCreated in (True, False):
            with self.subTest(dateCreated=dateCreated):
                # ARRANGE
                self.tearDown_table()
                firstRows = [
                    {"select": i, "we`ird": i * 2, "100%": i * 3} for i in range(1, 6)
                ]
                secondRows = [{"select": 1, "we`ird": 99, "100%": 99}]

                # ACT
                self._insert(firstRows, replace=False, dateCreated=dateCreated)
                self._insert(secondRows + firstRows[1:2], False, dateCreated)

                # ASSERT
                self.assertEqual(
                    [(r["select"], r["we`ird"], r["100%"]) for r in self._select()],
                    [(i, i * 2, i * 3) for i in range(1, 6)],
                )

    def test_overwrites_duplicates_in_awkward_names_when_replace_is_true(self):
        for dateCreated in (True, False):
            with self.subTest(dateCreated=dateCreated):
                # ARRANGE
                self.tearDown_table()
                firstRows = [
                    {"select": i, "we`ird": i * 2, "100%": i * 3} for i in range(1, 6)
                ]
                secondRows = [
                    {"select": 1, "we`ird": 99, "100%": 98},
                    {"select": 2, "we`ird": 97, "100%": 96},
                    {"select": 3, "we`ird": 95, "100%": 94},
                ]

                # ACT
                self._insert(firstRows, replace=False, dateCreated=dateCreated)
                self._insert(secondRows, replace=True, dateCreated=dateCreated)

                # ASSERT
                self.assertEqual(
                    [(r["select"], r["we`ird"], r["100%"]) for r in self._select()],
                    [(1, 99, 98), (2, 97, 96), (3, 95, 94), (4, 8, 12), (5, 10, 15)],
                )

    def tearDown_table(self):
        from fundamentals.mysql import writequery

        writequery(
            log=log,
            sqlQuery="DROP TABLE IF EXISTS %s;" % self.quotedTable,
            dbConn=dbConn,
        )
