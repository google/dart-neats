import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final data = ByteData(4)..setInt16(0, -1000, Endian.little);

  /// This check succeeds.
  check(data).int16At(0).equals(-1000);

  /// This check fails.
  try {
    check(data).int16At(0).equals(0);
  } catch (e) {
    print(e);
    // Expected: a ByteData that:
    //   has int16 at 0 that:
    //     equals <0>
    // Actual: a ByteData that:
    //   has int16 at 0 that:
    //   Actual: <-1000>
    //   Which: are not equal
  }
}
