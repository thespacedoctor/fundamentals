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
import inspect
import psutil


def fmultiprocess(
        log,
        function,
        inputArray,
        poolSize=False,
        timeout=3600,
        **kwargs):
    """multiprocess pool

    **Key Arguments:**
        - ``log`` -- logger
        - ``function`` -- the function to multiprocess
        - ``inputArray`` -- the array to be iterated over
        - ``poolSize`` -- limit the number of CPU that are used in multiprocess job
        - ``timeout`` -- time in sec after which to raise a timeout error if the processes have not completed

    **Return:**
        - ``resultArray`` -- the array of results

    **Usage:**

        .. code-block:: python 

            from fundamentals import multiprocess
            # DEFINE AN INPUT ARRAY
            inputArray = range(10000)
            results = multiprocess(log=log, function=functionName, poolSize=10, timeout=300,
                                  inputArray=inputArray, otherFunctionKeyword="cheese")
    """
    log.debug('starting the ``multiprocess`` function')

    # DEFINTE POOL SIZE - NUMBER OF CPU CORES TO USE (BEST = ALL - 1)
    if not poolSize:
        poolSize = psutil.cpu_count()

    if poolSize:
        p = Pool(processes=poolSize)
    else:
        p = Pool()

    cpuCount = psutil.cpu_count()
    chunksize = int((len(inputArray) + 1) / cpuCount * 3)

    if chunksize == 0:
        chunksize = 1

    # MAP-REDUCE THE WORK OVER MULTIPLE CPU CORES
    if "log" in inspect.getargspec(function)[0]:
        mapfunc = partial(function, log=log, **kwargs)
        resultArray = p.map_async(mapfunc, inputArray, chunksize=chunksize)
    else:
        mapfunc = partial(function, **kwargs)
        resultArray = p.map_async(mapfunc, inputArray, chunksize=chunksize)

    resultArray = resultArray.get(timeout=timeout)

    p.close()
    p.terminate()

    log.debug('completed the ``multiprocess`` function')
    return resultArray
