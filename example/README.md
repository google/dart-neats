Example - keep markdown code samples up to date
===============================================

This package updates examples in _fenced code blocks_ in markdown files to
match source files in `example/` or `test/`, using the same `#region`,
`#endregion`, and `#hide` markers as `dartdoc`'s `{@example}` directive.

**Disclaimer:** This is not an officially supported Google product.

## Usage

Mark a region in an example or test file:

<!-- @example example/hello_world.dart -->
```dart
import 'package:test/test.dart';

void main() {
  test('greets the world', () {
    // #region greeting
    final message = 'Hello, world!';
    print(message);
    // #endregion greeting
    expect(message, isNotEmpty);
  });
}
```

Reference the file (or `#region`) in your markdown fence's info string, or in an
HTML comment on the line above it:

````markdown
```dart example/hello_world.dart#greeting
final message = 'Hello, world!';
print(message);
```

<!-- @example example/hello_world.dart#greeting -->
```dart
final message = 'Hello, world!';
print(message);
```
````

A leading `/` resolves from the package root; any other path resolves relative
to the markdown file. Pass `indent=keep` (default `indent=strip`) to keep shared
leading indentation.

Update all markdown files in your package:

```console
$ dart run example update
```

## Validating in tests / CI

Add a test calling `validateExamples()` so `dart test` fails if any markdown
code block is out of date:

```dart
// test/example_test.dart
import 'package:example/example.dart';
import 'package:test/test.dart';

void main() {
  test('examples are up to date', () async {
    await validateExamples();
  });
}
```

Or check from the command line:

```console
$ dart run example validate
```
