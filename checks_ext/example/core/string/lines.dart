import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check('apple\nbanana\ncherry').lines.contains('banana');

  /// This check fails.
  try {
    check('apple\nbanana\ncherry').lines.contains('date');
  } catch (e) {
    print(e);
  }
  // Expected: a String that:
  //   has lines that:
  //     contains 'date'
  // Actual: a String that:
  //   has lines that:
  //   Actual: ['apple', 'banana', 'cherry']
  //   Which: does not contain 'date'
}
