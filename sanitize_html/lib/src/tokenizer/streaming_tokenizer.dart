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

/// A streaming tokenizer following the WHATWG [tokenizer states][1].
///
/// Handles comments (including `<!-->` and `--!>`), bogus comments,
/// doctypes, RAWTEXT and RCDATA elements, script data escaping and
/// `plaintext` without building a tree. The content of RAWTEXT, RCDATA,
/// script and `template` elements is not reported: a browser never renders
/// it as markup, so unwrapping such an element must not make it live.
///
/// Known deviations:
///
///  * `<![CDATA[` is a bogus comment even inside foreign content.
///  * `noscript` is always RAWTEXT (as with scripting enabled).
///  * Character references in text are left to the writer.
///  * `/>` is honoured on `svg` and `math` only, not inside foreign content.
///
/// [1]: https://html.spec.whatwg.org/multipage/parsing.html#tokenization
library;

import '../html_token_sink.dart';
import '../util/ascii.dart';
import 'elements.dart';
import 'entities.dart';

/// See `HtmlTokenizer.streaming`.
void tokenizeStreaming(String html, HtmlTokenSink sink) {
  _StreamingTokenizer(html, sink)._run();
  sink.close();
}

final class _StreamingTokenizer {
  final String _html;
  final int _len;
  final HtmlTokenSink _sink;
  int _pos = 0;

  /// Whether the tag most recently parsed by [_attributes] ended with `/>`.
  bool _selfClosing = false;

  _StreamingTokenizer(this._html, this._sink) : _len = _html.length;

  void _run() {
    var textStart = 0;
    while (true) {
      final lt = _html.indexOf('<', _pos);
      if (lt < 0 || lt + 1 >= _len) {
        break;
      }
      _pos = lt + 1;
      final next = _html.codeUnitAt(_pos);
      if (isAsciiAlpha(next)) {
        _flushText(textStart, lt);
        _startTag();
      } else if (next == $slash) {
        if (_pos + 1 >= _len) {
          continue; // `</` at EOF is text.
        }
        _flushText(textStart, lt);
        _pos++;
        if (isAsciiAlpha(_html.codeUnitAt(_pos))) {
          final name = _tagName();
          // Attributes on end tags are parse errors and ignored.
          if (_attributes() != null) {
            _sink.endTag(name);
          }
        } else {
          // `</>` is ignored, `</` + anything else is a bogus comment.
          _skipPast('>');
        }
      } else if (next == $exclamation) {
        _flushText(textStart, lt);
        _pos++;
        _markupDeclaration();
      } else if (next == $question) {
        _flushText(textStart, lt);
        _skipPast('>');
      } else {
        continue; // `<` followed by anything else is text.
      }
      textStart = _pos;
    }
    _flushText(textStart, _len);
  }

  void _flushText(int start, int end) {
    if (end > start) {
      _sink.text(_html, start, end);
    }
  }

  /// Parses a start tag; `_pos` is at the first character of the name.
  void _startTag() {
    final name = _tagName();
    final attributes = _attributes();
    if (attributes == null) {
      return; // EOF in tag: no token is emitted.
    }
    _sink.startTag(name, attributes);
    if (_selfClosing && foreignContentElements.contains(name)) {
      // `/>` closes the element only in foreign content; the sink has no
      // self-closing flag, so report the end tag here. Elements _inside_
      // foreign content are not tracked and nest like HTML elements.
      _sink.endTag(name);
    } else if (name == 'script') {
      _skipScriptData();
      _sink.endTag(name);
    } else if (rawTextElements.contains(name)) {
      _skipRawText(name);
      _sink.endTag(name);
    } else if (name == 'plaintext') {
      _pos = _len;
    }
  }

  /// The [tag name state][1].
  ///
  /// [1]: https://html.spec.whatwg.org/multipage/parsing.html#tag-name-state
  String _tagName() {
    final start = _pos;
    while (_pos < _len) {
      final c = _html.codeUnitAt(_pos);
      if (isHtmlWhitespace(c) || c == $slash || c == $gt) {
        break;
      }
      _pos++;
    }
    return asciiLowerSubstring(_html, start, _pos);
  }

  /// Parses attributes up to and including the closing `>`; the first
  /// occurrence of an attribute wins. Sets [_selfClosing]. Returns `null` on
  /// EOF inside the tag. The [before attribute name state][1] and following.
  ///
  /// [1]: https://html.spec.whatwg.org/multipage/parsing.html#before-attribute-name-state
  Map<String, String>? _attributes() {
    var attributes = const <String, String>{};
    _selfClosing = false;
    while (_pos < _len) {
      final c = _html.codeUnitAt(_pos);
      if (isHtmlWhitespace(c)) {
        _pos++;
        continue;
      }
      if (c == $gt) {
        _pos++;
        return attributes;
      }
      if (c == $slash) {
        _pos++;
        if (_pos < _len && _html.codeUnitAt(_pos) == $gt) {
          _pos++;
          _selfClosing = true;
          return attributes;
        }
        continue;
      }
      final nameStart = _pos;
      while (_pos < _len) {
        final c = _html.codeUnitAt(_pos);
        if (isHtmlWhitespace(c) ||
            c == $slash ||
            c == $gt ||
            (c == $equal && _pos > nameStart)) {
          break;
        }
        _pos++;
      }
      final name = asciiLowerSubstring(_html, nameStart, _pos);
      _skipWhitespace();
      var value = '';
      if (_pos < _len && _html.codeUnitAt(_pos) == $equal) {
        _pos++;
        _skipWhitespace();
        value = _attributeValue();
      }
      if (attributes.isEmpty) {
        attributes = <String, String>{};
      }
      attributes[name] ??= value;
    }
    return null;
  }

