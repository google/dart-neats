import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final buffer = Int16List.fromList([1, 2]).buffer;
  final data = Int32List.view(buffer);

  /// This check succeeds.
  check(data).asInt16List.deepEquals([1, 2]);

  /// This check fails.
  try {
    check(data).asInt16List.deepEquals([0, 0]);
  } catch (e) {
    print(e);
    // Expected: a Int32List that:
    //   as Int16List that:
    //     is deeply equal to [0, 0]
    // Actual: a Int32List that:
    //   as Int16List that:
    //   Actual: [1, 2]
    //   Which: at [<0>] is <1>
    //   which does not equal <0>
  }
}
