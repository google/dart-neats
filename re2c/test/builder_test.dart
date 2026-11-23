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

import 'package:build/build.dart';
import 'package:build_test/build_test.dart';
import 'package:checks/checks.dart';
import 'package:re2c/builder.dart';
import 'package:test/scaffolding.dart';

void main() {
  test(
    'compiles .re with transitive includes and tracks them as inputs',
    () async {
      final result = await testBuilderFactories(
        [re2cBuilder],
        {
          'pkg|lib/base.re.inc': '/*!re2c digit = [0-9]; */\n',
          'pkg|lib/sub/defs.re.inc': '''
/*!include:re2c "../base.re.inc" */
/*!re2c number = digit+; */
''',
          'pkg|lib/sub/extra.re.inc': 'ident = [a-z]+;\n',
          'pkg|lib/scanner.re': '''
/*!include:re2c "sub/defs.re.inc" */
int scan(String yyinput, int yycursor, int yylimit) {
  /*!re2c
    !include "sub/extra.re.inc";
    number { return 1; }
    ident  { return 2; }
    \$      { return 0; }
    *      { return -1; }
  */
}
''',
        },
        visibleOutputBuilderFactories: {re2cBuilder},
      );

      check(result.errors).isEmpty();
      check(result.succeeded).isTrue();
      final generated = result.readerWriter.testing.readString(
        AssetId('pkg', 'lib/scanner.dart'),
      );
      check(generated)
        ..contains('// GENERATED CODE - DO NOT MODIFY BY HAND')
        ..contains('int scan(String yyinput, int yycursor, int yylimit)');

      check(result.readerWriter.testing.inputsTracked).unorderedEquals([
        AssetId('pkg', 'lib/scanner.re'),
        AssetId('pkg', 'lib/sub/extra.re.inc'),
        AssetId('pkg', 'lib/sub/defs.re.inc'),
        AssetId('pkg', 'lib/base.re.inc'),
      ]);
    },
  );

  test('reports re2c errors with the asset path', () async {
    final result = await testBuilderFactories(
      [re2cBuilder],
      {
        'pkg|lib/broken.re': '''
int scan(String yyinput, int yycursor, int yylimit) {
  /*!re2c
    [0-9+ { return 1; }
  */
}
''',
      },
      visibleOutputBuilderFactories: {re2cBuilder},
      onLog: (_) {},
    );

    check(result.succeeded).isFalse();
    check(result.errors.join('\n')).contains('lib/broken.re:3:');
  });
}
