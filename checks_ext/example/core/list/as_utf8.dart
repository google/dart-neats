import 'package:checks_ext/checks_ext.dart';

void main() {
  final bytes = [104, 101, 108, 108, 111]; // 'hello'

  /// This check succeeds.
  check(bytes).asUtf8.equals('hello');

  /// This check fails.
  final invalidBytes = [255, 254];
  try {
    check(invalidBytes).asUtf8.equals('hello');
  } catch (e) {
    print(e);
    // Expected: a List<int> that:
    //   as UTF-8 string
    // Actual: [255, 254]
    // Which: is not valid UTF-8
  }
}
