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

import 'package:checks/context.dart';

export 'package:checks/checks.dart';
export 'package:checks/context.dart';

extension Expect<T> on Subject<T> {
  void expectTrue(Description description, bool Function(T) predicate) =>
      context.expect(() => [description.positive], (s) {
        if (predicate(s)) return null;
        return Rejection(which: [description.negative]);
      });

  void expectFalse(Description description, bool Function(T) predicate) =>
      context.expect(() => [description.negative], (s) {
        if (!predicate(s)) return null;
        return Rejection(which: [description.positive]);
      });
}

typedef Description = ({String positive, String negative});

String prettyPrintDuration(Duration duration) {
  if (duration == Duration.zero) return '0s';
  final isNegative = duration.isNegative;
  final absDuration = duration.abs();

  final parts = <String>[];

  final days = absDuration.inDays;
  if (days > 0) parts.add('$days day${days > 1 ? 's' : ''}');

  final hours = absDuration.inHours % 24;
  if (hours > 0) parts.add('$hours hour${hours > 1 ? 's' : ''}');

  final minutes = absDuration.inMinutes % 60;
  if (minutes > 0) parts.add('${minutes}m');

  final seconds = absDuration.inSeconds % 60;
  if (seconds > 0) parts.add('${seconds}s');

  final ms = absDuration.inMilliseconds % 1000;
  if (ms > 0) parts.add('${ms}ms');

  final us = absDuration.inMicroseconds % 1000;
  if (us > 0) parts.add('${us}us');

  final result = parts.join(' ');
  return isNegative ? '-$result' : result;
}
