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
import 'package:collection/collection.dart';

extension IterableComparableChecksExt<T extends Comparable<T>>
    on Subject<Iterable<T>> {
  /// Expects that the iterable is sorted in natural order.
  ///
  /// {@example /example/core/comparable/is_sorted.dart}
  void isSorted() => context.expect(() => ['is sorted'], (actual) {
    final list = actual.toList();
    for (var i = 0; i < list.length - 1; i++) {
      final a = list[i];
      final b = list[i + 1];
      if (a.compareTo(b) > 0) {
        return Rejection(
          which: [
            ...prefixFirst(
              'is not sorted, because element at index $i ',
              literal(a),
            ),
            ...prefixFirst(
              'compares after element at index ${i + 1} ',
              literal(b),
            ),
          ],
        );
      }
    }
    return null;
  });

  /// The maximum element in the iterable.
  ///
  /// {@example /example/core/comparable/max.dart}
  Subject<T> get max => context.nest(() => ['has max'], (actual) {
    if (actual.isEmpty) return Extracted.rejection(which: ['is empty']);
    return Extracted.value(actual.max);
  });

  /// The minimum element in the iterable.
  ///
  /// {@example /example/core/comparable/min.dart}
  Subject<T> get min => context.nest(() => ['has min'], (actual) {
    if (actual.isEmpty) return Extracted.rejection(which: ['is empty']);
    return Extracted.value(actual.min);
  });
}

extension IterableDoubleChecksExt on Subject<Iterable<double>> {
  /// The maximum element in the iterable.
  Subject<double> get max => context.nest(() => ['has max'], (actual) {
    if (actual.isEmpty) return Extracted.rejection(which: ['is empty']);
    return Extracted.value(actual.max);
  });

  /// The minimum element in the iterable.
  Subject<double> get min => context.nest(() => ['has min'], (actual) {
    if (actual.isEmpty) return Extracted.rejection(which: ['is empty']);
    return Extracted.value(actual.min);
  });

  /// The sum of the elements in the iterable.
  Subject<double> get sum => context.nest(() => ['has sum'], (actual) {
    return Extracted.value(actual.sum);
  });
}

extension IterableIntegerChecksExt on Subject<Iterable<int>> {
  /// The maximum element in the iterable.
  Subject<int> get max => context.nest(() => ['has max'], (actual) {
    if (actual.isEmpty) return Extracted.rejection(which: ['is empty']);
    return Extracted.value(actual.max);
  });

  /// The minimum element in the iterable.
  Subject<int> get min => context.nest(() => ['has min'], (actual) {
    if (actual.isEmpty) return Extracted.rejection(which: ['is empty']);
    return Extracted.value(actual.min);
  });

  /// The sum of the elements in the iterable.
  ///
  /// {@example /example/core/comparable/sum.dart}
  Subject<int> get sum => context.nest(() => ['has sum'], (actual) {
    return Extracted.value(actual.sum);
  });

  /// The average of the elements in the iterable.
  ///
  /// {@example /example/core/comparable/average.dart}
  Subject<double> get average => context.nest(() => ['has average'], (actual) {
    if (actual.isEmpty) return Extracted.rejection(which: ['is empty']);
    return Extracted.value(actual.average);
  });
}

extension IterableNumberChecksExt on Subject<Iterable<num>> {
  /// The maximum element in the iterable.
  Subject<num> get max => context.nest(() => ['has max'], (actual) {
    if (actual.isEmpty) return Extracted.rejection(which: ['is empty']);
    return Extracted.value(actual.max);
  });

  /// The minimum element in the iterable.
  Subject<num> get min => context.nest(() => ['has min'], (actual) {
    if (actual.isEmpty) return Extracted.rejection(which: ['is empty']);
    return Extracted.value(actual.min);
  });

  /// The sum of the elements in the iterable.
  Subject<num> get sum => context.nest(() => ['has sum'], (actual) {
    return Extracted.value(actual.sum);
  });

  /// The average of the elements in the iterable.
  Subject<double> get average => context.nest(() => ['has average'], (actual) {
    if (actual.isEmpty) return Extracted.rejection(which: ['is empty']);
    return Extracted.value(actual.average);
  });
}
