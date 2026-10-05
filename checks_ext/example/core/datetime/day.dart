import 'package:checks_ext/checks_ext.dart';

void main() {
  final date = DateTime(2026, 6, 2);

  /// This check succeeds.
  check(date).day.equals(2);

  /// This check fails.
  try {
    check(date).day.equals(15);
  } catch (e) {
    print(e);
    // Expected: a DateTime that:
    //   has day that:
    //     equals <15>
    // Actual: a DateTime that:
    //   has day that:
    //   Actual: <2>
    //   Which: are not equal
  }
}
