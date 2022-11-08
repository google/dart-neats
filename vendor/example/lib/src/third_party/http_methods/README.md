List of Registered HTTP Methods
===============================

This package provides a list of [all registered HTTP methods][1], as well as
whether a method is considers _safe_, that is, specified in [HTTP 1.1][2].

**Disclaimer:** This is not an officially supported Google product.

## Example
```dart
import 'package:http_methods/http_methods.dart';

void main() {
  assert(isHttpMethod('get'));
  assert(isHttpMethod('GET'));
  assert(isHttpMethod('PUT'));
  assert(!isHttpMethod('not-a-method'));

  print('all http methods:');
  for (String method in httpMethods) {
    print(method);
  }
}
```

## See Also
 * [IANA registered HTTP methods][1].
 * [HTTP 1.1 (RFC 7231)][2].

[1]: https://www.iana.org/assignments/http-methods/http-methods.txt
[2]: https://tools.ietf.org/html/rfc7231#section-4