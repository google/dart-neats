import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check([1, 2, 3]).average.equals(2.0);

  /// This check fails.
  try {
    check([1, 2, 3]).average.equals(3.0);
  } catch (e) {
    print(e);
  }
  // Expected: a List<int> that:
  //   has average that:
  //     equals <3.0>
  // Actual: a List<int> that:
  //   has average that:
  //   Actual: <2.0>
  //   Which: are not equal
}
