import 'dart:convert';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:markdown/markdown.dart';
import 'package:source_span/source_span.dart';

import '../dartdoc_test.dart';

final _md = Document(extensionSet: ExtensionSet.gitHubWeb);

class DocumentationComment {
  final FileSpan span;
  final String contents;

  DocumentationComment({
    required this.contents,
    required this.span,
  });
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

void extractFile(String filePath, ParsedUnitResult result) {
  final comments = extractDocumentationComments(result);
  for (final c in comments) {
    final samples = extractCodeSamples(c);
    for (final s in samples) {
      print(s.comment.span.start.toolString);
      print(s.code);
    }
    writeCodeSamples(filePath, samples);
  }
}

List<DocumentationComment> extractDocumentationComments(ParsedUnitResult r) {
  final file = SourceFile.fromString(r.content, url: r.uri);
  final comments = <DocumentationComment>[];
  r.unit.accept(_ForEachCommentAstVisitor((comment) {
    if (comment.isDocumentation) {
      final span = file.span(comment.offset, comment.end);

      final content = stripComments(span.text);

      comments.add(DocumentationComment(
        contents: content,
        span: span,
      ));
    }
  }));
  return comments;
}

Iterable<String> stripCommonWhiteSpace(String comment) {
  final lines = LineSplitter.split(comment);
  return lines.map((l) => l.trimLeft());
}

String stripComments(String comment) {
  if (comment.isEmpty) return '';

  final buf = StringBuffer();
  final lines = stripCommonWhiteSpace(comment);
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

class _ForEachCommentAstVisitor extends RecursiveAstVisitor<void> {
  final void Function(Comment comment) _forEach;

  _ForEachCommentAstVisitor(this._forEach);

  @override
  void visitComment(Comment node) => _forEach(node);
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
