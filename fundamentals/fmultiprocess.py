
#!/usr/local/bin/python
# encoding: utf-8
"""
*A function to quickly add multiprocessing to any program*

:Author:
    David Young
"""


import os
os.environ['TERM'] = 'vt100'


def fmultiprocess(
        log,
        function,
        inputArray,
        poolSize=False,
        timeout=3600,
        turnOffMP=False,
        progressBar=False,
        mute=False,
        **kwargs):
    """multiprocess pool

    **Key Arguments**

    - ``log`` -- logger
    - ``function`` -- the function to multiprocess
    - ``inputArray`` -- the array to be iterated over
    - ``poolSize`` -- limit the number of CPU that are used in multiprocess job
    - ``timeout`` -- time in sec after which to raise a timeout error if the processes have not completed
    - ``turnOffMP`` -- turn off multiprocessing. Useful for profiling and debugging. Default **False**
    - ``progressBar`` -- add a progress bar
    - ``mute`` -- mute terminal output from child processes


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

    import multiprocess as mp
    import time
    import inspect
    from functools import partial
    import psutil
    import os
    import sys

    logFound = "log" in inspect.signature(function).parameters

    global theseBatches

    if turnOffMP == False:
        import psutil
        from multiprocess import cpu_count, Pool
        from ctypes import c_int32

        # DEFINTE POOL SIZE - NUMBER OF CPU CORES TO USE (BEST = ALL - 1)
        if not poolSize:
            poolSize = psutil.cpu_count()

        if mute:
            # MUTE STDOUT AND PRINTING TO TERMINAL
            def startFunc(log, l, c):
                global counter_lock
                global counter
                counter = c
                counter_lock = l
                import logging
                streamHandlers = [
                    h for h in log.handlers if not isinstance(h, logging.FileHandler)]
                streamHandlersLevel = [
                    h.level for h in log.handlers if not isinstance(h, logging.FileHandler)]
                [h.setLevel(logging.WARNING) for h in log.handlers if not isinstance(
                    h, logging.FileHandler)]
                sys.stdout = open(os.devnull, 'w')
        else:
            def startFunc(log, l, c):
                global counter_lock
                global counter
                counter = c
                counter_lock = l
                pass

        # COUNTER AND LOCK FOR PROGRESS BAR
        c = mp.Value(c_int32)
        l = mp.Lock()

        if poolSize:
            p = Pool(processes=poolSize, initializer=startFunc,
                     initargs=(log, l, c))
        else:
            p = Pool(initializer=startFunc, initargs=(log, l, c))

        cpuCount = psutil.cpu_count()
        chunksize = max(1, (len(inputArray) + 1) // (cpuCount * 3))

        if chunksize == 0:
            chunksize = 1

        def thisFunction(
                p):

            result = mapfunc(p)

            # WE CAN DO SOMETHING ELSE AFTER RUNNING OF SINGLE FUNCTIONS
            with counter_lock:
                counter.value += 1

            return result

        if logFound:
            mapfunc = partial(function, log=log, **kwargs)
        else:
            mapfunc = partial(function, **kwargs)

        if not timeout:
            # 1 HRS
            timeout = 60 * 60
        start_time = time.time()

        futureArray = p.map_async(
            thisFunction, inputArray, chunksize=chunksize)
        if progressBar:
            import tqdm
            with tqdm.tqdm(total=len(inputArray)) as pbar:
                while not futureArray.ready():
                    current_time = time.time()
                    if current_time > start_time + timeout:
                        raise TimeoutError(
                            f"The timeout limit of {timeout}s has been reached")
                    if c.value != 0:
                        with l:
                            increment = c.value
                            c.value = 0
                        pbar.update(n=increment)
                    time.sleep(0.5)
                if c.value != 0:
                    with l:
                        increment = c.value
                        c.value = 0
                    pbar.update(n=increment)

        try:
            resultArray = futureArray.get(timeout=timeout)
        except Exception as e:
            log.error(f"Multiprocessing error: {e}")
            raise

        p.close()
        p.join()

    else:
        resultArray = []

        if logFound:
            for i in inputArray:
                r = function(i, log=log, ** kwargs)
                resultArray.append(r)
        else:
            for i in inputArray:
                r = function(i, **kwargs)
                resultArray.append(r)

    log.debug('completed the ``multiprocess`` function')
    return resultArray
