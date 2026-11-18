import 'dart:async';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final controller = StreamController<int>();
  final sub = controller.stream.listen((_) {});

  /// This check succeeds.
  check(controller).isNotPaused();

  /// This check fails.
  sub.pause();
  try {
    check(controller).isNotPaused();
  } catch (e) {
    print(e);
    // Expected: a StreamController<int> that:
    //   is not paused
    // Actual: <Instance of '_AsyncStreamController<int>'>
    // Which: is paused
  }

  /* Clean up */
  sub.cancel();
}
