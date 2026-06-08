import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(
    Duration(seconds: 5),
  ).isCloseTo(Duration(seconds: 6), within: Duration(seconds: 2));

  /// This check fails.
  try {
    check(
      Duration(seconds: 5),
    ).isCloseTo(Duration(seconds: 8), within: Duration(seconds: 2));
  } catch (e) {
    print(e);
  }
  // Expected: a Duration that:
  //   is close to 8s within 2s
  // Actual: <0:00:05.000000>
  // Which: differs by 3s
  // which is more than 2s
}
