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
import 'package:checks/checks.dart';

export 'package:matcher/matcher.dart';
export 'package:checks/checks.dart';

/// Test code generation for [source] by running `build_runner` in-memory.
///
/// This takes test case [name] and [source] code for
/// `package:test_package/lib/src/schema.dart`. It'll then run [typedSqlBuilder]
/// using `build_runner` in-memory expecting either:
///  * an error matching [error], or,
///  * a generated file matching [output].
///
/// The [source] must contain `part 'schema.g.dart';`, if it does not it'll be
/// automatically prepended with:
/// ```dart
/// import 'package:typed_sql/typed_sql.dart';
/// part 'schema.g.dart';
/// ```
///
/// Each test case must supply either [error] or [output], never both.
/// Both are expected to be `checks` conditions (functions taking a `Subject`).
void testCodeGeneration({
  required String name,
  required String source,
  Condition<String>? error,
  Condition<String>? output,
}) {
  if (error == null && output == null) {
    throw ArgumentError(
      'A condition must be given for either error or output',
      'output',
    );
  }
  if (error != null && output != null) {
    throw ArgumentError(
      'A condition must only be given for one of error or output',
      'output',
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
      check(result.succeeded).isFalse();
      final errorString = result.errors.join('\n');
      error(check(errorString));
    }

    if (output != null) {
      check(result.errors).isEmpty();
      check(result.succeeded).isTrue();
      check(result.outputs).length.equals(1);
      final outputId = result.outputs.first;
      final outputContent = await result.readerWriter.readAsString(outputId);
      check(outputContent).which(output);
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
      .map(
        (line) => line.substring(switch (indentation) {
          -1 => 0,
          int i when (i < line.length) => i,
          int _ => line.length,
        }),
      )
      .join('\n');
}
