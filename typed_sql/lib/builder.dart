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

/// @nodoc
library;

import 'dart:async';

import 'package:analyzer/dart/analysis/results.dart' show LibraryElementResult;
import 'package:analyzer/dart/element/element.dart' show ClassElement;
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
    // Look up CustomDataType for later use!
    final typedSqlLibrary = await targetLibrary.element.session
        .getLibraryByUri('package:typed_sql/typed_sql.dart');
    if (typedSqlLibrary is! LibraryElementResult) {
      throw g.InvalidGenerationSource(
        'Unable to resolve "package:typed_sql/typed_sql.dart"',
      );
    }
    final customDataType =
        typedSqlLibrary.element.exportNamespace.get('CustomDataType');
    if (customDataType is! ClassElement) {
      throw g.InvalidGenerationSource('Unable to resolve `CustomDataType`');
    }

    final ctx = ParserContext(
      customDataType: customDataType,
    );

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
