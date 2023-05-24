#!/usr/bin/env python
# encoding: utf-8
"""
*helper class to daemonise you code*

:Author:
    David Young

:Date Created:
    May 23, 2023
"""

from fundamentals import tools
from builtins import object
import sys
import os
os.environ['TERM'] = 'vt100'


class daemonise():
    """
    A class to daemonise a python code

    **Key Arguments:**
        - ``log`` -- logger
        - ``name`` -- a name for the daemon (e.g. python package name)

    **Usage:**

    Add something like this to your command-line usage:

    ```text
    Usage:
    myCommand (start|stop|restart|status)

    Options:
        start                 start the myCommand daemon
        stop                  stop the myCommand daemon
        restart               restart the myCommand daemon
        status                print the staus of the myCommand daemon 
    ```

    and then when executing the commands:

    ```python
    from fundamental import daemonise
    class myDaemon(daemonise):
        def action(
                self,
                **kwargs):
            self.log.info('starting the ``action`` method')

            anotherParameter = kwargs["anotherParameter"]

            import time
            while True:
                print(f"OVERRIDE ACTION - {anotherParameter}")
                time.sleep(3)

            self.log.info('completed the ``action`` method')
            return None

    d = myDaemon(log=log, name="gocart", anotherParameter=42.)

    if a['start']:
        d.start()
    elif a['stop']:
        d.stop()
    elif a['restart']:
        d.restart()
    elif a['status']:
        d.status()
    ```

    Replace `**akws` with any keywords you need.

    """

    def __init__(
            self,
            log,
            name,
            **akws
    ):
        self.log = log
        log.debug("instansiating a new 'daemonise' object")

        # MAKE ROOT DIR
        from os.path import expanduser
        home = expanduser("~")
        self.rootDir = home + "/.config/gocart/"
        if not os.path.exists(self.rootDir):
            os.makedirs(self.rootDir)

        self.name = name
        self.errLog = home + f"/.config/{name}/daemon_err.log"
        self.outLog = home + f"/.config/{name}/daemon.log"
        self.pidFile = home + f"/.config/{name}/daemon.pid"
        self.akws = akws

        return

    def start(self):
        """start the daemonise running
        """
        self.log.info('starting the ``get`` method')

        import time
        import signal
        from daemon import pidfile
        import daemon

        if os.path.exists(self.pidFile):
            with open(self.pidFile, mode='r') as f:
                pid = f.read().strip()
                print(f"{self.name} is already running (PID = {pid}).")
        else:
            print(f"{self.name} has been started.")
            print(f"The logs can be found here: {self.rootDir}")
            with daemon.DaemonContext(
                working_directory=self.rootDir,
                umask=0o002,
                pidfile=pidfile.TimeoutPIDLockFile(self.pidFile),
                stdout=open(self.outLog, 'a'),
                stderr=open(self.errLog, 'a'),
                signal_map={signal.SIGTERM: self.cleanup}
            ) as context:
                self.action(**self.akws)

        self.log.info('completed the ``get`` method')
        return None

    def cleanup(
            self,
            signum,
            frame):
        """*the code to run when daemon is killed*
        """
        self.log.debug('starting the ``cleanup`` method')

        from datetime import datetime, date, time
        now = datetime.now()
        now = now.strftime("%Y%m%dt%H%M%S")

        print(f"{self.name} stopped at {now}")
        sys.exit(0)

        self.log.debug('completed the ``cleanup`` method')
        return None

    def action(
            self,
            **akws):
        """*the code to execute in daemon mode, this method should be overriden to execute novel code*
        """
        self.log.debug('starting the ``action`` method')

        import time
        while True:
            print("ACTION")
            time.sleep(3)

        self.log.debug('completed the ``action`` method')
        return None

    def stop(
            self):
        """*stop the daemon and cleanup*
        """
        self.log.debug('starting the ``stop`` method')

        import signal

        if os.path.exists(self.pidFile):
            with open(self.pidFile, mode='r') as f:
                pid = f.read().strip()
            os.kill(int(pid), signal.SIGTERM)
            print(f"{self.name} has been stopped.")
        else:
            print(f"{self.name} is not running.")

        self.log.debug('completed the ``stop`` method')
        return None

    def status(
            self):
        """*print the status of the daemon*
        """
        self.log.debug('starting the ``status`` method')

        if os.path.exists(self.pidFile):
            with open(self.pidFile, mode='r') as f:
                pid = f.read().strip()
            print(f"{self.name} is running (PID = {pid}).")
        else:
            print(f"{self.name} is not running.")

        self.log.debug('completed the ``status`` method')
        return None

    def restart(
            self):
        """*stop and start the daemon*
        """
        self.log.debug('starting the ``status`` method')

        import time
        self.stop()

        iteration = 0
        while os.path.exists(self.pidFile) and iteration < 15:
            iteration += 1
            time.sleep(2)

        self.start()

        self.log.debug('completed the ``status`` method')
        return None
