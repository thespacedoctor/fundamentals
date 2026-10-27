"""Tests that ``fmultiprocess`` tears its worker pool down however the map ends.

The tests are plain pytest functions and need no settings file or database.
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

import psutil
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


def is_pool_worker_candidate(child):
    """Return True for a running child that is not the interpreter's resource tracker.

    The first lock or pool a process creates starts one long-lived resource tracker. It is
    not a pool worker and is meant to outlive the call.
    """
    try:
        isTracker = any("resource_tracker" in part for part in child.cmdline())
        return (
            child.is_running()
            and child.status() != psutil.STATUS_ZOMBIE
            and not isTracker
        )
    except psutil.NoSuchProcess:
        return False


def live_children():
    return [
        child
        for child in psutil.Process().children(recursive=True)
        if is_pool_worker_candidate(child)
    ]


def children_still_alive_after_grace(pidsBefore):
    candidates = [child for child in live_children() if child.pid not in pidsBefore]
    _, stillAlive = psutil.wait_procs(candidates, timeout=WORKER_EXIT_GRACE_SECONDS)
    return [child for child in stillAlive if is_pool_worker_candidate(child)]


def stop_children_not_in(pidsBefore):
    """Stop every child this test started, so no worker outlives a failing test."""
    gc.collect()
    started = [child for child in live_children() if child.pid not in pidsBefore]
    for child in started:
        with contextlib.suppress(psutil.NoSuchProcess):
            child.kill()
    psutil.wait_procs(started, timeout=WORKER_EXIT_GRACE_SECONDS)


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


def test_fmultiprocess_stops_its_workers_when_a_task_raises(log, cyclic_gc_disabled):
    from fundamentals import fmultiprocess

    # ARRANGE
    pidsBefore = {child.pid for child in live_children()}

    try:
        # ACT
        with pytest.raises(ValueError, match="synthetic task failure"):
            fmultiprocess(
                log=log,
                function=task_that_fails_once,
                inputArray=list(range(8)),
                poolSize=2,
            )
        leaked = children_still_alive_after_grace(pidsBefore)

        # ASSERT
        assert leaked == []
    finally:
        stop_children_not_in(pidsBefore)


def test_fmultiprocess_stops_its_workers_when_three_calls_fail(log, cyclic_gc_disabled):
    from fundamentals import fmultiprocess

    # ARRANGE
    pidsBefore = {child.pid for child in live_children()}

    try:
        # ACT
        for _ in range(3):
            with pytest.raises(ValueError, match="synthetic task failure"):
                fmultiprocess(
                    log=log,
                    function=task_that_fails_once,
                    inputArray=list(range(8)),
                    poolSize=2,
                )
        leaked = children_still_alive_after_grace(pidsBefore)

        # ASSERT
        assert leaked == []
    finally:
        stop_children_not_in(pidsBefore)


def test_fmultiprocess_stops_its_workers_when_the_progress_bar_times_out(
    log, cyclic_gc_disabled
):
    from fundamentals import fmultiprocess

    # ARRANGE
    pidsBefore = {child.pid for child in live_children()}
    startTime = time.time()

    try:
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
        leaked = children_still_alive_after_grace(pidsBefore)

        # ASSERT: THE TEARDOWN RETURNED PROMPTLY AND LEFT NO WORKER BEHIND
        assert leaked == []
        assert time.time() - startTime < LONG_TASK_SECONDS / 2
    finally:
        stop_children_not_in(pidsBefore)


def test_fmultiprocess_stops_its_workers_when_get_times_out(log, cyclic_gc_disabled):
    from fundamentals import fmultiprocess

    # ARRANGE
    pidsBefore = {child.pid for child in live_children()}

    try:
        # ACT
        with pytest.raises(Exception, match=""):
            fmultiprocess(
                log=log,
                function=task_that_sleeps,
                inputArray=[1, 2],
                poolSize=2,
                timeout=1,
            )
        leaked = children_still_alive_after_grace(pidsBefore)

        # ASSERT
        assert leaked == []
    finally:
        stop_children_not_in(pidsBefore)


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
