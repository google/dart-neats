import 'package:checks_ext/checks_ext.dart';

void main() {
  final date = DateTime(2026, 6, 2);

  /// This check succeeds.
  check(date).month.equals(6);

  /// This check fails.
  try {
    check(date).month.equals(12);
  } catch (e) {
    print(e);
    // Expected: a DateTime that:
    //   has month that:
    //     equals <12>
    // Actual: a DateTime that:
    //   has month that:
    //   Actual: <6>
    //   Which: are not equal
  }
}
