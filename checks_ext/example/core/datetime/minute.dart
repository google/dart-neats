import 'package:checks_ext/checks_ext.dart';

void main() {
  final date = DateTime(2026, 6, 2, 14, 30); // 14:30

  /// This check succeeds.
  check(date).minute.equals(30);

  /// This check fails.
  try {
    check(date).minute.equals(0);
  } catch (e) {
    print(e);
    // Expected: a DateTime that:
    //   has minute that:
    //     equals <0>
    // Actual: a DateTime that:
    //   has minute that:
    //   Actual: <30>
    //   Which: are not equal
  }
}
