import 'package:checks_ext/checks_ext.dart';

void main() {
  final uri = Uri.parse('https://example.com');

  /// This check succeeds.
  check(uri).hasScheme('https');

  /// This check fails.
  try {
    check(uri).hasScheme('http');
  } catch (e) {
    print(e);
  }
  // Expected: a Uri that:
  //   has scheme 'http'
  // Actual: <https://example.com>
  // Which: has scheme 'https'
}
