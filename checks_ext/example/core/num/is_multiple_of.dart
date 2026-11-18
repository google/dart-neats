import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(6).isMultipleOf(3);

  /// This check fails.
  try {
    check(5).isMultipleOf(3);
  } catch (e) {
    print(e);
  }
  // Expected: a int that:
  //   is multiple of <3>
  // Actual: <5>
  // Which: is not a multiple of <3>
}
