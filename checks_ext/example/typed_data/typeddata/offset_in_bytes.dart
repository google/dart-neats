import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final buffer = Uint8List(8).buffer;
  final data = Uint8List.view(buffer, 2);

  /// This check succeeds.
  check(data).offsetInBytes.equals(2);

  /// This check fails.
  try {
    check(data).offsetInBytes.equals(0);
  } catch (e) {
    print(e);
    // Expected: a Uint8List that:
    //   has offsetInBytes that:
    //     equals <0>
    // Actual: a Uint8List that:
    //   has offsetInBytes that:
    //   Actual: <2>
    //   Which: are not equal
  }
}
