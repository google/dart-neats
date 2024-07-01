# dartdoc_test

This package provides an easy way to test code samples embedded in dartdoc
documentation comments.

**Disclaimer:** This is not an officially supported Google product.

# Using in cli

## install

```bash
dart pub global active dartdoc_test
```

## Usage

```bash
# analyze dart code samples in documentation comments
dartdoc_test analyze
```

# Using in test

```dart
import 'package:dartdoc_test:dartdoc_test.dart';
import 'package:test/test.dart';

void main() {
  test('analyze documentation code samples' {
    DartDocTest().analyze();
  });
}
```
