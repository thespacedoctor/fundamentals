from __future__ import print_function
from builtins import str
import os
import unittest
import shutil
import unittest
import yaml
from fundamentals.utKit import utKit
from fundamentals import tools
from os.path import expanduser
home = expanduser("~")

packageDirectory = utKit("").get_project_root()
settingsFile = packageDirectory + "/test_settings.yaml"
# settingsFile = home + \
#     "/git_repos/_misc_/settings/fundamentals/test_settings.yaml"

su = tools(
    arguments={"settingsFile": settingsFile},
    docString=__doc__,
    logLevel="DEBUG",
    options_first=False,
    projectName=None,
    defaultSettingsFile=False
)
arguments, settings, log, dbConn = su.setup()

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


# xt-setup-unit-testing-files-and-folders
# xt-utkit-refresh-database

class test_rolling_window_sigma_clip(unittest.TestCase):

    def test_rolling_window_sigma_clip_function(self):
        import numpy as np
        import random
        normalDist = np.random.normal(loc=100, scale=3.0, size=[200])
        for i in range(1, 7):
            randNum = random.randint(1, 201)
            normalDist[randNum] = normalDist[randNum] * 4.5
        normalDist = list(normalDist)

        from fundamentals.stats import rolling_window_sigma_clip
        arrayMask = rolling_window_sigma_clip(
            log=log,
            array=normalDist,
            clippingSigma=2.2,
            windowSize=11)

        # JUST KEEP UNMASKED VALUES
        try:
            normalDist = [e for e, m in zip(
                normalDist, arrayMask) if m == False]
        except:
            normalDist = []

    def test_rolling_window_sigma_clip_function_exception(self):

        from fundamentals.stats import rolling_window_sigma_clip
        try:
            this = rolling_window_sigma_clip(
                log=log,
                settings=settings,
                fakeKey="break the code"
            )
            this.get()
            assert False
        except Exception as e:
            assert True
            print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
