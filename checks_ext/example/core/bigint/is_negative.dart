import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(BigInt.from(-1)).isNegative();

  /// This check fails.
  try {
    check(BigInt.from(1)).isNegative();
  } catch (e) {
    print(e);
  }
  // Expected: a BigInt that:
  //   is negative
  // Actual: <1>
  // Which: is not negative
}
