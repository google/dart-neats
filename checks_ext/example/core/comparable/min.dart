import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check([5, 1, 3]).min.equals(1);

  /// This check fails.
  try {
    check([5, 1, 3]).min.equals(5);
  } catch (e) {
    print(e);
    // Expected: a List<int> that:
    //   has min that:
    //     equals <5>
    // Actual: a List<int> that:
    //   has min that:
    //   Actual: <1>
    //   Which: are not equal
  }
}
