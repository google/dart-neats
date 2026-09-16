import 'package:checks_ext/checks_ext.dart';

void main() {
  final date = DateTime(2026, 6, 2);

  /// This check succeeds.
  check(date).isBetween(DateTime(2026, 6, 1), DateTime(2026, 6, 3));

  /// This check fails.
  try {
    check(date).isBetween(DateTime(2026, 6, 4), DateTime(2026, 6, 6));
  } catch (e) {
    print(e);
    // Expected: a DateTime that:
    //   is between <2026-06-04 00:00:00.000>
    //   and <2026-06-06 00:00:00.000>
    //    (inclusive)
    // Actual: <2026-06-02 00:00:00.000>
    // Which: was not between <2026-06-04 00:00:00.000>
    // and <2026-06-06 00:00:00.000>
    //  (inclusive)
  }
}
