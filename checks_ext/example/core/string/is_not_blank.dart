import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check('abc').isNotBlank();

  /// This check fails.
  try {
    check('  ').isNotBlank();
  } catch (e) {
    print(e);
  }
  // Expected: a String that:
  //   is not blank
  // Actual: '  '
  // Which: was blank
}
