import 'package:checks_ext/checks_ext.dart';

void main() {
  final entry = MapEntry('a', 1);

  /// This check succeeds.
  check(entry).value.equals(1);

  /// This check fails.
  try {
    check(entry).value.equals(2);
  } catch (e) {
    print(e);
  }
  // Expected: a MapEntry<String, int> that:
  //   has value that:
  //     equals <2>
  // Actual: a MapEntry<String, int> that:
  //   has value that:
  //   Actual: <1>
  //   Which: are not equal
}
