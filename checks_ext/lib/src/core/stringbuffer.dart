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

extension StringBufferChecksExt on Subject<StringBuffer> {
  /// The string content built by this string buffer.
  ///
  /// {@example /example/core/stringbuffer/as_string.dart}
  Subject<String> get asString => has((b) => b.toString(), 'asString');

  /// The length of the string content.
  Subject<int> get length => has((b) => b.length, 'length');

  static const _empty = (positive: 'is empty', negative: 'is not empty');

  /// Expects that the string buffer is empty.
  ///
  /// {@example /example/core/stringbuffer/is_empty.dart}
  void isEmpty() => expectTrue(_empty, (b) => b.isEmpty);

  /// Expects that the string buffer is not empty.
  ///
  /// {@example /example/core/stringbuffer/is_empty.dart}
  void isNotEmpty() => expectFalse(_empty, (b) => b.isEmpty);
}
