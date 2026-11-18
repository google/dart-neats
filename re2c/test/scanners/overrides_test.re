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

// Exercises overriding the defaults of dart.syntax: custom variable names,
// NUL as an end-of-input sentinel usable in trailing contexts (instead of
// the `$` rule), and submatch extraction with tags.

/*!re2c
  re2c:eof = -1;
  re2c:tags = 1;
  re2c:YYPEEK = "p < end ? s.codeUnitAt(p) : 0";
  re2c:YYSKIP = "p++;";
  re2c:YYBACKUP = "m = p;";
  re2c:YYRESTORE = "p = m;";
  re2c:YYSHIFT = "p += @@{shift};";
  re2c:YYSTAGP = "@@{tag} = p;";
  re2c:YYSTAGN = "@@{tag} = -1;";
  re2c:YYSHIFTSTAG = "@@{tag} += @@{shift};";
  re2c:YYRESTORETAG = "p = @@{tag};";

  eof   = "\x00";
  space = [ \t];
  name  = [a-zA-Z][a-zA-Z0-9-]*;
*/

/// The length of an ATX heading opener (`#` to `######`) at [start], or 0.
int scanAtxHeading(String s, int start, int end) {
  var p = start, m = start;
  /*!re2c
    [#]{1,6} / (space | "\n" | eof) { return p - start; }
    *                               { return 0; }
  */
}

/// The `key = value` pair at [start], or `null`.
///
/// The value is everything up to the end of the line.
({String key, String value})? scanAssignment(String s, int start, int end) {
  var p = start, m = start;
  var k1 = -1, k2 = -1, v1 = -1, v2 = -1;
  /*!stags:re2c format = "var @@ = -1;\n"; */
  /*!re2c
    space* @k1 name @k2 space* "=" space* @v1 [^\n\x00]* @v2 {
      return (key: s.substring(k1, k2), value: s.substring(v1, v2));
    }
    * { return null; }
  */
}

void main() {
  test('scanAtxHeading', () {
    check(scanAtxHeading('### Title', 0, 9)).equals(3);
    check(scanAtxHeading('###', 0, 3)).equals(3);
    check(scanAtxHeading('###\n', 0, 4)).equals(3);
    check(scanAtxHeading('####### x', 0, 9)).equals(0);
    check(scanAtxHeading('#x', 0, 2)).equals(0);
  });

  test('scanAssignment', () {
    check(
      scanAssignment('  key-1 = some value\nrest', 0, 25),
    ).equals((key: 'key-1', value: 'some value'));
    check(scanAssignment('key', 0, 3)).isNull();
  });
}
