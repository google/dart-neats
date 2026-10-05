import 'dart:math';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final point = Point(3, 4); // magnitude is 5.0

  /// This check succeeds.
  check(point).magnitude.equals(5.0);

  /// This check fails.
  try {
    check(point).magnitude.equals(10.0);
  } catch (e) {
    print(e);
    // Expected: a Point<int> that:
    //   has magnitude that:
    //     equals <10.0>
    // Actual: a Point<int> that:
    //   has magnitude that:
    //   Actual: <5.0>
    //   Which: are not equal
  }
}
