import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(Duration(seconds: -5)).isNegative();

  /// This check fails.
  try {
    check(Duration(seconds: 5)).isNegative();
  } catch (e) {
    print(e);
  }
  // Expected: a Duration that:
  //   is negative
  // Actual: <0:00:05.000000>
  // Which: is not negative
}
