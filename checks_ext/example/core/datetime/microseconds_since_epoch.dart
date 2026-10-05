import 'package:checks_ext/checks_ext.dart';

void main() {
  final date = DateTime.fromMicrosecondsSinceEpoch(123456789);

  /// This check succeeds.
  check(date).microsecondsSinceEpoch.equals(123456789);

  /// This check fails.
  try {
    check(date).microsecondsSinceEpoch.equals(0);
  } catch (e) {
    print(e);
    // Expected: a DateTime that:
    //   has microsecondsSinceEpoch that:
    //     equals <0>
    // Actual: a DateTime that:
    //   has microsecondsSinceEpoch that:
    //   Actual: <123456789>
    //   Which: are not equal
  }
}
