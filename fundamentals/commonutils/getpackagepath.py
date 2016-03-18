#!/usr/local/bin/python
# encoding: utf-8
"""
*Get the root path for this python package*

:Author:
    David Young

:Date Created:
    February 25, 2016
"""
import os


def getpackagepath():
    """
    *Get the root path for this python package*

    *Used in unit testing code*
    """
    moduleDirectory = os.path.dirname(__file__)
    packagePath = os.path.dirname(__file__) + "/../"

    return packagePath
