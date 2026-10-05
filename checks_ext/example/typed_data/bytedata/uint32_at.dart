import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final data = ByteData(4)..setUint32(0, 100000, Endian.little);

  /// This check succeeds.
  check(data).uint32At(0).equals(100000);

  /// This check fails.
  try {
    check(data).uint32At(0).equals(0);
  } catch (e) {
    print(e);
    // Expected: a ByteData that:
    //   has uint32 at 0 that:
    //     equals <0>
    // Actual: a ByteData that:
    //   has uint32 at 0 that:
    //   Actual: <100000>
    //   Which: are not equal
  }
}
