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

import 'package:checks_ext/src/core/set.dart';
import '../util.dart';

void main() {
  group('SetChecks', () {
    test('isSubsetOf succeeds when it is a subset', () {
      check({1, 2}).isSubsetOf({1, 2, 3});
    });

    test('isSubsetOf succeeds when equal', () {
      check({1, 2}).isSubsetOf({1, 2});
    });

    test('isSupersetOf succeeds when it is a superset', () {
      check({1, 2, 3}).isSupersetOf({1, 2});
    });

    test('isSupersetOf succeeds when equal', () {
      check({1, 2}).isSupersetOf({1, 2});
    });

    testCheckGolden(
      () {
        check({1, 2, 3}).isSubsetOf({1, 2});
      },
      '''
# isSubsetOf failure message golden
Expected: a Set<int> that:
  is a subset of {1, 2}
Actual: {1, 2, 3}
Which: contains elements not in the other set: {3}''',
    );

    testCheckGolden(
      () {
        check({1, 2}).isSupersetOf({1, 2, 3});
      },
      '''
# isSupersetOf failure message golden
Expected: a Set<int> that:
  is a superset of {1, 2, 3}
Actual: {1, 2}
Which: is missing elements from the other set: {3}''',
    );
  });
}
