import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check([1, 2, 3]).isSorted();

  /// This check fails.
  try {
    check([2, 1, 3]).isSorted();
  } catch (e) {
    print(e);
  }
  // Expected: a List<int> that:
  //   is sorted
  // Actual: [2, 1, 3]
  // Which: is not sorted, because element at index 0 <2>
  // compares after element at index 1 <1>
}
