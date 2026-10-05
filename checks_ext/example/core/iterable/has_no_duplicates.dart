import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check([1, 2, 3]).hasNoDuplicates();

  /// This check fails.
  try {
    check([1, 2, 1, 2]).hasNoDuplicates();
  } catch (e) {
    print(e);
  }
  // Expected: a List<int> that:
  //   has no duplicates
  // Actual: [1, 2, 1, 2]
  // Which: has duplicates: [1, 2]
}
