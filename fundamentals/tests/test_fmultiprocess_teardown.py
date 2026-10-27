"""Tests that ``fmultiprocess`` tears its worker pool down however the map ends.

The tests are plain pytest functions and need no settings file or database.

Each test finds the pool's workers through the ``pool_workers`` fixture, which records every
``multiprocess`` pool created during the test. Other child processes of the test run (for
example under pytest-xdist) are never counted, so the file is safe to run in parallel.
"""

import contextlib
import gc
import logging
import os
import signal
import subprocess
import sys
import textwrap
import time

import multiprocess
import multiprocess.pool as pool_module
import pytest

# HOW LONG A POOL WORKER GETS TO EXIT ON ITS OWN BEFORE IT COUNTS AS LEAKED
WORKER_EXIT_GRACE_SECONDS = 5.0
# THE ONE INPUT ON WHICH THE TASK RAISES, SO THE MAP FAILS PART-WAY THROUGH
FAILING_TASK_INPUT = 3
# A TASK THAT OUTLASTS ANY TIMEOUT USED HERE
LONG_TASK_SECONDS = 60
# HARD LIMIT FOR THE SUBPROCESS TESTS, SO A HANG FAILS THE TEST RATHER THAN THE SUITE
SUBPROCESS_HARD_TIMEOUT_SECONDS = 60

PACKAGE_ROOT = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
)


def task_that_fails_once(value, log):
    if value == FAILING_TASK_INPUT:
        raise ValueError("synthetic task failure")
    return value


def task_that_sleeps(value):
    time.sleep(LONG_TASK_SECONDS)
    return value


def task_that_doubles(value):
    return value * 2


@pytest.fixture
def log():
    return logging.getLogger("test_fmultiprocess_teardown")


@pytest.fixture
def cyclic_gc_disabled():
    """Turn the cyclic garbage collector off, so only explicit teardown frees the pool."""
    gc.collect()
    wasEnabled = gc.isenabled()
    gc.disable()
    try:
        yield
    finally:
        if wasEnabled:
            gc.enable()
        gc.collect()


class PoolWorkerTracker:
    """Records the pools created during a test and reports their workers that still run."""

    def __init__(self):
        self.pools = []

    def alive(self):
        return [
            worker
            for pool in self.pools
            for worker in list(getattr(pool, "_pool", []))
            if worker.is_alive()
        ]

    def alive_after_grace(self):
        deadline = time.time() + WORKER_EXIT_GRACE_SECONDS
        while self.alive() and time.time() < deadline:
            time.sleep(0.05)
        return self.alive()

    def kill_all(self):
        """Stop every worker this test started, so none outlives a failing test."""
        gc.collect()
        for worker in self.alive():
            with contextlib.suppress(Exception):
                worker.kill()
        self.alive_after_grace()


@pytest.fixture
def pool_workers(monkeypatch):
    tracker = PoolWorkerTracker()
    originalInit = pool_module.Pool.__init__

    def recordingInit(self, *args, **kwargs):
        # RECORD BEFORE CONSTRUCTION SO A POOL THAT FAILS PART-WAY IS STILL TRACKED
        tracker.pools.append(self)
        originalInit(self, *args, **kwargs)

    monkeypatch.setattr(pool_module.Pool, "__init__", recordingInit)
    try:
        yield tracker
    finally:
        tracker.kill_all()


def test_fmultiprocess_returns_results_in_input_order(log):
    from fundamentals import fmultiprocess

    # ARRANGE
    inputArray = list(range(10))

    # ACT
    results = fmultiprocess(
        log=log, function=task_that_doubles, inputArray=inputArray, poolSize=2
    )

    # ASSERT
    assert results == [value * 2 for value in inputArray]


def test_fmultiprocess_stops_its_workers_when_a_task_raises(
    log, cyclic_gc_disabled, pool_workers
):
    from fundamentals import fmultiprocess

    # ACT
    with pytest.raises(ValueError, match="synthetic task failure"):
        fmultiprocess(
            log=log,
            function=task_that_fails_once,
            inputArray=list(range(8)),
            poolSize=2,
        )

    # ASSERT: THE CALL REALLY STARTED A POOL, AND NONE OF ITS WORKERS STILL RUNS
    assert len(pool_workers.pools) == 1
    assert pool_workers.alive_after_grace() == []


