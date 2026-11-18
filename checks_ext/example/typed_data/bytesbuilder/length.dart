import 'dart:typed_data';
import 'package:checks_ext/checks_ext.dart';

void main() {
  final builder = BytesBuilder()..add([1, 2, 3]);

  /// This check succeeds.
  check(builder).length.equals(3);

  /// This check fails.
  try {
    check(builder).length.equals(0);
  } catch (e) {
    print(e);
    // Expected: a BytesBuilder that:
    //   has length that:
    //     equals <0>
    // Actual: a BytesBuilder that:
    //   has length that:
    //   Actual: <3>
    //   Which: are not equal
  }
}
