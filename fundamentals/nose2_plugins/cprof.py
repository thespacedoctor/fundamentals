'''
Profile test execution using cProfile.
Config option ``sort`` can be used to change how profiling information
is presented.
'''
__all__ = ('Profiler',)

import logging
import cProfile
import pstats
from pyprof2calltree import convert, visualize
import nose2
import os

os.environ['PATH'] += ':/usr/local/bin'

log = logging.getLogger('.'.join(('nose2', 'plugins', __package__)))


class Profiler(nose2.events.Plugin):
    '''Profile the test run using cProfile'''

    configSection = 'profiler'
    commandLineSwitch = ('P', 'profile', 'Run test under cprofile')

    def __init__(self):
        self.sort = self.config.as_str('sort', 'cumulative')
        self.prof = None
        self.pfile = self.config.as_str('filename', '')
        self.cachegrind = self.config.as_str('cachegrind', '')

    def startTestRun(self, event):
        '''Setup profiler'''
        self.prof = cProfile.Profile()
        event.executeTests = self.prof.runcall

    def beforeSummaryReport(self, event):
        '''Output profiling results'''
        self.prof.disable()
        stats = pstats.Stats(self.prof, stream=event.stream).sort_stats(
            self.sort)
        event.stream.writeln(nose2.util.ln('Profiling results'))
        stats.print_stats()
        if self.pfile:
            stats.dump_stats(self.pfile)
        if self.cachegrind:
            visualize(self.prof.getstats())
