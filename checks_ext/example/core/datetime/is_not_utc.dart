import 'package:checks_ext/checks_ext.dart';

void main() {
  final date = DateTime(2026, 6, 2);

  /// This check succeeds.
  check(date).isNotUtc();

  /// This check fails.
  try {
    check(DateTime.utc(2026, 6, 2)).isNotUtc();
  } catch (e) {
    print(e);
    // Expected: a DateTime that:
    //   is not in UTC
    // Actual: <2026-06-02 00:00:00.000Z>
    // Which: is UTC
  }
}
