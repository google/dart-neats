import 'package:checks_ext/checks_ext.dart';

void main() {
  final bytes = [104, 101, 108, 108, 111]; // 'hello'

  /// This check succeeds.
  check(bytes).isValidUtf8();

  /// This check fails.
  final invalidBytes = [255, 254];
  try {
    check(invalidBytes).isValidUtf8();
  } catch (e) {
    print(e);
    // Expected: a List<int> that:
    //   is valid UTF-8
    // Actual: [255, 254]
    // Which: is not valid UTF-8
  }
}
