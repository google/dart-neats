// Copyright 2026 Google LLC
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

/// Implements `HtmlRewriter.impliedEndTags`.
///
/// Tracks every start tag, including ones the sanitizer will unwrap, as the
/// tree builder does. The stack is capped at the writer's `maxDepth`, like
/// Blink's: a deeper start tag closes the innermost open element, which
/// keeps every scan bounded and the rewriter linear.
library;

import '../delegating_html_token_sink.dart';
import '../html_rewriter.dart';
import '../html_writer.dart' show isVoidElement, maxDepth;

/// See `HtmlRewriter.impliedEndTags`.
HtmlRewriter impliedEndTags() => const HtmlRewriter(_ImpliedEndTags.new);

/// Start tags before which the ["in body" insertion mode][1] closes an open
/// `<p>` in button scope.
///
/// [1]: https://html.spec.whatwg.org/multipage/parsing.html#parsing-main-inbody
const _closesParagraph = <String>{
  'address',
  'article',
  'aside',
  'blockquote',
  'center',
  'dd',
  'details',
  'dialog',
  'dir',
  'div',
  'dl',
  'dt',
  'fieldset',
  'figcaption',
  'figure',
  'footer',
  'form',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'header',
  'hgroup',
  'hr',
  'li',
  'listing',
  'main',
  'menu',
  'nav',
  'ol',
  'p',
  'plaintext',
  'pre',
  'search',
  'section',
  'summary',
  'table',
  'ul',
  'xmp',
};

/// Start tags that close the innermost open element in `targets` with none
/// of `boundaries` opened after it, and everything above it: the "in table",
/// "in row" and "in cell" insertion modes, a `select` in scope, and, for
/// `a`, the [adoption agency algorithm][1].
///
/// [1]: https://html.spec.whatwg.org/multipage/parsing.html#adoption-agency-algorithm
const _closesInScope =
    <String, ({Set<String> targets, Set<String> boundaries})>{
  'a': (targets: {'a'}, boundaries: _formattingMarkers),
  'input': (targets: {'select'}, boundaries: _scope),
  'keygen': (targets: {'select'}, boundaries: _scope),
  'select': (targets: {'select'}, boundaries: _scope),
  'tbody': (targets: _rowGroups, boundaries: _tableScope),
  'td': (targets: {'td', 'th'}, boundaries: _tableScope),
  'textarea': (targets: {'select'}, boundaries: _scope),
  'tfoot': (targets: _rowGroups, boundaries: _tableScope),
  'th': (targets: {'td', 'th'}, boundaries: _tableScope),
  'thead': (targets: _rowGroups, boundaries: _tableScope),
  'tr': (targets: {'tr'}, boundaries: _tableScope),
};

/// Start tags that pop the current node while it is one of the set: "if the
/// current node is an HTML element whose tag name is one of h1–h6, pop the
/// current node"; `option` and `optgroup` likewise for an open `option`.
const _closesCurrent = <String, Set<String>>{
  'h1': _headings,
  'h2': _headings,
  'h3': _headings,
  'h4': _headings,
  'h5': _headings,
  'h6': _headings,
  'optgroup': {'option', 'optgroup'},
  'option': {'option'},
};

/// Start tags that close the nearest open element in the set unless a
/// [special][1] element other than `address`, `div` or `p` is open above it:
/// the `li`, `dd` and `dt` loops.
///
/// [1]: https://html.spec.whatwg.org/multipage/parsing.html#special
const _closesUnlessSpecial = <String, Set<String>>{
  'dd': {'dd', 'dt'},
  'dt': {'dd', 'dt'},
  'li': {'li'},
};

final _listItemStop = _special.difference(const {'address', 'div', 'p'});

const _headings = <String>{'h1', 'h2', 'h3', 'h4', 'h5', 'h6'};

/// What an end tag closes, per the ["in body"][1] and "in table" insertion
/// modes: the innermost open element of that name (or any of `names`) with
/// none of `boundaries` opened after it. End tags of other [_special]
/// elements use [_scope]; any other end tag is blocked by an open special
/// element.
///
/// [1]: https://html.spec.whatwg.org/multipage/parsing.html#parsing-main-inbody
final _endTags = <String, ({Set<String> boundaries, Set<String>? names})>{
  for (final name in _special) name: (boundaries: _scope, names: null),
  'p': (boundaries: _buttonScope, names: null),
  'li': (boundaries: _listItemScope, names: null),
  for (final name in _headings) name: (boundaries: _scope, names: _headings),
  for (final name in _tableParts) name: (boundaries: _tableScope, names: null),
};

const _tableParts = <String>{
  'caption',
  'colgroup',
  'table',
  'tbody',
  'td',
  'tfoot',
  'th',
  'thead',
  'tr',
};
const _rowGroups = <String>{'tbody', 'tfoot', 'thead'};

/// Boundaries of the tree builder's [element scopes][1].
///
/// [1]: https://html.spec.whatwg.org/multipage/parsing.html#has-an-element-in-scope
const _scope = <String>{
  'applet',
  'caption',
  'html',
  'table',
  'td',
  'th',
  'marquee',
  'object',
  'template',
  'mi',
  'mo',
  'mn',
  'ms',
  'mtext',
  'annotation-xml',
  'foreignobject',
  'desc',
  'title',
};
const _buttonScope = <String>{..._scope, 'button'};
const _listItemScope = <String>{..._scope, 'ol', 'ul'};
const _tableScope = <String>{'html', 'table', 'template'};

