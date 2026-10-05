import 'package:checks_ext/checks_ext.dart';

void main() {
  final entry = MapEntry('a', 1);

  /// This check succeeds.
  check(entry).key.equals('a');

  /// This check fails.
  try {
    check(entry).key.equals('b');
  } catch (e) {
    print(e);
  }
  // Expected: a MapEntry<String, int> that:
  //   has key that:
  //     equals 'b'
  // Actual: a MapEntry<String, int> that:
  //   has key that:
  //   Actual: 'a'
  //   Which: differs at offset 0:
  //   b
  //   a
  //   ^
}
