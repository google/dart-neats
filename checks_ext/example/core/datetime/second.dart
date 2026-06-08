import 'package:checks_ext/checks_ext.dart';

void main() {
  final date = DateTime(2026, 6, 2, 14, 30, 45); // 14:30:45

  /// This check succeeds.
  check(date).second.equals(45);

  /// This check fails.
  try {
    check(date).second.equals(0);
  } catch (e) {
    print(e);
    // Expected: a DateTime that:
    //   has second that:
    //     equals <0>
    // Actual: a DateTime that:
    //   has second that:
    //   Actual: <45>
    //   Which: are not equal
  }
}
