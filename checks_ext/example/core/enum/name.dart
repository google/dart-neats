import 'package:checks_ext/checks_ext.dart';

enum Fruit { apple, banana }

void main() {
  /// This check succeeds.
  check(Fruit.apple).name.equals('apple');

  /// This check fails.
  try {
    check(Fruit.apple).name.equals('banana');
  } catch (e) {
    print(e);
  }
  // Expected: a Fruit that:
  //   has name that:
  //     equals 'banana'
  // Actual: a Fruit that:
  //   has name that:
  //   Actual: 'apple'
  //   Which: differs at offset 0:
  //   banana
  //   apple
  //   ^
}
