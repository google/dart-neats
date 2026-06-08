import 'dart:async';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final controller = StreamController<int>();

  /// This check succeeds.
  check(controller).hasNoListener();

  /// This check fails.
  controller.stream.listen((_) {});
  try {
    check(controller).hasNoListener();
  } catch (e) {
    print(e);
  }
  // Expected: a StreamController<int> that:
  //   has no listener
  // Actual: <Instance of '_AsyncStreamController<int>'>
  // Which: has listener
}
