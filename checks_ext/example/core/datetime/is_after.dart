import 'package:checks_ext/checks_ext.dart';

void main() {
  final date = DateTime(2026, 6, 2);

  /// This check succeeds.
  check(date).isAfter(DateTime(2026, 6, 1));

  /// This check fails.
  try {
    check(date).isAfter(DateTime(2026, 6, 3));
  } catch (e) {
    print(e);
    // Expected: a DateTime that:
    //   is after <2026-06-03 00:00:00.000>
    // Actual: <2026-06-02 00:00:00.000>
    // Which: was not after <2026-06-03 00:00:00.000>
  }
}
