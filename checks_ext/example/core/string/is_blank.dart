import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check('  ').isBlank();

  /// This check fails.
  try {
    check('abc').isBlank();
  } catch (e) {
    print(e);
  }
  // Expected: a String that:
  //   is blank
  // Actual: 'abc'
  // Which: was not blank
}
