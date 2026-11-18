import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(Endian.little).isLittleEndian();

  /// This check fails.
  try {
    check(Endian.big).isLittleEndian();
  } catch (e) {
    print(e);
  }
  // Expected: a Endian that:
  //   is Endian.little
  // Actual: <Instance of 'Endian'>
  // Which: is Endian.big
}
