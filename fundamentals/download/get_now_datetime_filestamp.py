#!/usr/local/bin/python
# encoding: utf-8
"""
*Generate the datetime stamp for filenames*

:Author:
    David Young

:Date Created:
    March 16, 2016
"""
################# GLOBAL IMPORTS ####################
import sys
import os
os.environ['TERM'] = 'vt100'
from fundamentals import tools


def get_now_datetime_filestamp(longTime=False):
    """
    *A datetime stamp to be appended to the end of filenames: ``YYYYMMDDtHHMMSS``*

    **Key Arguments:**
        - ``longTime`` -- make time string longer (more change of filenames being unique)

    **Return:**
        - ``now`` -- current time and date in filename format

    **Usage:**
        .. code-block:: python 

            from fundamentals.download import get_now_datetime_filestamp
            get_now_datetime_filestamp(longTime=False)
            #Out: '20160316t154635'

            get_now_datetime_filestamp(longTime=True)
            #Out: '20160316t154644133638' 
    """
    ## > IMPORTS ##
    from datetime import datetime, date, time
    now = datetime.now()
    if longTime:
        now = now.strftime("%Y%m%dt%H%M%S%f")
    else:
        now = now.strftime("%Y%m%dt%H%M%S")

    return now
