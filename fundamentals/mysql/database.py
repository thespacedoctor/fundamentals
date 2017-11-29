#!/usr/local/bin/python
# encoding: utf-8
"""
*a database object that can setup up a ssh tunnel (optional) and a database connection*

:Author:
    David Young

:Date Created:
    November 22, 2017
"""
################# GLOBAL IMPORTS ####################
import sys
import os
os.environ['TERM'] = 'vt100'
import readline
import glob
import pickle
import time
from subprocess import Popen, PIPE, STDOUT
import pymysql as ms
# import pymysql as ms
from docopt import docopt
from fundamentals.mysql import readquery


class database():
    """
    *a database object that can setup up a ssh tunnel (optional) and a database connection*

    **Key Arguments:**
        - ``log`` -- logger
        - ``dbSettings`` -- a dictionary of database settings

    **Return:**
        - ``dbConns`` -- a database connection

    **Usage:**

        Given a python dictionary that looks like this:

        .. code-block:: python 

            dbSettings = {
                'host': '127.0.0.1', 
                'loginPath': 'atlasMovers', 
                'user': 'monster', 
                'tunnel': {
                    'remote ip': 'psweb.mp.qub.ac.uk', 
                    'remote datbase host': 'dormammu', 
                    'remote user': 'monster', 
                    'port': 9006
                }, 
                'password': 'myPass', 
                'db': 'atlas_moving_objects'
            }

        ``loginPath`` and ``tunnel`` are optional, to setup the a database connection, run the following:

        .. code-block:: python 

            # SETUP ALL DATABASE CONNECTIONS
            from fundamentals.mysql import database
            dbConn = database(
                log=log,
                dbSettings=dbSettings
            ).connect()
    """
    # INITIALISATION

    def __init__(
            self,
            log,
            dbSettings=False,
            autocommit=True

    ):
        self.log = log
        log.debug("instansiating a new '_database' object")
        self.dbSettings = dbSettings
        self.autocommit = autocommit

        return None

    def connect(self):
        """connect to the database

        **Return:**
            - ``dbConn`` -- the database connection

        See the class docstring for usage
        """
        self.log.debug('starting the ``get`` method')

        dbSettings = self.dbSettings

        port = False
        if "tunnel" in dbSettings and dbSettings["tunnel"]:
            port = self._setup_tunnel(
                tunnelParameters=dbSettings["tunnel"]
            )

        # SETUP A DATABASE CONNECTION
        host = dbSettings["host"]
        user = dbSettings["user"]
        passwd = dbSettings["password"]
        dbName = dbSettings["db"]
        dbConn = ms.connect(
            host=host,
            user=user,
            passwd=passwd,
            db=dbName,
            port=port,
            use_unicode=True,
            charset='utf8'
        )
        if self.autocommit:
            dbConn.autocommit(True)

        self.log.debug('completed the ``get`` method')
        return dbConn

    def _setup_tunnel(
            self,
            tunnelParameters):
        """
        *setup a ssh tunnel for a database connection to port through*

        **Key Arguments:**
            - ``tunnelParameters`` -- the tunnel parameters found associated with the database settings

        **Return:**
            - ``sshPort`` -- the port the ssh tunnel is connected via
        """
        self.log.debug('starting the ``_setup_tunnel`` method')

        # TEST TUNNEL DOES NOT ALREADY EXIST
        sshPort = tunnelParameters["port"]
        connected = self._checkServer(
            "127.0.0.1", sshPort)
        if connected:
            self.log.debug('ssh tunnel already exists - moving on')
        else:
            # GRAB TUNNEL SETTINGS FROM SETTINGS FILE
            ru = tunnelParameters["remote user"]
            rip = tunnelParameters["remote ip"]
            rh = tunnelParameters["remote datbase host"]

            cmd = "ssh -fnN %(ru)s@%(rip)s -L %(sshPort)s:%(rh)s:3306" % locals()
            p = Popen(cmd, shell=True, close_fds=True)
            output = p.communicate()[0]
            self.log.debug('output: %(output)s' % locals())

            # TEST CONNECTION - QUIT AFTER SO MANY TRIES
            connected = False
            count = 0
            while not connected:
                connected = self._checkServer(
                    "127.0.0.1", sshPort)
                time.sleep(1)
                count += 1
                if count == 5:
                    self.log.error(
                        'cound not setup tunnel to remote datbase' % locals())
                    sys.exit(0)
        return sshPort

    def _checkServer(self, address, port):
        """Check that the TCP Port we've decided to use for tunnelling is available
        """
        self.log.debug('starting the ``_checkServer`` method')

        # CREATE A TCP SOCKET
        import socket
        s = socket.socket()
        self.log.debug(
            """Attempting to connect to `%(address)s` on port `%(port)s`""" % locals())
        try:
            s.connect((address, port))
            self.log.debug(
                """Connected to `%(address)s` on port `%(port)s`""" % locals())
            return True
        except socket.error, e:
            self.log.warning(
                """Connection to `%(address)s` on port `%(port)s` failed - try again: %(e)s""" % locals())
            return False

        return None

    # xt-class-method
