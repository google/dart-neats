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

import 'dart:async' show Future;
import 'package:test/test.dart';
import 'package:neat_periodic_task/neat_periodic_task.dart';
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
}
