import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(BigInt.from(5)).bitLength.equals(3);

  /// This check fails.
  try {
    check(BigInt.from(5)).bitLength.equals(4);
  } catch (e) {
    print(e);
  }
  // Expected: a BigInt that:
  //   has bitLength that:
  //     equals <4>
  // Actual: a BigInt that:
  //   has bitLength that:
  //   Actual: <3>
  //   Which: are not equal
}
