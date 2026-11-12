---
name: example
description: >-
  Write, organize, and update code examples in Dart and Flutter packages.
---

# Writing and Updating Examples in Dart Packages

Keep documentation code samples in `README.md`, `doc/*.md`, and `///` dartdoc
comments backed by real source files so every sample is analyzed by
`dart analyze` and (where appropriate) executed by `dart test`.

## 1. Choosing How to Structure an Example

There are three patterns for examples in a Dart or Flutter package. Pick the
pattern that fits the example's complexity and testing needs:

| Pattern | Location | Verified by | Best for |
| :--- | :--- | :--- | :--- |
| **(A) Standalone app** | `example/myapp/` (with its own `pubspec.yaml`) | Its own `flutter test` / `dart test` suite | Complex demos, multi-file examples, Flutter widget apps, `{@dartpad}` dartdoc directive |
| **(B) Simple script** | `example/my_example.dart` | `dart analyze` | Short `main()` scripts, `{@dartpad}` dartdoc directive |
| **(C) Tested region** | `test/my_feature_test.dart` (using `#region`) | Package's `dart test` + `dart analyze` | Snippets in `README.md` and dartdoc `{@example}` that need assertions or test setup |


### (A) Standalone App (`example/myapp/`)

Use a sub-package with its own `pubspec.yaml` when an example needs dependencies
beyond the main package, multiple screens/files, or a runnable Flutter app to
demonstrate a widget.

- **Pros:** Full application environment; can have its own `test/` directory
  with widget or integration tests.
- **Cons:** Separate `pubspec.yaml` to maintain; more infrastructure in CI.


### (B) Simple Standalone Script (`example/my_example.dart`)

Use a single `.dart` file in `example/` (sharing the root `pubspec.yaml`) for
short, self-contained `main()` programs.

- **Pros:** Zero test boilerplate; automatically covered by `dart analyze`;
  easy to load into DartPad (when compatible with web/DDC).
- **Cons:** Not executed by `dart test`, if testing is important consider using
  **(A)** or **(C)** instead.


### (C) Region Inside a Test (`test/my_feature_test.dart`)

Write an ordinary unit test in `test/` and wrap the lines you want to show in
documentation with `// #region <name>` and `// #endregion <name>`.

- **Pros:** **The example is a real test.** It runs automatically on `dart test`,
  can use your existing test setup (fakes, mocks, in-memory databases, temporary
  directories), and can assert on results while hiding test noise with `#hide`.
- **Cons:** Lives in `test/` rather than `example/`, so it is meant for
  extracting into `README.md` or dartdoc `{@example}` rather than opening as a
  standalone file in DartPad.

```dart
// test/cache_test.dart
import 'package:my_pkg/my_pkg.dart';
import 'package:test/test.dart';

void main() {
  test('stores and retrieves values', () async {
    final backend = FakeBackend();
    // #region basic-usage
    final cache = Cache(backend);
    backend.started(); // #hide
    await cache.put('greeting', 'Hello, world!');

    final value = await cache.get('greeting');
    // #endregion basic-usage
    expect(value, 'Hello, world!');
  });
}
```

---

## 2. Marking Regions and Hiding Lines (`#region`, `#endregion`, `#hide`)

Both `dartdoc` (`{@example}`) and `package:example` (`dart run example update`)
use the same region extraction rules:

- **`// #region <name>` and `// #endregion [<name>]`**:
  Marks a named slice of a file. The optional `<name>` on `#endregion` is
  checked against the innermost open `#region`.
- **Reopening a region**:
  Opening the same `#region <name>` more than once in the same file
  concatenates those slices in order. This is useful when you want to include
  imports or a helper declaration together with a snippet inside `main()` or
  `test()`.
- **`// #hide`**:
  Any line inside an extracted region that contains `#hide` is omitted
  from the extracted output.
- **Comment syntax is format-agnostic**:
  Markers are matched as substrings (`#region <name>`, `#endregion`, `#hide`),
  so they work in Dart (`// #region foo`), YAML (`# #region foo`), SQL
  (`-- #region foo`), or HTML (`<!-- #region foo -->`).
- **Whole-file references vs. `#region` references**:
  Marker lines (`#region`, `#endregion`, `#hide`) are stripped when extracting a
  named `#<region>`, and kept when referencing a whole file without `#<region>`.
- **Formatting with `dart format`**:
  When closing a `#region` after a top-level declaration, place the blank line
  *after* `// #endregion` (not before it) so `dart format` keeps `// #endregion`
  attached to the preceding declaration rather than inserting a blank line at
  the end of the extracted region.

---

## 3. Injecting Examples into Dartdoc (`{@example}`)

Use the `{@example}` directive in `///` doc comments instead of hand-written
inline code blocks whenever an example is more than a couple of lines:

```dart
/// Caches keys and values in [Backend].
///
/// {@example /test/cache_test.dart#basic-usage}
class Cache {
  // ...
}
```

### Syntax and Options

```text
/// {@example <path>[#<region>] [lang=<language>] [indent=strip|keep]}
```

- **`<path>`**:
  - A leading `/` resolves from the **package root** (e.g.
    `/test/cache_test.dart#basic-usage` or `/example/hello.dart`). Prefer
    package-root paths in `lib/` so moving files inside `lib/src/` doesn't
    break relative paths.
  - Without a leading `/`, the path resolves relative to the file containing
    the doc comment.
- **`lang=<language>`**: Overrides the fence language (defaults to the file
  extension, such as `dart`).
- **`indent=strip|keep`**: `strip` (the default) removes common leading space
  indentation from the extracted lines.

---

## 4. Updating Examples in `README.md` (`package:example`)

Standard markdown viewers (GitHub, pub.dev, IDEs) do not evaluate `{@example}`
directives. Instead, `package:example` keeps real fenced code blocks in
`README.md` and `doc/*.md` up to date with your source files so the markdown
renders everywhere and is still backed by analyzed/tested code.

### Setup

Add `package:example` as a `dev_dependency`:

```console
$ dart pub add dev:example
```

### Referencing a File or Region in Markdown

You can attach a reference to any fenced code block in two ways:

1. **In the fence's info string** (after the language name):
   ````markdown
   ```dart test/cache_test.dart#basic-usage
   final cache = Cache(backend);
   await cache.put('greeting', 'Hello, world!');

   final value = await cache.get('greeting');
   ```
   ````
2. **In an HTML comment on the line immediately above the fence** (if you don't
   want the file path in the info string):
   ````markdown
   <!-- @example test/cache_test.dart#basic-usage -->
   ```dart
   final cache = Cache(backend);
   await cache.put('greeting', 'Hello, world!');

   final value = await cache.get('greeting');
   ```
   ````

Path resolution matches `dartdoc`: a leading `/` resolves from the nearest
enclosing `pubspec.yaml` directory (package root), and a relative path resolves
from the directory containing the Markdown file.

Optional `key=value` settings can follow the reference:
- `indent=strip|keep` (default `strip`): strip common leading space indentation
  or keep it.

### Updating and Validating

After editing an example or adding a new code block reference in Markdown, run:

```console
$ dart run example update
```

In CI (such as GitHub Actions) or `dart test`, verify that no markdown code
block has drifted out of date by adding a test calling `validateExamples()`:

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

Or run the CLI check directly:

```console
$ dart run example validate
```

### Using `package:example` without `dev_dependencies`
If you don't want a `dev_dependencies` on `package:example` you can just run:

```console
$ dart run example@ update
```

This also works in CI, but having a `dev_dependencies` ensures the behavior is
consistent.
