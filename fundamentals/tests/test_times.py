from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml

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


class test_datetime_relative_to_now(unittest.TestCase):

    def test_reports_minutes_for_a_date_five_minutes_ago(self):
        from datetime import datetime, timedelta
        from fundamentals import times

        date = datetime.now() - timedelta(seconds=300)

        relTime = times.datetime_relative_to_now(date)

        self.assertEqual(relTime, " +5min")


# class test_times(unittest.TestCase):

#     def test_times_function(self):
#         kwargs = {}
#         kwargs["log"] = log
#         kwargs["settings"] = settings
#         # xt-kwarg_key_and_value

#         testObject = times(**kwargs)
#         testObject.get()

#         # x-print-testpage-for-pessto-marshall-web-object

#     # x-class-to-test-named-worker-function
