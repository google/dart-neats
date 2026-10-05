import 'package:checks_ext/checks_ext.dart';

void main() {
  final date1 = DateTime(2026, 6, 2);
  final date2 = DateTime(2026, 6, 1);

  /// This check succeeds.
  check(date1).difference(date2).equals(Duration(days: 1));

  /// This check fails.
  try {
    check(date1).difference(date2).equals(Duration(days: 2));
  } catch (e) {
    print(e);
  }
  // Expected: a DateTime that:
  //   difference from <2026-06-01 00:00:00.000> that:
  //     equals <48:00:00.000000>
  // Actual: a DateTime that:
  //   difference from <2026-06-01 00:00:00.000> that:
  //   Actual: <24:00:00.000000>
  //   Which: are not equal
}
