import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final data = ByteData(4)..setUint8(0, 42);

  /// This check succeeds.
  check(data).uint8At(0).equals(42);

  /// This check fails.
  try {
    check(data).uint8At(0).equals(0);
  } catch (e) {
    print(e);
    // Expected: a ByteData that:
    //   has uint8 at 0 that:
    //     equals <0>
    // Actual: a ByteData that:
    //   has uint8 at 0 that:
    //   Actual: <42>
    //   Which: are not equal
  }
}
