import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check([1, 2, 3, 4]).containsSequence([2, 3]);

  /// This check fails.
  try {
    check([1, 2, 3, 4]).containsSequence([2, 4]);
  } catch (e) {
    print(e);
  }
  // Expected: a List<int> that:
  //   contains sequence [2, 4]
  // Actual: [1, 2, 3, 4]
  // Which: does not contain the sequence
}
