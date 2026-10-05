import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final buffer = Float32List.fromList([1.0, 2.0]).buffer;

  /// This check succeeds.
  check(buffer).asFloat32List().deepEquals([1.0, 2.0]);

  /// This check fails.
  try {
    check(buffer).asFloat32List().deepEquals([0.0, 0.0]);
  } catch (e) {
    print(e);
    // Expected: a ByteBuffer that:
    //   as Float32List that:
    //     is deeply equal to [0.0, 0.0]
    // Actual: a ByteBuffer that:
    //   as Float32List that:
    //   Actual: [1.0, 2.0]
    //   Which: at [<0>] is <1.0>
    //   which does not equal <0.0>
  }
}
