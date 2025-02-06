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

import 'dart:async';

import 'package:build/build.dart' show BuildStep, log, Builder, BuilderOptions;
import 'package:source_gen/source_gen.dart' as g;
import 'package:typed_sql/src/codegen/parse_library.dart';
import 'package:code_builder/code_builder.dart' as code;
import 'package:typed_sql/src/codegen/build_code.dart';

/// A [Builder] that generates extension methods and classes for typed_sql.
Builder typedSqlBuilder(BuilderOptions options) => g.SharedPartBuilder(
      [_TypedSqlBuilder(options)],
      'typed_sql',
    );

Builder sqlSchemaBuilder(BuilderOptions options) => _SqlSchemaBuilder();

final class _SqlSchemaBuilder extends Builder {
  @override
  Future<void> build(BuildStep buildStep) async {
    final library = await parseLibrary(g.LibraryReader(
      await buildStep.inputLibrary,
    ));
    if (library.isEmpty) {
      return;
    }

    log.info('Generating SQL schema');
    buildStep.writeAsString(buildStep.allowedOutputs.first, '''
      -- TODO: Create tables, and figure out how users specify dialect!
    ''');
  }

  @override
  Map<String, List<String>> get buildExtensions => const {
        '.dart': ['.sql'],
      };
}

final class _TypedSqlBuilder extends g.Generator {
  final BuilderOptions options;

  _TypedSqlBuilder(this.options);

  @override
  Future<String?> generate(
    g.LibraryReader libraryReader,
    BuildStep buildStep,
  ) async {
    final library = await parseLibrary(libraryReader);
    if (library.isEmpty) {
      return null;
    }

    return code.Library(
      (b) => b.body..addAll(buildCode(library)),
    ).accept(code.DartEmitter(useNullSafetySyntax: true)).toString();
  }
}
