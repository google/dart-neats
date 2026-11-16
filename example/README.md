This tool updates examples in _fenced code blocks_ in markdown files to match
source files in `example/` or `test/`, using the same `#region`, `#endregion`,
and `#hide` markers as `dartdoc`'s `{@example}` directive.

**Disclaimer:** This is not an officially supported Google product.

## Usage

Mark a region in an example or test file:

```dart @example example/hello_world.dart
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

Reference the file (or `#region`) after `@example` in your markdown fence's info
string:

````markdown
```dart @example example/hello_world.dart#greeting
final message = 'Hello, world!';
print(message);
```
````

A leading `/` resolves from the package root; any other path resolves relative
to the markdown file. Pass `indent=keep` (default `indent=strip`) to keep shared
leading indentation.

Update all markdown files locally (requires Dart 3.12+):

```console
$ dart run example@ update
```

## Validating in CI

Check that no markdown code block is out of date:

```console
$ dart run example@ validate
```

In GitHub Actions, call the reusable workflow (pinned to a commit SHA):

```yaml
jobs:
  examples:
    uses: google/dart-neats/.github/workflows/validate-examples.yml@<commit-sha>
```
