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

import 'dart:async' show Future, Completer;
import 'dart:convert' show json, utf8;
import 'package:test/test.dart';
import 'package:neat_periodic_task/neat_periodic_task.dart';
import 'package:neat_periodic_task/src/neat_status.dart';
import 'package:logging/logging.dart';
import 'package:collection/collection.dart' show ListEquality;

class _StatusStore {
  List<int>? _value;

  NeatStatusProvider provider() => _StatusStoreNeatStatusProvider(this);
}

class _StatusStoreNeatStatusProvider implements NeatStatusProvider {
  final _StatusStore _store;
  List<int>? _lastRead;
  _StatusStoreNeatStatusProvider(this._store);

  @override
  Future<List<int>?> get() async {
    await Future.delayed(Duration(milliseconds: 1));
    _lastRead = _store._value;
    return _lastRead;
  }

  @override
  Future<bool> set(List<int> status) async {
    await Future.delayed(Duration(milliseconds: 1));
    if (_store._value == null ||
        ListEquality().equals(_lastRead, _store._value)) {
      _store._value = status;
      _lastRead = status;
      return true;
    }
    return false;
  }
}

void main() {
  // Setup logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((r) => print(r));

  test('schedule periodic task', () async {
    var count = 0;
    final scheduler = NeatPeriodicTaskScheduler(
      name: 'test-task',
      interval: Duration(milliseconds: 500),
      timeout: Duration(milliseconds: 50),
      minCycle: Duration(milliseconds: 100),
      maxCycle: Duration(milliseconds: 250),
      task: () async {
        print('doing operation');
        await Future.delayed(Duration(milliseconds: 10));
        count++;
      },
    );

    scheduler.start();

    await Future.delayed(Duration(milliseconds: 1200));

    await scheduler.stop();

    expect(count, equals(3));
  });

  test('schedule periodic task with racing', () async {
    final statusStore = _StatusStore();

    var count = 0;
    final schedulerA = NeatPeriodicTaskScheduler(
      name: 'machine-A',
      interval: Duration(milliseconds: 500),
      timeout: Duration(milliseconds: 50),
      minCycle: Duration(milliseconds: 100),
      maxCycle: Duration(milliseconds: 250),
      status: statusStore.provider(),
      task: () async {
        print('doing operation A');
        await Future.delayed(Duration(milliseconds: 10));
        count++;
      },
    );

    final schedulerB = NeatPeriodicTaskScheduler(
      name: 'machine-B',
      interval: Duration(milliseconds: 500),
      timeout: Duration(milliseconds: 50),
      minCycle: Duration(milliseconds: 100),
      maxCycle: Duration(milliseconds: 250),
      status: statusStore.provider(),
      task: () async {
        print('doing operation B');
        await Future.delayed(Duration(milliseconds: 10));
        count++;
      },
    );

    schedulerA.start();
    await Future.delayed(Duration(milliseconds: 1000));
    schedulerB.start();
    await Future.delayed(Duration(milliseconds: 1000));
    await schedulerA.stop();
    await Future.delayed(Duration(milliseconds: 1200));
    await schedulerB.stop();

    expect(count, inInclusiveRange(6, 7));
  });

  test('heartbeat updates while task is running', () async {
    final statusStore = _StatusStore();
    final taskStarted = Completer<void>();
    final allowFinish = Completer<void>();

    final scheduler = NeatPeriodicTaskScheduler(
      name: 'heartbeat-test',
      interval: Duration(milliseconds: 500),
      timeout: Duration(seconds: 10),
      minCycle: Duration(milliseconds: 50),
      maxCycle: Duration(milliseconds: 100),
      heartbeatInterval: Duration(milliseconds: 30),
      heartbeatTimeout: Duration(milliseconds: 100),
      status: statusStore.provider(),
      task: () async {
        taskStarted.complete();
        await allowFinish.future;
      },
    );

    scheduler.start();
    await taskStarted.future;

    // Give it time to send a few heartbeats.
    await Future.delayed(Duration(milliseconds: 40));
    final status1 = NeatTaskStatus.deserialize(statusStore._value);
    expect(status1.state, equals('running'));
    expect(status1.heartbeat, isNotNull);

    await Future.delayed(Duration(milliseconds: 60));
    final status2 = NeatTaskStatus.deserialize(statusStore._value);
    expect(status2.state, equals('running'));
    expect(status2.heartbeat!.isAfter(status1.heartbeat!), isTrue);

    allowFinish.complete();
    await Future.delayed(Duration(milliseconds: 50));
    await scheduler.stop();

    final statusFinal = NeatTaskStatus.deserialize(statusStore._value);
    expect(statusFinal.state, equals('finished'));
  });

  test(
      'abandoned task with expired heartbeat is reclaimed without waiting for full timeout',
      () async {
    final statusStore = _StatusStore();
    final now = DateTime.now().toUtc();

    // Simulate an abandoned task that started 1 minute ago, last heartbeat 200ms ago.
    // Full timeout is 1 hour!
    final abandoned = NeatTaskStatus.create(
      state: 'running',
      started: now.subtract(Duration(minutes: 1)),
      heartbeat: now.subtract(Duration(milliseconds: 200)),
      owner: 'dead-worker',
    );
    statusStore._value = abandoned.serialize();

    var reclaimed = false;
    final scheduler = NeatPeriodicTaskScheduler(
      name: 'recovery-test',
      interval: Duration(seconds: 10),
      timeout: Duration(hours: 1),
      minCycle: Duration(milliseconds: 50),
      maxCycle: Duration(milliseconds: 100),
      heartbeatInterval: Duration(milliseconds: 30),
      heartbeatTimeout: Duration(milliseconds: 100),
      status: statusStore.provider(),
      task: () async {
        reclaimed = true;
      },
    );

    scheduler.start();
    await Future.delayed(Duration(milliseconds: 150));
    await scheduler.stop();

    expect(reclaimed, isTrue);
    final status = NeatTaskStatus.deserialize(statusStore._value);
    expect(status.state, equals('finished'));
    expect(status.owner, isNot(equals('dead-worker')));
  });

  test('trigger reclaims task if heartbeat is expired', () async {
    final statusStore = _StatusStore();
    final now = DateTime.now().toUtc();

    // Abandoned task with expired heartbeat, but overall timeout not reached.
    final abandoned = NeatTaskStatus.create(
      state: 'running',
      started: now.subtract(Duration(minutes: 1)),
      heartbeat: now.subtract(Duration(milliseconds: 200)),
      owner: 'dead-worker',
    );
    statusStore._value = abandoned.serialize();

    var ran = false;
    final scheduler = NeatPeriodicTaskScheduler(
      name: 'trigger-test',
      interval: Duration(seconds: 10),
      timeout: Duration(hours: 1),
      minCycle: Duration(milliseconds: 50),
      maxCycle: Duration(milliseconds: 100),
      heartbeatInterval: Duration(milliseconds: 30),
      heartbeatTimeout: Duration(milliseconds: 100),
      status: statusStore.provider(),
      task: () async {
        ran = true;
      },
    );

    await scheduler.trigger();
    expect(ran, isTrue);
    final status = NeatTaskStatus.deserialize(statusStore._value);
    expect(status.state, equals('finished'));
  });

  test('active task with healthy heartbeats is not stolen', () async {
    final statusStore = _StatusStore();
    final aStarted = Completer<void>();
    final allowAFinish = Completer<void>();
    var bRan = false;

    final schedulerA = NeatPeriodicTaskScheduler(
      name: 'machine-A',
      interval: Duration(seconds: 10),
      timeout: Duration(seconds: 5),
      minCycle: Duration(milliseconds: 50),
      maxCycle: Duration(milliseconds: 100),
      heartbeatInterval: Duration(milliseconds: 30),
      heartbeatTimeout: Duration(milliseconds: 100),
      status: statusStore.provider(),
      task: () async {
        aStarted.complete();
        await allowAFinish.future;
      },
    );

    final schedulerB = NeatPeriodicTaskScheduler(
      name: 'machine-B',
      interval: Duration(seconds: 10),
      timeout: Duration(seconds: 5),
      minCycle: Duration(milliseconds: 50),
      maxCycle: Duration(milliseconds: 100),
      heartbeatInterval: Duration(milliseconds: 30),
      heartbeatTimeout: Duration(milliseconds: 100),
      status: statusStore.provider(),
      task: () async {
        bRan = true;
      },
    );

    schedulerA.start();
    await aStarted.future;

    schedulerB.start();
    // Allow A to run for ~150ms while sending heartbeats every 30ms.
    // Since heartbeatTimeout is 100ms and A sends heartbeats every 30ms, B must not run.
    await Future.delayed(Duration(milliseconds: 150));
    expect(bRan, isFalse);

    allowAFinish.complete();
    await Future.delayed(Duration(milliseconds: 50));
    await schedulerA.stop();
    await schedulerB.stop();

    expect(bRan, isFalse);
    final status = NeatTaskStatus.deserialize(statusStore._value);
    expect(status.state, equals('finished'));
  });

  test('overall timeout terminates task even if heartbeats are active',
      () async {
    final statusStore = _StatusStore();
    final taskStarted = Completer<void>();

    final scheduler = NeatPeriodicTaskScheduler(
      name: 'timeout-override-test',
      interval: Duration(seconds: 10),
      timeout: Duration(milliseconds: 100),
      minCycle: Duration(milliseconds: 50),
      maxCycle: Duration(milliseconds: 100),
      heartbeatInterval: Duration(milliseconds: 20),
      heartbeatTimeout: Duration(milliseconds: 80),
      status: statusStore.provider(),
      task: () async {
        taskStarted.complete();
        // Hang indefinitely while heartbeats fire
        await Completer<void>().future;
      },
    );

    scheduler.start();
    await taskStarted.future;

    // After > 100ms, timeout should trigger and terminate task
    await Future.delayed(Duration(milliseconds: 200));
    await scheduler.stop();

    // Since timeout occurred, the task failed and was not marked 'finished'.
    final status = NeatTaskStatus.deserialize(statusStore._value);
    expect(status.state, equals('running'));
  });

  test(
      'task with active heartbeats is reclaimed if total duration exceeds timeout',
      () async {
    final statusStore = _StatusStore();
    final now = DateTime.now().toUtc();

    // Task started 200ms ago, but heartbeat is fresh (10ms ago).
    // However, total timeout is only 100ms!
    final stuckTask = NeatTaskStatus.create(
      state: 'running',
      started: now.subtract(Duration(milliseconds: 200)),
      heartbeat: now.subtract(Duration(milliseconds: 10)),
      owner: 'stuck-worker',
    );
    statusStore._value = stuckTask.serialize();

    var reclaimed = false;
    final scheduler = NeatPeriodicTaskScheduler(
      name: 'stuck-reclaim-test',
      interval: Duration(seconds: 10),
      timeout: Duration(milliseconds: 100),
      minCycle: Duration(milliseconds: 50),
      maxCycle: Duration(milliseconds: 100),
      heartbeatInterval: Duration(milliseconds: 20),
      heartbeatTimeout: Duration(milliseconds: 80),
      status: statusStore.provider(),
      task: () async {
        reclaimed = true;
      },
    );

    scheduler.start();
    await Future.delayed(Duration(milliseconds: 100));
    await scheduler.stop();

    expect(reclaimed, isTrue);
    final status = NeatTaskStatus.deserialize(statusStore._value);
    expect(status.state, equals('finished'));
    expect(status.owner, isNot(equals('stuck-worker')));
  });

  test(
      'status without heartbeat falls back to full timeout and is not prematurely reclaimed',
      () async {
    final statusStore = _StatusStore();
    final now = DateTime.now().toUtc();

    // Legacy status: started 200ms ago, NO heartbeat.
    // heartbeatTimeout is 100ms, but full timeout is 10 seconds!
    final legacyStatus = NeatTaskStatus(
      format: NeatTaskStatus.formatIdentifier,
      version: NeatTaskStatus.currentVersion,
      state: 'running',
      started: now.subtract(Duration(milliseconds: 200)),
      heartbeat: null,
      owner: 'legacy-worker',
    );
    statusStore._value = legacyStatus.serialize();

    var reclaimed = false;
    final scheduler = NeatPeriodicTaskScheduler(
      name: 'legacy-fallback-test',
      interval: Duration(seconds: 10),
      timeout: Duration(seconds: 10),
      minCycle: Duration(milliseconds: 50),
      maxCycle: Duration(milliseconds: 100),
      heartbeatInterval: Duration(milliseconds: 30),
      heartbeatTimeout: Duration(milliseconds: 100),
      status: statusStore.provider(),
      task: () async {
        reclaimed = true;
      },
    );

    scheduler.start();
    // Wait for longer than heartbeatTimeout (100ms)
    await Future.delayed(Duration(milliseconds: 250));
    await scheduler.stop();

    // Must NOT have reclaimed the task because legacy status lacks heartbeat!
    expect(reclaimed, isFalse);
    final status = NeatTaskStatus.deserialize(statusStore._value);
    expect(status.owner, equals('legacy-worker'));
    expect(status.state, equals('running'));
  });

  test('heartbeat timer is cancelled when task throws an exception', () async {
    final statusStore = _StatusStore();

    final scheduler = NeatPeriodicTaskScheduler(
      name: 'exception-cleanup-test',
      interval: Duration(seconds: 10),
      timeout: Duration(seconds: 5),
      minCycle: Duration(milliseconds: 50),
      maxCycle: Duration(milliseconds: 100),
      heartbeatInterval: Duration(milliseconds: 20),
      heartbeatTimeout: Duration(seconds: 10),
      status: statusStore.provider(),
      task: () async {
        await Future.delayed(Duration(milliseconds: 10));
        throw Exception('task failed');
      },
    );

    scheduler.start();
    await Future.delayed(Duration(milliseconds: 50));
    final statusAfterFailure = NeatTaskStatus.deserialize(statusStore._value);
    final lastHeartbeat = statusAfterFailure.heartbeat;

    // Wait more intervals; no more heartbeats should be written
    await Future.delayed(Duration(milliseconds: 80));
    final statusLater = NeatTaskStatus.deserialize(statusStore._value);
    expect(statusLater.heartbeat, equals(lastHeartbeat));

    await scheduler.stop();
  });

  test('loss of lock during heartbeat is handled gracefully without crashing',
      () async {
    final statusStore = _StatusStore();
    final taskStarted = Completer<void>();
    final allowFinish = Completer<void>();

    final scheduler = NeatPeriodicTaskScheduler(
      name: 'lock-loss-test',
      interval: Duration(seconds: 10),
      timeout: Duration(seconds: 5),
      minCycle: Duration(milliseconds: 50),
      maxCycle: Duration(milliseconds: 100),
      heartbeatInterval: Duration(milliseconds: 20),
      heartbeatTimeout: Duration(milliseconds: 80),
      status: statusStore.provider(),
      task: () async {
        taskStarted.complete();
        await allowFinish.future;
      },
    );

    scheduler.start();
    await taskStarted.future;

    // Simulate another worker stealing the lock while task is running
    final stolenStatus = NeatTaskStatus.create(
      state: 'running',
      started: DateTime.now().toUtc(),
      owner: 'thief-worker',
    );
    statusStore._value = stolenStatus.serialize();

    // Allow heartbeats to try to send while lock is stolen
    await Future.delayed(Duration(milliseconds: 60));

    // Finish task and stop scheduler
    allowFinish.complete();
    await Future.delayed(Duration(milliseconds: 30));
    await scheduler.stop();

    // The thief's lock should NOT have been overwritten with finished
    final currentStatus = NeatTaskStatus.deserialize(statusStore._value);
    expect(currentStatus.owner, equals('thief-worker'));
  });

  group('NeatTaskStatus serialization', () {
    test('round-trips with heartbeat', () {
      final now = DateTime.now().toUtc();
      final status = NeatTaskStatus.create(
        state: 'running',
        started: now,
        heartbeat: now.add(Duration(seconds: 1)),
        owner: 'test-owner',
      );
      final bytes = status.serialize();
      final decoded = NeatTaskStatus.deserialize(bytes);
      expect(decoded.format, equals(NeatTaskStatus.formatIdentifier));
      expect(decoded.version, equals(NeatTaskStatus.currentVersion));
      expect(decoded.state, equals('running'));
      expect(decoded.started, equals(now));
      expect(decoded.heartbeat, equals(now.add(Duration(seconds: 1))));
      expect(decoded.owner, equals('test-owner'));
    });

    test('deserializes legacy JSON without heartbeat field', () {
      final jsonMap = {
        'format': NeatTaskStatus.formatIdentifier,
        'version': 1,
        'state': 'running',
        'started': '2026-08-28T10:00:00.000Z',
        'owner': 'legacy-owner',
      };
      final bytes = json.fuse(utf8).encode(jsonMap);
      final decoded = NeatTaskStatus.deserialize(bytes);
      expect(decoded.format, equals(NeatTaskStatus.formatIdentifier));
      expect(decoded.state, equals('running'));
      expect(decoded.heartbeat, isNull);
      expect(decoded.owner, equals('legacy-owner'));
    });

    test('deserializes JSON with explicit null heartbeat', () {
      final jsonMap = {
        'format': NeatTaskStatus.formatIdentifier,
        'version': 1,
        'state': 'finished',
        'started': '2026-08-28T10:00:00.000Z',
        'heartbeat': null,
        'owner': 'legacy-owner',
      };
      final bytes = json.fuse(utf8).encode(jsonMap);
      final decoded = NeatTaskStatus.deserialize(bytes);
      expect(decoded.state, equals('finished'));
      expect(decoded.heartbeat, isNull);
    });
  });
}
