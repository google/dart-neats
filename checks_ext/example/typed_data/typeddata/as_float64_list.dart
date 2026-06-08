import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final buffer = Float64List.fromList([1.0, 2.0]).buffer;
  final data = Float64List.view(buffer);

  /// This check succeeds.
  check(data).asFloat64List.deepEquals([1.0, 2.0]);

  /// This check fails.
  try {
    check(data).asFloat64List.deepEquals([0.0, 0.0]);
  } catch (e) {
    print(e);
    // Expected: a Float64List that:
    //   as Float64List that:
    //     is deeply equal to [0.0, 0.0]
    // Actual: a Float64List that:
    //   as Float64List that:
    //   Actual: [1.0, 2.0]
    //   Which: at [<0>] is <1.0>
    //   which does not equal <0.0>
  }
}
