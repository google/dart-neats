import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check('abc').isLowerCase();

  /// This check fails.
  try {
    check('Abc').isLowerCase();
  } catch (e) {
    print(e);
  }
  // Expected: a String that:
  //   is lower case
  // Actual: 'Abc'
  // Which: was not lower case
}
