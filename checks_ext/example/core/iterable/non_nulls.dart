import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check([1, null, 2]).nonNulls.deepEquals([1, 2]);

  /// This check fails.
  try {
    check([1, null, 2]).nonNulls.deepEquals([1, 3]);
  } catch (e) {
    print(e);
  }
  // Expected: a List<int?> that:
  //   skipping nulls that:
  //     is deeply equal to [1, 3]
  // Actual: a List<int?> that:
  //   skipping nulls that:
  //   Actual: (1, 2)
  //   Which: at [<1>] is <2>
  //   which does not equal <3>
}
