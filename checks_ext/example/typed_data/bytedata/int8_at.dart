import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final data = ByteData(4)..setInt8(0, -42);

  /// This check succeeds.
  check(data).int8At(0).equals(-42);

  /// This check fails.
  try {
    check(data).int8At(0).equals(0);
  } catch (e) {
    print(e);
    // Expected: a ByteData that:
    //   has int8 at 0 that:
    //     equals <0>
    // Actual: a ByteData that:
    //   has int8 at 0 that:
    //   Actual: <-42>
    //   Which: are not equal
  }
}
