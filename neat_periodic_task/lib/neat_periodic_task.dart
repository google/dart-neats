// Copyright 2019 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

library neat_periodic_task;

import 'dart:async' show Future, Completer, scheduleMicrotask, TimeoutException;
import 'package:retry/retry.dart' show RetryOptions;
import 'package:logging/logging.dart' show Logger;
import 'package:slugid/slugid.dart' show Slugid;
import 'src/neat_status.dart' show NeatTaskStatus;

final _log = Logger('neat_periodic_task');

/// Abstractions for getting and setting task status.
///
/// This must abstract some optimistically consistent piece of a data storage
/// service. The [get] method returns the current status file, and if the
/// current status file has not changed when [set] is called, the status is
/// updated and [set] return true.
///
/// Notice that the definition above makes this object stateful, as it must
/// remember the value last time it was read. This also means that a specific
/// instance of [NeatStatusProvider] must only be given to one
/// [NeatPeriodicTaskScheduler].
///
/// Generally, services like Google Cloud Storage offers an `etag` that enables
/// optimistic concurrency. Hence, an object implementing this interface would
/// only need to store the `etag` and make all updates conditional.
abstract class NeatStatusProvider {
  /// Get the current status file.
  ///
  /// Returns the current status file, or `null` if no status file has ever
  /// been written.
  Future<List<int>?> get();

  /// Set the current status file, if status file have not been changed since
  /// last time it was read.
  ///
  /// Returns `true`, if the status file has not changed since last time [get]
  /// was called, and the status file was successful updated. If the status
  /// file was changed, this should return `false` and avoid overwriting the
  /// status file.
  ///
  /// If no status file has ever been written, it should be overwritten and
  /// this should return `true`.
  ///
  /// **Note**, if implemented on top of Google Cloud Storage or similar this
  /// method should use a conditional `PUT` request, only updating the blob if
  /// the `etag` is unchanged from last time it was read.
  Future<bool> set(List<int> status);

  /// Wrap a [NeatStatusProvider] such that [get]/[set] are retried on any
  /// [Exception].
  ///
  /// While not ideal, fetching a status object is usually low-overhead, so
  /// unnecessary retries are cheap.
  static NeatStatusProvider withRetry(NeatStatusProvider provider,
          {RetryOptions options = const RetryOptions()}) =>
      _NeatStatusProviderWithRetry(provider, options);
}

class _InMemoryNeatStatusProvider implements NeatStatusProvider {
  List<int>? _value;

  @override
  Future<List<int>?> get() async => _value;

  @override
  Future<bool> set(List<int> status) async {
    _value = status;
    return true;
  }
}

class _NeatStatusProviderWithRetry extends NeatStatusProvider {
  final NeatStatusProvider _provider;
  final RetryOptions _r;
  _NeatStatusProviderWithRetry(this._provider, this._r);
  @override
  Future<List<int>?> get() =>
      _r.retry(() => _provider.get(), retryIf: (e) => e is Exception);
  @override
  Future<bool> set(List<int> status) =>
      _r.retry(() => _provider.set(status), retryIf: (e) => e is Exception);
}

/// Interface for a periodic task.
///
/// If the task fails it should throw an exception.
typedef NeatPeriodicTask = Future<void> Function();

/// A [NeatPeriodicTaskScheduler] runs a [NeatPeriodicTask] periodically.
///
/// This is intended to be robust way to schedule a periodic task. If the task
/// fails it will schedule the task again later. This will not crash if the task
/// consistently fails. Instead users should monitor for the continuous
/// verification that the task has completed successfully.
class NeatPeriodicTaskScheduler {
  final String _name;
  final Duration _interval;
  final Duration _timeout;
  final NeatPeriodicTask _task;
  final NeatStatusProvider _statusProvider;
  final Duration _minCycle;
  final Duration _maxCycle;

  bool _running = false;
  final _stopping = Completer<void>();
  final _stopped = Completer<void>();

  /// Create a [NeatPeriodicTaskScheduler].
  ///
  /// The [name] is used when writing log messages, notably it is written as
  /// `'### [ALIVE] neat-periodic-task: "<name>"'`, when the task is verified to
  /// have been completed within [interval] time from now. Thus, monitoring logs
  /// and alerting if this message does not appear at-least every `3 * interval`
  /// is a very robust way to alert about task failure.
  ///
  /// The [interval] is the time interval with which the [task] should be
  /// invoked. A new task will not be started until the previous task has
  /// finished, unless this takes longer than [timeout].
  ///
  /// If the system has multiple processes running the same task, a
  /// [NeatStatusProvider] can be used to synchronize task scheduling through
  /// a _status file_. Notice that the [NeatStatusProvider] interface is
  /// stateful, thus, it is always wrong to reuse an instance of
  /// [NeatStatusProvider].
  ///
  /// The [status] provider is effectively a light weight locking mechanism to
  /// prevent the task from running concurrently. However, this only holds if
  /// the task always completes or fails within [timeout], as it may otherwise
  /// be restarted.
  ///
  /// If the task fails consistently, it will be retried at [timeout] delay,
  /// this will continue indefinitely. Thus, it is sensible to pick a high
  /// [timeout], if the operation is expensive and this can be tolerated.
  NeatPeriodicTaskScheduler({
    required String name,
    required Duration interval,
    required Duration timeout,
    required NeatPeriodicTask task,
    NeatStatusProvider? status,
    Duration minCycle = const Duration(minutes: 5),
    Duration maxCycle = const Duration(hours: 3),
  })  : _name = name,
        _interval = interval,
        _timeout = timeout,
        _task = task,
        _statusProvider = status ?? _InMemoryNeatStatusProvider(),
        _minCycle = minCycle,
        _maxCycle = maxCycle {
    if (maxCycle <= minCycle) {
      throw ArgumentError.value(
          maxCycle, 'maxCycle', 'maxCycle must larger than minCycle');
    }
    if (interval < minCycle * 2) {
      throw ArgumentError.value(interval, 'interval',
          'interval must be large than 2 * minCycle for reasonable behavior');
    }
  }

