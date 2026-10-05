import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(BigInt.from(1)).isOdd();

  /// This check fails.
  try {
    check(BigInt.from(2)).isOdd();
  } catch (e) {
    print(e);
  }
  // Expected: a BigInt that:
  //   is odd
  // Actual: <2>
  // Which: is not odd
}
