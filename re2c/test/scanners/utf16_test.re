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

// With `re2c:encoding:utf16 = 1;` rules are written in code points and
// surrogate pairs are decoded by the scanner, so `[^]` consumes a whole
// astral character and literals above U+FFFF (like `"😀"`) are allowed.

/*!re2c
  re2c:encoding:utf16 = 1;
*/

/// The length in code units of the first code point.
int unitsPerChar(String yyinput, int yycursor, int yylimit) {
  /*!re2c
    [^] { return yycursor; }
    $   { return 0; }
  */
}

/// 1 for `"😀"`, 2 for another emoticon (U+1F600-U+1F64F), 3 for any other
/// astral character.
int astral(String yyinput, int yycursor, int yylimit) {
  /*!re2c
    "😀"                     { return 1; }
    [\U0001F600-\U0001F64F] { return 2; }
    [\U00010000-\U0010FFFF] { return 3; }
    $                        { return 0; }
    *                        { return -1; }
  */
}

void main() {
  test('unitsPerChar', () {
    check(unitsPerChar('a', 0, 1)).equals(1);
    check(unitsPerChar('😀', 0, 2)).equals(2);
  });

  test('astral', () {
    check(astral('😀', 0, 2)).equals(1);
    check(astral('🙏', 0, 2)).equals(2);
    check(astral('𝄞', 0, 2)).equals(3);
    check(astral('a', 0, 1)).equals(-1);
    check(astral('', 0, 0)).equals(0);
  });
}
