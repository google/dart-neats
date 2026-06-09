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

extension TypedDataChecksExt on Subject<TypedData> {
  /// The length of this view in bytes.
  ///
  /// {@example /example/typed_data/typeddata/length_in_bytes.dart}
  Subject<int> get lengthInBytes =>
      has((d) => d.lengthInBytes, 'lengthInBytes');

  /// The offset of this view from the start of its buffer, in bytes.
  ///
  /// {@example /example/typed_data/typeddata/offset_in_bytes.dart}
  Subject<int> get offsetInBytes =>
      has((d) => d.offsetInBytes, 'offsetInBytes');

  /// Creates a [ByteData] view of the region represented by this [TypedData].
  Subject<ByteData> get asByteData => context.nest(
    () => ['as ByteData'],
    (d) => Extracted.value(
      d.buffer.asByteData(d.offsetInBytes, d.lengthInBytes),
    ),
  );
}
