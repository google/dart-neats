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

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

// Scanners see UTF-16 code units. The alphabet is 16 bits wide, so negated
// classes and `*` cover every code unit, and literals are code points <= 0xFFFF.

/// 1 for Latin-1 letters (U+0080-U+00FF), 2 for ASCII letters, 3 otherwise.
int classify(String yyinput, int yycursor, int yylimit) {
  /*!re2c
    [\x80-\xFF]+ { return 1; }
    [a-zA-Z]+    { return 2; }
    $            { return 0; }
    *            { return 3; }
  */
}

/// Whether [yyinput] is a single non-ASCII code unit.
bool isNonAscii(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!re2c
    [^\x00-\x7F] $ { return true; }
    $              { return false; }
    *              { return false; }
  */
}

/// Matches a few non-ASCII literals, written directly and as escapes.
int literal(String yyinput, int yycursor, int yylimit) {
  /*!re2c
    "é"      { return 1; }
    "\u20AC" { return 2; }
    "日本"    { return 3; }
    $        { return 0; }
    *        { return -1; }
  */
}

/// The length in code units of the first code point, treating surrogate
/// pairs as two separate code units (the default).
int unitsPerChar(String yyinput, int yycursor, int yylimit) {
  /*!re2c
    [^] { return yycursor; }
    $   { return 0; }
  */
}

void main() {
  test('classify', () {
    check(classify('é', 0, 1)).equals(1);
    check(classify('abc', 0, 3)).equals(2);
    check(classify('€', 0, 1)).equals(3);
    check(classify('😀', 0, 2)).equals(3);
    check(classify('Я', 0, 1)).equals(3);
    check(classify('', 0, 0)).equals(0);
  });

  test('isNonAscii', () {
    check(isNonAscii('é')).isTrue();
    check(isNonAscii('\uFFFF')).isTrue();
    check(isNonAscii('\x7F')).isFalse();
    check(isNonAscii('a')).isFalse();
    check(isNonAscii('😀')).isFalse();
  });

  test('literal', () {
    check(literal('é', 0, 1)).equals(1);
    check(literal('€', 0, 1)).equals(2);
    check(literal('日本語', 0, 3)).equals(3);
    check(literal('e', 0, 1)).equals(-1);
  });

  test('unitsPerChar', () {
    check(unitsPerChar('a', 0, 1)).equals(1);
    check(unitsPerChar('€', 0, 1)).equals(1);
    check(unitsPerChar('😀', 0, 2)).equals(1);
  });
}
