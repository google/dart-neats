import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final buffer = Uint16List.fromList([1, 2]).buffer;

  /// This check succeeds.
  check(buffer).asUint16List().deepEquals([1, 2]);

  /// This check fails.
  try {
    check(buffer).asUint16List().deepEquals([0, 0]);
  } catch (e) {
    print(e);
    // Expected: a ByteBuffer that:
    //   as Uint16List that:
    //     is deeply equal to [0, 0]
    // Actual: a ByteBuffer that:
    //   as Uint16List that:
    //   Actual: [1, 2]
    //   Which: at [<0>] is <1>
    //   which does not equal <0>
  }
}
