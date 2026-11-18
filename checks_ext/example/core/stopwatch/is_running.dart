import 'package:checks_ext/checks_ext.dart';

void main() {
  final stopwatch = Stopwatch()..start();

  /// This check succeeds.
  check(stopwatch).isRunning();

  /// This check fails.
  final stopped = Stopwatch();
  try {
    check(stopped).isRunning();
  } catch (e) {
    print(e);
  }
  // Expected: a Stopwatch that:
  //   is running
  // Actual: Stopwatch(running: false, elapsed: 0s)
  // Which: is not running
}
