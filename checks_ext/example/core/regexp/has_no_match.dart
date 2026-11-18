import 'package:checks_ext/checks_ext.dart';

void main() {
  final regex = RegExp(r'\d+');

  /// This check succeeds.
  check(regex).hasNoMatch('abc');

  /// This check fails.
  try {
    check(regex).hasNoMatch('123');
  } catch (e) {
    print(e);
  }
  // Expected: a RegExp that:
  //   does not match '123'
  // Actual: <RegExp: pattern=\d+ flags=>
  // Which: matched '123' at index 0:
  // 123
  // ^
}
