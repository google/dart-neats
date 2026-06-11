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

extension SetChecksExt<T> on Subject<Set<T>> {
  /// Expects that this set is a subset of [other].
  ///
  /// {@example /example/core/set/is_subset_of.dart}
  void isSubsetOf(Set<T> other) {
    context.expect(() => prefixFirst('is a subset of ', literal(other)), (
      actual,
    ) {
      final missing = actual.difference(other);
      if (missing.isEmpty) return null;
      return Rejection(
        which: [
          ...prefixFirst(
            'contains elements not in the other set: ',
            literal(missing),
          ),
        ],
      );
    });
  }

  /// Expects that this set is a superset of [other].
  void isSupersetOf(Set<T> other) {
    context.expect(() => prefixFirst('is a superset of ', literal(other)), (
      actual,
    ) {
      final missing = other.difference(actual);
      if (missing.isEmpty) return null;
      return Rejection(
        which: [
          ...prefixFirst(
            'is missing elements from the other set: ',
            literal(missing),
          ),
        ],
      );
    });
  }
}
