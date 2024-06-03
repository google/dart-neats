import 'dart:convert';

import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:markdown/markdown.dart';
import 'package:source_span/source_span.dart';

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

class Extractor {
  const Extractor();

  void extractFile() {}

  List<DocumentationComment> extractDocumentationComments(ParsedUnitResult r) {
    final file = SourceFile.fromString(r.content, url: r.uri);
    final comments = <DocumentationComment>[];
    r.unit.accept(_ForEachCommentAstVisitor((comment) {
      if (comment.isDocumentation) {
        final span = file.span(comment.offset, comment.end);

        // TODO: remove `///` syntax with a better way..
        var lines = LineSplitter.split(span.text);
        lines = lines.map((l) => l.replaceFirst('///', ''));
        comments.add(DocumentationComment(
          contents: lines.join('\n'),
          span: span,
        ));
      }
    }));
    return comments;
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
