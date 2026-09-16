import 'package:checks_ext/checks_ext.dart';

void main() {
  final uriData = UriData.fromString('hello', base64: true);

  /// This check succeeds.
  check(uriData).isBase64();

  /// This check fails.
  final rawData = UriData.fromString('hello', base64: false);
  try {
    check(rawData).isBase64();
  } catch (e) {
    print(e);
  }
  // Expected: a UriData that:
  //   is base64
  // Actual: <data:,hello>
  // Which: is not base64
}
