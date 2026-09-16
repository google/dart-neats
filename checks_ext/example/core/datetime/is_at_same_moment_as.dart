import 'package:checks_ext/checks_ext.dart';

void main() {
  final date = DateTime(2026, 6, 2);

  /// This check succeeds.
  check(date).isAtSameMomentAs(DateTime(2026, 6, 2));

  /// This check fails.
  try {
    check(date).isAtSameMomentAs(DateTime(2026, 6, 1));
  } catch (e) {
    print(e);
    // Expected: a DateTime that:
    //   is at same moment as <2026-06-01 00:00:00.000>
    // Actual: <2026-06-02 00:00:00.000>
    // Which: was not at same moment as <2026-06-01 00:00:00.000>
  }
}