/// The tree builder's [special][1] elements: an end tag for anything else
/// is ignored when one of these is open above its element.
///
/// [1]: https://html.spec.whatwg.org/multipage/parsing.html#special
const _special = <String>{
  'address',
  'applet',
  'area',
  'article',
  'aside',
  'base',
  'basefont',
  'bgsound',
  'blockquote',
  'body',
  'br',
  'button',
  'caption',
  'center',
  'col',
  'colgroup',
  'dd',
  'details',
  'dir',
  'div',
  'dl',
  'dt',
  'embed',
  'fieldset',
  'figcaption',
  'figure',
  'footer',
  'form',
  'frame',
  'frameset',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'head',
  'header',
  'hgroup',
  'hr',
  'html',
  'iframe',
  'img',
  'input',
  'keygen',
  'li',
  'link',
  'listing',
  'main',
  'marquee',
  'menu',
  'meta',
  'nav',
  'noembed',
  'noframes',
  'noscript',
  'object',
  'ol',
  'p',
  'param',
  'plaintext',
  'pre',
  'script',
  'search',
  'section',
  'select',
  'source',
  'style',
  'summary',
  'table',
  'tbody',
  'td',
  'template',
  'textarea',
  'tfoot',
  'th',
  'thead',
  'title',
  'tr',
  'track',
  'ul',
  'wbr',
  'xmp',
  'mi',
  'mo',
  'mn',
  'ms',
  'mtext',
  'annotation-xml',
  'foreignobject',
  'desc',
};

/// Elements that push a marker onto the
/// [list of active formatting elements][1], beyond which an `<a>` start tag
/// does not close an open `<a>`.
///
/// [1]: https://html.spec.whatwg.org/multipage/parsing.html#list-of-active-formatting-elements
const _formattingMarkers = <String>{
  'applet',
  'caption',
  'marquee',
  'object',
  'td',
  'template',
  'th',
};

/// Emits the end tags the tree builder implies.
///
/// A start tag closes what the tables above say it closes. An end tag
/// closes the innermost open element it names and everything opened after
/// it, unless a boundary of its scope was opened after it: for [special][1]
/// elements the boundaries of their scope, for any other element the
/// special elements themselves; a heading end tag closes any open heading.
///
/// [1]: https://html.spec.whatwg.org/multipage/parsing.html#parsing-main-inbody
final class _ImpliedEndTags extends DelegatingHtmlTokenSink {
  /// Names of the open elements, outermost first.
  final List<String> _open = [];

  _ImpliedEndTags(super.sink);

  @override
  void startTag(String name, Map<String, String> attributes) {
    if (_closesUnlessSpecial[name] case final targets?) {
      final index = _indexInScope(targets, name, _listItemStop);
      if (index >= 0) {
        _popTo(index);
      }
    }
    if (_closesParagraph.contains(name) && _isOpenInScope('p', _buttonScope)) {
      _close('p');
    }
    if (_closesCurrent[name] case final targets?) {
      while (_open.isNotEmpty && targets.contains(_open.last)) {
        _popTo(_open.length - 1);
      }
    }
    if (_closesInScope[name] case (:final targets, :final boundaries)) {
      final index = _indexInScope(targets, name, boundaries);
      if (index >= 0) {
        _popTo(index);
      }
    }
    if (isVoidElement(name)) {
      super.startTag(name, attributes);
      return;
    }
    if (_open.length >= maxDepth) {
      super.endTag(_open.removeLast());
    }
    super.startTag(name, attributes);
    _open.add(name);
  }

  @override
  void endTag(String name) {
    final (:boundaries, :names) =
        _endTags[name] ?? (boundaries: _special, names: null);
    final index = _indexInScope(names, name, boundaries);
    if (index >= 0) {
      _popTo(index);
    }
  }

  /// Closes the innermost open [name] and everything opened after it.
  void _close(String name) => _popTo(_open.lastIndexOf(name));

  /// Emits an end tag for every open element above [index], innermost first.
  void _popTo(int index) {
    while (_open.length > index) {
      super.endTag(_open.removeLast());
    }
  }

  /// The tree builder's ["has an element in scope"][1]: whether [name] is
  /// open and none of [boundaries] was opened after it.
  ///
  /// [1]: https://html.spec.whatwg.org/multipage/parsing.html#has-an-element-in-the-specific-scope
  bool _isOpenInScope(String name, Set<String> boundaries) =>
      _indexInScope(null, name, boundaries) >= 0;

  /// Index of the innermost open element called [name] (or in [names], if
  /// given) with none of [boundaries] opened after it, or -1.
  int _indexInScope(Set<String>? names, String name, Set<String> boundaries) {
    for (var i = _open.length - 1; i >= 0; i--) {
      final open = _open[i];
      if (open == name || (names != null && names.contains(open))) {
        return i;
      }
      if (boundaries.contains(open)) {
        return -1;
      }
    }
    return -1;
  }

  @override
  void close() {
    _popTo(0);
    super.close();
  }
}
