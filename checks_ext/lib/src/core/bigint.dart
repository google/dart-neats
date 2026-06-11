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

extension BigIntChecksExt on Subject<BigInt> {
  /// The bit length of this big integer.
  ///
  /// {@example /example/core/bigint/bit_length.dart}
  Subject<int> get bitLength => has((s) => s.bitLength, 'bitLength');

  /// The sign of this big integer.
  ///
  /// {@example /example/core/bigint/sign.dart}
  Subject<int> get sign => has((s) => s.sign, 'sign');

  static const _even = (positive: 'is even', negative: 'is not even');

  /// Expects that this big integer is even.
  ///
  /// {@example /example/core/bigint/is_even.dart}
  void isEven() => expectTrue(_even, (s) => s.isEven);

  /// Expects that this big integer is not even.
  ///
  /// {@example /example/core/bigint/is_not_even.dart}
  void isNotEven() => expectFalse(_even, (s) => s.isEven);

  static const _odd = (positive: 'is odd', negative: 'is not odd');

  /// Expects that this big integer is odd.
  ///
  /// {@example /example/core/bigint/is_odd.dart}
  void isOdd() => expectTrue(_odd, (s) => s.isOdd);

  /// Expects that this big integer is not odd.
  ///
  /// {@example /example/core/bigint/is_not_odd.dart}
  void isNotOdd() => expectFalse(_odd, (s) => s.isOdd);

  static const _negative = (
    positive: 'is negative',
    negative: 'is not negative',
  );

  /// Expects that this big integer is negative.
  ///
  /// {@example /example/core/bigint/is_negative.dart}
  void isNegative() => expectTrue(_negative, (s) => s.isNegative);

  /// Expects that this big integer is not negative.
  void isNotNegative() => expectFalse(_negative, (s) => s.isNegative);

  static const _validInt = (
    positive: 'is valid int',
    negative: 'is not valid int',
  );

  /// Expects that this big integer is a valid 64-bit integer.
  ///
  /// {@example /example/core/bigint/is_valid_int.dart}
  void isValidInt() => expectTrue(_validInt, (s) => s.isValidInt);

  /// Expects that this big integer is not a valid 64-bit integer.
  void isNotValidInt() => expectFalse(_validInt, (s) => s.isValidInt);
}
