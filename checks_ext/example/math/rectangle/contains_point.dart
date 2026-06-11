import 'dart:math';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final rect = Rectangle(10, 20, 30, 40);

  /// This check succeeds.
  check(rect).containsPoint(Point(15, 25));

  /// This check fails.
  try {
    check(rect).containsPoint(Point(0, 0));
  } catch (e) {
    print(e);
    // Expected: a Rectangle<int> that:
    //   contains point <Point(0, 0)>
    // Actual: <Rectangle (10, 20) 30 x 40>
    // Which: does not contain point <Point(0, 0)>
  }
}
