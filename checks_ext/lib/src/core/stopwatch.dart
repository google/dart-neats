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

import '../util.dart';

extension StopwatchChecksExt on Subject<Stopwatch> {
  /// The elapsed time measured by this stopwatch.
  Subject<Duration> get elapsed => has((s) => s.elapsed, 'elapsed');

  /// Expects that the stopwatch is currently running.
  void isRunning() {
    context.expect(() => ['is running'], (actual) {
      if (actual.isRunning) return null;
      return Rejection(
        actual: [
          'Stopwatch(running: false, elapsed: ${prettyPrintDuration(actual.elapsed)})',
        ],
        which: ['is not running'],
      );
    });
  }

  /// Expects that the stopwatch is not currently running.
  void isNotRunning() {
    context.expect(() => ['is not running'], (actual) {
      if (!actual.isRunning) return null;
      return Rejection(
        actual: [
          'Stopwatch(running: true, elapsed: ${prettyPrintDuration(actual.elapsed)})',
        ],
        which: ['is running'],
      );
    });
  }

  /// The elapsed time measured by this stopwatch in ticks.
  Subject<int> get elapsedTicks => has((s) => s.elapsedTicks, 'elapsedTicks');

  /// The elapsed time measured by this stopwatch in milliseconds.
  Subject<int> get elapsedMilliseconds =>
      has((s) => s.elapsedMilliseconds, 'elapsedMilliseconds');
}
