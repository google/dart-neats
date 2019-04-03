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

import 'package:universal_html/html.dart' as html;
import 'package:meta/meta.dart' show required;

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
class SaneHtmlValidator implements html.NodeValidator {
  final bool Function(String) allowElementId;
  final bool Function(String) allowClassName;

  SaneHtmlValidator({
    @required this.allowElementId,
    @required this.allowClassName,
  });

  @override
  bool allowsAttribute(html.Element element, String attribute, String value) {
    if (!_allowedElements.contains(element.tagName)) {
      return false;
    }
    if (_alwaysAllowedAttributes.contains(attribute)) {
      return true;
    }
    // Special validators for id and class on all elements
    if (attribute == 'id') {
      return allowElementId(element.id);
    }
    if (attribute == 'class') {
      return element.classes.every(allowClassName);
    }
    // Special validators for special attributes on special tags (href/src/cite)
    final attributeValidators = _elementAttributeValidators[element.tagName];
    if (attributeValidators == null) {
      return false;
    }
    final validator = attributeValidators[attribute];
    if (validator == null) {
      return false;
    }
    return validator(value);
  }

  @override
  bool allowsElement(html.Element element) {
    return _allowedElements.contains(element.tagName);
  }
}
