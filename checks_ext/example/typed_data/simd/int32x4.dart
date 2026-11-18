import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final v = Int32x4(1, 2, 3, 4);

  /// This check succeeds.
  check(v).x.equals(1);
  check(v).y.equals(2);
  check(v).z.equals(3);
  check(v).w.equals(4);

  /// This check fails.
  try {
    check(v).x.equals(0);
  } catch (e) {
    print(e);
    // Expected: a Int32x4 that:
    //   has x that:
    //     equals <0>
    // Actual: a Int32x4 that:
    //   has x that:
    //   Actual: <1>
    //   Which: are not equal
  }
}
