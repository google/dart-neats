import 'dart:math';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final point = Point(3, 4);

  /// This check succeeds.
  check(point).y.equals(4);

  /// This check fails.
  try {
    check(point).y.equals(10);
  } catch (e) {
    print(e);
    // Expected: a Point<int> that:
    //   has y that:
    //     equals <10>
    // Actual: a Point<int> that:
    //   has y that:
    //   Actual: <4>
    //   Which: are not equal
  }
}
