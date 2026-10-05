// Copyright 2026 Google LLC
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

import 'package:checks_ext/src/core/stopwatch.dart';
import '../util.dart';

void main() {
  group('StopwatchChecks', () {
    test('properties extract correct values', () {
      final stopwatch = Stopwatch();
      check(stopwatch)
        ..isNotRunning()
        ..elapsed.equals(Duration.zero)
        ..elapsedTicks.equals(0)
        ..elapsedMilliseconds.equals(0);
    });

    test('reflects running state', () {
      final stopwatch = Stopwatch()..start();
      check(stopwatch).isRunning();
      stopwatch.stop();
      check(stopwatch).isNotRunning();
    });

    test('elapsed increases when running', () async {
      final stopwatch = Stopwatch()..start();
      // A short sleep to ensure some time elapses
      await Future.delayed(const Duration(milliseconds: 5));
      stopwatch.stop();

      check(stopwatch).elapsed.isGreaterThan(Duration.zero);
      check(stopwatch).elapsedMilliseconds.isGreaterThan(0);
    });
    testCheckGolden(
      () {
        final Stopwatch stopwatch = FakeStopwatch(
          isRunning: false,
          elapsed: Duration.zero,
        );
        check(stopwatch).isRunning();
      },
      '''
# isRunning failure message golden
Expected: a Stopwatch that:
  is running
Actual: Stopwatch(running: false, elapsed: 0s)
Which: is not running''',
    );

    testCheckGolden(
      () {
        final Stopwatch stopwatch = FakeStopwatch(
          isRunning: true,
          elapsed: const Duration(seconds: 5),
        );
        check(stopwatch).isNotRunning();
      },
      '''
# isNotRunning failure message golden
Expected: a Stopwatch that:
  is not running
Actual: Stopwatch(running: true, elapsed: 5s)
Which: is running''',
    );
  });
}

class FakeStopwatch implements Stopwatch {
  @override
  final bool isRunning;
  @override
  final Duration elapsed;

  FakeStopwatch({required this.isRunning, required this.elapsed});

  @override
  int get elapsedTicks => elapsed.inMicroseconds;
  @override
  int get elapsedMicroseconds => elapsed.inMicroseconds;
  @override
  int get elapsedMilliseconds => elapsed.inMilliseconds;
  @override
  int get frequency => 1000000;

  @override
  void start() {}
  @override
  void stop() {}
  @override
  void reset() {}
}
