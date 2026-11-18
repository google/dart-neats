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

extension RectangleChecksExt<T extends num> on Subject<Rectangle<T>> {
  /// The left coordinate of the rectangle.
  ///
  /// {@example /example/math/rectangle/left.dart}
  Subject<T> get left => has((r) => r.left, 'left');

  /// The top coordinate of the rectangle.
  ///
  /// {@example /example/math/rectangle/top.dart}
  Subject<T> get top => has((r) => r.top, 'top');

  /// The width of the rectangle.
  ///
  /// {@example /example/math/rectangle/width.dart}
  Subject<T> get width => has((r) => r.width, 'width');

  /// The height of the rectangle.
  ///
  /// {@example /example/math/rectangle/height.dart}
  Subject<T> get height => has((r) => r.height, 'height');

  /// The right coordinate of the rectangle.
  ///
  /// {@example /example/math/rectangle/right.dart}
  Subject<T> get right => has((r) => r.right, 'right');

  /// The bottom coordinate of the rectangle.
  ///
  /// {@example /example/math/rectangle/bottom.dart}
  Subject<T> get bottom => has((r) => r.bottom, 'bottom');

  /// Expects that the rectangle contains the given [point].
  ///
  /// {@example /example/math/rectangle/contains_point.dart}
  void containsPoint(Point<num> point) {
    context.expect(() => prefixFirst('contains point ', literal(point)), (
      actual,
    ) {
      if (actual.containsPoint(point)) return null;
      return Rejection(
        which: [...prefixFirst('does not contain point ', literal(point))],
      );
    });
  }

  /// Expects that the rectangle contains the given [other] rectangle.
  ///
  /// {@example /example/math/rectangle/contains_rectangle.dart}
  void containsRectangle(Rectangle<num> other) {
    context.expect(() => prefixFirst('contains rectangle ', literal(other)), (
      actual,
    ) {
      if (actual.containsRectangle(other)) return null;
      return Rejection(
        which: [...prefixFirst('does not contain rectangle ', literal(other))],
      );
    });
  }
}
