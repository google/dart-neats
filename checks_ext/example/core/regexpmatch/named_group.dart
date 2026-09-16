import 'package:checks_ext/checks_ext.dart';

void main() {
  final match = RegExp(r'(?<year>\d{4})').firstMatch('2026')!;

  /// This check succeeds.
  check(match).namedGroup('year').equals('2026');

  /// This check fails.
  try {
    check(match).namedGroup('year').equals('2025');
  } catch (e) {
    print(e);
  }
  // Expected: a RegExpMatch that:
  //   has namedGroup(year) that:
  //     equals '2025'
  // Actual: a RegExpMatch that:
  //   has namedGroup(year) that:
  //   Actual: '2026'
  //   Which: are not equal
}
