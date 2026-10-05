import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check(Endian.big).isBigEndian();

  /// This check fails.
  try {
    check(Endian.little).isBigEndian();
  } catch (e) {
    print(e);
  }
  // Expected: a Endian that:
  //   is Endian.big
  // Actual: <Instance of 'Endian'>
  // Which: is Endian.little
}
