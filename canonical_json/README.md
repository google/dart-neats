Canonical JSON Encoder/Decoder
==============================
This package provides an encoder and decoder for encoding/decoding
[canonical JSON][1]. The canonical JSON format does not support floating-point
numbers and the decoder validates that the value is indeed a canonically encoded
JSON value.

**Disclaimer:** This is not an officially supported Google product.

## Example

```dart
import 'package:canonical_json/canonical_json.dart';
void main() {
  // Encode a message
  final bytes = canonicalJson.encode({
    'from': 'alice',
    'message': 'Hi Bob',
  });
  final hash = sha256(bytes); // using a sha256 from some library...
  // Decode message
  try {
    final msg = canonicalJson.decode(bytes);
    if (!fixedTimeEqual(sha256(canonicalJson.encode(msg)), bytes)) {
      print('Expected a different hash!');
    }
    print(msg['message']);
  } on InvalidCanonicalJsonException {
    print('Message was not canonical JSON!');
  }
}
```

## Canonical JSON Format

 * Integers are encoded without leading zeros.
 * Floating point numbers are not permitted.
 * Map keys appear in sorted by byte values.
 * Whitespace is not permitted (outside of strings).
 * Only allow escape sequences in strings are `\\` and `\"`.
 * Strings must be valid UTF-8 in [Unicode Normalization Form C][4].

This follows the rules outlined in [canoncial JSON][1], with the deviation that
this package requires strings to be encoded as valid UTF-8 in
[Unicode Normalization Form C][4] rather than arbitrary
byte values. This is only recommended by [canoncial JSON][1], but this library
takes the opinion that binary values should be encoded.

## See Also

 * Specification of [canoncial JSON][1] used by this package.
 * [Discusson of alternative canonicalization formats for JSON][2].
 * Specification of JSON in [RFC 8259][3]

[1]: http://wiki.laptop.org/go/Canonical_JSON
[2]: https://gibson042.github.io/canonicaljson-spec/#prior-art
[3]: https://tools.ietf.org/html/rfc8259
[4]: http://unicode.org/reports/tr15/