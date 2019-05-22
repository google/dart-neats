// Copyright 2019 Google LLC
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

import 'package:html/dom.dart';

final _attrEscape = HtmlEscape(HtmlEscapeMode.attribute);
final _textEscape = HtmlEscape(HtmlEscapeMode.element);

String formatHtmlNode(Node node) {
  return _HtmlFormatter()._format(node);
}

class _HtmlFormatter {
  final _sb = StringBuffer();

  String _format(Node node) {
    _writeNodes([node]);
    return _sb.toString();
  }

  void _writeNodes(List<Node> nodes) {
    if (nodes == null || nodes.isEmpty) return;
    for (Node node in nodes) {
      if (node is Element) {
        _writeElement(node);
      } else if (node is Text) {
        _sb.write(_textEscape.convert(node.text));
      } else if (node is Document) {
        _writeNodes([node.documentElement]);
      } else if (node is DocumentFragment) {
        _writeNodes(node.nodes);
      } else if (node is Comment) {
        // no output
      } else if (node is DocumentType) {
        // no output
      } else {
        throw UnimplementedError('Unknown node: ${node.runtimeType} ($node)');
      }
    }
  }

  void _writeElement(Element elem) {
    final tagName = elem.localName;
    _sb.write('<$tagName');
    elem.attributes.forEach((k, v) {
      _sb.write(' $k="${_attrEscape.convert(v)}"');
    });
    if (elem.hasChildNodes()) {
      _sb.write('>');
      _writeNodes(elem.nodes);
      _sb.write('</$tagName>');
    } else if (tagName.toLowerCase() == 'script') {
      _sb.write('></$tagName>');
    } else {
      _sb.write(' />');
    }
  }
}
