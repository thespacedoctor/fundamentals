#!/usr/bin/env python
# encoding: utf-8
"""
*given a sorted list of values, median sigma-clip values based on a window of values either side of each value (rolling window) and return the array mask*

:Author:
    David Young

:Date Created:
    January  1, 2021
"""
from builtins import object
import sys
import os
os.environ['TERM'] = 'vt100'
from fundamentals import tools


def rolling_window_sigma_clip(
        log,
        array,
        clippingSigma,
        windowSize):
    """*given a sorted list of values, median sigma-clip values based on a window of values either side of each value (rolling window) and return the array mask*

    **Key Arguments:**

    - `log` -- logger
    - `array` -- the array to clean up (arrays of length < 5 are not clipped but returned unmasked)
    - `clippingSigma` -- the minimum sigma to clip (using median-absolute distribution as sigma proxy)
    - `windowSize` -- the size of the window to use when calculating the median distribution (window of 11 will use 5 values each side of the value in question)

    **Usage:**

    ```python
    from fundamentals.stats import rolling_window_sigma_clip
    arrayMask = rolling_window_sigma_clip(
        log=self.log,
        array=myArray,
        clippingSigma=2.2,
        windowSize=11)

    ## JUST KEEP UNMASKED VALUES
    try:
        myArray = [e for e, m in zip(
            myArray, arrayMask) if m == False]
    except:
        myArray = []
    ```           
    """
    log.debug('starting the ``rolling_window_sigma_clip`` function')

    from astropy.stats import sigma_clip, mad_std

    midWindow = int((windowSize + 1) / 2)
    # ACCOMODATE SMALL LIST SIZES
    if len(array) < 5:
        return len(array) * [False]
    elif len(array) < windowSize:
        masked = sigma_clip(
            array, sigma_lower=clippingSigma, sigma_upper=clippingSigma, maxiters=7, cenfunc='median', stdfunc=mad_std)
        return list(masked.mask)
    startOfWindow = 0
    endOfWindow = windowSize
    maskedArray = []
    dataIndex = 0
    while len(array) >= endOfWindow:
        arrayWindow = array[startOfWindow:endOfWindow]
        startOfWindow += 1
        endOfWindow += 1
        masked = sigma_clip(
            arrayWindow, sigma_lower=clippingSigma, sigma_upper=clippingSigma, maxiters=7, cenfunc='median', stdfunc=mad_std)

        if dataIndex == 0:
            # 0,1,2...midWindow-1
            maskedArray += list(masked.mask)[0:midWindow]
            dataIndex += midWindow
        elif len(array) == endOfWindow - 1:
            # -midWindow...-2,-1
            maskedArray += list(masked.mask)[-midWindow:]
            dataIndex += midWindow
        else:
            maskedArray += [list(masked.mask)[midWindow - 1]]
            dataIndex += 1

    log.debug('completed the ``rolling_window_sigma_clip`` function')
    return maskedArray
