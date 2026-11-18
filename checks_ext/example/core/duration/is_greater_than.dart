import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(Duration(seconds: 5)).isGreaterThan(Duration(seconds: 2));

  /// This check fails.
  try {
    check(Duration(seconds: 1)).isGreaterThan(Duration(seconds: 2));
  } catch (e) {
    print(e);
  }
  // Expected: a Duration that:
  //   is greater than 2s
  // Actual: <0:00:01.000000>
  // Which: was not greater than 2s
  // actual was 1s
}
