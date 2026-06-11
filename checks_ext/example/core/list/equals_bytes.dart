import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check([0, 1, 2]).equalsBytes([0, 1, 2]);

  /// This check fails showing hex output.
  try {
    check([0, 1, 2]).equalsBytes([0, 1, 3]);
  } catch (e) {
    print(e);
  }
  // Expected: a List<int> that:
  //   equals [0, 1, 3]
  // Actual: [0, 1, 2]
  // Which: differs at offset 2:
  // Actual:   00 01 [02]
  // Expected: 00 01 [03]
}
