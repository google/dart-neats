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

// ignore_for_file: deprecated_member_use
// See: https://github.com/dart-lang/build/issues/3977

/// This library providers the [Builder] implementation for `build_runner`.
///
/// > [!NOTE]
/// > You should generally never need to import or use this library, it is
/// > exposed for use by `build_runner` **only**.
///
/// @nodoc
library;

import 'dart:async';

import 'package:build/build.dart'
    show BuildStep, Builder, BuilderOptions, NonLibraryAssetException;
import 'package:code_builder/code_builder.dart' as code;
import 'package:glob/glob.dart';
import 'package:source_gen/source_gen.dart' as g;

import 'src/codegen/build_code.dart';
import 'src/codegen/parse_library.dart';
import 'src/codegen/record_parser.dart';

/// A [Builder] that generates extension methods and classes for typed_sql.
Builder typedSqlBuilder(BuilderOptions options) => g.SharedPartBuilder(
      [_TypedSqlBuilder(options)],
      'typed_sql',
      allowSyntaxErrors: false,
    );

final class _TypedSqlBuilder extends g.Generator {
  final BuilderOptions options;

  _TypedSqlBuilder(this.options);

  @override
  Future<String?> generate(
    g.LibraryReader targetLibrary,
    BuildStep buildStep,
  ) async {
    final ctx = ParserContext();

    final library = await parseLibrary(ctx, targetLibrary);
    if (library.isEmpty) {
      return null;
    }

    // Check if Subjects from package:checks is imported!
    final hasSubjectFromChecks = targetLibrary.element.importedLibraries
        .map((l) => l.exportNamespace.get('Subject')?.library?.identifier)
        .nonNulls
        .any((id) => id.startsWith('package:checks/'));

    // Find all records using in all dart libraries in the target package!
    final recordParser = RecordParser();
    await for (final input in buildStep.findAssets(Glob('**.dart'))) {
      try {
        final library = await buildStep.resolver.libraryFor(input);
        // We only consider libraries that are importing the library we are
        // generating for!
        if (!library.importedLibraries.contains(targetLibrary.element)) {
          continue;
        }
        final astNode = await buildStep.resolver.astNodeFor(
          library.definingCompilationUnit,
          resolve: true,
        );
        if (astNode != null) {
          recordParser.parseRecords(astNode);
        }
      } on NonLibraryAssetException {
        // pass
      }
    }

    return code.Library(
      (b) => b.body
        ..addAll(buildCode(
          library,
          recordParser.canonicalizedParsedRecords(),
          createChecksExtensions: hasSubjectFromChecks,
        )),
    ).accept(code.DartEmitter(useNullSafetySyntax: true)).toString();
  }
}
