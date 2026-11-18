import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check([1, 5, 3]).max.equals(5);

  /// This check fails.
  try {
    check([1, 5, 3]).max.equals(1);
  } catch (e) {
    print(e);
    // Expected: a List<int> that:
    //   has max that:
    //     equals <1>
    // Actual: a List<int> that:
    //   has max that:
    //   Actual: <5>
    //   Which: are not equal
  }
}
