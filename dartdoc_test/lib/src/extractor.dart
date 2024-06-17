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

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:markdown/markdown.dart';
import 'package:path/path.dart' as path;
import 'package:source_span/source_span.dart';

final _md = Document(extensionSet: ExtensionSet.gitHubWeb);

class DocumentationComment {
  final FileSpan span;
  final String contents;
  final List<String> imports;

  DocumentationComment({
    required this.contents,
    required this.span,
    required this.imports,
  });
}

class DocumentationCodeSample {
  final DocumentationComment comment;
  final String code;
  final List<String> imports;
  final bool hasMain;
  // TODO: Find the SourceSpan of [code] within [comment], this is pretty hard
  //       to do because package:markdown doesn't provide any line-numbers or
  //       offsets. One option is to parse it manually, instead of using
  //       package:markdown. Or just search for ```dart and ``` and use that to
  //       find code samples.
  final FileSpan? span;

  DocumentationCodeSample({
    required this.comment,
    required this.code,
    this.span,
    this.imports = const [],
    this.hasMain = false,
  });

  String get wrappedCode {
    final fileName = path.basename(comment.span.file.url!.path);

    final buf = StringBuffer();
    buf.writeAll(comment.imports, '\n');
    buf.writeln();
    buf.writeln('import "$fileName";');
    buf.writeln();
    buf.writeln('void main() {');
    buf.writeAll(LineSplitter.split(code).map((l) => '  $l'), '\n');
    buf.writeln();
    buf.writeln('}');
    return buf.toString();
  }
}

List<DocumentationCodeSample> extractFile(
  ParsedUnitResult result,
) {
  var samples = <DocumentationCodeSample>[];
  final comments = extractDocumentationComments(result);
  for (final c in comments) {
    final extractedSamples = extractCodeSamples(c);
    samples.addAll(extractedSamples);
  }
  return samples;
}

List<DocumentationComment> extractDocumentationComments(ParsedUnitResult r) {
  final file = SourceFile.fromString(r.content, url: r.uri);

  final imports = getImports(file, r);

  final comments = <DocumentationComment>[];
  r.unit.accept(_ForEachCommentAstVisitor((comment) {
    if (comment.isDocumentation) {
      final span = file.span(comment.offset, comment.end);
      final content = stripComments(span.text);

      comments.add(DocumentationComment(
        contents: content,
        span: span,
        imports: imports,
      ));
    }
  }));
  return comments;
}

Iterable<String> stripleadingWhiteSpace(String comment) {
  final lines = LineSplitter.split(comment);
  return lines.map((l) => l.trimLeft());
}

/// Strips documentation comments syntax and leading whitespaces from a string.
///
/// This function supports both `///` and `/** */` style comments.
/// ```dart
/// final comment1 = '/// some comment';
/// print(stripComments(comment1)); // 'some comment'
/// ```
/// ```dart
/// final comment2 = '''
/// /**
/// * some comment
/// */''';
/// stripComments(comment2); // 'some comment'
/// ```
String stripComments(String comment) {
  if (comment.isEmpty) return '';

  final buf = StringBuffer();
  final lines = stripleadingWhiteSpace(comment);
  if (lines.first.startsWith('///')) {
    for (final l in lines) {
      if (l.startsWith('/// ')) {
        buf.writeln(l.substring(4));
      } else if (l.startsWith('///')) {
        buf.writeln(l.substring(3));
      } else {
        buf.writeln(l);
      }
    }
  } else if (lines.first.startsWith('/**') && lines.last.endsWith('*/')) {
    for (final l in lines) {
      if (l.startsWith('* ') || l.startsWith('*/')) {
        buf.writeln(l.substring(2));
      } else if (l.startsWith('*')) {
        buf.writeln(l.substring(1));
      }
    }
  } else {
    return '';
  }

  return buf.toString().trim();
}

List<DocumentationCodeSample> extractCodeSamples(
  DocumentationComment comment,
) {
  final samples = <DocumentationCodeSample>[];
  final nodes = _md.parse(comment.contents);
  nodes.accept(_ForEachElement((element) {
    if (element.tag == 'code' &&
        element.attributes['class'] == 'language-dart') {
      var code = '';
      element.children?.accept(_ForEachText((text) {
        code += text.textContent;
      }));
      if (code.isNotEmpty) {
        samples.add(DocumentationCodeSample(comment: comment, code: code));
      }
    }
  }));
  return samples;
}

List<String> getImports(SourceFile f, ParsedUnitResult r) {
  final imports = <String>[];
  r.unit.accept(_ForEachImportAstVisitor((node) {
    final span = f.span(node.offset, node.end);
    imports.add(span.text);
  }));
  return imports;
}

class _ForEachCommentAstVisitor extends RecursiveAstVisitor<void> {
  final void Function(Comment comment) _forEach;

  _ForEachCommentAstVisitor(this._forEach);

  @override
  void visitComment(Comment node) {
    _forEach(node);
  }
}

class _ForEachImportAstVisitor extends RecursiveAstVisitor<void> {
  final void Function(ImportDirective node) _forEach;

  _ForEachImportAstVisitor(this._forEach);

  @override
  void visitImportDirective(ImportDirective node) => _forEach(node);
}

extension on List<Node> {
  void accept(NodeVisitor visitor) {
    for (final node in this) {
      node.accept(visitor);
    }
  }
}

class _ForEachElement extends NodeVisitor {
  final void Function(Element element) _forEach;

  _ForEachElement(this._forEach);

  @override
  bool visitElementBefore(Element element) => true;

  @override
  void visitElementAfter(Element element) => _forEach(element);

  @override
  void visitText(Text text) {}
}

class _ForEachText extends NodeVisitor {
  final void Function(Text element) _forEach;

  _ForEachText(this._forEach);

  @override
  bool visitElementBefore(Element element) => true;

  @override
  void visitElementAfter(Element element) {}

  @override
  void visitText(Text text) => _forEach(text);
}
