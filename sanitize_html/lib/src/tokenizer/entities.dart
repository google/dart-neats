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

/// Decodes character references in attribute values: the attribute-value
/// branch of the [character reference state][1].
///
/// [1]: https://html.spec.whatwg.org/multipage/parsing.html#character-reference-state
library;

import '../util/ascii.dart';
import 'named_character_references.dart';

/// Decodes the character references in `s[start..end)`.
String decodeCharacterReferences(String s, int start, int end) {
  var amp = _indexOfAmpersand(s, start, end);
  if (amp < 0) {
    return s.substring(start, end);
  }
  final out = StringBuffer();
  var copied = start;
  while (amp >= 0) {
    final decoded = _decodeAt(s, amp, end);
    if (decoded != null) {
      out
        ..write(s.substring(copied, amp))
        ..write(decoded.text);
      copied = decoded.end;
      amp = _indexOfAmpersand(s, copied, end);
    } else {
      amp = _indexOfAmpersand(s, amp + 1, end);
    }
  }
  out.write(s.substring(copied, end));
  return out.toString();
}

/// Index of the first `&` in `s[start..end)`, or -1.
///
/// Not `String.indexOf`, which has no end bound and would scan past the
/// slice for every attribute value.
int _indexOfAmpersand(String s, int start, int end) {
  for (var i = start; i < end; i++) {
    if (s.codeUnitAt(i) == $amp) {
      return i;
    }
  }
  return -1;
}

/// Decodes the reference starting with the `&` at `s[amp]`, if there is one.
({String text, int end})? _decodeAt(String s, int amp, int end) {
  var i = amp + 1;
  if (i >= end) {
    return null;
  }
  if (s.codeUnitAt(i) == $hash) {
    return _decodeNumeric(s, i + 1, end);
  }
  final nameStart = i;
  while (i < end && _isAlphanumeric(s.codeUnitAt(i))) {
    i++;
  }
  if (i == nameStart) {
    return null;
  }
  final name = s.substring(nameStart, i);
  if (i < end && s.codeUnitAt(i) == $semicolon) {
    final text = namedCharacterReferences[name];
    return text == null ? null : (text: text, end: i + 1);
  }
  // Legacy references without `;` are not decoded in attributes when
  // followed by `=` or an alphanumeric ("for historical reasons"); the
  // alphanumeric case cannot occur here since the name is maximal.
  // https://html.spec.whatwg.org/multipage/parsing.html#named-character-reference-state
  if (i < end && s.codeUnitAt(i) == $equal) {
    return null;
  }
  final text = legacyNamedCharacterReferences[name];
  return text == null ? null : (text: text, end: i);
}

({String text, int end})? _decodeNumeric(String s, int i, int end) {
  var value = 0;
  final int digitsStart;
  if (i < end && asciiLower(s.codeUnitAt(i)) == $x) {
    digitsStart = ++i;
    while (i < end) {
      final c = s.codeUnitAt(i);
      final digit = switch (c) {
        >= $0 && <= $9 => c - $0,
        >= $a && <= $f => c - $a + 10,
        >= $A && <= $F => c - $A + 10,
        _ => -1,
      };
      if (digit < 0) {
        break;
      }
      if (value <= _maxCodePoint) {
        value = value * 16 + digit;
      }
      i++;
    }
  } else {
    digitsStart = i;
    while (i < end) {
      final c = s.codeUnitAt(i);
      if (c < $0 || c > $9) {
        break;
      }
      if (value <= _maxCodePoint) {
        value = value * 10 + (c - $0);
      }
      i++;
    }
  }
  if (i == digitsStart) {
    return null;
  }
  if (i < end && s.codeUnitAt(i) == $semicolon) {
    i++;
  }
  return (text: _numericReferenceText(value), end: i);
}

/// The [numeric character reference end state][1].
///
/// [1]: https://html.spec.whatwg.org/multipage/parsing.html#numeric-character-reference-end-state
String _numericReferenceText(int value) {
  if (value == 0 || value > _maxCodePoint || _isSurrogate(value)) {
    return '\uFFFD';
  }
  return _windows1252[value] ?? String.fromCharCode(value);
}

const _maxCodePoint = 0x10FFFF;

bool _isSurrogate(int c) => c >= 0xD800 && c <= 0xDFFF;

/// Replacements for the C1 controls U+0080-U+009F, which browsers interpret
/// as Windows-1252.
const _windows1252 = <int, String>{
  0x80: '\u20AC',
  0x82: '\u201A',
  0x83: '\u0192',
  0x84: '\u201E',
  0x85: '\u2026',
  0x86: '\u2020',
  0x87: '\u2021',
  0x88: '\u02C6',
  0x89: '\u2030',
  0x8A: '\u0160',
  0x8B: '\u2039',
  0x8C: '\u0152',
  0x8E: '\u017D',
  0x91: '\u2018',
  0x92: '\u2019',
  0x93: '\u201C',
  0x94: '\u201D',
  0x95: '\u2022',
  0x96: '\u2013',
  0x97: '\u2014',
  0x98: '\u02DC',
  0x99: '\u2122',
  0x9A: '\u0161',
  0x9B: '\u203A',
  0x9C: '\u0153',
  0x9E: '\u017E',
  0x9F: '\u0178',
};

bool _isAlphanumeric(int c) => isAsciiDigit(c) || isAsciiAlpha(c);
