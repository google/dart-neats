import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check('123').isNumeric();

  /// This check fails.
  try {
    check('12a').isNumeric();
  } catch (e) {
    print(e);
  }
  // Expected: a String that:
  //   is numeric
  // Actual: '12a'
  // Which: contains non-numeric characters
}
