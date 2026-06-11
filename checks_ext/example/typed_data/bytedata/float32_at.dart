import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final data = ByteData(4)..setFloat32(0, 3.14, Endian.little);

  /// This check succeeds.
  check(data).float32At(0).isCloseTo(3.14, 0.01);

  /// This check fails.
  try {
    check(data).float32At(0).equals(0.0);
  } catch (e) {
    print(e);
    // Expected: a ByteData that:
    //   has float32 at 0 that:
    //     equals <0.0>
    // Actual: a ByteData that:
    //   has float32 at 0 that:
    //   Actual: <3.140000104904175>
    //   Which: are not equal
  }
}
