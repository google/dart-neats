import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final builder = BytesBuilder();

  /// This check succeeds.
  check(builder).isEmpty();

  /// This check fails.
  try {
    check(BytesBuilder()..add([1])).isEmpty();
  } catch (e) {
    print(e);
    // Expected: a BytesBuilder that:
    //   is empty
    // Actual: <Instance of '_CopyingBytesBuilder'>
    // Which: is not empty
  }
}
