import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(BigInt.from(2)).isEven();

  /// This check fails.
  try {
    check(BigInt.from(1)).isEven();
  } catch (e) {
    print(e);
  }
  // Expected: a BigInt that:
  //   is even
  // Actual: <1>
  // Which: is not even
}
