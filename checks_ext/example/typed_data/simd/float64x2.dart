import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final v = Float64x2(1.0, 2.0);

  /// This check succeeds.
  check(v).x.equals(1.0);
  check(v).y.equals(2.0);

  /// This check fails.
  try {
    check(v).x.equals(0.0);
  } catch (e) {
    print(e);
    // Expected: a Float64x2 that:
    //   has x that:
    //     equals <0.0>
    // Actual: a Float64x2 that:
    //   has x that:
    //   Actual: <1.0>
    //   Which: are not equal
  }
}
