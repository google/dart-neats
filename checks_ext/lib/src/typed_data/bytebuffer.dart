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

extension ByteBufferChecksExt on Subject<ByteBuffer> {
  /// The length of this byte buffer in bytes.
  ///
  /// {@example /example/typed_data/bytebuffer/length_in_bytes.dart}
  Subject<int> get lengthInBytes =>
      has((b) => b.lengthInBytes, 'lengthInBytes');

  /// Creates a [Uint8List] view of a region of this byte buffer.
  ///
  /// {@example /example/typed_data/bytebuffer/as_uint8_list.dart}
  Subject<Uint8List> asUint8List([int byteOffset = 0, int? length]) =>
      context.nest(
        () => ['as Uint8List'],
        (b) => Extracted.value(b.asUint8List(byteOffset, length)),
      );

  /// Creates a [Int8List] view of a region of this byte buffer.
  ///
  /// {@example /example/typed_data/bytebuffer/as_int8_list.dart}
  Subject<Int8List> asInt8List([int byteOffset = 0, int? length]) =>
      context.nest(
        () => ['as Int8List'],
        (b) => Extracted.value(b.asInt8List(byteOffset, length)),
      );

  /// Creates a [Uint16List] view of a region of this byte buffer.
  ///
  /// {@example /example/typed_data/bytebuffer/as_uint16_list.dart}
  Subject<Uint16List> asUint16List([int byteOffset = 0, int? length]) =>
      context.nest(
        () => ['as Uint16List'],
        (b) => Extracted.value(b.asUint16List(byteOffset, length)),
      );

  /// Creates a [Int16List] view of a region of this byte buffer.
  ///
  /// {@example /example/typed_data/bytebuffer/as_int16_list.dart}
  Subject<Int16List> asInt16List([int byteOffset = 0, int? length]) =>
      context.nest(
        () => ['as Int16List'],
        (b) => Extracted.value(b.asInt16List(byteOffset, length)),
      );

  /// Creates a [Uint32List] view of a region of this byte buffer.
  ///
  /// {@example /example/typed_data/bytebuffer/as_uint32_list.dart}
  Subject<Uint32List> asUint32List([int byteOffset = 0, int? length]) =>
      context.nest(
        () => ['as Uint32List'],
        (b) => Extracted.value(b.asUint32List(byteOffset, length)),
      );

  /// Creates a [Int32List] view of a region of this byte buffer.
  ///
  /// {@example /example/typed_data/bytebuffer/as_int32_list.dart}
  Subject<Int32List> asInt32List([int byteOffset = 0, int? length]) =>
      context.nest(
        () => ['as Int32List'],
        (b) => Extracted.value(b.asInt32List(byteOffset, length)),
      );

  /// Creates a [Float32List] view of a region of this byte buffer.
  ///
  /// {@example /example/typed_data/bytebuffer/as_float32_list.dart}
  Subject<Float32List> asFloat32List([int byteOffset = 0, int? length]) =>
      context.nest(
        () => ['as Float32List'],
        (b) => Extracted.value(b.asFloat32List(byteOffset, length)),
      );

  /// Creates a [Float64List] view of a region of this byte buffer.
  ///
  /// {@example /example/typed_data/bytebuffer/as_float64_list.dart}
  Subject<Float64List> asFloat64List([int byteOffset = 0, int? length]) =>
      context.nest(
        () => ['as Float64List'],
        (b) => Extracted.value(b.asFloat64List(byteOffset, length)),
      );
}
