import 'dart:math';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final rect = Rectangle(10, 20, 30, 40);

  /// This check succeeds.
  check(rect).top.equals(20);

  /// This check fails.
  try {
    check(rect).top.equals(0);
  } catch (e) {
    print(e);
    // Expected: a Rectangle<int> that:
    //   has top that:
    //     equals <0>
    // Actual: a Rectangle<int> that:
    //   has top that:
    //   Actual: <20>
    //   Which: are not equal
  }
}
