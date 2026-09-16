import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check([1, 2, 3]).containsAll([1, 2]);

  /// This check fails.
  try {
    check([1, 2, 3]).containsAll([1, 4]);
  } catch (e) {
    print(e);
  }
  // Expected: a List<int> that:
  //   contains all of [1, 4]
  // Actual: [1, 2, 3]
  // Which: is missing elements: [4]
}
