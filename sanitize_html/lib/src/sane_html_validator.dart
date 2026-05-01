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

import 'package:html/dom.dart';
import 'package:html/parser.dart' as html_parser;

final _allowedElements = <String>{
  'H1',
  'H2',
  'H3',
  'H4',
  'H5',
  'H6',
  'H7',
  'H8',
  'BR',
  'B',
  'I',
  'STRONG',
  'EM',
  'A',
  'PRE',
  'CODE',
  'IMG',
  'TT',
  'DIV',
  'INS',
  'DEL',
  'SUP',
  'SUB',
  'P',
  'OL',
  'UL',
  'TABLE',
  'THEAD',
  'TBODY',
  'TFOOT',
  'BLOCKQUOTE',
  'DL',
  'DT',
  'DD',
  'KBD',
  'Q',
  'SAMP',
  'VAR',
  'HR',
  'RUBY',
  'RT',
  'RP',
  'LI',
  'TR',
  'TD',
  'TH',
  'S',
  'STRIKE',
  'SUMMARY',
  'DETAILS',
  'CAPTION',
  'FIGURE',
  'FIGCAPTION',
  'ABBR',
  'BDO',
  'CITE',
  'DFN',
  'MARK',
  'SMALL',
  'SPAN',
  'TIME',
  'WBR',
};

final _alwaysAllowedAttributes = <String>{
  'abbr',
  'accept',
  'accept-charset',
  'accesskey',
  'action',
  'align',
  'alt',
  'aria-describedby',
  'aria-hidden',
  'aria-label',
  'aria-labelledby',
  'axis',
  'border',
  'cellpadding',
  'cellspacing',
  'char',
  'charoff',
  'charset',
  'checked',
  'clear',
  'cols',
  'colspan',
  'color',
  'compact',
  'coords',
  'datetime',
  'dir',
  'disabled',
  'enctype',
  'for',
  'frame',
  'headers',
  'height',
  'hreflang',
  'hspace',
  'ismap',
  'label',
  'lang',
  'maxlength',
  'media',
  'method',
  'multiple',
  'name',
  'nohref',
  'noshade',
  'nowrap',
  'open',
  'prompt',
  'readonly',
  'rel',
  'rev',
  'rows',
  'rowspan',
  'rules',
  'scope',
  'selected',
  'shape',
  'size',
  'span',
  'start',
  'summary',
  'tabindex',
  'target',
  'title',
  'type',
  'usemap',
  'valign',
  'value',
  'vspace',
  'width',
  'itemprop',
};

bool _alwaysAllowed(String _) => true;

bool _validLink(String url) {
  try {
    final uri = Uri.parse(url);
    return uri.isScheme('https') ||
        uri.isScheme('http') ||
        uri.isScheme('mailto') ||
        !uri.hasScheme;
  } on FormatException {
    return false;
  }
}

bool _validUrl(String url) {
  try {
    final uri = Uri.parse(url);
    return uri.isScheme('https') || uri.isScheme('http') || !uri.hasScheme;
  } on FormatException {
    return false;
  }
}

final _citeAttributeValidator = <String, bool Function(String)>{
  'cite': _validUrl,
};

final _elementAttributeValidators =
    <String, Map<String, bool Function(String)>>{
  'A': {
    'href': _validLink,
  },
  'IMG': {
    'src': _validUrl,
    'longdesc': _validUrl,
  },
  'DIV': {
    'itemscope': _alwaysAllowed,
    'itemtype': _alwaysAllowed,
  },
  'BLOCKQUOTE': _citeAttributeValidator,
  'DEL': _citeAttributeValidator,
  'INS': _citeAttributeValidator,
  'Q': _citeAttributeValidator,
};

/// An implementation of [html.NodeValidator] that only allows sane HTML tags
/// and attributes protecting against XSS.
///
/// Modeled after the [rules employed by Github][1] when sanitizing GFM (Github
/// Flavored Markdown). Notably this excludes CSS styles and other tags that
/// easily interferes with the rest of the page.
///
/// [1]: https://github.com/jch/html-pipeline/blob/master/lib/html/pipeline/sanitization_filter.rb
class SaneHtmlValidator {
  final bool Function(String)? allowElementId;
  final bool Function(String)? allowClassName;
  final Iterable<String>? Function(String)? addLinkRel;

