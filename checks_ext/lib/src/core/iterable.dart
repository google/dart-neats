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

import 'dart:collection';
import 'package:collection/collection.dart';
import '../util.dart';

extension NullableIterableChecksExt<T extends Object> on Subject<Iterable<T?>> {
  /// Returns a subject containing only the non-null elements.
  ///
  /// {@example /example/core/iterable/non_nulls.dart}
  Subject<Iterable<T>> get nonNulls => context.nest(
    () => ['skipping nulls'],
    (value) => Extracted.value(value.nonNulls),
  );
}

extension IterableChecksExt<T> on Subject<Iterable<T>> {
  /// Expects that the iterable is sorted by the key extracted by [keyOf].
  ///
  /// {@example /example/core/iterable/is_sorted_by.dart}
  void isSortedBy<K extends Comparable<K>>(
    K Function(T) keyOf, [
    String? keyName,
  ]) => context.expect(
    () => [
      if (keyName != null)
        'is sorted by key "$keyName"'
      else
        'is sorted by key',
    ],
    (actual) {
      final list = actual.toList();
      for (var i = 0; i < list.length - 1; i++) {
        final a = keyOf(list[i]);
        final b = keyOf(list[i + 1]);
        if (a.compareTo(b) > 0) {
          final keyPrefix = keyName != null
              ? 'with key "$keyName" '
              : 'with key ';
          return Rejection(
            which: [
              ...prefixFirst(
                'is not sorted, because element at index $i ',
                literal(list[i]),
              ),
              ...prefixFirst(keyPrefix, literal(a)),
              ...prefixFirst(
                'compares after element at index ${i + 1} ',
                literal(list[i + 1]),
              ),
              ...prefixFirst(keyPrefix, literal(b)),
            ],
          );
        }
      }
      return null;
    },
  );

  /// Expects that this iterable contains all elements of [expected].
  ///
  /// {@example /example/core/iterable/contains_all.dart}
  void containsAll(Iterable<T> expected) {
    context.expect(() => prefixFirst('contains all of ', literal(expected)), (
      actual,
    ) {
      final actualSet = actual.toSet();
      final missing = expected.where((e) => !actualSet.contains(e)).toList();

      if (missing.isEmpty) return null;

      return Rejection(
        which: [...prefixFirst('is missing elements: ', literal(missing))],
      );
    });
  }

  /// Expects that this iterable contains the [expected] sequence contiguously.
  ///
  /// {@example /example/core/iterable/contains_sequence.dart}
  void containsSequence(Iterable<T> expected) {
    context.expect(() => prefixFirst('contains sequence ', literal(expected)), (
      actual,
    ) {
      final actualList = actual.toList();
      final expectedList = expected.toList();

      if (expectedList.isEmpty) return null;

      for (var i = 0; i <= actualList.length - expectedList.length; i++) {
        var match = true;
        for (var j = 0; j < expectedList.length; j++) {
          if (actualList[i + j] != expectedList[j]) {
            match = false;
            break;
          }
        }
        if (match) return null;
      }

      return Rejection(which: ['does not contain the sequence']);
    });
  }

  /// Expects that this iterable contains duplicate elements.
  ///
  /// {@example /example/core/iterable/has_duplicates.dart}
  void hasDuplicates({Equality<T>? equality}) {
    context.expect(() => ['has duplicates'], (actual) {
      final seen = HashSet<T>(
        equals: equality?.equals,
        hashCode: equality?.hash,
      );
      for (final element in actual) {
        if (!seen.add(element)) {
          return null; // Found a duplicate
        }
      }
      return Rejection(which: ['has no duplicates']);
    });
  }

  /// Expects that this iterable contains no duplicate elements.
  ///
  /// {@example /example/core/iterable/has_no_duplicates.dart}
  void hasNoDuplicates({Equality<T>? equality}) {
    context.expect(() => ['has no duplicates'], (actual) {
      final seen = HashSet<T>(
        equals: equality?.equals,
        hashCode: equality?.hash,
      );
      final duplicates = LinkedHashSet<T>(
        equals: equality?.equals,
        hashCode: equality?.hash,
      );

      for (final element in actual) {
        if (!seen.add(element)) {
          duplicates.add(element);
        }
      }

      if (duplicates.isEmpty) return null;

      return Rejection(
        which: [
          ...prefixFirst('has duplicates: ', literal(duplicates.toList())),
        ],
      );
    });
  }
}
