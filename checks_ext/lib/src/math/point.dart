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

import 'dart:math';
import '../util.dart';

extension PointChecksExt<T extends num> on Subject<Point<T>> {
  /// The x coordinate of the point.
  ///
  /// {@example /example/math/point/x.dart}
  Subject<T> get x => has((p) => p.x, 'x');

  /// The y coordinate of the point.
  ///
  /// {@example /example/math/point/y.dart}
  Subject<T> get y => has((p) => p.y, 'y');

  /// The magnitude of the point (distance from origin).
  ///
  /// {@example /example/math/point/magnitude.dart}
  Subject<double> get magnitude => has((p) => p.magnitude, 'magnitude');
}
