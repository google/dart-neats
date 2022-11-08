PEM Encoding/Decoding for Dart
==============================
Encoding/decoding of PEM (Privacy-Enhanced Mail) textual key encoding
following [RFC 7468][1].

**Disclaimer:** This is not an officially supported Google product.

To maximize interoperabilty encoding methods in this package always produces
strict-mode output. While decoding methods defaults to lax-mode which ignores
extra whitespace, line breaks, tabs as specified in [RFC 7468][1].

Decoding methods ignore text surrounding the PEM blocks, this also implies that
decoding methods cannot distinguish between malformed PEM blocks and text to be
ignored. Thus, malformed PEM blocks will not cause exceptions to be thrown,
though the `PemCodec` will throw if no PEM block with acceptable label is
present.

## Example
```dart
import 'package:pem/pem.dart';

// Parse PEM encoded private key.
List<int> keyData = PemCodec(PemLabel.privateKey).decode("""
  -----BEGIN PRIVATE KEY-----
  MIGEAgEAMBAGByqGSM49AgEGBSuBBAAKBG0wawIBAQQgVcB/UNPxalR9zDYAjQIf
  jojUDiQuGnSJrFEEzZPT/92hRANCAASc7UJtgnF/abqWM60T3XNJEzBv5ez9TdwK
  H0M6xpM2q+53wmsN/eYLdgtjgBd3DBmHtPilCkiFICXyaA8z9LkJ
  -----END PRIVATE KEY-----
""");

// Encode keyData as PEM string.
String pemBlock = PemCodec(PemLabel.privateKey).encode(keyData);

// Print encoded block (should print what we parsed, without indentation)
print(pemBlock);
```

See [API reference][2] for further details and examples on how to parse 
documents containing multiple PEM blocks, as is often the case for certificate
chains.

[1]: https://tools.ietf.org/html/rfc7468
[2]: https://pub.dartlang.org/documentation/pem/latest/
