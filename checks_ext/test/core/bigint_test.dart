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

import 'package:checks_ext/src/core/bigint.dart';
import '../util.dart';

void main() {
  group('BigIntChecks', () {
    test('bitLength extracts bitLength', () {
      check(BigInt.from(5)).bitLength.equals(3); // 5 is 101 in binary
    });

    test('sign extracts sign', () {
      check(BigInt.from(5)).sign.equals(1);
      check(BigInt.from(-5)).sign.equals(-1);
      check(BigInt.zero).sign.equals(0);
    });

    test('isEven succeeds', () {
      check(BigInt.from(2)).isEven();
    });

    test('isEven fails', () {
      check(
        BigInt.from(1),
      ).isRejectedBy((it) => it.isEven(), which: ['is not even']);
    });

    test('isNotEven succeeds', () {
      check(BigInt.from(1)).isNotEven();
    });

    test('isNotEven fails', () {
      check(
        BigInt.from(2),
      ).isRejectedBy((it) => it.isNotEven(), which: ['is even']);
    });

    test('isOdd succeeds', () {
      check(BigInt.from(1)).isOdd();
    });

    test('isOdd fails', () {
      check(
        BigInt.from(2),
      ).isRejectedBy((it) => it.isOdd(), which: ['is not odd']);
    });

    test('isNotOdd succeeds', () {
      check(BigInt.from(2)).isNotOdd();
    });

    test('isNotOdd fails', () {
      check(
        BigInt.from(1),
      ).isRejectedBy((it) => it.isNotOdd(), which: ['is odd']);
    });

    test('isNegative succeeds', () {
      check(BigInt.from(-1)).isNegative();
    });

    test('isNegative fails', () {
      check(
        BigInt.from(1),
      ).isRejectedBy((it) => it.isNegative(), which: ['is not negative']);
    });

    test('isValidInt succeeds', () {
      check(BigInt.from(42)).isValidInt();
    });

    test('isValidInt fails', () {
      final huge = BigInt.parse('10000000000000000000000000000000000000000');
      check(
        huge,
      ).isRejectedBy((it) => it.isValidInt(), which: ['is not valid int']);
    });

    testCheckGolden(
      () {
        check(BigInt.from(1)).isEven();
      },
      '''
# isEven failure message golden
Expected: a BigInt that:
  is even
Actual: <1>
Which: is not even''',
    );
  });
}
