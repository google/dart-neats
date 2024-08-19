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
import 'package:source_span/source_span.dart';

import 'model.dart';

final _md = Document(extensionSet: ExtensionSet.gitHubWeb);

/// Eztract code samples from [ParsedUnitResult].
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

/// Extract code samples from a file (analysis result)
List<DocumentationComment> extractDocumentationComments(ParsedUnitResult r) {
  final file = SourceFile.fromString(r.content, url: r.uri);

  final imports = getImports(file, r);

  final comments = <DocumentationComment>[];
  r.unit.accept(_ForEachCommentAstVisitor((comment) {
    if (comment.isDocumentation) {
      final span = file.span(comment.offset, comment.end);
      final content = stripComments(span.text);

      comments.add(DocumentationComment(
        path: r.path,
        contents: content,
        span: span,
        imports: imports,
      ));
    }
  }));
  return comments;
}

/// Strips leading whitespaces from a string.
///
/// ```dart
/// final comment = '  /// some comment\n';
/// print(stripleadingWhiteSpace(comment)); // ['/// some comment']
/// ```
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

/// Extracts code samples from a documentation comment.
/// one comment can have multiple code samples.
/// so this function returns a list of code samples.
List<DocumentationCodeSample> extractCodeSamples(DocumentationComment comment) {
  final nodes = _md.parse(comment.contents);
  var samples = <DocumentationCodeSample>[];
  nodes.accept(_ForEachElement((element) {
    if (element.tag == 'pre') {
      if (element.children == null ||
          element.children!.isEmpty ||
          element.children!.first is! Element) {
        return;
      }

      final child = element.children!.first as Element;
      // get code block only if it's a dart code block.
      // when no class is specified, it's considered as dart code block.
      if (child.tag == 'code' &&
          (child.attributes['class'] == 'language-dart' ||
              child.attributes['class'] == 'language-dart#no-test' ||
              child.attributes['class'] == null)) {
        var code = '';
        element.children?.accept(_ForEachText((text) {
          code += text.textContent;
        }));
        if (code.isNotEmpty) {
          samples.add(DocumentationCodeSample(
            comment: comment,
            code: code,
            noTest: child.attributes['class'] == 'language-dart#no-test',
          ));
        }
      }
    }
  }));
  return samples;
}

/// Get imports used on a file.
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

extension on DartdocTestFile {
  /// get file infomations from [ParsedUnitResult].s
  static DartdocTestFile from(ParsedUnitResult result) {
    final sourceFile = SourceFile.fromString(result.content, url: result.uri);
    final comments = extractDocumentationComments(result);
    final imports = getImports(sourceFile, result);
    return DartdocTestFile(sourceFile, imports, comments);
  }
}
