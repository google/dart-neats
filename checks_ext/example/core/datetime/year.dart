import 'package:checks_ext/checks_ext.dart';

void main() {
  final date = DateTime(2026, 6, 2);

  /// This check succeeds.
  check(date).year.equals(2026);

  /// This check fails.
  try {
    check(date).year.equals(2020);
  } catch (e) {
    print(e);
    // Expected: a DateTime that:
    //   has year that:
    //     equals <2020>
    // Actual: a DateTime that:
    //   has year that:
    //   Actual: <2026>
    //   Which: are not equal
  }
}
