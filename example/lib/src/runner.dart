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

/// Running [updateDocument] over a directory of markdown files.
library;

import 'dart:io';

import 'package:path/path.dart' as p;

import 'diagnostic.dart';
import 'update.dart';
import 'util/files.dart';

/// What [updateDirectory] did.
final class RunOutcome {
  /// Markdown files that were looked at.
  final int scanned;

  /// Documents that are out of date, with the number of stale blocks in each.
  final Map<String, int> stale;

  /// Errors encountered while checking or updating documents, in file order.
  final List<ExampleFormatException> diagnostics;

  RunOutcome({
    required this.scanned,
    required this.stale,
    required this.diagnostics,
  });
}

/// Updates or checks every markdown file under [directory].
///
/// With [write], out-of-date documents are rewritten; without it they are
/// only reported, which is what `validate` does in CI.
///
/// Each document is resolved against **its own** package root via
/// `.dart_tool/package_config.json`, so a workspace of many packages, or a
/// package with an `example/` application of its own, does the right thing
/// without being told about it.
Future<RunOutcome> updateDirectory({
  required String directory,
  required bool write,
}) async {
  final root = p.normalize(p.absolute(directory));
  final diagnostics = <ExampleFormatException>[];
  final stale = <String, int>{};
  var scanned = 0;

  for (final file in markdownFiles(root)) {
    scanned++;
    final label = p.relative(file, from: root);

    final String source;
    try {
      source = File(file).readAsStringSync();
    } on FileSystemException catch (e) {
      diagnostics.add(
        ExampleFormatException('cannot read `$label` (${e.message})'),
      );
      continue;
    }

    final packageRoot = source.contains('```') || source.contains('~~~')
        ? await packageRootOf(file)
        : null;

    final result = updateDocument(
      source: source,
      documentPath: file,
      packageRoot: packageRoot,
      sourceUrl: p.toUri(label),
      readFile: (path) {
        final example = File(path);
        return example.existsSync() ? example.readAsStringSync() : null;
      },
    );
    diagnostics.addAll(result.diagnostics);

    if (result.stale.isNotEmpty) stale[label] = result.stale.length;
    if (result.updated == null) continue;

    if (write) {
      File(file).writeAsStringSync(result.updated!);
    }
  }

  return RunOutcome(
    scanned: scanned,
    stale: stale,
    diagnostics: diagnostics,
  );
}

/// Checks that all markdown example blocks under [directory] (defaulting to
/// [Directory.current]) are up to date with the files they reference.
///
/// Throws an [AssertionError] if any referenced file or region is invalid or
/// if any markdown code block is out of date (i.e., whenever
/// `dart run example validate` would fail).
Future<void> validateExamples({String? directory}) async {
  final outcome = await updateDirectory(
    directory: directory ?? Directory.current.path,
    write: false,
  );
  final problems = <String>[
    for (final error in outcome.diagnostics) error.toString(),
    for (final MapEntry(key: file, value: count) in outcome.stale.entries)
      '$file: error: $count code '
          '${count == 1 ? 'block is' : 'blocks are'} out of date; run '
          '`dart run example update`',
  ];
  if (problems.isNotEmpty) {
    throw AssertionError(problems.join('\n\n'));
  }
}
