import 'package:checks_ext/checks_ext.dart';

void main() {
  final bytes = [1, 2, 3, 4, 5];

  /// This check succeeds.
  check(bytes).containsBytes([3, 4]);

  /// This check fails.
  try {
    check(bytes).containsBytes([3, 6]);
  } catch (e) {
    print(e);
  }
  // Expected: a List<int> that:
  //   contains bytes [3, 6]
  // Actual: [1, 2, 3, 4, 5]
  // Which: does not contain the sequence: 03 06
  // Actual bytes:                 01 02 03 04 05
}
