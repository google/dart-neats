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
  const DartdocTestFile(this._comments, this._sourceFile);

  final List<DocumentationComment> _comments;
  final FileSpan _sourceFile;

  List<DocumentationComment> get comments => _comments;
  FileSpan get sourceFile => _sourceFile;
}

/// A documentation comment extracted from a source file.
class DocumentationComment {
  /// The path of the original file
  final String path;

  /// The span of the comment in the source file.
  final FileSpan span;

  /// The contents of the comment. (includes code blocks and text)
  final String contents;

  /// The imports used in the source file.
  final List<String> imports;

  DocumentationComment({
    required this.path,
    required this.contents,
    required this.span,
    required this.imports,
  });
}

/// A code sample extracted from a documentation comment.
class DocumentationCodeSample {
  /// The documentation comment that contains the code sample.
  final DocumentationComment comment;

  /// content of the code sample.
  final String code;

  DocumentationCodeSample({
    required this.comment,
    required this.code,
  });

  bool get ignore => code.contains('// dartdoc_test:ignore_error');
  bool get hasMain => code.contains('void main()');
  bool get hasImport => code.contains('import ');

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
    buf.writeln('void main() {');
    buf.writeAll(LineSplitter.split(code).map((l) => '  $l'), '\n');
    buf.writeln();
    buf.writeln('}');
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
