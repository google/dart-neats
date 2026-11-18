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

// Regular expression operators: character class difference (`\`), bounded
// repetition (`{n}`, `{n,m}`), `.` (any code unit except `\n`) vs `[^]`
// (any code unit including `\n`), and escape sequences.

/// Whether [yyinput] is a run of lowercase ASCII consonants (`[a-z] \ [aeiou]`).
bool isConsonants(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!local:re2c
    vowel     = [aeiou];
    consonant = [a-z] \ vowel;

    consonant+ $ { return true; }
    $            { return false; }
    *            { return false; }
  */
}

/// Whether [yyinput] is a `#rrggbb` or `#rgb` hex color using bounded
/// repetitions (`{3}` and `{6}`).
bool isHexColor(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!local:re2c
    hex = [0-9a-fA-F];

    "#" (hex{6} | hex{3}) $ { return true; }
    $                       { return false; }
    *                       { return false; }
  */
}

/// `.` matches any code unit except `\n`; `[^]` matches any code unit
/// including `\n`.
({int dot, int any}) lineVsAny(String yyinput) {
  int scanDot() {
    var yycursor = 0;
    final yylimit = yyinput.length;
    /*!local:re2c
      .+ { return yycursor; }
      $  { return 0; }
      *  { return 0; }
    */
  }

  int scanAny() {
    var yycursor = 0;
    final yylimit = yyinput.length;
    /*!local:re2c
      [^]+ { return yycursor; }
      $    { return 0; }
    */
  }

  return (dot: scanDot(), any: scanAny());
}

void main() {
  test('isConsonants (character class difference)', () {
    check(isConsonants('rhythm')).isTrue();
    check(isConsonants('hello')).isFalse();
    check(isConsonants('123')).isFalse();
  });

  test('isHexColor (bounded repetition)', () {
    check(isHexColor('#fff')).isTrue();
    check(isHexColor('#1a2B3c')).isTrue();
    check(isHexColor('#1234')).isFalse();
    check(isHexColor('#1234567')).isFalse();
  });

  test('lineVsAny (. vs [^])', () {
    check(lineVsAny('ab\ncd')).equals((dot: 2, any: 5));
    check(lineVsAny('\ncd')).equals((dot: 0, any: 3));
  });
}
