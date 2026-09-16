import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final data = ByteData(8)..setFloat64(0, 3.1415926535, Endian.little);

  /// This check succeeds.
  check(data).float64At(0).equals(3.1415926535);

  /// This check fails.
  try {
    check(data).float64At(0).equals(0.0);
  } catch (e) {
    print(e);
    // Expected: a ByteData that:
    //   has float64 at 0 that:
    //     equals <0.0>
    // Actual: a ByteData that:
    //   has float64 at 0 that:
    //   Actual: <3.1415926535>
    //   Which: are not equal
  }
}
