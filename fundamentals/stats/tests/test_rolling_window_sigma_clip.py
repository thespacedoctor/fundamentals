from __future__ import print_function
from builtins import str
import unittest
import unittest
import yaml
import pytest

# xt-setup-unit-testing-files-and-folders
# xt-utkit-refresh-database


@pytest.mark.usefixtures("session_attributes")
class test_rolling_window_sigma_clip(unittest.TestCase):

    def test_rolling_window_sigma_clip_function(self):
        import numpy as np
        import random

        normalDist = np.random.normal(loc=100, scale=3.0, size=[200])
        for i in range(1, 7):
            randNum = random.randint(1, 199)
            normalDist[randNum] = normalDist[randNum] * 4.5
        normalDist = list(normalDist)

        from fundamentals.stats import rolling_window_sigma_clip

        arrayMask = rolling_window_sigma_clip(
            log=self.log, array=normalDist, clippingSigma=2.2, windowSize=11
        )

        # JUST KEEP UNMASKED VALUES
        try:
            normalDist = [e for e, m in zip(normalDist, arrayMask) if m == False]
        except:
            normalDist = []

    def test_mask_length_matches_array_length_for_odd_window_sizes(self):
        import numpy as np
        from fundamentals.stats import rolling_window_sigma_clip

        rng = np.random.default_rng(42)
        pairs = [(11, 11), (12, 11), (20, 11), (5, 3)]
        for windowSize in [3, 5, 7, 11, 13]:
            for arrayLength in [windowSize, windowSize + 1, windowSize + 2, 20, 50]:
                if arrayLength >= 5:
                    pairs.append((arrayLength, windowSize))
        for arrayLength, windowSize in pairs:
            array = list(rng.normal(loc=100, scale=3.0, size=arrayLength))
            arrayMask = rolling_window_sigma_clip(
                log=self.log, array=array, clippingSigma=2.2, windowSize=windowSize
            )
            self.assertEqual(
                len(arrayMask),
                len(array),
                "windowSize=%s arrayLength=%s" % (windowSize, arrayLength),
            )

    def test_even_window_size_raises_value_error(self):
        from fundamentals.stats import rolling_window_sigma_clip

        array = [100.0 + (i % 5) for i in range(20)]
        with self.assertRaises(ValueError):
            rolling_window_sigma_clip(
                log=self.log, array=array, clippingSigma=2.2, windowSize=10
            )

    def test_odd_window_mask_matches_original_implementation_output(self):
        from fundamentals.stats import rolling_window_sigma_clip

        # EXPECTED MASK PRODUCED BY THE ORIGINAL (origin/develop) IMPLEMENTATION
        array = [100.0 + ((i * 7) % 11) - 5 for i in range(30)]
        array[1] = 160.0
        array[15] = 40.0
        array[28] = 170.0
        expectedMaskedIndices = [1, 15, 28]
        expectedMask = [i in expectedMaskedIndices for i in range(30)]

        arrayMask = rolling_window_sigma_clip(
            log=self.log, array=array, clippingSigma=2.2, windowSize=7
        )

        self.assertEqual(list(arrayMask), expectedMask)

    def test_rolling_window_sigma_clip_function_exception(self):

        from fundamentals.stats import rolling_window_sigma_clip

        try:
            this = rolling_window_sigma_clip(
                log=self.log, settings=self.settings, fakeKey="break the code"
            )
            this.get()
            assert False
        except Exception as e:
            assert True
            print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
