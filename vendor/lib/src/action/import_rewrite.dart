// Copyright 2022 Google LLC
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

import 'dart:io' show File, Directory, FileSystemException, IOException;
import 'package:glob/glob.dart' show Glob;
import 'package:glob/list_local_fs.dart' show ListLocalFileSystem;
import 'package:async/async.dart' show StreamGroup;
import 'package:analyzer/dart/ast/ast.dart'
    show ExportDirective, ImportDirective, StringLiteral, SingleStringLiteral;
import 'package:analyzer/dart/ast/visitor.dart' show RecursiveAstVisitor;
import 'package:meta/meta.dart' show sealed;
import 'package:vendor/src/action/action.dart' show Action, Context;
import 'package:vendor/src/exceptions.dart' show VendorFailure, ExitCode;
import 'package:path/path.dart' as p;
import 'package:vendor/src/utils/iterable_ext.dart' show IterableExt;
import 'package:yaml_edit/yaml_edit.dart' show SourceEdit;

import 'package:analyzer/dart/analysis/results.dart' show ParsedUnitResult;

import 'package:analyzer/dart/analysis/analysis_context_collection.dart'
    show AnalysisContextCollection;

@sealed
class ImportRewriteAction extends Action {
  /// Folder within which to make the rewrite
  final Uri folder;

  final Uri from;
  final Uri to;

  ImportRewriteAction({
    required this.folder,
    required this.from,
    required this.to,
  });

  @override
  String get summary => 'rewrite import "$from" -> "$to" in $folder';

  @override
  Future<void> apply(Context ctx) async {
    final rootPath = p.canonicalize(ctx.rootPackageFolder.toFilePath());
    final analysisContextCollection = AnalysisContextCollection(
      includedPaths: [rootPath],
    );
    final context = analysisContextCollection.contextFor(rootPath);
    final session = context.currentSession;

    final absoluteFolder = ctx.rootPackageFolder.resolveUri(folder);
    final files = _findDartFiles(
      absoluteFolder,
      excludeVendorFolder: absoluteFolder == ctx.rootPackageFolder,
    );

    ctx.log('# Apply: $summary');
    await for (final f in files) {
      ctx.log('- rewriting "$f"');
      final u = session.getParsedUnit(absoluteFolder.resolve(f).toFilePath());
      if (u is ParsedUnitResult) {
        if (u.isPart) {
          continue; // Skip parts, they can't have imports
        }
        if (u.errors.isNotEmpty) {
          ctx.warning('  Failed to parse: ${u.errors.first.toString()}');
          continue;
        }

        // Run rewrite visitor
        final rewriter = _ImportRewriteVisitor(from, to, ctx);
        u.unit.accept(rewriter);

        // Rebase all edits on top of eachother
        var delta = 0;
        final edits = <SourceEdit>[];
        for (final edit in rewriter.edits) {
          edits.add(SourceEdit(
            edit.offset + delta,
            edit.length,
            edit.replacement,
          ));
          delta += edit.replacement.length - edit.length;
        }

        // Apply edits updating the result
        final result = SourceEdit.applyAll(u.content, edits);

        // Update file
        // Note: we could probably make vendoring faster by collecting all edits
        //       from various rewrite actions and applying them all at once.
        try {
          await File.fromUri(absoluteFolder.resolve(f)).writeAsString(result);
        } on IOException catch (e) {
          throw VendorFailure(
            ExitCode.ioError,
            'unable to save "$f", failure: $e',
          );
        }
      }
    }
  }
}

extension on Uri {
  /// [pathSegments] without the last entry, if it's empty. The last entry is
  /// an empty string when we have trailing a slash (e.g. `package:foo/`).
  Iterable<String> get pathSegmentsNoTrailingSlash {
    if (pathSegments.isEmpty) {
      return pathSegments;
    }
    if (pathSegments.last.isNotEmpty) {
      return pathSegments;
    }
    return pathSegments.take(pathSegments.length - 1);
  }
}

class _ImportRewriteVisitor extends RecursiveAstVisitor<void> {
  final Uri _from;
  final Uri _to;
  final Context _ctx;
  final List<SourceEdit> edits = [];

  _ImportRewriteVisitor(this._from, this._to, this._ctx);

  @override
  void visitExportDirective(ExportDirective n) {
    _rewriteUri(n.uri);
    for (final c in n.configurations) {
      _rewriteUri(c.uri);
    }
  }

  @override
  void visitImportDirective(ImportDirective n) {
    _rewriteUri(n.uri);
    for (final c in n.configurations) {
      _rewriteUri(c.uri);
    }
  }

  void _rewriteUri(StringLiteral s) {
    final u = Uri.tryParse(s.stringValue!);
    if (u == null) {
      // TODO: Print source location here.
      _ctx.warning('  Unable to parse: "${s.stringValue}"');
      return; // ignore URIs we can't parse
    }
    if (!_matchesFrom(u)) {
      return;
    }

    // Construct new URI
    final relativePath = u.pathSegments.skip(
      _from.pathSegmentsNoTrailingSlash.length,
    );
    final newUri = _to.replace(
      pathSegments: _to.pathSegmentsNoTrailingSlash.followedBy(relativePath),
    );

    // We prefer single quote, but if it's a SingleStringLiteral, which it
    // almost always is, we quickly check to see if it's single or double.
    // If it's not a SingleStringLiteral and double quoted, we use single quote.
    final quote = (s is SingleStringLiteral && !s.isSingleQuoted) ? '"' : "'";

    edits.add(SourceEdit(s.offset, s.length, '$quote$newUri$quote'));
  }

  bool _matchesFrom(Uri u) {
    u = u.normalizePath();
    return u.scheme == _from.scheme &&
        u.pathSegments.startsWith(_from.pathSegmentsNoTrailingSlash) &&
        u.pathSegments.length > _from.pathSegmentsNoTrailingSlash.length;
  }
}

const _sourceFoldersInPackage = ['lib/', 'test/', 'bin/', 'benchmark/'];

Stream<String> _findDartFiles(Uri folder, {bool excludeVendorFolder = false}) =>
    StreamGroup.merge(_sourceFoldersInPackage.map(
      (path) => Glob('**.dart')
          .list(
        root: folder.resolve(path).toFilePath(),
        followLinks: false,
      )
          .handleError(
        (e) {/* ignore folder doesn't exist */},
        test: (e) =>
            e is FileSystemException &&
            (e.osError?.errorCode == 2 ||
                !Directory.fromUri(folder.resolve(path)).existsSync()),
      ),
    ))
        .where((entity) => entity is File)
        .map((entity) => p.relative(entity.path, from: folder.toFilePath()))
        .where((path) =>
            !excludeVendorFolder || !p.isWithin('lib/src/third_party/', path));
