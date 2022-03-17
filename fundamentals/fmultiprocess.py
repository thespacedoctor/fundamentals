#!/usr/local/bin/python
# encoding: utf-8
"""
*A function to quickly add multiprocessing to any program*

:Author:
    David Young
"""
from __future__ import division
from past.utils import old_div
import sys
import os
os.environ['TERM'] = 'vt100'
from fundamentals import tools
from functools import partial
import inspect


def fmultiprocess(
        log,
        function,
        inputArray,
        poolSize=False,
        timeout=3600,
        turnOffMP=False,
        **kwargs):
    """multiprocess pool

    **Key Arguments**

    - ``log`` -- logger
    - ``function`` -- the function to multiprocess
    - ``inputArray`` -- the array to be iterated over
    - ``poolSize`` -- limit the number of CPU that are used in multiprocess job
    - ``timeout`` -- time in sec after which to raise a timeout error if the processes have not completed
    - ``turnOffMP`` -- turn off multiprocessing. Useful for profiling and debugging. Default **False**


    **Return**

    - ``resultArray`` -- the array of results


    **Usage**

    ```python
    from fundamentals import multiprocess
    # DEFINE AN INPUT ARRAY
    inputArray = range(10000)
    results = multiprocess(log=log, function=functionName, poolSize=10, timeout=300,
                          inputArray=inputArray, otherFunctionKeyword="cheese")
    ```

    """
    log.debug('starting the ``multiprocess`` function')

    logFound = False
    # PYTHON 3 VS 2 ..
    try:
        if "log" in inspect.getfullargspec(function)[0]:
            logFound = True
    except:
        if "log" in inspect.getargspec(function)[0]:
            logFound = True

    if turnOffMP == False:
        import psutil
        # import multiprocess as mp
        # mp.set_start_method('forkserver')
        from multiprocess import cpu_count, Pool

        # DEFINTE POOL SIZE - NUMBER OF CPU CORES TO USE (BEST = ALL - 1)
        if not poolSize:
            poolSize = psutil.cpu_count()

        if poolSize:
            p = Pool(processes=poolSize)
        else:
            p = Pool()

        cpuCount = psutil.cpu_count()
        chunksize = int(old_div((len(inputArray) + 1), (cpuCount * 3)))

        if chunksize == 0:
            chunksize = 1

        # chunksize = 1
        # MAP-REDUCE THE WORK OVER MULTIPLE CPU CORES
        if logFound:
            mapfunc = partial(function, log=log, **kwargs)
            resultArray = p.map_async(mapfunc, inputArray, chunksize=chunksize)
        else:
            mapfunc = partial(function, **kwargs)
            resultArray = p.map_async(mapfunc, inputArray, chunksize=chunksize)

        resultArray = resultArray.get(timeout=timeout)

        p.close()
        p.join()
        # p.terminate()

    else:
        resultArray = []

        if logFound:
            for i in inputArray:
                r = function(log, i, **kwargs)
                resultArray.append(r)
        else:
            for i in inputArray:
                r = function(i, **kwargs)
                resultArray.append(r)

    log.debug('completed the ``multiprocess`` function')
    return resultArray
