import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final v = Float32x4(1.0, 2.0, 3.0, 4.0);

  /// This check succeeds.
  check(v).x.equals(1.0);
  check(v).y.equals(2.0);
  check(v).z.equals(3.0);
  check(v).w.equals(4.0);

  /// This check fails.
  try {
    check(v).x.equals(0.0);
  } catch (e) {
    print(e);
    // Expected: a Float32x4 that:
    //   has x that:
    //     equals <0.0>
    // Actual: a Float32x4 that:
    //   has x that:
    //   Actual: <1.0>
    //   Which: are not equal
  }
}
