import os
import shutil
import tempfile


def pytest_configure(config):
    """
    *Point HOME at a throwaway directory for the whole test session*

    The test settings write the log file under ``~/.config``. Test modules set up logging while they are collected, so HOME has to change before collection starts. This stops the suite from failing when the real HOME cannot be written and from writing into the real one.
    """
    testHome = tempfile.mkdtemp(prefix="fundamentals_test_home_")
    previousHome = os.environ.get("HOME")
    os.environ["HOME"] = testHome

    def restore_home():
        if previousHome is None:
            os.environ.pop("HOME", None)
        else:
            os.environ["HOME"] = previousHome
        shutil.rmtree(testHome, ignore_errors=True)

    config.add_cleanup(restore_home)
