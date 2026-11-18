import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final buffer = Uint8List(4).buffer;

  /// This check succeeds.
  check(buffer).lengthInBytes.equals(4);

  /// This check fails.
  try {
    check(buffer).lengthInBytes.equals(10);
  } catch (e) {
    print(e);
    // Expected: a ByteBuffer that:
    //   has lengthInBytes that:
    //     equals <10>
    // Actual: a ByteBuffer that:
    //   has lengthInBytes that:
    //   Actual: <4>
    //   Which: are not equal
  }
}
