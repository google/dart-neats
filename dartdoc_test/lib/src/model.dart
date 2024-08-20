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

/// A dart file that contains documentation comments and code samples.
final class DartdocTestFile {
  /// Create a new [DartdocTestFile].
  DartdocTestFile(this._sourceFile, this._imports, this._comments);

  final SourceFile _sourceFile;
  final List<String> _imports;
  final List<DocumentationComment> _comments;

  /// The source file.
  SourceFile get sourceFile => _sourceFile;

  /// The imports used in the source file.
  List<String> get imports => _imports;

  /// The documentation comments in the source file.
  List<DocumentationComment> get comments => _comments;
}

/// A documentation comment extracted from a source file.
final class DocumentationComment {
  final String _path;
  final FileSpan _span;
  final String _contents;
  final List<String> _imports;

  /// The path of the source file that contains the comment.
  String get path => _path;

  /// The span of the comment in the source file.
  FileSpan get span => _span;

  /// The contents of the comment. (includes code blocks and text)
  String get contents => _contents;

  /// The imports used in the source file.
  List<String> get imports => _imports;

  /// Create a new [DocumentationComment].
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
final class DocumentationCodeSample {
  /// The documentation comment that contains the code sample.
  final DocumentationComment comment;

  /// content of the code sample.
  final String code;

  /// Whether the code sample has a `no-test` tag.
  final bool noTest;

  /// Create a new [DocumentationCodeSample].
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

/// A generated code sample file.
final class CodeSampleFile {
  /// The path of the generated file.
  final String path;

  /// The generated source file.
  final SourceFile sourceFile;

  /// The code sample that generated the file.
  final DocumentationCodeSample sample;

  /// Create a new [CodeSampleFile].
  CodeSampleFile({
    required this.path,
    required this.sourceFile,
    required this.sample,
  });
}
