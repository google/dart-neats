import 'package:checks_ext/checks_ext.dart';

void main() {
  final date = DateTime.utc(2026, 6, 2);

  /// This check succeeds.
  check(date).isUtc();

  /// This check fails.
  try {
    check(DateTime(2026, 6, 2)).isUtc();
  } catch (e) {
    print(e);
    // Expected: a DateTime that:
    //   is UTC
    // Actual: <2026-06-02 00:00:00.000>
    // Which: is not in UTC
  }
}
