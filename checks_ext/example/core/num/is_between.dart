import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(5).isBetween(1, 10);

  /// This check fails.
  try {
    check(0).isBetween(1, 10);
  } catch (e) {
    print(e);
  }
  // Expected: a int that:
  //   is between <1>
  //   and <10>
  //    (inclusive)
  // Actual: <0>
  // Which: is not between <1>
  // and <10>
  //  (inclusive)
}
