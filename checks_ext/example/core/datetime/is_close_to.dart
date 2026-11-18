import 'package:checks_ext/checks_ext.dart';

void main() {
  final date1 = DateTime(2026, 6, 2);
  final date2 = DateTime(2026, 6, 1);

  /// This check succeeds.
  check(date1).isCloseTo(date2, within: Duration(days: 2));

  /// This check fails.
  try {
    check(date1).isCloseTo(date2, within: Duration(hours: 1));
  } catch (e) {
    print(e);
  }
  // Expected: a DateTime that:
  //   is close to <2026-06-01 00:00:00.000> within 1 hour
  // Actual: <2026-06-02 00:00:00.000>
  // Which: differs by 1 day
  // which is more than 1 hour
}
