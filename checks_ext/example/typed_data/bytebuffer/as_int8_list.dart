import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final buffer = Int8List.fromList([1, 2, 3, 4]).buffer;

  /// This check succeeds.
  check(buffer).asInt8List().deepEquals([1, 2, 3, 4]);

  /// This check fails.
  try {
    check(buffer).asInt8List().deepEquals([0, 0, 0, 0]);
  } catch (e) {
    print(e);
    // Expected: a ByteBuffer that:
    //   as Int8List that:
    //     is deeply equal to [0, 0, 0, 0]
    // Actual: a ByteBuffer that:
    //   as Int8List that:
    //   Actual: [1, 2, 3, 4]
    //   Which: at [<0>] is <1>
    //   which does not equal <0>
  }
}
