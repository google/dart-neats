# dartdoc_test

This package provides an easy way to test code samples embedded in dartdoc
documentation comments.

**Disclaimer:** This is not an officially supported Google product.

# Using in cli

```bash
# Add dartdoc_test as dev dependency
dart pub add dev:dartdoc_test

# Run dartdoc_test directly
dart run dartdoc_test analyze
```

# Using in test

You can test documentation code samples by creating `test/dartdoc_test.dart`.

```dart
import 'package:dartdoc_test/dartdoc_test.dart';
import 'package:test/test.dart';

void main() {
  test('analyze documentation code samples' {
    DartDocTest().analyze();
  });
}
```

and then

```bash
dart test
```
