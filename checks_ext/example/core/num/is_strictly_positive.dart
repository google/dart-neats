import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(1).isStrictlyPositive();

  /// This check fails.
  try {
    check(0).isStrictlyPositive();
  } catch (e) {
    print(e);
  }
  // Expected: a int that:
  //   is strictly positive
  // Actual: <0>
  // Which: is not strictly positive
}
