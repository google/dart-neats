import 'package:checks_ext/checks_ext.dart';

void main() {
  final match = RegExp(r'banana').firstMatch('apple banana cherry')!;

  /// This check succeeds.
  check(match).start.equals(6);

  /// This check fails.
  try {
    check(match).start.equals(0);
  } catch (e) {
    print(e);
  }
  // Expected: a RegExpMatch that:
  //   has start that:
  //     equals <0>
  // Actual: a RegExpMatch that:
  //   has start that:
  //   Actual: <6>
  //   Which: are not equal
}
