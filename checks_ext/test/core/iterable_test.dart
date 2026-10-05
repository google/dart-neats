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

import 'package:checks_ext/src/core/iterable.dart';
import 'package:collection/collection.dart';

import '../util.dart';

void main() {
  group('isSortedBy', () {
    test('succeeds for sorted maps by key', () {
      check([
        {'age': 20},
        {'age': 30},
      ]).isSortedBy((m) => m['age'] as int);
    });

    test('fails for unsorted maps by key', () {
      check([
        {'age': 30},
        {'age': 20},
      ]).isRejectedBy(
        (it) => it.isSortedBy((m) => m['age'] as int),
        which: [
          "is not sorted, because element at index 0 {'age': 30}",
          "with key <30>",
          "compares after element at index 1 {'age': 20}",
          "with key <20>",
        ],
      );
    });

    test('succeeds for empty list', () {
      check(<Map<String, int>>[]).isSortedBy((m) => m['age'] as int);
    });

    test('succeeds for one element', () {
      check([
        {'age': 42},
      ]).isSortedBy((m) => m['age'] as int);
    });

    testCheckGolden(
      () {
        check([
          {'age': 30},
          {'age': 20},
        ]).isSortedBy((m) => m['age'] as int);
      },
      '''
# isSortedBy failure message golden
Expected: a List<Map<String, int>> that:
  is sorted by key
Actual: [{'age': 30}, {'age': 20}]
Which: is not sorted, because element at index 0 {'age': 30}
with key <30>
compares after element at index 1 {'age': 20}
with key <20>''',
    );

    testCheckGolden(
      () {
        check([
          {'age': 30},
          {'age': 20},
        ]).isSortedBy((m) => m['age'] as int, 'age');
      },
      '''
# isSortedBy with keyName failure message golden
Expected: a List<Map<String, int>> that:
  is sorted by key "age"
Actual: [{'age': 30}, {'age': 20}]
Which: is not sorted, because element at index 0 {'age': 30}
with key "age" <30>
compares after element at index 1 {'age': 20}
with key "age" <20>''',
    );

    testCheckGolden(
      () {
        check([
          {
            'name': 'Bob Builder',
            'age': 34,
            'species': 'human',
            'employment': 'construction',
            'location': 'Builderland',
            'hobbies': ['building', 'fixing'],
          },
          {
            'name': 'Alice Architect',
            'age': 30,
            'species': 'human',
            'employment': 'design',
            'location': 'Builderland',
            'hobbies': ['drawing', 'planning'],
          },
        ]).isSortedBy((m) => m['age'] as int, 'age');
      },
      '''
# isSortedBy with large entries failure message golden
Expected: a List<Map<String, Object>> that:
  is sorted by key "age"
Actual: [{'name': 'Bob Builder',
'age': 34,
'species': 'human',
'employment': 'construction',
'location': 'Builderland',
'hobbies': ['building', 'fixing']},
{'name': 'Alice Architect',
'age': 30,
'species': 'human',
'employment': 'design',
'location': 'Builderland',
'hobbies': ['drawing', 'planning']}]
Which: is not sorted, because element at index 0 {'name': 'Bob Builder',
'age': 34,
'species': 'human',
'employment': 'construction',
'location': 'Builderland',
'hobbies': ['building', 'fixing']}
with key "age" <34>
compares after element at index 1 {'name': 'Alice Architect',
'age': 30,
'species': 'human',
'employment': 'design',
'location': 'Builderland',
'hobbies': ['drawing', 'planning']}
with key "age" <30>''',
    );
  });

  group('containsAll', () {
    test('succeeds when all elements are present', () {
      check([1, 2, 3]).containsAll([1, 2]);
      check([1, 2, 3]).containsAll([3, 1]);
    });

    test('fails when elements are missing', () {
      check([1, 2, 3]).isRejectedBy(
        (it) => it.containsAll([1, 4]),
        which: ["is missing elements: [4]"],
      );
    });

    testCheckGolden(
      () {
        check([1, 2, 3]).containsAll([1, 4]);
      },
      '''
# containsAll failure message golden
Expected: a List<int> that:
  contains all of [1, 4]
Actual: [1, 2, 3]
Which: is missing elements: [4]''',
    );
    testCheckGolden(
      () {
        final myMap = {'a': 1, 'b': 2};
        check(myMap).has((m) => m.keys, 'keys').containsAll(['a', 'c']);
      },
      '''
# containsAll with map keys failure message golden
Expected: a Map<String, int> that:
  has keys that:
    contains all of ['a', 'c']
Actual: a Map<String, int> that:
  has keys that:
  Actual: ('a', 'b')
  Which: is missing elements: ['c']''',
    );
  });

  group('NullableIterableChecks', () {
    test('nonNulls extracts non-null elements', () {
      check([1, null, 2]).nonNulls.deepEquals([1, 2]);
    });

    testCheckGolden(
      () {
        check([1, null, 2]).nonNulls.deepEquals([1, 3]);
      },
      '''
# nonNulls failure message golden
Expected: a List<int?> that:
  skipping nulls that:
    is deeply equal to [1, 3]
Actual: a List<int?> that:
  skipping nulls that:
  Actual: (1, 2)
  Which: at [<1>] is <2>
  which does not equal <3>''',
    );
  });

  group('containsSequence', () {
    test('succeeds when containing sequence', () {
      check([1, 2, 3, 4, 5]).containsSequence([2, 3, 4]);
    });

    test('fails when not containing sequence', () {
      check([1, 2, 3, 4, 5]).isRejectedBy(
        (it) => it.containsSequence([2, 4]),
        which: ['does not contain the sequence'],
      );
    });

    testCheckGolden(
      () {
        check([1, 2, 3]).containsSequence([2, 4]);
      },
      '''
# containsSequence failure message golden
Expected: a List<int> that:
  contains sequence [2, 4]
Actual: [1, 2, 3]
Which: does not contain the sequence''',
    );
  });

  group('hasDuplicates', () {
    test('succeeds when having duplicates', () {
      check([1, 2, 2, 3]).hasDuplicates();
    });

    test('fails when having no duplicates', () {
      check([
        1,
        2,
        3,
      ]).isRejectedBy((it) => it.hasDuplicates(), which: ['has no duplicates']);
    });

    test('works with custom equality', () {
      check([
        'a',
        'A',
      ]).hasDuplicates(equality: EqualityBy((s) => s.toLowerCase()));
    });
  });

  group('hasNoDuplicates', () {
    test('succeeds when having no duplicates', () {
      check([1, 2, 3]).hasNoDuplicates();
    });

    test('fails when having duplicates', () {
      check([1, 2, 2, 3]).isRejectedBy(
        (it) => it.hasNoDuplicates(),
        which: ["has duplicates: [2]"],
      );
    });

    test('works with custom equality', () {
      check(['a', 'A']).isRejectedBy(
        (it) =>
            it.hasNoDuplicates(equality: EqualityBy((s) => s.toLowerCase())),
        which: ["has duplicates: ['A']"],
      );
    });

    testCheckGolden(
      () {
        check([1, 2, 2, 3, 3]).hasNoDuplicates();
      },
      '''
# hasNoDuplicates failure message golden
Expected: a List<int> that:
  has no duplicates
Actual: [1, 2, 2, 3, 3]
Which: has duplicates: [2, 3]''',
    );
  });
}
