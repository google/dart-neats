import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check([1, 2, 3]).sum.equals(6);

  /// This check fails.
  try {
    check([1, 2, 3]).sum.equals(5);
  } catch (e) {
    print(e);
  }
  // Expected: a List<int> that:
  //   has sum that:
  //     equals <5>
  // Actual: a List<int> that:
  //   has sum that:
  //   Actual: <6>
  //   Which: are not equal
}
