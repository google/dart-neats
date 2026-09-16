import 'package:checks_ext/checks_ext.dart';

void main() {
  final date = DateTime(2026, 6, 2); // Tuesday (2)

  /// This check succeeds.
  check(date).weekday.equals(DateTime.tuesday);

  /// This check fails.
  try {
    check(date).weekday.equals(DateTime.sunday);
  } catch (e) {
    print(e);
    // Expected: a DateTime that:
    //   has weekday that:
    //     equals <7>
    // Actual: a DateTime that:
    //   has weekday that:
    //   Actual: <2>
    //   Which: are not equal
  }
}
