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
}