  SaneHtmlValidator({
    required this.allowElementId,
    required this.allowClassName,
    required this.addLinkRel,
  });

  String sanitize(String htmlString) {
    final root = html_parser.parseFragment(htmlString);
    _sanitize(root);
    return root.outerHtml;
  }

  bool containsDisallowedContent(String htmlString) {
    try {
      final root = html_parser.parseFragment(htmlString);
      return _hasDisallowedContent(root);
    } catch (e) {
      throw Exception('Error parsing HTML: $e');
    }
  }

  void _sanitize(Node node) {
    if (node is Element) {
      final tagName = node.localName!.toUpperCase();
      if (!_allowedElements.contains(tagName)) {
        node.remove();
        return;
      }
      node.attributes.removeWhere((k, v) {
        final attrName = k.toString();
        if (attrName == 'id') {
          return allowElementId == null || !allowElementId!(v);
        }
        if (attrName == 'class') {
          if (allowClassName == null) return true;
          node.classes.removeWhere((cn) => !allowClassName!(cn));
          return node.classes.isEmpty;
        }
        return !_isAttributeAllowed(tagName, attrName, v);
      });
      if (tagName == 'A') {
        final href = node.attributes['href'];
        if (href != null && addLinkRel != null) {
          final rels = addLinkRel!(href);
          if (rels != null && rels.isNotEmpty) {
            final currentRel = node.attributes['rel'] ?? '';
            final allRels = <String>{
              ...currentRel.split(' ').where((e) => e.isNotEmpty),
              ...rels,
            };
            node.attributes['rel'] = allRels.join(' ');
          }
        }
      }
    }
    if (node.hasChildNodes()) {
      // doing it in reverse order, because we could otherwise skip one, when a
      // node is removed...
      for (var i = node.nodes.length - 1; i >= 0; i--) {
        _sanitize(node.nodes[i]);
      }
    }
  }

  bool _hasDisallowedContent(Node node) {
    // Check if the node is an Element
    if (node is Element) {
      final tagName = node.localName?.toUpperCase() ?? '';

      // If the tag is not allowed, return true
      if (!_allowedElements.contains(tagName)) {
        return true;
      }

      // Check each attribute of the element
      for (var attribute in node.attributes.entries) {
        final attrName = attribute.key.toString();
        final attrValue = attribute.value;

        // Allow 'id' attribute only if allowElementId allows it
        if (attrName == 'id' && (allowElementId == null || !allowElementId!(attrValue))) {
          return true;
        }

        // Allow 'class' attribute only if all classes are allowed
        if (attrName == 'class' && allowClassName != null) {
          for (var className in node.classes) {
            if (!allowClassName!(className)) {
              return true;
            }
          }
        }

        // Check other attributes against allowed attributes list and validators
        if (!_isAttributeAllowed(tagName, attrName, attrValue)) {
          return true;
        }
      }

      // Special handling for 'A' elements with 'href' attribute
      if (tagName == 'A' && node.attributes.containsKey('href')) {
        final href = node.attributes['href'];
        // Validate the href attribute
        if (href != null && !_validLink(href)) {
          return true;  // Disallow invalid URLs in 'href'
        }
      }
    }

    // Recursively check child nodes for disallowed content
    for (var child in node.nodes) {
      if (_hasDisallowedContent(child)) {
        return true;
      }
    }

    // If no disallowed content was found, return false
    return false;
  }

  bool _isAttributeAllowed(String tagName, String attrName, String value) {
    if (_alwaysAllowedAttributes.contains(attrName)) return true;

    // Special validators for special attributes on special tags (href/src/cite)
    final attributeValidators = _elementAttributeValidators[tagName];
    if (attributeValidators == null) {
      return false;
    }

    final validator = attributeValidators[attrName];
    if (validator == null) {
      return false;
    }

    return validator(value);
  }
}