  /// The [before attribute value state][1] and following.
  ///
  /// [1]: https://html.spec.whatwg.org/multipage/parsing.html#before-attribute-value-state
  String _attributeValue() {
    if (_pos >= _len) {
      return '';
    }
    final quote = _html.codeUnitAt(_pos);
    final int start, end;
    if (quote == $quot || quote == $apos) {
      start = ++_pos;
      final close = _html.indexOf(quote == $quot ? '"' : "'", _pos);
      end = close < 0 ? _len : close;
      _pos = close < 0 ? _len : close + 1;
    } else {
      start = _pos;
      while (_pos < _len) {
        final c = _html.codeUnitAt(_pos);
        if (isHtmlWhitespace(c) || c == $gt) {
          break;
        }
        _pos++;
      }
      end = _pos;
    }
    return decodeCharacterReferences(_html, start, end);
  }

  /// `_pos` is just after `<!`: the [markup declaration open state][1].
  ///
  /// [1]: https://html.spec.whatwg.org/multipage/parsing.html#markup-declaration-open-state
  void _markupDeclaration() {
    if (!_html.startsWith('--', _pos)) {
      // Doctype, CDATA (outside foreign content) or bogus comment.
      _skipPast('>');
      return;
    }
    _pos += 2;
    // `<!-->` and `<!--->` are complete (empty) comments.
    if (_html.startsWith('>', _pos)) {
      _pos++;
      return;
    }
    if (_html.startsWith('->', _pos)) {
      _pos += 2;
      return;
    }
    // Otherwise the comment ends at `-->` or `--!>`.
    while (true) {
      final dashes = _html.indexOf('--', _pos);
      if (dashes < 0) {
        _pos = _len;
        return;
      }
      _pos = dashes + 2;
      while (_pos < _len && _html.codeUnitAt(_pos) == $minus) {
        _pos++;
      }
      if (_html.startsWith('>', _pos)) {
        _pos++;
        return;
      }
      if (_html.startsWith('!>', _pos)) {
        _pos += 2;
        return;
      }
    }
  }

  /// Skips to the end tag of the RAWTEXT / RCDATA element [name], per the
  /// [RAWTEXT less-than sign state][1].
  ///
  /// [1]: https://html.spec.whatwg.org/multipage/parsing.html#rawtext-less-than-sign-state
  void _skipRawText(String name) {
    while (true) {
      final lt = _html.indexOf('</', _pos);
      if (lt < 0) {
        _pos = _len;
        return;
      }
      _pos = lt + 2;
      if (_matchesTagName(name)) {
        _attributes();
        return;
      }
    }
  }

  /// Skips script content, honouring the `<!--` ... `-->` escaping rules
  /// under which `<script>` ... `</script>` pairs inside a comment are text;
  /// the [script data state][1] and following.
  ///
  /// [1]: https://html.spec.whatwg.org/multipage/parsing.html#script-data-state
  void _skipScriptData() {
    // While escaped, the index of the `-->` that ends the escaped state (or
    // `_len`), computed once so that this loop stays linear.
    var escapedUntil = -1, doubleEscaped = false;
    while (true) {
      final lt = _html.indexOf('<', _pos);
      if (lt < 0) {
        _pos = _len;
        return;
      }
      if (escapedUntil >= 0 && escapedUntil < lt) {
        escapedUntil = -1;
        doubleEscaped = false;
      }
      final escaped = escapedUntil >= 0;
      _pos = lt + 1;
      if (_html.startsWith('/', _pos)) {
        _pos++;
        if (_matchesTagName('script')) {
          if (doubleEscaped) {
            doubleEscaped = false;
          } else {
            _attributes();
            return;
          }
        }
      } else if (!escaped && _html.startsWith('!--', _pos)) {
        _pos += 3;
        // `<!-->` and `<!--->` do not enter the escaped state.
        while (_html.startsWith('-', _pos)) {
          _pos++;
        }
        if (_html.startsWith('>', _pos)) {
          _pos++;
        } else {
          final close = _html.indexOf('-->', _pos);
          escapedUntil = close < 0 ? _len : close;
        }
      } else if (escaped && !doubleEscaped && _matchesTagName('script')) {
        doubleEscaped = true;
      }
    }
  }

  /// Whether `_pos` is at [name] (ASCII case-insensitive) followed by
  /// whitespace, `/`, `>` or EOF; advances past the name if so.
  bool _matchesTagName(String name) {
    final end = _pos + name.length;
    if (end > _len) {
      return false;
    }
    for (var i = 0; i < name.length; i++) {
      if (asciiLower(_html.codeUnitAt(_pos + i)) != name.codeUnitAt(i)) {
        return false;
      }
    }
    if (end < _len) {
      final c = _html.codeUnitAt(end);
      if (!isHtmlWhitespace(c) && c != $slash && c != $gt) {
        return false;
      }
    }
    _pos = end;
    return true;
  }

  void _skipWhitespace() {
    while (_pos < _len && isHtmlWhitespace(_html.codeUnitAt(_pos))) {
      _pos++;
    }
  }

  /// Advances past the next occurrence of [s], or to EOF.
  void _skipPast(String s) {
    final index = _html.indexOf(s, _pos);
    _pos = index < 0 ? _len : index + s.length;
  }
}
