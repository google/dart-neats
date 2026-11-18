import 'dart:math';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final point = Point(3, 4);

  /// This check succeeds.
  check(point).x.equals(3);

  /// This check fails.
  try {
    check(point).x.equals(10);
  } catch (e) {
    print(e);
    // Expected: a Point<int> that:
    //   has x that:
    //     equals <10>
    // Actual: a Point<int> that:
    //   has x that:
    //   Actual: <3>
    //   Which: are not equal
  }
}
