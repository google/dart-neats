import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(BigInt.from(2)).isNotOdd();

  /// This check fails.
  try {
    check(BigInt.from(1)).isNotOdd();
  } catch (e) {
    print(e);
  }
  // Expected: a BigInt that:
  //   is not odd
  // Actual: <1>
  // Which: is odd
}
