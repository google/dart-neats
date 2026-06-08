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

  /// Creates a [Uint8List] view of the region represented by this [TypedData].
  ///
  /// {@example /example/typed_data/typeddata/as_uint8_list.dart}
  Subject<Uint8List> get asUint8List => context.nest(
    () => ['as Uint8List'],
    (d) => Extracted.value(
      d.buffer.asUint8List(
        d.offsetInBytes,
        d.lengthInBytes ~/ Uint8List.bytesPerElement,
      ),
    ),
  );

  /// Creates a [Int8List] view of the region represented by this [TypedData].
  ///
  /// {@example /example/typed_data/typeddata/as_int8_list.dart}
  Subject<Int8List> get asInt8List => context.nest(
    () => ['as Int8List'],
    (d) => Extracted.value(
      d.buffer.asInt8List(
        d.offsetInBytes,
        d.lengthInBytes ~/ Int8List.bytesPerElement,
      ),
    ),
  );

  /// Creates a [Uint16List] view of the region represented by this [TypedData].
  ///
  /// {@example /example/typed_data/typeddata/as_uint16_list.dart}
  Subject<Uint16List> get asUint16List => context.nest(
    () => ['as Uint16List'],
    (d) => Extracted.value(
      d.buffer.asUint16List(
        d.offsetInBytes,
        d.lengthInBytes ~/ Uint16List.bytesPerElement,
      ),
    ),
  );

  /// Creates a [Int16List] view of the region represented by this [TypedData].
  ///
  /// {@example /example/typed_data/typeddata/as_int16_list.dart}
  Subject<Int16List> get asInt16List => context.nest(
    () => ['as Int16List'],
    (d) => Extracted.value(
      d.buffer.asInt16List(
        d.offsetInBytes,
        d.lengthInBytes ~/ Int16List.bytesPerElement,
      ),
    ),
  );

  /// Creates a [Uint32List] view of the region represented by this [TypedData].
  ///
  /// {@example /example/typed_data/typeddata/as_uint32_list.dart}
  Subject<Uint32List> get asUint32List => context.nest(
    () => ['as Uint32List'],
    (d) => Extracted.value(
      d.buffer.asUint32List(
        d.offsetInBytes,
        d.lengthInBytes ~/ Uint32List.bytesPerElement,
      ),
    ),
  );

  /// Creates a [Int32List] view of the region represented by this [TypedData].
  ///
  /// {@example /example/typed_data/typeddata/as_int32_list.dart}
  Subject<Int32List> get asInt32List => context.nest(
    () => ['as Int32List'],
    (d) => Extracted.value(
      d.buffer.asInt32List(
        d.offsetInBytes,
        d.lengthInBytes ~/ Int32List.bytesPerElement,
      ),
    ),
  );

  /// Creates a [Float32List] view of the region represented by this [TypedData].
  ///
  /// {@example /example/typed_data/typeddata/as_float32_list.dart}
  Subject<Float32List> get asFloat32List => context.nest(
    () => ['as Float32List'],
    (d) => Extracted.value(
      d.buffer.asFloat32List(
        d.offsetInBytes,
        d.lengthInBytes ~/ Float32List.bytesPerElement,
      ),
    ),
  );

  /// Creates a [Float64List] view of the region represented by this [TypedData].
  ///
  /// {@example /example/typed_data/typeddata/as_float64_list.dart}
  Subject<Float64List> get asFloat64List => context.nest(
    () => ['as Float64List'],
    (d) => Extracted.value(
      d.buffer.asFloat64List(
        d.offsetInBytes,
        d.lengthInBytes ~/ Float64List.bytesPerElement,
      ),
    ),
  );
}
