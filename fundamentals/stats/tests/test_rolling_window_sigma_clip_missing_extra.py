import sys
import unittest
from unittest import mock

from fundamentals.logs import emptyLogger


def _hide_package(name):
    """*make a package, and every submodule already loaded, unimportable*"""
    for loaded in [m for m in sys.modules if m.split(".")[0] == name]:
        sys.modules[loaded] = None
    sys.modules[name] = None


def _forget_package(name):
    """*drop a package from the module cache so it must be imported afresh*"""
    for loaded in [m for m in sys.modules if m.split(".")[0] == name]:
        del sys.modules[loaded]


class test_rolling_window_sigma_clip_missing_extra(unittest.TestCase):

    def _clip(self):
        from fundamentals.stats import rolling_window_sigma_clip

        return rolling_window_sigma_clip(
            log=emptyLogger(),
            array=[1.0, 2.0, 3.0, 4.0, 5.0, 6.0],
            clippingSigma=2.2,
            windowSize=3,
        )

    def test_raises_import_error_naming_stats_extra_when_astropy_missing(self):
        with mock.patch.dict(sys.modules):
            _hide_package("astropy")

            with self.assertRaises(ImportError) as raised:
                self._clip()

        self.assertIn("pip install fundamentals[stats]", str(raised.exception))

    def test_raises_import_error_naming_stats_extra_when_numpy_missing(self):
        with mock.patch.dict(sys.modules):
            _forget_package("astropy")
            _hide_package("numpy")

            with self.assertRaises(ImportError) as raised:
                self._clip()

        self.assertIn("pip install fundamentals[stats]", str(raised.exception))


if __name__ == "__main__":
    unittest.main()
