import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final endian = Endian.host;

  /// This check succeeds.
  check(endian).isHost();

  /// This check fails.
  final nonHost = Endian.host == Endian.big ? Endian.little : Endian.big;
  try {
    check(nonHost).isHost();
  } catch (e) {
    print(e);
  }
  // Expected: a Endian that:
  //   is Endian.host
  // Actual: <Instance of 'Endian'>
  // Which: is Endian.big
}
