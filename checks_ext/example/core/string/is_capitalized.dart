import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check('Apple').isCapitalized();

  /// This check fails.
  try {
    check('apple').isCapitalized();
  } catch (e) {
    print(e);
  }
  // Expected: a String that:
  //   is capitalized
  // Actual: 'apple'
  // Which: first character was not upper case
}
