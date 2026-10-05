import 'dart:math';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final rect = Rectangle(10, 20, 30, 40);

  /// This check succeeds.
  check(rect).containsRectangle(Rectangle(15, 25, 10, 10));

  /// This check fails.
  try {
    check(rect).containsRectangle(Rectangle(0, 0, 5, 5));
  } catch (e) {
    print(e);
    // Expected: a Rectangle<int> that:
    //   contains rectangle <Rectangle (0, 0) 5 x 5>
    // Actual: <Rectangle (10, 20) 30 x 40>
    // Which: does not contain rectangle <Rectangle (0, 0) 5 x 5>
  }
}
