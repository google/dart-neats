// Copyright 2025 Google LLC
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

import 'package:build_test/build_test.dart';
import 'package:collection/collection.dart';
import 'package:test/test.dart';
import 'package:typed_sql/builder.dart' show typedSqlBuilder;

export 'package:matcher/matcher.dart';

/// Test code generation for [source] by running `build_runner` in-memory.
///
/// This takes test case [name] and [source] code for
/// `package:test_package/lib/src/schema.dart`. It'll then run [typedSqlBuilder]
/// using `build_runner` in-memory expecting either:
///  * an error matching [error], or,
///  * a generated file matching [generated].
///
/// The [source] must contain `part 'schema.g.dart';`, if it does not it'll be
/// automatically prepended with:
/// ```dart
/// import 'package:typed_sql/typed_sql.dart';
/// part 'schema.g.dart';
/// ```
///
/// Each test case must supply either [error] or [generated], never both.
/// If you only want to test that there was an error, or that generation
/// was successful use the [anything] matcher.
void testCodeGeneration({
  required String name,
  required String source,
  Matcher? error,
  Matcher? generated,
}) {
  if (error == null && generated == null) {
    throw ArgumentError(
      'A matcher must be given for either error or generated',
      'generated',
    );
  }
  if (error != null && generated != null) {
    throw ArgumentError(
      'A matcher must only be given for one of error or generated',
      'generated',
    );
  }

  source = _stripIndentation(source);

  // Prepend header if needed.
  if (!source.contains("part 'schema.g.dart';")) {
    source = [
      "import 'package:typed_sql/typed_sql.dart';",
      "part 'schema.g.dart';",
      '',
      source,
    ].join('\n');
  }

  test(name, () async {
    final readerWriter = TestReaderWriter(rootPackage: 'test_package');
    await readerWriter.testing.loadIsolateSources();

    final result = await testBuilderFactories(
      [typedSqlBuilder],
      {
        'test_package|lib/src/schema.dart': source,
      },
      readerWriter: readerWriter,
      visibleOutputBuilderFactories: {typedSqlBuilder},
      onLog: (log) => printOnFailure('build_runner: $log'),
    );

    if (error != null) {
      expect(result.errors, anyElement(error));
      expect(
        result.succeeded,
        isFalse,
        reason: 'test case is expected to fail',
      );
    }

    if (generated != null) {
      expect(
        result.errors,
        isEmpty,
        reason: 'expected no errors when test case is successful',
      );
      expect(
        result.succeeded,
        isTrue,
        reason: 'test case is expected to be successful',
      );
      expect(result.outputs, hasLength(1));
      final outputId = result.outputs.first;
      final output = await result.readerWriter.readAsString(outputId);
      expect(output, generated);
    }
  });
}

String _stripIndentation(String source) {
  // Minimum indentation from all lines
  final indentation = source
      .split('\n')
      .where((line) => line.contains(RegExp(r'[^ \t]')))
      .map(
        (line) => line.indexOf(RegExp(r'[^ ]')),
      )
      .min;
  // Strip minimum indentation from all lines
  return source
      .split('\n')
      .map((line) => line.substring(switch (indentation) {
            -1 => 0,
            int i when (i < line.length) => i,
            int _ => line.length,
          }))
      .join('\n');
}
