import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check('ABC').isUpperCase();

  /// This check fails.
  try {
    check('Abc').isUpperCase();
  } catch (e) {
    print(e);
  }
  // Expected: a String that:
  //   is upper case
  // Actual: 'Abc'
  // Which: was not upper case
}
