import 'package:checks_ext/checks_ext.dart';

void main() {
  final buffer = StringBuffer('abc');

  /// This check succeeds.
  check(buffer).asString.equals('abc');

  /// This check fails.
  try {
    check(buffer).asString.equals('def');
  } catch (e) {
    print(e);
  }
  // Expected: a StringBuffer that:
  //   has asString that:
  //     equals 'def'
  // Actual: a StringBuffer that:
  //   has asString that:
  //   Actual: 'abc'
  //   Which: differs at offset 0:
  //   def
  //   abc
  //   ^
}
