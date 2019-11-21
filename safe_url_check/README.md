`safe_url_check` for Dart
=========================

Utility to check if an untrusted URL is broken, without accidentally connecting
to a private IP address.

**Disclaimer:** This is not an officially supported Google product.

When running in a Cloud environment a program usually has access to private IPv4
addresses. This private IP-space might be used to grant access to database,
caches, temporary credentials and various other services. If a program in such
a cloud environment is checking untrusted URLs to see if a URL is broken, an
attacker could fool the program into connecting to a private IP address by
configuring DNS to resolve as such.

This is generally undesirable. In most cases it is unlikely to cause any
issues, as making a trivial `HEAD` or `GET` request to check if the URL is
broken should be without side-effects. However, it's often preferable to harden
security by protecting unauthorized access to the private IP space.

This package offers a `safeUrlCheck` function, which makes a `HEAD` request and
follows redirects after verifying that the host does not resolve to a private
IPv4 address or locally unique IPv6 address.

Note, it is plausible that it is desirable to restrict access to additional
addresses space, pull-requests with suggestions are encouraged.

## Example

```dart
import 'package:safe_url_check/safe_url_check.dart';

Future<void> main() async {
  // Check if https://google.com is a broken URL.
  final exists = await safeUrlCheck(
    Uri.parse('https://google.com'),
    userAgent: 'myexample/1.0.0 (+https://example.com)',
  );
  if (exists) {
    print('The url: https://google.com is NOT broken');
  }
}
```
