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

// Exercises the defaults of dart.syntax: a `String` input scanned by code
// unit, the `$` end-of-input rule, NUL as an ordinary character and
// backtracking with `yymarker`.

/// Returns the end of the run of ASCII digits starting at [yycursor], or -1.
int scanDigits(String yyinput, int yycursor, int yylimit) {
  /*!re2c
    [0-9]+ { return yycursor; }
    $      { return -1; }
    *      { return -1; }
  */
}

/// Classifies the token starting at [yycursor].
///
///  * 0: end of input
///  * 1: HTML comment opener
///  * 2: any other `<`
///  * 3: NUL character
///  * 4: run of anything else
int classify(String yyinput, int yycursor, int yylimit) {
  var yymarker = yycursor;
  /*!re2c
    "<!--"      { return 1; }
    "<"         { return 2; }
    "\x00"      { return 3; }
    [^\x00<]+   { return 4; }
    $           { return 0; }
    *           { return -1; }
  */
}

void main() {
  test('scanDigits', () {
    check(scanDigits('123abc', 0, 6)).equals(3);
    check(scanDigits('123abc', 3, 6)).equals(-1);
    check(scanDigits('123', 3, 3)).equals(-1);
    check(scanDigits('1234', 0, 2)).equals(2);
  });

  test('classify', () {
    check(classify('', 0, 0)).equals(0);
    check(classify('<!-- x', 0, 6)).equals(1);
    check(classify('<!-', 0, 3)).equals(2);
    check(classify('\x00', 0, 1)).equals(3);
    check(classify('abc\x00<', 0, 5)).equals(4);
    check(classify('abc\x00<', 3, 5)).equals(3);
    check(classify('é€😀<', 0, 5)).equals(4);
  });
}
