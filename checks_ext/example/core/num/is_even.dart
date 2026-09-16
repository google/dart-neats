import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(2).isEven();

  /// This check fails.
  try {
    check(1).isEven();
  } catch (e) {
    print(e);
  }
  // Expected: a int that:
  //   is even
  // Actual: <1>
  // Which: is odd
}
