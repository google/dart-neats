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

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'package:source_span/source_span.dart';
import 'package:markdown/markdown.dart';

final _parser = ArgParser()
  ..addFlag(
    'help',
    abbr: 'h',
    help: 'Show help',
    negatable: false,
  )
  ..addMultiOption(
    'directory',
    abbr: 'd',
    help: 'Directories to analyze',
  );

Future<void> main(List<String> args) async {
  final rootFolder = Directory.current.absolute.path;
  final exampleFolder = p.join(rootFolder);
  final contextCollection = AnalysisContextCollection(
    includedPaths: [rootFolder],
    resourceProvider: PhysicalResourceProvider.INSTANCE,
  );

  final ctx = contextCollection.contextFor(rootFolder);
  final session = ctx.currentSession;

  // TODO: add `include` and `exclude` options
  final files = Directory(rootFolder)
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList();
  for (final file in files) {
    final result = session.getParsedUnit(file.path);
    if (result is ParsedUnitResult) {
      final comments = extractDocumentationComments(result);
      print(comments.length);
      for (final c in comments) {
        final samples = extractCodeSamples(c);
      }
    }
  }
}

class DocumentationComment {
  final FileSpan span;
  final String contents;

  DocumentationComment({
    required this.contents,
    required this.span,
  });
}

List<DocumentationComment> extractDocumentationComments(ParsedUnitResult r) {
  final file = SourceFile.fromString(r.content, url: r.uri);
  final comments = <DocumentationComment>[];
  r.unit.accept(_ForEachCommentAstVisitor((comment) {
    if (comment.isDocumentation) {
      final span = file.span(comment.offset, comment.end);
      print(span.text);
      var lines = LineSplitter.split(span.text);
      lines = lines.map((line) => line.substring(3));
      if (lines.every((line) => line.isEmpty || line.startsWith(' '))) {
        lines = lines.map((line) => line.isEmpty ? '' : line.substring(1));
      }
      comments.add(DocumentationComment(
        contents: lines.join('\n'),
        span: span,
      ));
    }
  }));
  return comments;
}

class _ForEachCommentAstVisitor extends RecursiveAstVisitor<void> {
  final void Function(Comment comment) _forEach;

  _ForEachCommentAstVisitor(this._forEach);

  @override
  void visitComment(Comment node) => _forEach(node);
}

class DocumentationCodeSample {
  final DocumentationComment comment;
  final String code;
  // TODO: Find the SourceSpan of [code] within [comment], this is pretty hard
  //       to do because package:markdown doesn't provide any line-numbers or
  //       offsets. One option is to parse it manually, instead of using
  //       package:markdown. Or just search for ```dart and ``` and use that to
  //       find code samples.

  DocumentationCodeSample({
    required this.comment,
    required this.code,
  });
}

final _md = Document(extensionSet: ExtensionSet.gitHubWeb);

List<DocumentationCodeSample> extractCodeSamples(DocumentationComment comment) {
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
