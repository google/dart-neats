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
import 'package:example/src/diagnostic.dart';
import 'package:example/src/markdown/locator.dart';
import 'package:example/src/markdown/references.dart';
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
  group('info string', () {
    test('finds a reference after the language', () {
      final (:reference, :diagnostics) =
          readOne('```dart example/hello.dart\n```\n');
      check(diagnostics).isEmpty();
      check(reference).isNotNull()
        ..path.equals('example/hello.dart')
        ..region.isNull();
    });

    test('reads the region from the fragment', () {
      final (:reference, :diagnostics) =
          readOne('```dart example/hello.dart#greeting\n```\n');
      check(diagnostics).isEmpty();
      check(reference).isNotNull()
        ..path.equals('example/hello.dart')
        ..region.equals('greeting');
    });

    test('treats a trailing # as a whole-file reference', () {
      final (:reference, :diagnostics) =
          readOne('```dart example/hello.dart#\n```\n');
      check(diagnostics).isEmpty();
      check(reference).isNotNull()
        ..path.equals('example/hello.dart')
        ..region.isNull();
    });

    test('collects key=value options', () {
      final (:reference, :diagnostics) = readOne(
        '```dart a.dart indent=keep title=demo\n```\n',
      );
      check(diagnostics).isEmpty();
      check(reference).isNotNull()
        ..path.equals('a.dart')
        ..options.deepEquals({
          'indent': 'keep',
          'title': 'demo',
        });
    });

    test('ignores tokens it does not understand', () {
      final (:reference, :diagnostics) =
          readOne('```dart {.copy} example/hello.dart showLineNumbers\n```\n');
      check(diagnostics).isEmpty();
      check(reference).isNotNull().path.equals('example/hello.dart');
    });

    test('finds a path that starts with ./ or ../', () {
      for (final path in ['./hello.dart', '../example/hello.dart']) {
        final (:reference, :diagnostics) = readOne('```dart $path\n```\n');
        check(diagnostics).isEmpty();
        check(reference).isNotNull().path.equals(path);
      }
    });

    test('leaves ordinary code blocks alone', () {
      for (final info in [
        'dart',
        '',
        'console',
        'dart {.copy}',
        'dart .copy',
        'pubspec.yaml',
        'example/hello.dart',
      ]) {
        final (:reference, :diagnostics) = readOne('```$info\nx\n```\n');
        check(reference, because: 'info string "$info"').isNull();
        check(diagnostics, because: 'info string "$info"').isEmpty();
      }
    });

    test('uses the first reference-shaped token', () {
      final (:reference, :diagnostics) =
          readOne('```dart a/one.dart b/two.dart\n```\n');
      check(diagnostics).isEmpty();
      check(reference).isNotNull().path.equals('a/one.dart');
    });

    test('works inside a block quote', () {
      final (:reference, :diagnostics) =
          readOne('> ```dart example/hello.dart\n> ```\n');
      check(diagnostics).isEmpty();
      check(reference).isNotNull().path.equals('example/hello.dart');
    });
  });

  group('html comment', () {
    test('finds a reference on the line above', () {
      final (:reference, :diagnostics) = readOne(
        '<!-- @example example/hello.dart#greeting -->\n```dart\n```\n',
      );
      check(diagnostics).isEmpty();
      check(reference).isNotNull()
        ..path.equals('example/hello.dart')
        ..region.equals('greeting');
    });

    test('is case insensitive and tolerates spacing', () {
      final (:reference, :diagnostics) = readOne(
        '<!--@EXAMPLE   example/hello.dart-->\n```dart\n```\n',
      );
      check(diagnostics).isEmpty();
      check(reference).isNotNull().path.equals('example/hello.dart');
    });

    test('must be on the immediately preceding line', () {
      final (:reference, :diagnostics) = readOne(
        '<!-- @example example/hello.dart -->\n\n```dart\n```\n',
      );
      check(reference).isNull();
      check(diagnostics).isEmpty();
    });

    test('ignores other comments', () {
      final (:reference, :diagnostics) = readOne(
        '<!-- just a comment -->\n```dart\n```\n',
      );
      check(reference).isNull();
      check(diagnostics).isEmpty();
    });

    test('an empty @example comment is an error', () {
      final (:reference, :diagnostics) = readOne(
        '<!-- @example -->\n```dart\n```\n',
      );
      check(reference).isNull();
      check(diagnostics).single
        ..line.equals(0)
        ..message.contains('names no file');
    });

    test('an unusable first token is an error, not something to ignore', () {
      final (:reference, :diagnostics) = readOne(
        '<!-- @example {.copy} -->\n```dart\n```\n',
      );
      check(reference).isNull();
      check(diagnostics).single.line.equals(0);
    });

    test('rejects tokens that are not known options', () {
      for (final token in ['nonsense', 'indnet=keep']) {
        final (:reference, :diagnostics) = readOne(
          '<!-- @example example/hello.dart $token -->\n```dart\n```\n',
        );
        check(reference).isNull();
        check(diagnostics).single
          ..line.equals(0)
          ..message.contains(token);
      }
    });

    test('works inside a block quote', () {
      final (:reference, :diagnostics) = readOne(
        '> <!-- @example example/hello.dart -->\n> ```dart\n> ```\n',
      );
      check(diagnostics).isEmpty();
      check(reference).isNotNull().path.equals('example/hello.dart');
    });
  });

  group('findReferences', () {
    test('finds both syntaxes, in document order', () {
      final (:references, :diagnostics) = readAll('''
# Title

```dart example/one.dart
```

Prose.

<!-- @example example/two.dart#region -->
```dart
```

```dart
handwritten;
```
''');
      check(diagnostics).isEmpty();
      check(references.map((r) => r.reference)).deepEquals([
        'example/one.dart',
        'example/two.dart#region',
      ]);
    });

    test('a document with no references yields nothing', () {
      final (:references, :diagnostics) = readAll('```dart\nx;\n```\n');
      check(references).isEmpty();
      check(diagnostics).isEmpty();
    });

    test('two different references for one block is an error', () {
      final (:references, :diagnostics) = readAll('''
<!-- @example example/one.dart -->
```dart example/two.dart
```
''');
      check(references).isEmpty();
      check(diagnostics).single.line.equals(1);
    });

    test('the same reference written twice is not an error', () {
      final (:references, :diagnostics) = readAll('''
<!-- @example example/one.dart -->
```dart example/one.dart
```
''');
      check(diagnostics).isEmpty();
      check(references).single.reference.equals('example/one.dart');
    });
  });
}
