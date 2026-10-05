import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check('ab12').isAlphanumeric();

  /// This check fails.
  try {
    check('ab1!').isAlphanumeric();
  } catch (e) {
    print(e);
  }
  // Expected: a String that:
  //   is alphanumeric
  // Actual: 'ab1!'
  // Which: contains characters that are not letters or digits
}