  /// Start the scheduler.
  void start() {
    if (_running) {
      throw StateError('NeatPeriodicTaskScheduler for "$_name" is running');
    }
    _running = true;

    _log.fine(() => 'NeatPeriodicTaskScheduler "$_name" STARTING');
    scheduleMicrotask(_loop);
  }

  /// Stop the scheduler.
  ///
  /// This returns a [Future] that is completed when the scheduler has finished
  /// any on-going iterations. This will not abort an ongoing task, but it will
  /// stop further iterations of the task.
  Future<void> stop() async {
    if (!_stopping.isCompleted) {
      _stopping.complete();
    }
    _log.fine(() => 'NeatPeriodicTaskScheduler "$_name" STOPPING');
    return await _stopped.future;
  }

  Future<void> _loop() async {
    try {
      while (!_stopping.isCompleted) {
        await _iteration();
      }
    } catch (e, st) {
      _log.shout('iteration failed for "$_name"', e, st);
    } finally {
      if (!_stopping.isCompleted) {
        scheduleMicrotask(_loop);
      } else {
        _stopped.complete();
      }
    }
  }

  Future<NeatTaskStatus> _getStatus() async {
    final data = await _statusProvider.get();
    return NeatTaskStatus.deserialize(data);
  }

  /// Sleep, but stop sleeping if we are stopping.
  Future<void> _sleep(Duration delay) => Future.any([
        Future.delayed(delay),
        _stopping.future,
      ]);

  /// Do an iteration where we check the status and either sleep or attempt to
  /// claim the task and run.
  Future<void> _iteration() async {
    _log.finest(() => 'fetching status for "$_name"');
    final status = await _getStatus();
    if (status.version > NeatTaskStatus.currentVersion) {
      _log.warning(
          'status for "$_name" with newer version found, version: ${status.version}');
      await _sleep(_interval);
      return;
    }

    // Find time elapsed since last time the task started running.
    final now = DateTime.now().toUtc();
    final elapsed = now.difference(status.started);
    _log.finest(() => 'time elapsed since "$_name" was last started $elapsed');

    // If state is 'finished' the delay before next run is _interval, otherwise
    // we assume state is 'running' as delay is only _timeout.
    var delay = _interval;
    if (status.state != 'finished') {
      delay = _timeout;
    }

    // If delay isn't past yet, we sleep.
    if (elapsed < delay) {
      var d = delay ~/ 2;
      // Always sleep at least minCycle to ensure the iteration doesn't spin too
      // fast as we approach the next iteration.
      if (d < _minCycle) {
        d = _minCycle;
      }
      // Never sleep more than maxCycle, as we must wake-up and print a log line
      // that says we've checked the status of the task. Operators can either
      // monitor the message saying this was done, or they can monitor the
      // message saying that the status was monitored.
      if (d > _maxCycle) {
        d = _maxCycle;
      }
      if (status.state == 'finished') {
        _log.info('### [ALIVE] neat-periodic-task: "$_name"');
      }
      _log.finest(() => 'NeatPeriodicTaskScheduler "$_name" sleeps $d');
      await _sleep(d);

      // Return such that we do another _iteration() call..
      return;
    }

    // If elapsed >= delay, then we claim and run the task.
    await _claimAndRun(status.update(
      owner: Slugid.nice().toString(),
      state: 'running',
      started: now,
    ));
  }

  /// Claim the status and attempt to run.
  Future<void> _claimAndRun(NeatTaskStatus status) async {
    // Attempt to claim the task, if we're not the owner we failed to stop.
    _log.finest(() => 'Attempt to claim task status for "$_name"');
    final claimed = await _statusProvider.set(status.serialize());
    if (!claimed) {
      _log.finest(() => 'Failed to claim task status for "$_name"');
      return;
    }

    try {
      _log.info('### [START] neat-periodic-task: "$_name"');
      await _task().timeout(_timeout);
      _log.info('### [FINISHED] neat-periodic-task: "$_name"');
    } on TimeoutException {
      _log.shout(
          '### [FAILED] neat-periodic-task: "$_name", timeout exceeded!');
      return;
    } catch (e, st) {
      _log.shout('### [FAILED] neat-periodic-task: "$_name"', e, st);
      return;
    }

    _log.finest(() => 'Attempting to set finished status for "$_name"');
    final st = status.update(state: 'finished').serialize();
    if (!await _statusProvider.set(st)) {
      _log.warning(
        'Failed to set finished status for "$_name" '
        '-- not a problem if it only happens occasionally',
      );
    }
  }

  /// Trigger the task, if it's not already running.
  ///
  /// This attempts to claim the status and trigger the task, if it is not
  /// already running.
  ///
  /// Returns a [Future] that completes when the task is done.
  Future<void> trigger() async {
    _log.finest(() => 'NeatPeriodicTaskScheduler "$_name" trigger() called');
    final status = await _getStatus();

    // Find time elapsed since last time the task was started.
    final now = DateTime.now().toUtc();
    final elapsed = now.difference(status.started);

    // If not running, or timed-out we run the task again.
    if (status.state != 'running' || elapsed > _timeout) {
      await _claimAndRun(status.update(
        owner: Slugid.nice().toString(),
        state: 'running',
        started: now,
      ));
    } else {
      _log.info('trigger() call on "$_name" ignored, as task is running');
    }
  }
}
