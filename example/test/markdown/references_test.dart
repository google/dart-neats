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
import 'package:snippets/src/diagnostic.dart';
import 'package:snippets/src/markdown/locator.dart';
import 'package:snippets/src/markdown/references.dart';
import 'package:source_span/source_span.dart';
import 'package:test/scaffolding.dart';

import '../checks_ext.dart';

({List<ExampleReference> references, List<ExampleFormatException> diagnostics})
    readAll(String source) {
  final diagnostics = <ExampleFormatException>[];
  final document = SourceFile.fromString(source, url: 'README.md').span(0);
  final references = findReferences(
    locateFencedCodeBlocks(document),
    report: diagnostics.add,
  );
  return (references: references, diagnostics: diagnostics);
}

({ExampleReference? reference, List<ExampleFormatException> diagnostics})
    readOne(
  String source,
) {
  final (:references, :diagnostics) = readAll(source);
  check(references.length).isLessOrEqual(1);
  return (reference: references.firstOrNull, diagnostics: diagnostics);
}

void main() {
  test('finds a reference after <lang> @example', () {
    final (:reference, :diagnostics) =
        readOne('```dart @example example/hello.dart\n```\n');
    check(diagnostics).isEmpty();
    check(reference).isNotNull()
      ..path.equals('example/hello.dart')
      ..region.isNull()
      ..options.isEmpty();
  });

  test('reads the region from the fragment', () {
    final (:reference, :diagnostics) =
        readOne('```dart @example example/hello.dart#greeting\n```\n');
    check(diagnostics).isEmpty();
    check(reference).isNotNull()
      ..path.equals('example/hello.dart')
      ..region.equals('greeting');
  });

  test('treats a trailing # as a whole-file reference', () {
    final (:reference, :diagnostics) =
        readOne('```dart @example example/hello.dart#\n```\n');
    check(diagnostics).isEmpty();
    check(reference).isNotNull()
      ..path.equals('example/hello.dart')
      ..region.isNull();
  });

  test('collects key=value options', () {
    final (:reference, :diagnostics) = readOne(
      '```dart @example a.dart indent=keep title=demo\n```\n',
    );
    check(diagnostics).isEmpty();
    check(reference).isNotNull()
      ..path.equals('a.dart')
      ..options.deepEquals({
        'indent': 'keep',
        'title': 'demo',
      });
  });

  test('accepts extensionless and relative paths', () {
    for (final path in ['LICENSE', './hello.dart', '../example/hello.dart']) {
      final (:reference, :diagnostics) =
          readOne('```text @example $path\n```\n');
      check(diagnostics).isEmpty();
      check(reference).isNotNull().path.equals(path);
    }
  });

  test('leaves code blocks without @example alone', () {
    for (final info in [
      'dart',
      '',
      'console',
      'dart {.copy}',
      'dart lib/main.dart',
      'dart bank_test.dart#transfer-100',
      'pubspec.yaml',
      '{image} https://example.com/a.png',
    ]) {
      final (:reference, :diagnostics) = readOne('```$info\nx\n```\n');
      check(reference, because: 'info string "$info"').isNull();
      check(diagnostics, because: 'info string "$info"').isEmpty();
    }
  });

  test('works inside a block quote', () {
    final (:reference, :diagnostics) =
        readOne('> ```dart @example example/hello.dart\n> ```\n');
    check(diagnostics).isEmpty();
    check(reference).isNotNull().path.equals('example/hello.dart');
  });

  test('finds multiple references in document order', () {
    final (:references, :diagnostics) = readAll('''
# Title

```dart @example example/one.dart
```

```dart
handwritten;
```

```dart @example example/two.dart#region
```
''');
    check(diagnostics).isEmpty();
    check(references.map((r) => r.reference)).deepEquals([
      'example/one.dart',
      'example/two.dart#region',
    ]);
  });

  group('errors', () {
    test('reports missing language before @example', () {
      for (final info in ['@example a.dart', '   @example a.dart']) {
        final (:reference, :diagnostics) = readOne('```$info\n```\n');
        check(reference).isNull();
        check(diagnostics).single
          ..line.equals(0)
          ..message.contains('missing language before `@example`');
      }
    });

    test('reports @example that is not immediately after the language', () {
      final (:reference, :diagnostics) =
          readOne('```dart {.copy} @example a.dart\n```\n');
      check(reference).isNull();
      check(diagnostics).single
        ..line.equals(0)
        ..message.contains('immediately after the fence language');
    });

    test('reports non-lowercase @EXAMPLE', () {
      final (:reference, :diagnostics) =
          readOne('```dart @EXAMPLE a.dart\n```\n');
      check(reference).isNull();
      check(diagnostics).single
        ..line.equals(0)
        ..message.contains('lowercase `@example`');
    });

    test('reports @example with no file path', () {
      final (:reference, :diagnostics) = readOne('```dart @example\n```\n');
      check(reference).isNull();
      check(diagnostics).single
        ..line.equals(0)
        ..message.contains('names no file');
    });

    test('reports option given where file path was expected', () {
      final (:reference, :diagnostics) =
          readOne('```dart @example indent=keep\n```\n');
      check(reference).isNull();
      check(diagnostics).single
        ..line.equals(0)
        ..message.contains('expected a file path');
    });

    test('reports tokens after the path that are not key=value', () {
      for (final bad in ['nonsense', 'indent=']) {
        final (:reference, :diagnostics) =
            readOne('```dart @example example/hello.dart $bad\n```\n');
        check(reference).isNull();
        check(diagnostics).single
          ..line.equals(0)
          ..message.contains(bad);
      }
    });
  });
}
