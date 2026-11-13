// Copyright 2026 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:checks/checks.dart';
import 'package:example/src/update.dart';
import 'package:test/scaffolding.dart';

import 'checks_ext.dart';

/// Runs the driver over [source] with [files] on the "disk".
///
/// Paths in [files] are relative to the package root; the document is
/// `/pkg/README.md` unless [document] says otherwise.
UpdateResult update(
  String source, {
  Map<String, String> files = const {},
  String document = 'README.md',
}) =>
    updateDocument(
      source: source,
      documentPath: '/pkg/$document',
      packageRoot: '/pkg',
      readFile: (path) => files[path.replaceFirst('/pkg/', '')],
    );

const _hello = '''
// #region greeting
void main() {
  print('hello');
}
// #endregion
''';

void main() {
  test('fills in an empty block', () {
    check(update(
      '```dart example/hello.dart#greeting\n```\n',
      files: {'example/hello.dart': _hello},
    ))
      ..diagnostics.isEmpty()
      ..stale.length.equals(1)
      ..updated.equals('''
```dart example/hello.dart#greeting
void main() {
  print('hello');
}
```
''');
  });

  test('a block that is already correct is left alone', () {
    const source = '''
```dart example/hello.dart#greeting
void main() {
  print('hello');
}
```
''';
    check(update(source, files: {'example/hello.dart': _hello}))
      ..diagnostics.isEmpty()
      ..stale.isEmpty()
      ..updated.isNull();
  });

  test('is idempotent', () {
    final once = update(
      '```dart example/hello.dart#greeting\nstale;\n```\n',
      files: {'example/hello.dart': _hello},
    );
    final twice = update(once.updated!, files: {'example/hello.dart': _hello});
    check(twice.updated).isNull();
  });

  test('leaves the rest of the document byte-identical', () {
    final result = update('''
# Title

Some prose with a ``` in it.

```dart example/hello.dart#greeting
```

    an indented code block

> a quote
''', files: {'example/hello.dart': _hello});
    check(result.updated).isNotNull()
      ..startsWith('# Title\n\nSome prose')
      ..endsWith('> a quote\n');
  });

  test('writes the container prefix on every line', () {
    final result = update(
      '> ```dart example/hello.dart#greeting\n> ```\n',
      files: {'example/hello.dart': _hello},
    );
    check(result.updated).equals('''
> ```dart example/hello.dart#greeting
> void main() {
>   print('hello');
> }
> ```
''');
  });

  test('indents into a list item', () {
    final result = update('''
1. Run this:

   ```dart example/hello.dart#greeting
   ```
''', files: {'example/hello.dart': _hello});
    check(result.updated).equals('''
1. Run this:

   ```dart example/hello.dart#greeting
   void main() {
     print('hello');
   }
   ```
''');
  });

  test('blank lines carry no trailing whitespace', () {
    final result = update(
      '> ```dart a.dart\n> ```\n',
      files: {'a.dart': 'one;\n\ntwo;\n'},
    );
    check(result.updated)
        .equals('> ```dart a.dart\n> one;\n>\n> two;\n> ```\n');
  });

  test('preserves CRLF', () {
    final result = update(
      '```dart a.dart\r\n```\r\n',
      files: {'a.dart': 'x;\n'},
    );
    check(result.updated).equals('```dart a.dart\r\nx;\r\n```\r\n');
  });

  test('lengthens the fence when the content contains one', () {
    final result = update(
      '```markdown a.md\n```\n',
      files: {'a.md': '```dart\nx;\n```\n'},
    );
    check(result.updated).equals('''
````markdown a.md
```dart
x;
```
````
''');
  });

  test('updates several blocks at once', () {
    final result = update('''
```dart a.dart
```

```dart b.dart
```
''', files: {'a.dart': 'a;\n', 'b.dart': 'b;\n'});
    check(result.updated).equals('''
```dart a.dart
a;
```

```dart b.dart
b;
```
''');
  });

  test('the HTML comment syntax works too', () {
    final result = update(
      '<!-- @example a.dart -->\n```dart\n```\n',
      files: {'a.dart': 'a;\n'},
    );
    check(result.updated)
        .equals('<!-- @example a.dart -->\n```dart\na;\n```\n');
  });

  test('updates regions from YAML and JS files', () {
    final result = update('''
```yaml config.yaml#deps
```

```js web/app.js#init
```
''', files: {
      'config.yaml': '# #region deps\npath: ^1.9.0\n# #endregion\n',
      'web/app.js': '// #region init\nmount();\n// #endregion\n',
    });
    check(result.diagnostics).isEmpty();
    check(result.updated).equals('''
```yaml config.yaml#deps
path: ^1.9.0
```

```js web/app.js#init
mount();
```
''');
  });

  test('supports indent=strip|keep option', () {
    const file = '  a;\n';
    check(update('```dart a.dart\n```\n', files: {'a.dart': file}).updated)
        .equals('```dart a.dart\na;\n```\n');
    check(
      update('```dart a.dart indent=keep\n```\n', files: {'a.dart': file})
          .updated,
    ).equals('```dart a.dart indent=keep\n  a;\n```\n');
    check(
      update(
        '<!-- @example a.dart indent=keep -->\n```dart\n```\n',
        files: {'a.dart': file},
      ).updated,
    ).equals('<!-- @example a.dart indent=keep -->\n```dart\n  a;\n```\n');
  });

  test('rejects invalid indent= option value', () {
    final badIndent = update(
      '```dart a.dart indent=bogus\n```\n',
      files: {'a.dart': 'a;\n'},
    );
    check(badIndent.diagnostics).single.message.contains('indent=bogus');
  });

  group('errors', () {
    test('a missing file is an error, and nothing is written', () {
      check(update('```dart missing.dart\n```\n'))
        ..updated.isNull()
        ..diagnostics.single.which((d) => d
          ..line.equals(0)
          ..message.contains('missing.dart'));
    });

    test('a missing region is an error at the reference', () {
      check(update(
        'intro\n\n```dart example/hello.dart#nope\n```\n',
        files: {'example/hello.dart': _hello},
      ))
        ..updated.isNull()
        ..diagnostics.single.which((d) => d
          ..line.equals(2)
          ..span
              .isNotNull()
              .sourceUrl
              .isNotNull()
              .has((u) => u.path, 'path')
              .endsWith('README.md'));
    });

    test('one broken reference does not stop the others', () {
      check(update('''
```dart missing.dart
```

```dart a.dart
```
''', files: {'a.dart': 'a;\n'}))
        ..diagnostics.isNotEmpty()
        ..updated.isNotNull().contains('a;');
    });

    test('an unclosed block is an error, even if its content matches', () {
      for (final source in ['```dart a.dart\n', '```dart a.dart\na;\n']) {
        check(update(source, files: {'a.dart': 'a;\n'}))
          ..updated.isNull()
          ..diagnostics.single.message.contains('closing fence');
      }
    });

    test('a reference outside the package is an error', () {
      check(update('```dart x%2F..%2F..%2F..%2Fetc/hostname\n```\n'))
        ..updated.isNull()
        ..diagnostics.single.message.contains('outside the package');
    });

    test('a malformed example file is an error', () {
      check(update(
        '```dart a.dart#r\n```\n',
        files: {'a.dart': '// #region r\na;\n'},
      ))
        ..updated.isNull()
        ..diagnostics.single.message.contains('never closed');
    });
  });
}
