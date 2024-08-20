# dartdoc_test

This package provides an easy way to test code samples embedded in documentation comments.

**Disclaimer:** This is not an officially supported Google product.

# Background

Writing code samples in documentation comments is a great way to make your code easier to understand.
And code samples are seen many times in API Documentation and are often copied and used.
However, code samples in documentation comments are not analyzed, which makes them unreliable and difficult to maintain.
Most dart packages and libraries provide lots of documentation and code samples, and maintainability become a big issue.

Therefore, `dartdoc_test` provides a way to analyze code samples in documentation comments and detect problems they comtain. This improbes the maintainability and reliability of your documentation.

# Using in cli

```bash
# Add dartdoc_test as dev dependency
dart pub add dev:dartdoc_test

# Run dartdoc_test directly
dart run dartdoc_test
```

# Using in test

By creating `test/dartdoc_test.dart`, you can test code samples with using the `dart test` command.

```bash
# Create test file for code samples to "test/dartdoc_test.dart"
dart run dartdoc_test add

# Run test command
dart test
```

The add command creates a test file like this:

```dart
import 'package:dartdoc_test/dartdoc_test.dart';

/// Test code samples in documentation comments in this package.
///
/// It extracts code samples from documentation comments in this package and
/// analyzes them. If there are any errors in the code samples, the test will fail
/// and you can see the problems details.
///
/// If you want to test only specific files, you can use [exclude] options.
void main() => runDartdocTest();

```

# Ignore analysis

If you don't want to analyze a particular code sample, you can exclude it by adding tag `#no-test` within the code block.

````txt
/// This code sample will not be analyzed.
///
/// ```dart#no-test
/// final a = 1 // it is not reported.
/// ```
````

Alternatively, if you want to exclude a particular directory or file, you can use the `exclude` option.

```
dart run dartdoc_test --exclude "example/**,*_test.dart"
```

Or

```dart
void main() {
  runDartdocTest(
    exclude: ['*_test.dart', 'example/**'],
  );
}
```
