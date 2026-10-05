import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(BigInt.from(1)).isNotEven();

  /// This check fails.
  try {
    check(BigInt.from(2)).isNotEven();
  } catch (e) {
    print(e);
  }
  // Expected: a BigInt that:
  //   is not even
  // Actual: <2>
  // Which: is even
}
