import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check('abc').isAlpha();

  /// This check fails.
  try {
    check('ab1').isAlpha();
  } catch (e) {
    print(e);
  }
  // Expected: a String that:
  //   is alpha
  // Actual: 'ab1'
  // Which: contains non-alphabetic characters
}
