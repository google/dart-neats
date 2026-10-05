import 'dart:async';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final completer = Completer<int>()..complete(42);

  /// This check succeeds.
  check(completer).isCompleted();

  /// This check fails.
  final pending = Completer<int>();
  try {
    check(pending).isCompleted();
  } catch (e) {
    print(e);
  }
  // Expected: a Completer<int> that:
  //   is completed
  // Actual: <Instance of '_AsyncCompleter<int>'>
  // Which: is not completed
}
