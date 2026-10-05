import 'package:checks_ext/checks_ext.dart';

void main() {
  final regex = RegExp(r'\d+');

  /// This check succeeds.
  check(regex).allMatches('123 456').length.equals(2);

  /// This check fails.
  try {
    check(regex).allMatches('abc').isNotEmpty();
  } catch (e) {
    print(e);
  }
  // Expected: a RegExp that:
  //   has allMatches on 'abc' that:
  //     is not empty
  // Actual: a RegExp that:
  //   has allMatches on 'abc' that:
  //   Actual: ()
  //   Which: is empty
}