def test_fmultiprocess_stops_its_workers_when_three_calls_fail(
    log, cyclic_gc_disabled, pool_workers
):
    from fundamentals import fmultiprocess

    # ACT
    for _ in range(3):
        with pytest.raises(ValueError, match="synthetic task failure"):
            fmultiprocess(
                log=log,
                function=task_that_fails_once,
                inputArray=list(range(8)),
                poolSize=2,
            )

    # ASSERT
    assert len(pool_workers.pools) == 3
    assert pool_workers.alive_after_grace() == []


def test_fmultiprocess_stops_its_workers_when_the_progress_bar_times_out(
    log, cyclic_gc_disabled, pool_workers
):
    from fundamentals import fmultiprocess

    # ARRANGE
    startTime = time.time()

    # ACT
    with pytest.raises(TimeoutError, match="timeout limit"):
        fmultiprocess(
            log=log,
            function=task_that_sleeps,
            inputArray=[1, 2],
            poolSize=2,
            timeout=1,
            progressBar=True,
        )
    elapsed = time.time() - startTime

    # ASSERT: THE TEARDOWN RETURNED PROMPTLY AND LEFT NO WORKER BEHIND
    assert len(pool_workers.pools) == 1
    assert elapsed < LONG_TASK_SECONDS / 2
    assert pool_workers.alive_after_grace() == []


def test_fmultiprocess_stops_its_workers_when_get_times_out(
    log, cyclic_gc_disabled, pool_workers
):
    from fundamentals import fmultiprocess

    # ARRANGE
    startTime = time.time()

    # ACT
    with pytest.raises(multiprocess.TimeoutError):
        fmultiprocess(
            log=log,
            function=task_that_sleeps,
            inputArray=[1, 2],
            poolSize=2,
            timeout=1,
        )
    elapsed = time.time() - startTime

    # ASSERT: THE TEARDOWN RETURNED PROMPTLY AND LEFT NO WORKER BEHIND
    assert len(pool_workers.pools) == 1
    assert elapsed < LONG_TASK_SECONDS / 2
    assert pool_workers.alive_after_grace() == []


def test_fmultiprocess_stops_its_workers_when_map_async_fails(
    log, cyclic_gc_disabled, pool_workers, monkeypatch
):
    from fundamentals import fmultiprocess

    # ARRANGE
    def failingMapAsync(self, *args, **kwargs):
        raise RuntimeError("synthetic map_async failure")

    monkeypatch.setattr(pool_module.Pool, "map_async", failingMapAsync)

    # ACT
    with pytest.raises(RuntimeError, match="synthetic map_async failure"):
        fmultiprocess(
            log=log, function=task_that_doubles, inputArray=[1, 2], poolSize=2
        )

    # ASSERT
    assert len(pool_workers.pools) == 1
    assert pool_workers.alive_after_grace() == []


def test_fmultiprocess_stops_started_workers_when_interrupted_while_building_the_pool(
    log, cyclic_gc_disabled, pool_workers, monkeypatch
):
    from fundamentals import fmultiprocess

    # ARRANGE: THE WORKERS START, THEN CTRL-C ARRIVES BEFORE THE POOL CONSTRUCTOR RETURNS
    originalRepopulate = pool_module.Pool._repopulate_pool

    def interruptedRepopulate(self):
        originalRepopulate(self)
        raise KeyboardInterrupt

    monkeypatch.setattr(pool_module.Pool, "_repopulate_pool", interruptedRepopulate)

    # ACT
    with pytest.raises(KeyboardInterrupt):
        fmultiprocess(
            log=log, function=task_that_doubles, inputArray=[1, 2], poolSize=2
        )

    # ASSERT: WORKERS REALLY STARTED, AND NONE OF THEM STILL RUNS
    assert sum(len(pool._pool) for pool in pool_workers.pools) >= 1
    assert pool_workers.alive_after_grace() == []


