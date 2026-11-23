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

// Incremental / streaming scanning with `re2c:yyfill:enable = 1;`:
//  * With the default `re2c:eof = 0;`, the generated scanner emits `if (yyfill())`
//    (`re2c:YYFILL = "yyfill()";`) whenever `yycursor` reaches `yylimit`; `yyfill()`
//    appends the next chunk and returns `true`, or returns `false` at end of stream
//    so the `$` rule matches.
//  * With `re2c:eof = -1;`, re2c substitutes `@@{len}` and emits `YYFILL` as a
//    statement (`re2c:YYFILL = "yyfill(@@{len});";`), and `max:re2c` emits
//    `const yymaxfill` (maximum lookahead needed by a fill).

/*!max:re2c*/

/// Counts words across a stream of string [chunks] using `re2c:eof = 0;` and
/// `bool yyfill()`, even when words are split across chunk boundaries.
int countWordsChunked(Iterable<String> chunks) {
  final iterator = chunks.iterator;
  var yyinput = '';
  var yycursor = 0;
  var yylimit = 0;
  var token = 0;
  var eof = false;

  bool yyfill() {
    if (eof) return false;
    yyinput = yyinput.substring(token);
    yycursor -= token;
    yylimit -= token;
    token = 0;
    while (iterator.moveNext()) {
      if (iterator.current.isNotEmpty) {
        yyinput += iterator.current;
        yylimit = yyinput.length;
        return true;
      }
    }
    eof = true;
    return false;
  }

  var count = 0;
  loop:
  while (true) {
    token = yycursor;
    /*!local:re2c
      re2c:yyfill:enable = 1;

      [a-zA-Z]+ { count++; continue loop; }
      [ \t\n]+  { continue loop; }
      $         { return count; }
      *         { return -1; }
    */
  }
}

/// Scans a 3-character `"abc"` token with `re2c:eof = -1;` and
/// `re2c:YYFILL = "yyfill(@@{len});";`, recording the requested fill length.
(bool, int) scanWithParameterizedFill(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  var requested = 0;
  void yyfill(int len) {
    requested = len;
  }

  /*!local:re2c
    re2c:eof = -1;
    re2c:yyfill:enable = 1;
    re2c:YYFILL = "yyfill(@@{len});";

    "abc" { return (true, requested); }
    *     { return (false, requested); }
  */
}

void main() {
  test('yymaxfill constant reflects maximum lookahead across blocks', () {
    check(yymaxfill).equals(3);
  });

  test('countWordsChunked (eof = 0, bool yyfill())', () {
    check(countWordsChunked([])).equals(0);
    check(countWordsChunked(['hel', 'lo ', '', 'wor', 'ld'])).equals(2);
    check(countWordsChunked(['one two', ' 123'])).equals(-1);
  });

  test('scanWithParameterizedFill (eof = -1, yyfill(@@{len}))', () {
    check(scanWithParameterizedFill('abc')).equals((true, 0));
    check(scanWithParameterizedFill('ab')).equals((false, 3));
  });
}
