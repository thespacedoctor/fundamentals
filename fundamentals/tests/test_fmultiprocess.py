from __future__ import print_function
from builtins import str
import unittest
import unittest
import yaml
import time
import pytest

# xt-setup-unit-testing-files-and-folders


def f(n, anotherKeyword="nothing"):
    result = 0
    for x in range(10000):
        result += n * n * x
    return result


@pytest.mark.usefixtures("session_attributes")
class test_multiprocess(unittest.TestCase):

    def test_multiprocess_function(self):

        from fundamentals import fmultiprocess

        # DEFINE AN INPUT ARRAY
        inputArray = list(range(1000))
        t1 = time.time()
        result = fmultiprocess(
            log=self.log, function=f, inputArray=inputArray, anotherKeyword="cheese"
        )

        took = time.time() - t1
        print("Multiprocessing took: %(took)s" % locals())

        t2 = time.time()

        result = []
        for i in inputArray:
            result.append(f(i))
        took = time.time() - t2
        print("Serial processing took: %(took)s" % locals())

    def test_multiprocess_function_exception(self):

        from fundamentals import fmultiprocess

        try:
            this = fmultiprocess(
                log=self.log, settings=self.settings, fakeKey="break the code"
            )
            this.get()
            assert False
        except Exception as e:
            assert True
            print(str(e))

        # x-print-testpage-for-pessto-marshall-web-object

    # x-class-to-test-named-worker-function
