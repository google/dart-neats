import 'package:checks_ext/checks_ext.dart';

void main() {
  final match = RegExp(r'(\d+)').firstMatch('123')!;

  /// This check succeeds.
  check(match)[1].equals('123');

  /// This check fails.
  try {
    check(match)[1].equals('456');
  } catch (e) {
    print(e);
  }
  // Expected: a RegExpMatch that:
  //   has group(1) that:
  //     equals '456'
  // Actual: a RegExpMatch that:
  //   has group(1) that:
  //   Actual: '123'
  //   Which: are not equal
}
