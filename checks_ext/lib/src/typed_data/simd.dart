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

extension Float32x4ChecksExt on Subject<Float32x4> {
  /// The x lane of this vector.
  ///
  /// {@example /example/typed_data/simd/float32x4.dart}
  Subject<double> get x => has((v) => v.x, 'x');

  /// The y lane of this vector.
  ///
  /// {@example /example/typed_data/simd/float32x4.dart}
  Subject<double> get y => has((v) => v.y, 'y');

  /// The z lane of this vector.
  ///
  /// {@example /example/typed_data/simd/float32x4.dart}
  Subject<double> get z => has((v) => v.z, 'z');

  /// The w lane of this vector.
  ///
  /// {@example /example/typed_data/simd/float32x4.dart}
  Subject<double> get w => has((v) => v.w, 'w');
}

extension Float64x2ChecksExt on Subject<Float64x2> {
  /// The x lane of this vector.
  ///
  /// {@example /example/typed_data/simd/float64x2.dart}
  Subject<double> get x => has((v) => v.x, 'x');

  /// The y lane of this vector.
  ///
  /// {@example /example/typed_data/simd/float64x2.dart}
  Subject<double> get y => has((v) => v.y, 'y');
}

extension Int32x4ChecksExt on Subject<Int32x4> {
  /// The x lane of this vector.
  ///
  /// {@example /example/typed_data/simd/int32x4.dart}
  Subject<int> get x => has((v) => v.x, 'x');

  /// The y lane of this vector.
  ///
  /// {@example /example/typed_data/simd/int32x4.dart}
  Subject<int> get y => has((v) => v.y, 'y');

  /// The z lane of this vector.
  ///
  /// {@example /example/typed_data/simd/int32x4.dart}
  Subject<int> get z => has((v) => v.z, 'z');

  /// The w lane of this vector.
  ///
  /// {@example /example/typed_data/simd/int32x4.dart}
  Subject<int> get w => has((v) => v.w, 'w');
}
