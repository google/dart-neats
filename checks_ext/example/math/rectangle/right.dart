import 'dart:math';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final rect = Rectangle(10, 20, 30, 40);

  /// This check succeeds.
  check(rect).right.equals(40);

  /// This check fails.
  try {
    check(rect).right.equals(0);
  } catch (e) {
    print(e);
    // Expected: a Rectangle<int> that:
    //   has right that:
    //     equals <0>
    // Actual: a Rectangle<int> that:
    //   has right that:
    //   Actual: <40>
    //   Which: are not equal
  }
}
