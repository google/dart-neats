import 'package:checks_ext/checks_ext.dart';

void main() {
  final regex = RegExp(r'\d+');

  /// This check succeeds.
  check(regex).pattern.equals(r'\d+');

  /// This check fails.
  try {
    check(regex).pattern.equals(r'\w+');
  } catch (e) {
    print(e);
  }
  // Expected: a RegExp that:
  //   has pattern that:
  //     equals '\\w+'
  // Actual: a RegExp that:
  //   has pattern that:
  //   Actual: '\\d+'
  //   Which: differs at offset 2:
  //   \\w+
  //   \\d+
  //     ^
}
