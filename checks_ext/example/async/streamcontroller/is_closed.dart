import 'dart:async';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final controller = StreamController<int>();

  /// This check succeeds.
  check(controller).isNotClosed();

  /// This check fails.
  try {
    check(controller).isClosed();
  } catch (e) {
    print(e);
    // Expected: a StreamController<int> that:
    //   is closed
    // Actual: <Instance of '_AsyncStreamController<int>'>
    // Which: is not closed
  }
}
