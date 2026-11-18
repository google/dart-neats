import 'package:checks_ext/checks_ext.dart';

void main() {
  final uri = Uri.parse('https://example.com');

  /// This check succeeds.
  check(uri).host.equals('example.com');

  /// This check fails.
  try {
    check(uri).host.equals('google.com');
  } catch (e) {
    print(e);
  }
  // Expected: a Uri that:
  //   has host that:
  //     equals 'google.com'
  // Actual: a Uri that:
  //   has host that:
  //   Actual: 'example.com'
  //   Which: differs at offset 0:
  //   google.com ...
  //   example.co ...
  //   ^
}
