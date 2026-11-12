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

/// Bringing one markdown document up to date with the files it references.
library;

import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;
import 'package:source_span/source_span.dart';

import 'diagnostic.dart';
import 'indent.dart';
import 'markdown/locator.dart';
import 'markdown/references.dart';
import 'markdown/splice.dart';
import 'region.dart';
import 'resolve.dart';

/// Reads the file at [path], or returns `null` if there is no such file.
///
/// An argument rather than `dart:io` so that the driver can be tested against
/// a `Map<String, String>`, which is both faster and far easier to read than
/// a temporary directory.
typedef FileReader = String? Function(String path);

/// What [updateDocument] made of a document.
final class UpdateResult {
  /// The updated document, or `null` if nothing needed to change.
  ///
  /// `update` writes this; `validate` only reports that it exists.
  final String? updated;

  /// References whose blocks were out of date, whether or not they could be
  /// updated.
  final List<ExampleReference> stale;

  /// Errors encountered while checking or updating this document.
  final List<ExampleFormatException> diagnostics;

  UpdateResult({
    required this.updated,
    required this.stale,
    required this.diagnostics,
  });
}

/// Returns [source] with every referenced code block filled in.
///
/// [documentPath] and [packageRoot] (when non-null) are absolute. If
/// [packageRoot] is `null`, documents without example references succeed and
/// documents with references report an error at the first reference.
/// Diagnostics in the document are labelled with [sourceUrl], which defaults to
/// [documentPath].
UpdateResult updateDocument({
  required String source,
  required String documentPath,
  required String? packageRoot,
  required FileReader readFile,
  Uri? sourceUrl,
}) {
  final diagnostics = <ExampleFormatException>[];
  final stale = <ExampleReference>[];

  if (!source.contains('```') && !source.contains('~~~')) {
    return UpdateResult(updated: null, stale: stale, diagnostics: diagnostics);
  }

  final document = SourceFile.fromString(
    source,
    url: sourceUrl ?? p.toUri(documentPath),
  ).span(0);
  final blocks = locateFencedCodeBlocks(document);

  final references = findReferences(blocks, report: diagnostics.add);
  if (references.isEmpty) {
    return UpdateResult(updated: null, stale: stale, diagnostics: diagnostics);
  }

  if (packageRoot == null) {
    diagnostics.add(ExampleFormatException(
      'no package configuration covers this file; run `dart pub get` first',
      references.first.span,
    ));
    return UpdateResult(updated: null, stale: stale, diagnostics: diagnostics);
  }

  // Work out what every block should contain before changing anything. A
  // broken reference is reported and skipped; the other blocks are updated.
  final wanted = <ExampleReference, String>{};
  for (final reference in references) {
    if (reference.block.closeFence == null) {
      diagnostics.add(ExampleFormatException(
        'this code block has no closing fence, so it cannot be updated safely',
        reference.block.openFence,
      ));
      continue;
    }

    final String content;
    try {
      content = _contentFor(
        reference,
        documentPath: documentPath,
        packageRoot: packageRoot,
        readFile: readFile,
      );
    } on ExampleFormatException catch (e) {
      diagnostics.add(
        e.span != null ? e : ExampleFormatException(e.message, reference.span),
      );
      continue;
    }

    if (content == reference.block.content) continue;
    stale.add(reference);
    wanted[reference] = content;
  }
  if (wanted.isEmpty) {
    return UpdateResult(updated: null, stale: stale, diagnostics: diagnostics);
  }

  // Splice from the end so that the offsets of the blocks still to be done
  // are not disturbed.
  var updated = source;
  for (final reference in wanted.keys
      .sortedBy<SourceSpan>((r) => r.block.contentSpan)
      .reversed) {
    updated = spliceContent(updated, reference.block, wanted[reference]!);
  }

  return UpdateResult(updated: updated, stale: stale, diagnostics: diagnostics);
}

/// The content [reference] asks for.
String _contentFor(
  ExampleReference reference, {
  required String documentPath,
  required String packageRoot,
  required FileReader readFile,
}) {
  final path = resolveReference(
    packageRoot: packageRoot,
    documentPath: documentPath,
    reference: reference.path,
  );
  final source = readFile(path);
  if (source == null) {
    throw ExampleFormatException(
      'there is no file `${reference.path}` '
      '(looked for `${p.relative(path, from: packageRoot)}`)',
      reference.span,
    );
  }
  final indent = switch (reference.options['indent']) {
    null || 'strip' => true,
    'keep' => false,
    final other => throw ExampleFormatException(
        'invalid `indent=$other`; expected `indent=strip` or `indent=keep`',
        reference.span,
      ),
  };
  final relativePath = p.relative(path, from: packageRoot);
  final example = SourceFile.fromString(
    source,
    url: p.toUri(relativePath),
  ).span(0);
  final content = extractRegion(example, region: reference.region);
  return indent ? stripIndentation(content) : content;
}
