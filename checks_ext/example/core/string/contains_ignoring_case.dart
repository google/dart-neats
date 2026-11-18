import 'package:checks_ext/checks_ext.dart';

void main() {
  /// This check succeeds.
  check('HelloWorld').containsIgnoringCase('world');

  /// This check fails.
  try {
    check('Hello').containsIgnoringCase('world');
  } catch (e) {
    print(e);
  }
  // Expected: a String that:
  //   contains ignoring case 'world'
  // Actual: 'Hello'
  // Which: does not contain 'world' (case-insensitive)
}
