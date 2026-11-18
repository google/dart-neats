import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(StringBuffer()).isEmpty();

  /// This check fails.
  try {
    check(StringBuffer('abc')).isEmpty();
  } catch (e) {
    print(e);
  }
  // Expected: a StringBuffer that:
  //   is empty
  // Actual: <abc>
  // Which: is not empty
}
