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

extension ByteDataChecksExt on Subject<ByteData> {
  /// The length of this view in bytes.
  ///
  /// {@example /example/typed_data/bytedata/length_in_bytes.dart}
  Subject<int> get lengthInBytes =>
      has((b) => b.lengthInBytes, 'lengthInBytes');

  /// Extracts a Float32 at the given [byteOffset].
  ///
  /// {@example /example/typed_data/bytedata/float32_at.dart}
  Subject<double> float32At(int byteOffset, [Endian endian = Endian.little]) =>
      context.nest(
        () => ['has float32 at $byteOffset'],
        (d) => Extracted.value(d.getFloat32(byteOffset, endian)),
      );

  /// Extracts a Float64 at the given [byteOffset].
  ///
  /// {@example /example/typed_data/bytedata/float64_at.dart}
  Subject<double> float64At(int byteOffset, [Endian endian = Endian.little]) =>
      context.nest(
        () => ['has float64 at $byteOffset'],
        (d) => Extracted.value(d.getFloat64(byteOffset, endian)),
      );

  /// Extracts a Uint32 at the given [byteOffset].
  ///
  /// {@example /example/typed_data/bytedata/uint32_at.dart}
  Subject<int> uint32At(int byteOffset, [Endian endian = Endian.little]) =>
      context.nest(
        () => ['has uint32 at $byteOffset'],
        (d) => Extracted.value(d.getUint32(byteOffset, endian)),
      );

  /// Extracts an Int32 at the given [byteOffset].
  ///
  /// {@example /example/typed_data/bytedata/int32_at.dart}
  Subject<int> int32At(int byteOffset, [Endian endian = Endian.little]) =>
      context.nest(
        () => ['has int32 at $byteOffset'],
        (d) => Extracted.value(d.getInt32(byteOffset, endian)),
      );

  /// Extracts a Uint16 at the given [byteOffset].
  ///
  /// {@example /example/typed_data/bytedata/uint16_at.dart}
  Subject<int> uint16At(int byteOffset, [Endian endian = Endian.little]) =>
      context.nest(
        () => ['has uint16 at $byteOffset'],
        (d) => Extracted.value(d.getUint16(byteOffset, endian)),
      );

  /// Extracts an Int16 at the given [byteOffset].
  ///
  /// {@example /example/typed_data/bytedata/int16_at.dart}
  Subject<int> int16At(int byteOffset, [Endian endian = Endian.little]) =>
      context.nest(
        () => ['has int16 at $byteOffset'],
        (d) => Extracted.value(d.getInt16(byteOffset, endian)),
      );

  /// Extracts a Uint8 at the given [byteOffset].
  ///
  /// {@example /example/typed_data/bytedata/uint8_at.dart}
  Subject<int> uint8At(int byteOffset) => context.nest(
    () => ['has uint8 at $byteOffset'],
    (d) => Extracted.value(d.getUint8(byteOffset)),
  );

  /// Extracts an Int8 at the given [byteOffset].
  ///
  /// {@example /example/typed_data/bytedata/int8_at.dart}
  Subject<int> int8At(int byteOffset) => context.nest(
    () => ['has int8 at $byteOffset'],
    (d) => Extracted.value(d.getInt8(byteOffset)),
  );
}
