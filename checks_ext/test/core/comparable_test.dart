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

import 'package:checks_ext/src/core/comparable.dart';

import '../util.dart';

void main() {
  group('isSorted', () {
    test('succeeds for sorted list', () {
      check([1, 2, 3]).isSorted();
    });

    test('succeeds for empty list', () {
      check(<int>[]).isSorted();
    });

    test('succeeds for one element', () {
      check([42]).isSorted();
    });

    test('fails for unsorted list', () {
      check([2, 1]).isRejectedBy(
        (it) => it.isSorted(),
        which: [
          'is not sorted, because element at index 0 <2>',
          'compares after element at index 1 <1>',
        ],
      );
    });

    test('succeeds for sorted letters', () {
      check(['a', 'b', 'c']).isSorted();
    });

    test('fails for unsorted letters', () {
      check(['b', 'a']).isRejectedBy(
        (it) => it.isSorted(),
        which: [
          "is not sorted, because element at index 0 'b'",
          "compares after element at index 1 'a'",
        ],
      );
    });

    testCheckGolden(
      () {
        check([2, 1]).isSorted();
      },
      '''
# isSorted failure message golden
Expected: a List<int> that:
  is sorted
Actual: [2, 1]
Which: is not sorted, because element at index 0 <2>
compares after element at index 1 <1>''',
    );
  });

  group('IterableComparableChecks', () {
    test('max succeeds', () {
      check([1, 3, 2]).max.equals(3);
    });
    test('max rejects empty', () {
      check(
        <int>[],
      ).isRejectedBy((it) => it.max.equals(0), which: ['is empty']);
    });
    test('max fails for wrong expectation', () {
      check([1, 3, 2]).isRejectedBy(
        (it) => it.max.equals(4),
        actual: ['<3>'],
        which: ['are not equal'],
      );
    });
    test('min succeeds', () {
      check([2, 1, 3]).min.equals(1);
    });
    test('min rejects empty', () {
      check(
        <int>[],
      ).isRejectedBy((it) => it.min.equals(0), which: ['is empty']);
    });
    test('min fails for wrong expectation', () {
      check([2, 1, 3]).isRejectedBy(
        (it) => it.min.equals(2),
        actual: ['<1>'],
        which: ['are not equal'],
      );
    });
  });

  group('IterableDoubleChecks', () {
    test('max succeeds', () {
      check([1.0, 3.0, 2.0]).max.equals(3.0);
    });
    test('max rejects empty', () {
      check(
        <double>[],
      ).isRejectedBy((it) => it.max.equals(0.0), which: ['is empty']);
    });
    test('max fails for wrong expectation', () {
      check([1.0, 3.0, 2.0]).isRejectedBy(
        (it) => it.max.equals(4.0),
        actual: ['<3.0>'],
        which: ['are not equal'],
      );
    });
    test('min succeeds', () {
      check([2.0, 1.0, 3.0]).min.equals(1.0);
    });
    test('min rejects empty', () {
      check(
        <double>[],
      ).isRejectedBy((it) => it.min.equals(0.0), which: ['is empty']);
    });
    test('min fails for wrong expectation', () {
      check([2.0, 1.0, 3.0]).isRejectedBy(
        (it) => it.min.equals(2.0),
        actual: ['<1.0>'],
        which: ['are not equal'],
      );
    });
    test('sum succeeds', () {
      check([1.0, 2.0]).sum.equals(3.0);
    });
    test('sum succeeds for empty', () {
      check(<double>[]).sum.equals(0.0);
    });
    test('sum fails for wrong expectation', () {
      check([1.0, 2.0]).isRejectedBy(
        (it) => it.sum.equals(4.0),
        actual: ['<3.0>'],
        which: ['are not equal'],
      );
    });
  });

  group('IterableIntegerChecks', () {
    test('max succeeds', () {
      check([1, 3, 2]).max.equals(3);
    });
    test('max rejects empty', () {
      check(
        <int>[],
      ).isRejectedBy((it) => it.max.equals(0), which: ['is empty']);
    });
    test('max fails for wrong expectation', () {
      check([1, 3, 2]).isRejectedBy(
        (it) => it.max.equals(4),
        actual: ['<3>'],
        which: ['are not equal'],
      );
    });
    test('min succeeds', () {
      check([2, 1, 3]).min.equals(1);
    });
    test('min rejects empty', () {
      check(
        <int>[],
      ).isRejectedBy((it) => it.min.equals(0), which: ['is empty']);
    });
    test('min fails for wrong expectation', () {
      check([2, 1, 3]).isRejectedBy(
        (it) => it.min.equals(2),
        actual: ['<1>'],
        which: ['are not equal'],
      );
    });
    test('sum succeeds', () {
      check([1, 2]).sum.equals(3);
    });
    test('sum fails for wrong expectation', () {
      check([1, 2]).isRejectedBy(
        (it) => it.sum.equals(4),
        actual: ['<3>'],
        which: ['are not equal'],
      );
    });
    test('average succeeds', () {
      check([1, 3]).average.equals(2.0);
    });
    test('average rejects empty', () {
      check(
        <int>[],
      ).isRejectedBy((it) => it.average.equals(0.0), which: ['is empty']);
    });
    test('average fails for wrong expectation', () {
      check([1, 3]).isRejectedBy(
        (it) => it.average.equals(3.0),
        actual: ['<2.0>'],
        which: ['are not equal'],
      );
    });
  });

  group('IterableNumberChecks', () {
    test('max succeeds', () {
      check([1, 3.0, 2]).max.equals(3.0);
    });
    test('max rejects empty', () {
      check(
        <num>[],
      ).isRejectedBy((it) => it.max.equals(0), which: ['is empty']);
    });
    test('max fails for wrong expectation', () {
      check([1, 3.0, 2]).isRejectedBy(
        (it) => it.max.equals(4.0),
        actual: ['<3.0>'],
        which: ['are not equal'],
      );
    });
    test('min succeeds', () {
      check([2, 1.0, 3]).min.equals(1.0);
    });
    test('min rejects empty', () {
      check(
        <num>[],
      ).isRejectedBy((it) => it.min.equals(0), which: ['is empty']);
    });
    test('min fails for wrong expectation', () {
      check([2, 1.0, 3]).isRejectedBy(
        (it) => it.min.equals(2.0),
        actual: ['<1.0>'],
        which: ['are not equal'],
      );
    });
    test('sum succeeds', () {
      check([1, 2.0]).sum.equals(3.0);
    });
    test('sum fails for wrong expectation', () {
      check([1, 2.0]).isRejectedBy(
        (it) => it.sum.equals(4.0),
        actual: ['<3.0>'],
        which: ['are not equal'],
      );
    });
    test('average succeeds', () {
      check([1, 3.0]).average.equals(2.0);
    });
    test('average rejects empty', () {
      check(
        <num>[],
      ).isRejectedBy((it) => it.average.equals(0.0), which: ['is empty']);
    });
    test('average fails for wrong expectation', () {
      check([1, 3.0]).isRejectedBy(
        (it) => it.average.equals(3.0),
        actual: ['<2.0>'],
        which: ['are not equal'],
      );
    });
  });
}
