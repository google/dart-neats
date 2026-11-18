import 'package:checks_ext/checks_ext.dart';

void main() {
  final date = DateTime(2026, 6, 2, 14); // 14:00

  /// This check succeeds.
  check(date).hour.equals(14);

  /// This check fails.
  try {
    check(date).hour.equals(9);
  } catch (e) {
    print(e);
    // Expected: a DateTime that:
    //   has hour that:
    //     equals <9>
    // Actual: a DateTime that:
    //   has hour that:
    //   Actual: <14>
    //   Which: are not equal
  }
}
