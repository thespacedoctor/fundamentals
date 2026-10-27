#!/usr/bin/env python
# encoding: utf-8
"""
*given a sorted list of values, median sigma-clip values based on a window of values either side of each value (rolling window) and return the array mask*

Author
: David Young

Date Created
: January  1, 2021
"""

import os

os.environ["TERM"] = "vt100"


def rolling_window_sigma_clip(log, array, clippingSigma, windowSize):
    """*given a sorted list of values, median sigma-clip values based on a window of values either side of each value (rolling window) and return the array mask*

    **Key Arguments:**

    - `log` -- logger
    - `array` -- the array to clean up (arrays of length < 5 are not clipped but returned unmasked)
    - `clippingSigma` -- the minimum sigma to clip (using median-absolute distribution as sigma proxy)
    - `windowSize` -- the size of the window to use when calculating the median distribution (must be odd; window of 11 will use 5 values each side of the value in question)

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
    log.debug("starting the ``rolling_window_sigma_clip`` function")

    try:
        from astropy.stats import sigma_clip, mad_std
    except ImportError as e:
        message = (
            "rolling_window_sigma_clip requires astropy and numpy, "
            "install them with: pip install fundamentals[stats]"
        )
        log.error(message)
        raise ImportError(message) from e

    if windowSize % 2 == 0:
        message = "windowSize must be odd, got %s" % (windowSize,)
        log.error(message)
        raise ValueError(message)

    # ACCOMODATE SMALL LIST SIZES
    if len(array) < 5:
        return len(array) * [False]
    elif len(array) < windowSize:
        masked = sigma_clip(
            array,
            sigma_lower=clippingSigma,
            sigma_upper=clippingSigma,
            maxiters=7,
            cenfunc="median",
            stdfunc=mad_std,
        )
        return list(masked.mask)
    # THE WINDOW CENTRE IS THE ELEMENT WHOSE MASK IS TAKEN FROM EACH WINDOW
    windowCentre = windowSize // 2
    numWindows = len(array) - windowSize + 1
    maskedArray = []
    for startOfWindow in range(numWindows):
        arrayWindow = array[startOfWindow : startOfWindow + windowSize]
        masked = sigma_clip(
            arrayWindow,
            sigma_lower=clippingSigma,
            sigma_upper=clippingSigma,
            maxiters=7,
            cenfunc="median",
            stdfunc=mad_std,
        )
        windowMask = masked.mask.tolist()

        if startOfWindow == 0:
            # HEAD: 0,1,2...windowCentre-1
            maskedArray += windowMask[:windowCentre]
        maskedArray += [windowMask[windowCentre]]
        if startOfWindow == numWindows - 1:
            # TAIL: -windowCentre...-2,-1
            maskedArray += windowMask[windowCentre + 1 :]

    log.debug("completed the ``rolling_window_sigma_clip`` function")
    return maskedArray
