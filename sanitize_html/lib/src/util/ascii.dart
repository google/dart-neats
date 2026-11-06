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

/// ASCII character helpers.
///
/// Every character test in this package compares a UTF-16 code unit with an
/// ASCII value, and every index at which a string is cut or escaped is that
/// of an ASCII code unit. Surrogate halves and all other non-ASCII code
/// units are `>= 0x80`, so they never satisfy such a test: a supplementary
/// character is never mistaken for a delimiter or split.
library;

// Code units, named as in `package:charcode`.

const $tab = 0x09;
const $lf = 0x0A;
const $ff = 0x0C;
const $cr = 0x0D;
const $space = 0x20;
const $exclamation = 0x21; // !
const $quot = 0x22; // "
const $hash = 0x23; // #
const $percent = 0x25; // %
const $amp = 0x26; // &
const $apos = 0x27; // '
const $minus = 0x2D; // -
const $dot = 0x2E; // .
const $slash = 0x2F; // /
const $0 = 0x30;
const $9 = 0x39;
const $colon = 0x3A; // :
const $semicolon = 0x3B; // ;
const $lt = 0x3C; // <
const $equal = 0x3D; // =
const $gt = 0x3E; // >
const $question = 0x3F; // ?
const $at = 0x40; // @
const $A = 0x41;
const $F = 0x46;
const $Z = 0x5A;
const $underscore = 0x5F; // _
const $a = 0x61;
const $f = 0x66;
const $x = 0x78;
const $z = 0x7A;
const $del = 0x7F;

/// Whether [c] is an ASCII lower-case letter.
bool isAsciiLower(int c) => c >= $a && c <= $z;

/// Whether [c] is an ASCII digit.
bool isAsciiDigit(int c) => c >= $0 && c <= $9;

/// Whether [c] is an ASCII letter.
bool isAsciiAlpha(int c) => (c >= $A && c <= $Z) || (c >= $a && c <= $z);

/// Whether [c] is ASCII whitespace as defined by the HTML tokenizer.
bool isHtmlWhitespace(int c) =>
    c == $space || c == $tab || c == $lf || c == $ff || c == $cr;

/// [c] with `A`-`Z` lowercased.
int asciiLower(int c) => c >= $A && c <= $Z ? c + ($a - $A) : c;

/// Lowercases ASCII letters in `s[start..end)`, returning the substring
/// itself when it has none.
String asciiLowerSubstring(String s, int start, int end) {
  for (var i = start; i < end; i++) {
    final c = s.codeUnitAt(i);
    if (asciiLower(c) != c) {
      final buffer = StringBuffer(s.substring(start, i));
      for (var j = i; j < end; j++) {
        buffer.writeCharCode(asciiLower(s.codeUnitAt(j)));
      }
      return buffer.toString();
    }
  }
  return s.substring(start, end);
}
