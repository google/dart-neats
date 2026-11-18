import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final builder = BytesBuilder()..add([1, 2, 3]);

  /// This check succeeds.
  check(builder).bytes.deepEquals([1, 2, 3]);

  /// This check fails.
  try {
    check(builder).bytes.deepEquals([0, 0, 0]);
  } catch (e) {
    print(e);
    // Expected: a BytesBuilder that:
    //   has bytes that:
    //     is deeply equal to [0, 0, 0]
    // Actual: a BytesBuilder that:
    //   has bytes that:
    //   Actual: [1, 2, 3]
    //   Which: at [<0>] is <1>
    //   which does not equal <0>
  }
}
