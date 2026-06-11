import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(Duration(seconds: 1)).isLessThan(Duration(seconds: 2));

  /// This check fails.
  try {
    check(Duration(seconds: 3)).isLessThan(Duration(seconds: 2));
  } catch (e) {
    print(e);
  }
  // Expected: a Duration that:
  //   is less than 2s
  // Actual: <0:00:03.000000>
  // Which: was not less than 2s
  // actual was 3s
}
