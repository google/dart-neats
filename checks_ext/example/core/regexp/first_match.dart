import 'package:checks_ext/checks_ext.dart';

void main() {
  final regex = RegExp(r'(?<year>\d{4})');

  /// This check succeeds.
  check(regex).firstMatch('2026').isNotNull().namedGroup('year').equals('2026');

  /// This check fails.
  try {
    check(regex).firstMatch('abc').isNotNull();
  } catch (e) {
    print(e);
  }
  // Expected: a RegExp that:
  //   has firstMatch on 'abc' that:
  //     is not null
  // Actual: a RegExp that:
  //   has firstMatch on 'abc' that:
  //   Actual: <null>
}
