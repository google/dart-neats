import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check({1, 2}).isSubsetOf({1, 2, 3});

  /// This check fails.
  try {
    check({1, 4}).isSubsetOf({1, 2, 3});
  } catch (e) {
    print(e);
  }
  // Expected: a Set<int> that:
  //   is a subset of {1, 2, 3}
  // Actual: {1, 4}
  // Which: contains elements not in the other set: {4}
}
