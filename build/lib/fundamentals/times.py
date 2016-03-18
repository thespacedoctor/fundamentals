#!/usr/local/bin/python
# encoding: utf-8
"""
*Some time functions to be used with logging etc*

:Author:
    David Young

:Date Created:
    February 26, 2016
"""
################# GLOBAL IMPORTS ####################
import sys
import os
os.environ['TERM'] = 'vt100'


def get_now_sql_datetime():
    """
    *A datetime stamp in MySQL format: ``YYYY-MM-DDTHH:MM:SS``*

    **Return:**
        - ``now`` -- current time and date in MySQL format

    **Usage:**
        .. code-block:: python 

            from fundamentals import times
            now = times.get_now_sql_datetime()
            print now

            # OUT: 2016-03-18T11:08:23 
    """
    ## > IMPORTS ##
    from datetime import datetime, date, time
    now = datetime.now()
    now = now.strftime("%Y-%m-%dT%H:%M:%S")

    return now


def calculate_time_difference(startDate, endDate):
    """
    *Return the time difference between two dates as a string*

    **Key Arguments:**
        - ``startDate`` -- the first date in YYYY-MM-DDTHH:MM:SS format
        - ``endDate`` -- the final date YYYY-MM-DDTHH:MM:SS format

    **Return:**
        - ``relTime`` -- the difference between the two dates in Y,M,D,h,m,s (string)

    **Usage:**
        .. code-block:: python 

            from fundamentals import times
            diff = times.calculate_time_difference(startDate="2015-10-13 10:02:12", endDate="2017-11-04 16:47:05")
            print diff

            # OUT: 2yrs 22dys 6h 44m 53s
    """
    ################ > IMPORTS ################
    from datetime import datetime
    from dateutil import relativedelta

    ################ > VARIABLE SETTINGS ######

    ################ >ACTION(S) ################
    if "T" not in startDate:
        startDate = startDate.strip().replace(" ", "T")
    if "T" not in endDate:
        endDate = endDate.strip().replace(" ", "T")
    startDate = datetime.strptime(startDate, '%Y-%m-%dT%H:%M:%S')
    endDate = datetime.strptime(endDate, '%Y-%m-%dT%H:%M:%S')
    d = relativedelta.relativedelta(endDate, startDate)

    relTime = ""
    if d.years > 0:
        relTime += str(d.years) + "yrs "
    if d.months > 0:
        relTime += str(d.months) + "mths "
    if d.days > 0:
        relTime += str(d.days) + "dys "
    if d.hours > 0:
        relTime += str(d.hours) + "h "
    if d.minutes > 0:
        relTime += str(d.minutes) + "m "
    if d.seconds > 0:
        relTime += str(d.seconds) + "s"
    ###############################

    if relTime == "":
        relTime = "0s"

    return relTime
