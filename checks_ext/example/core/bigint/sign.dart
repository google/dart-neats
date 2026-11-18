import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(BigInt.from(-5)).sign.equals(-1);

  /// This check fails.
  try {
    check(BigInt.from(-5)).sign.equals(1);
  } catch (e) {
    print(e);
  }
  // Expected: a BigInt that:
  //   has sign that:
  //     equals <1>
  // Actual: a BigInt that:
  //   has sign that:
  //   Actual: <-1>
  //   Which: are not equal
}
