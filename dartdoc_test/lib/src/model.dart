// Copyright 2023 Google LLC
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

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:source_span/source_span.dart';

class DartdocTestFile {
  DartdocTestFile(this._sourceFile, this._imports, this._comments);

  final SourceFile _sourceFile;
  final List<String> _imports;
  final List<DocumentationComment> _comments;

  SourceFile get sourceFile => _sourceFile;
  List<String> get imports => _imports;
  List<DocumentationComment> get comments => _comments;
}

/// A documentation comment extracted from a source file.
class DocumentationComment {
  final String _path;

  /// The span of the comment in the source file.
  final FileSpan _span;

  /// The contents of the comment. (includes code blocks and text)
  final String _contents;

  /// The imports used in the source file.
  final List<String> _imports;

  String get path => _path;
  FileSpan get span => _span;
  String get contents => _contents;
  List<String> get imports => _imports;

  DocumentationComment({
    required String path,
    required String contents,
    required FileSpan span,
    required List<String> imports,
  })  : _path = path,
        _contents = contents,
        _span = span,
        _imports = imports;
}

/// A code sample extracted from a documentation comment.
class DocumentationCodeSample {
  /// The documentation comment that contains the code sample.
  final DocumentationComment comment;

  /// content of the code sample.
  final String code;

  /// Whether the code sample has a `no-test` tag.
  final bool noTest;

  DocumentationCodeSample({
    required this.comment,
    required this.code,
    required this.noTest,
  });

  /// Whether the code sample has a `main` function.
  bool get hasMain => code.contains('void main()');

  /// Create a sample by wrapping the code with a main function and imports.
  String wrappedCode(Directory testDir) {
    final fileName = comment.span.sourceUrl;

    final buf = StringBuffer();
    buf.writeAll(comment.imports, '\n');
    buf.writeln();
    if (fileName != null) {
      if (fileName.hasAbsolutePath) {
        final path = p.relative(fileName.path, from: testDir.absolute.path);
        buf.writeln('import \'$path\';');
      } else {
        buf.writeln('import \'$fileName\';');
      }
    }
    buf.writeln();
    if (!hasMain) buf.writeln('void main() {');
    buf.writeAll(LineSplitter.split(code).map((l) => '  $l'), '\n');
    buf.writeln();
    if (!hasMain) buf.writeln('}');
    return buf.toString();
  }
}

class CodeSampleFile {
  final String path;
  final SourceFile sourceFile;
  final DocumentationCodeSample sample;

  CodeSampleFile({
    required this.path,
    required this.sourceFile,
    required this.sample,
  });
}
