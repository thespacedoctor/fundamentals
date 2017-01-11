#!/usr/local/bin/python
# encoding: utf-8
"""
*Take key-values from a yaml file including a tablename and add them to a mysql table*

:Author:
    David Young

:Date Created:
    January 10, 2017
"""
################# GLOBAL IMPORTS ####################
import sys
import os
import yaml
import requests
os.environ['TERM'] = 'vt100'
from fundamentals import tools


class yaml_to_database():
    """
    *The worker class for the yaml_to_database module*

    **Key Arguments:**
        - ``log`` -- logger
        - ``settings`` -- the settings dictionary
        - ``pathToInputDir`` -- path to the directory containing the yaml files that will be added to the database table(s)

    **Usage:**

        To setup your logger, settings and database connections, please use the ``fundamentals`` package (`see tutorial here <http://fundamentals.readthedocs.io/en/latest/#tutorial>`_). 

        To initiate a yaml_to_database object, use the following:

        .. todo::

            - add usage info
            - create a sublime snippet for usage
            - update the package tutorial if needed

        .. code-block:: python 

            usage code   
    """
    # Initialisation
    # 1. @flagged: what are the unique attrributes for each object? Add them
    # to __init__

    def __init__(
            self,
            log,
            pathToInputDir,
            settings=False,

    ):
        self.log = log
        log.debug("instansiating a new 'yaml_to_database' object")
        self.settings = settings
        self.pathToInputDir = pathToInputDir

        # xt-self-arg-tmpx

        # 2. @flagged: what are the default attrributes each object could have? Add them to variable attribute set here
        # Variable Data Atrributes

        # 3. @flagged: what variable attrributes need overriden in any baseclass(es) used
        # Override Variable Data Atrributes

        # Initial Actions

        return None

    # 4. @flagged: what actions does each object have to be able to perform? Add them here
    # Method Attributes
    def get(self):
        """
        *get the yaml_to_database object*

        **Return:**
            - ``yaml_to_database``

        **Usage:**
        .. todo::

            - add usage info
            - create a sublime snippet for usage
            - update the package tutorial if needed

        .. code-block:: python 

            usage code 
        """
        self.log.info('starting the ``get`` method')

        yaml_to_database = None

        self.log.info('completed the ``get`` method')
        return yaml_to_database

    def add_yaml_file_content_to_database(
        self,
        filepath
    ):
        """*given a file to a yaml file, add yaml file content to database*

        **Key Arguments:**
            # -

        **Return:**
            - None

        **Usage:**
            ..  todo::

                - add usage info
                - create a sublime snippet for usage
                - update package tutorial if needed

            .. code-block:: python 

                usage code 

        """
        self.log.info(
            'starting the ``add_yaml_file_content_to_database`` method')

        # OPEN THE FILE AND GET THE YAML CONTENT
        stream = file(filepath, 'r')
        yamlContent = yaml.load(stream)
        stream.close()

        if "kind" not in yamlContent:
            if "podcast" in yamlContent["table"]:
                yamlContent["kind"] = "audio"
            if "video" in yamlContent["table"]:
                yamlContent["kind"] = "video"
            if "reading-list" in yamlContent["table"]:
                yamlContent["kind"] = "webpage"

        # GET THE DATABASE TABLE NAME TO ENTER
        if "table" not in yamlContent:
            if yamlContent["kind"] == "video" or "podcast" in yamlContent["kind"]:
                dbTable = "podcasts"
            else:
                dbTable = "reading-list"
        dbTable = yamlContent["table"]
        del yamlContent["table"]

        # UNSHORTEN URL
        try:
            r = requests.head(yamlContent["url"], allow_redirects=True)
            yamlContent["url"] = r.url
        except:
            pass

        # RECODE INTO ASCII
        yamlContent["title"] = yamlContent["title"].encode("ascii", "dryx")
        yamlContent["original_yaml_path"] = filepath

        self.log.info(
            'completed the ``add_yaml_file_content_to_database`` method')
        return None

    # use the tab-trigger below for new method
    # xt-class-method

    # 5. @flagged: what actions of the base class(es) need ammending? ammend them here
    # Override Method Attributes
    # method-override-tmpx
