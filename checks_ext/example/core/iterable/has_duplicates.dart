import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check([1, 2, 1]).hasDuplicates();

  /// This check fails.
  try {
    check([1, 2, 3]).hasDuplicates();
  } catch (e) {
    print(e);
  }
  // Expected: a List<int> that:
  //   has duplicates
  // Actual: [1, 2, 3]
  // Which: has no duplicates
}
