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

/// Writes text, start tags and end tags as HTML.
///
/// Inserted where the parser is in the [data state][1], the output creates
/// no element and no attribute that was not pushed, because:
///
///  * text is always escaped: `<`, `>`, and `&` unless it begins a
///    character reference;
///  * attribute values are always double-quoted, with `&`, `"`, `<` and `>`
///    escaped;
///  * tag names must match `[a-z][a-z0-9._-]*` and attribute names
///    `[a-z][a-z0-9_:.-]*`, otherwise the writer throws;
///  * `image` is refused: the tree builder turns it into `img`;
///  * every element opened is closed, nested at most [maxDepth] deep, so
///    [RAWTEXT, RCDATA][2] and foreign content end where this writer ends
///    them.
///
/// The tree builder may still re-nest or clone pushed elements and insert
/// implied `tbody`, `tr`, `colgroup` and `p`; none of that adds a name or
/// attribute that was not pushed.
///
/// [1]: https://html.spec.whatwg.org/multipage/parsing.html#data-state
/// [2]: https://html.spec.whatwg.org/multipage/parsing.html#generic-raw-text-element-parsing-algorithm
library;

import 'dart:convert';

import 'html_token_sink.dart';
import 'util/ascii.dart';

/// Maximum number of simultaneously open elements.
///
/// Blink flattens at 512, counting the host document's depth; a quarter
/// leaves any host room; the sanitizer and `impliedEndTags` use the same
/// bound.
const maxDepth = 128;

/// Elements the ["in body" insertion mode][1] pops immediately, including
/// the obsolete ones it still treats so.
///
/// [1]: https://html.spec.whatwg.org/multipage/parsing.html#parsing-main-inbody
const _voidElements = <String>{
  'area',
  'base',
  'basefont',
  'bgsound',
  'br',
  'col',
  'embed',
  'frame',
  'hr',
  'img',
  'input',
  'keygen',
  'link',
  'meta',
  'param',
  'source',
  'track',
  'wbr',
};

/// Whether [name] is written as a lone start tag, like `<br>`.
bool isVoidElement(String name) => _voidElements.contains(name);

/// Whether [name] matches `[a-z][a-z0-9._-]*` and is not `image`.
bool isWritableTagName(String name) {
  if (name.isEmpty || !isAsciiLower(name.codeUnitAt(0))) {
    return false;
  }
  for (var i = 1; i < name.length; i++) {
    final c = name.codeUnitAt(i);
    if (!isAsciiLower(c) &&
        !isAsciiDigit(c) &&
        c != $dot &&
        c != $minus &&
        c != $underscore) {
      return false;
    }
  }
  return name != 'image';
}

/// Whether [name] matches `[a-z][a-z0-9_:.-]*`.
bool isWritableAttributeName(String name) {
  if (name.isEmpty || !isAsciiLower(name.codeUnitAt(0))) {
    return false;
  }
  for (var i = 1; i < name.length; i++) {
    final c = name.codeUnitAt(i);
    if (!isAsciiLower(c) &&
        !isAsciiDigit(c) &&
        c != $dot &&
        c != $minus &&
        c != $underscore &&
        c != $colon) {
      return false;
    }
  }
  return true;
}

/// A sink writing tokens into [output] as HTML in which the browser finds
/// exactly the elements and attributes pushed, no more.
///
/// Elements nest at most 128 deep: a start tag at that depth closes the
/// innermost open element first, as browsers do. Closing the sink closes
/// every open element, then [output]. Throws if:
///
///  * a tag name does not match `[a-z][a-z0-9._-]*`, or is `image`;
///  * an attribute name does not match `[a-z][a-z0-9_:.-]*`;
///  * a token arrives after [HtmlTokenSink.close].
HtmlTokenSink htmlWriter(StringConversionSink output) => _HtmlWriter(output);

final class _HtmlWriter extends HtmlTokenSink {
  final StringConversionSink _out;
  bool _closed = false;

  /// Open elements, outermost first.
  final List<String> _open = [];

  _HtmlWriter(this._out);

  @override
  void startTag(String name, Map<String, String> attributes) {
    _checkOpen();
    if (!isWritableTagName(name)) {
      throw ArgumentError.value(name, 'name', 'not a writable tag name');
    }
    final isVoid = _voidElements.contains(name);
    if (!isVoid && _open.length >= maxDepth) {
      _writeEndTag(_open.removeLast());
    }
    _out
      ..add('<')
      ..add(name);
    for (final MapEntry(:key, :value) in attributes.entries) {
      if (!isWritableAttributeName(key)) {
        throw ArgumentError.value(key, 'attributes', 'not a writable name');
      }
      _out
        ..add(' ')
        ..add(key)
        ..add('="');
      _writeEscaped(value, 0, value.length, inAttribute: true);
      _out.add('"');
    }
    _out.add('>');
    if (!isVoid) {
      _open.add(name);
    }
  }

  @override
  void endTag(String name) {
    _checkOpen();
    final index = _open.lastIndexOf(name);
    if (index < 0) {
      return;
    }
    while (_open.length > index) {
      _writeEndTag(_open.removeLast());
    }
  }

  @override
  void text(String source, int start, int end) {
    _checkOpen();
    _writeEscaped(source, start, end, inAttribute: false);
  }

  @override
  void close() {
    _checkOpen();
    _closed = true;
    while (_open.isNotEmpty) {
      _writeEndTag(_open.removeLast());
    }
    _out.close();
  }

  void _checkOpen() {
    if (_closed) {
      throw StateError('closed');
    }
  }

  void _writeEndTag(String name) {
    _out
      ..add('</')
      ..add(name)
      ..add('>');
  }

  /// Escapes `source[start..end)` into [_out], copying unescaped runs whole.
  /// (`add`, not `addSlice`: the SDK's `StringConversionSink`s copy a partial
  /// slice one code unit at a time.)
  ///
  /// In attribute values every `&` is escaped, so the browser decodes
  /// exactly the value the rules saw.
  void _writeEscaped(
    String source,
    int start,
    int end, {
    required bool inAttribute,
  }) {
    var runStart = start;
    for (var i = start; i < end; i++) {
      final String replacement;
      switch (source.codeUnitAt(i)) {
        case $lt:
          replacement = '&lt;';
        case $gt:
          replacement = '&gt;';
        case $quot when inAttribute:
          replacement = '&quot;';
        case $amp
            when inAttribute || !_startsCharacterReference(source, i, end):
          replacement = '&amp;';
        default:
          continue;
      }
      if (i > runStart) {
        _out.add(source.substring(runStart, i));
      }
      _out.add(replacement);
      runStart = i + 1;
    }
    if (end > runStart) {
      _out.add(source.substring(runStart, end));
    }
  }

  /// Whether the `&` at `source[i]` is followed by `#` or an alphanumeric.
  static bool _startsCharacterReference(String source, int i, int end) {
    if (i + 1 >= end) {
      return false;
    }
    final c = source.codeUnitAt(i + 1);
    return c == $hash || isAsciiDigit(c) || isAsciiAlpha(c);
  }
}
