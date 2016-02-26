#!/usr/local/bin/python
# encoding: utf-8
"""
times.py
==================
:Summary:
    Some time functions to be used with logging etc

:Author:
    David Young

:Date Created:
    February 26, 2016

:dryx syntax:
    - ``_someObject`` = a 'private' object that should only be changed for debugging

:Notes:
    - If you have any questions requiring this script/module please email me: davidrobertyoung@gmail.com
"""
################# GLOBAL IMPORTS ####################
import sys
import os
os.environ['TERM'] = 'vt100'


def get_now_sql_datetime():
    """A datetime stamp in MySQL format:
        ``YYYY-MM-DDTHH:MM:SS``

        **Return:**
            - ``now`` -- current time and date in MySQL format
    """
    ## > IMPORTS ##
    from datetime import datetime, date, time
    now = datetime.now()
    now = now.strftime("%Y-%m-%dT%H:%M:%S")

    return now


def calculate_time_difference(startDate, endDate):
    """Return the time difference between two dates

    **Key Arguments:**
        - ``startDate`` -- the first date in YYYY-MM-DDTHH:MM:SS format
        - ``endDate`` -- the final date YYYY-MM-DDTHH:MM:SS format

    **Return:**
        - ``diffDate`` -- the difference between the two dates in Y,M,D,h,m,s (string)
    """
    ################ > IMPORTS ################
    from datetime import datetime
    from dateutil import relativedelta

    ################ > VARIABLE SETTINGS ######

    ################ >ACTION(S) ################
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
