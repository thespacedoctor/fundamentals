#!/usr/local/bin/python
# encoding: utf-8
"""
*A function to quickly add multiprocessing to any program*

:Author:
    David Young

:Date Created:
    November  9, 2017
"""
################# GLOBAL IMPORTS ####################
import sys
import os
os.environ['TERM'] = 'vt100'
from fundamentals import tools
from multiprocess import cpu_count, Pool
from functools import partial


def fmultiprocess(
        log,
        function,
        inputArray,
        **kwargs):
    """multiprocess pool

    **Key Arguments:**
        - ``log`` -- logger
        - ``function`` -- the function to multiprocess
        - ``inputArray`` -- the array to be iterated over

    **Return:**
        - ``resultArray`` -- the array of results

    **Usage:**

        .. code-block:: python 

            from fundamentals import multiprocess
            # DEFINE AN INPUT ARRAY
            inputArray = range(10000)
            results = multiprocess(log=log, function=functionName,
                                  inputArray=inputArray, otherFunctionKeyword="cheese")
    """
    log.info('starting the ``multiprocess`` function')

    # DEFINTE POOL SIZE - NUMBER OF CPU CORES TO USE (BEST = ALL - 1)
    if cpu_count() > 1:
        poolSize = cpu_count() - 1
    else:
        poolSize = 1
    p = Pool(processes=poolSize)

    # MAP-REDUCE THE WORK OVER MULTIPLE CPU CORES
    try:
        mapfunc = partial(function, log=log, **kwargs)
        resultArray = p.map(mapfunc, inputArray)
    except:
        mapfunc = partial(function, **kwargs)
        resultArray = p.map(mapfunc, inputArray)

    p.close()
    p.join()
    p.terminate()

    log.info('completed the ``multiprocess`` function')
    return resultArray
