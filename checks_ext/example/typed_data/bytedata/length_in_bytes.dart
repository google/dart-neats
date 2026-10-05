import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final data = ByteData(8);

  /// This check succeeds.
  check(data).lengthInBytes.equals(8);

  /// This check fails.
  try {
    check(data).lengthInBytes.equals(0);
  } catch (e) {
    print(e);
    // Expected: a ByteData that:
    //   has lengthInBytes that:
    //     equals <0>
    // Actual: a ByteData that:
    //   has lengthInBytes that:
    //   Actual: <8>
    //   Which: are not equal
  }
}
