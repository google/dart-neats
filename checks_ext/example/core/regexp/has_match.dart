import 'package:checks_ext/checks_ext.dart';

void main() {
  final regex = RegExp(r'\d+');

  /// This check succeeds.
  check(regex).hasMatch('123');

  /// This check fails.
  try {
    check(regex).hasMatch('abc');
  } catch (e) {
    print(e);
  }
  // Expected: a RegExp that:
  //   matches 'abc'
  // Actual: <RegExp: pattern=\d+ flags=>
  // Which: does not match 'abc'
}
