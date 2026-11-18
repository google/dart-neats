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

import 'dart:typed_data';
import '../util.dart';

extension BytesBuilderChecksExt on Subject<BytesBuilder> {
  /// The bytes accumulated by this builder (does not clear).
  ///
  /// {@example /example/typed_data/bytesbuilder/bytes.dart}
  Subject<Uint8List> get bytes =>
      context.nest(() => ['has bytes'], (b) => Extracted.value(b.toBytes()));

  /// The length of the accumulated bytes.
  ///
  /// {@example /example/typed_data/bytesbuilder/length.dart}
  Subject<int> get length => has((b) => b.length, 'length');

  static const _empty = (positive: 'is empty', negative: 'is not empty');

  /// Expects that the bytes builder is empty.
  ///
  /// {@example /example/typed_data/bytesbuilder/is_empty.dart}
  void isEmpty() => expectTrue(_empty, (b) => b.isEmpty);

  /// Expects that the bytes builder is not empty.
  void isNotEmpty() => expectFalse(_empty, (b) => b.isEmpty);
}
