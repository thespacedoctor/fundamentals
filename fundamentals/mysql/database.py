#!/usr/local/bin/python
# encoding: utf-8
"""
*a database object that can setup up a ssh tunnel (optional) and a database connection*

Author
: David Young
"""

from builtins import object
import os

os.environ["TERM"] = "vt100"
try:
    import readline
except ImportError:
    # Windows: readline not available in stdlib Optionally use pyreadline3 if installed
    try:
        import pyreadline3 as readline
    except ImportError:
        readline = None  # or just pass — basic input() still works
from fundamentals.ssh_tunnel import setup_ssh_tunnel


class database(object):
    """
    *a database object that can setup up a ssh tunnel (optional) and a database connection*

    **Key Arguments**

    - ``log`` -- logger
    - ``dbSettings`` -- a dictionary of database settings


    **Return**

    - ``dbConns`` -- a database connection


    **Usage**

    Given a python dictionary that looks like this:

    ```python
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
    ```

    ``loginPath`` and ``tunnel`` are optional, to setup the a database connection, run the following:

    ```python
    # SETUP ALL DATABASE CONNECTIONS
    from fundamentals.mysql import database
    dbConn = database(
        log=log,
        dbSettings=dbSettings
    ).connect()
    ```

    """

    # INITIALISATION

    def __init__(self, log, dbSettings=False, autocommit=True):
        self.log = log
        log.debug("instansiating a new '_database' object")
        self.dbSettings = dbSettings
        self.autocommit = autocommit

        return None

    def connect(self):
        """*Connect to the database*

        **Return**

        - ``dbConn`` -- the database connection


        See the class docstring for usage
        """

        self.log.debug("starting the ``connect`` method")

        import pymysql as ms

        dbSettings = self.dbSettings

        port = False
        if "tunnel" in dbSettings and dbSettings["tunnel"]:
            port = self._setup_tunnel(tunnelParameters=dbSettings["tunnel"])
        elif "port" in dbSettings and dbSettings["port"]:
            port = int(dbSettings["port"])

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
            charset="utf8mb4",
            local_infile=1,
            client_flag=ms.constants.CLIENT.MULTI_STATEMENTS,
            connect_timeout=36000,
            max_allowed_packet=51200000,
        )
        if self.autocommit:
            dbConn.autocommit(True)

        self.log.debug("completed the ``connect`` method")
        return dbConn

    def _setup_tunnel(self, tunnelParameters):
        """
        *Setup a ssh tunnel for a database connection to port through*

        **Key Arguments**

        - ``tunnelParameters`` -- the tunnel parameters found associated with the database settings


        **Return**

        - ``sshPort`` -- the port the ssh tunnel is connected via

        Raises ``fundamentals.ssh_tunnel.tunnel_error`` if the tunnel settings are invalid or the tunnel cannot be set up.
        """
        self.log.debug("starting the ``_setup_tunnel`` method")

        sshPort = setup_ssh_tunnel(tunnelParameters=tunnelParameters, log=self.log)

        self.log.debug("completed the ``_setup_tunnel`` method")
        return sshPort

    # xt-class-method
