import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(Duration.zero).isZero();

  /// This check fails.
  try {
    check(Duration(seconds: 5)).isZero();
  } catch (e) {
    print(e);
  }
  // Expected: a Duration that:
  //   is zero
  // Actual: <0:00:05.000000>
  // Which: is not zero
}