def test_fmultiprocess_terminates_the_pool_when_interrupted_during_clean_shutdown(
    log, cyclic_gc_disabled, pool_workers, monkeypatch
):
    from fundamentals import fmultiprocess

    # ARRANGE: THE MAP SUCCEEDS, THEN CTRL-C ARRIVES DURING THE FIRST join()
    originalJoin = pool_module.Pool.join
    originalTerminate = pool_module.Pool.terminate
    joinCalls = []
    terminateCalls = []

    def interruptedJoin(self):
        joinCalls.append(self)
        if len(joinCalls) == 1:
            raise KeyboardInterrupt
        originalJoin(self)

    def recordingTerminate(self):
        terminateCalls.append(self)
        originalTerminate(self)

    monkeypatch.setattr(pool_module.Pool, "join", interruptedJoin)
    monkeypatch.setattr(pool_module.Pool, "terminate", recordingTerminate)

    # ACT
    with pytest.raises(KeyboardInterrupt):
        fmultiprocess(
            log=log, function=task_that_doubles, inputArray=[1, 2], poolSize=2
        )

    # ASSERT: THE POOL WAS TERMINATED AND JOINED, AND NO WORKER SURVIVED
    assert len(terminateCalls) >= 1
    assert len(joinCalls) >= 2
    assert pool_workers.alive_after_grace() == []


INTERRUPT_SCRIPT = textwrap.dedent(
    """
    import logging
    import os
    import signal
    import sys
    import threading
    import time

    import psutil

    from fundamentals import fmultiprocess

    LONG_TASK_SECONDS = {longTask}
    INTERRUPT_AFTER_SECONDS = 2.0


    def sleepy(value):
        time.sleep(LONG_TASK_SECONDS)
        return value


    if __name__ == "__main__":
        log = logging.getLogger("interrupt_script")
        # RAISE KEYBOARDINTERRUPT IN THE MAIN THREAD WHILE THE MAP IS RUNNING. "GROUP" SIGNALS
        # THE WORKERS TOO, AS CTRL-C DOES; "SELF" SIGNALS ONLY THE PARENT
        if sys.argv[1] == "group":
            sendSignal = lambda: os.killpg(os.getpgrp(), signal.SIGINT)
        else:
            sendSignal = lambda: os.kill(os.getpid(), signal.SIGINT)
        threading.Timer(INTERRUPT_AFTER_SECONDS, sendSignal).start()
        try:
            fmultiprocess(
                log=log, function=sleepy, inputArray=[1, 2], poolSize=2, timeout=3600
            )
        except KeyboardInterrupt:
            print("INTERRUPTED", flush=True)
        children = [
            c for c in psutil.Process().children(recursive=True)
            if c.is_running() and c.status() != psutil.STATUS_ZOMBIE
            and not any("resource_tracker" in part for part in c.cmdline())
        ]
        print("LIVE_CHILDREN=%d" % len(children), flush=True)
    """
).format(longTask=LONG_TASK_SECONDS)


# "SELF" SIGNALS ONLY THE PARENT AND IS THE DISCRIMINATING CASE: IT FAILS ON THE OLD CODE, WHICH
# LEFT THE IDLE WORKERS RUNNING. "GROUP" SIGNALS THE WORKERS TOO, AS A REAL CTRL-C DOES; IT IS THE
# REALISTIC REGRESSION CASE AND PASSES ON BOTH THE OLD AND THE FIXED CODE
@pytest.mark.parametrize("signalTarget", ["self", "group"])
def test_fmultiprocess_tears_the_pool_down_and_returns_on_keyboard_interrupt(
    tmp_path, signalTarget
):
    # ARRANGE
    scriptPath = tmp_path / "interrupt_script.py"
    scriptPath.write_text(INTERRUPT_SCRIPT)
    env = dict(os.environ, PYTHONPATH=PACKAGE_ROOT)
    process = subprocess.Popen(
        [sys.executable, str(scriptPath), signalTarget],
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True,
        start_new_session=True,
    )

    # ACT
    try:
        stdout, stderr = process.communicate(timeout=SUBPROCESS_HARD_TIMEOUT_SECONDS)
    except subprocess.TimeoutExpired:
        os.killpg(process.pid, signal.SIGKILL)
        process.communicate()
        pytest.fail("fmultiprocess hung after KeyboardInterrupt")
    finally:
        with contextlib.suppress(ProcessLookupError):
            os.killpg(process.pid, signal.SIGKILL)

    # ASSERT: CONTROL RETURNED, THE INTERPRETER EXITED CLEANLY AND NO WORKER SURVIVED
    assert process.returncode == 0, stderr
    assert "INTERRUPTED" in stdout, stdout + stderr
    assert "LIVE_CHILDREN=0" in stdout, stdout + stderr
