import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(BigInt.from(42)).isValidInt();

  /// This check fails.
  try {
    check(
      BigInt.parse('10000000000000000000000000000000000000000'),
    ).isValidInt();
  } catch (e) {
    print(e);
  }
  // Expected: a BigInt that:
  //   is valid int
  // Actual: <10000000000000000000000000000000000000000>
  // Which: is not valid int
}
