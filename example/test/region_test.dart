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

/// Region extraction, including the places where we deliberately refuse what
/// dartdoc accepts. Those cases are marked `divergence:` so that a future
/// change to dartdoc shows up here as a decision rather than a regression.
library;

import 'package:checks/checks.dart';
import 'package:example/src/diagnostic.dart';
import 'package:example/src/region.dart';
import 'package:path/path.dart' as p;
import 'package:source_span/source_span.dart';
import 'package:test/scaffolding.dart';

import 'checks_ext.dart';

String extract(
  String source, {
  String? region,
  String? path,
}) =>
    extractRegion(
      SourceFile.fromString(
        source,
        url: path == null ? null : p.toUri(path),
      ).span(0),
      region: region,
    );

const _file = '''
// #region greeting
void greet() {
  print('hello');
}
// #endregion
''';

void main() {
  test('extracts a region without its markers', () {
    check(extract(_file, region: 'greeting')).equals('''
void greet() {
  print('hello');
}
''');
  });

  test('the whole file is the default, keeping markers like dartdoc', () {
    check(extract(_file)).equals(_file);
  });

  test('preserves indentation as written', () {
    check(extract('''
void main() {
  // #region body
  final x = 1;
  // #endregion
}
''', region: 'body')).equals('  final x = 1;\n');
  });

  test('regions nest, and the inner one is part of the outer', () {
    const source = '''
// #region outer
a;
// #region inner
b;
// #endregion
c;
// #endregion
''';
    check(extract(source, region: 'outer')).equals('a;\nb;\nc;\n');
    check(extract(source, region: 'inner')).equals('b;\n');
  });

  test('#hide removes a line in a region', () {
    check(
      extract('// #region r\na;\nb; // #hide\nc;\n// #endregion\n',
          region: 'r'),
    ).equals('a;\nc;\n');
  });

  test('extracts regions from YAML files', () {
    const yaml = '''
name: demo
# #region deps
dependencies:
  path: ^1.9.0
  secret: any # #hide
# #endregion deps
''';
    check(extract(yaml, region: 'deps', path: 'pubspec.yaml')).equals('''
dependencies:
  path: ^1.9.0
''');
  });

  test('extracts regions from JS files', () {
    const js = '''
// #region init
const app = createApp();
app.debug = true; // #hide
app.mount('#root');
/* #endregion init */
''';
    check(extract(js, region: 'init', path: 'web/app.js')).equals('''
const app = createApp();
app.mount('#root');
''');
  });

  test('markers are recognised case insensitively and in HTML comments', () {
    check(extract('# #REGION conf\nname: x\n# #EndRegion\n', region: 'conf'))
        .equals('name: x\n');
    check(extract('<!-- #region r -->\nx\n<!-- #endregion -->\n', region: 'r'))
        .equals('x\n');
  });

  test('an empty region is empty', () {
    check(extract('// #region r\n// #endregion\n', region: 'r')).equals('');
  });

  test('a file without a trailing newline still ends with one', () {
    check(extract('// #region r\na;\n// #endregion', region: 'r'))
        .equals('a;\n');
  });

  test('CRLF is normalised', () {
    check(extract('// #region r\r\na;\r\n// #endregion\r\n', region: 'r'))
        .equals('a;\n');
  });

  test('a reopened region concatenates its parts, matching dartdoc', () {
    check(
      extract(
        '// #region r\na;\n// #endregion\nx;\n// #region r\nb;\n// #endregion\n',
        region: 'r',
      ),
    ).equals('a;\nb;\n');
  });

  group('errors', () {
    test('divergence: an unterminated region is an error', () {
      check(() => extract('// #region r\na;\n', region: 'r'))
          .throws<ExampleFormatException>()
        ..message.contains('never closed')
        ..line.equals(0);
    });

    test('divergence: #endregion without #region is an error', () {
      check(() => extract('a;\n// #endregion\n'))
          .throws<ExampleFormatException>()
          .line
          .equals(1);
    });

    test('divergence: a mismatched #endregion label is an error', () {
      check(
        () => extract(
          '// #region outer\n// #region inner\n// #endregion outer\n// #endregion\n',
          region: 'outer',
        ),
      ).throws<ExampleFormatException>()
        ..message.contains('closes `inner`')
        ..line.equals(2);
    });

    test('a matching #endregion label is fine', () {
      check(extract('// #region r\na;\n// #endregion r\n', region: 'r'))
          .equals('a;\n');
    });

    test('a missing region names the ones that do exist', () {
      check(
        () => extract(
          '// #region one\n// #endregion\n// #region two\n// #endregion\n',
          region: 'three',
        ),
      ).throws<ExampleFormatException>().message.contains('`one`, `two`');
    });

    test('a missing region in a file with none says so', () {
      check(() => extract('void main() {}\n', region: 'r'))
          .throws<ExampleFormatException>()
          .message
          .contains('no regions');
    });

    test('broken markers are caught even when the whole file is requested', () {
      check(() => extract('// #region unclosed\na;\n'))
          .throws<ExampleFormatException>();
    });

    test('the file path is attached to the error', () {
      check(() => extract('// #endregion\n', path: 'example/bad.dart'))
          .throws<ExampleFormatException>()
          .span
          .isNotNull()
          .sourceUrl
          .equals(p.toUri('example/bad.dart'));
    });
  });
}
