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

// Submatch extraction with capture groups:
//  * `re2c:captvars = 1;` binds `(...)` to `yytl<n>`/`yytr<n>` variables.
//  * `re2c:captures = 1;` populates `yynmatch` and `yypmatch` (sized using
//    `maxnmatch:re2c` -> `const yymaxnmatch`).
//  * `(!...)` is a non-capturing group when captures are enabled.
// With captures enabled, re2c warns that `$` matches the empty string, so
// these scanners use a NUL terminator instead.

/*!maxnmatch:re2c*/

typedef Version = ({int major, int minor, int patch});

int _part(String s, int start, int end) =>
    start == -1 ? 0 : int.parse(s.substring(start, end));

/// Parses `major.minor[.patch]` from a NUL-terminated string using `captvars`.
Version? parseVersionVars(String yyinput) {
  var yycursor = 0;
  var yymarker = 0;
  /*!svars:re2c:vars format = "var @@ = -1;\n"; */
  /*!stags:re2c:vars format = "var @@ = -1;\n"; */
  /*!local:re2c:vars
    re2c:captvars = 1;
    re2c:eof = -1;
    re2c:YYPEEK = "yyinput.codeUnitAt(yycursor)";

    num = [0-9]+;

    (num) "." (num) (!"." (num))? "\x00" {
      return (
        major: _part(yyinput, yytl1, yytr1),
        minor: _part(yyinput, yytl2, yytr2),
        patch: _part(yyinput, yytl3, yytr3),
      );
    }
    * { return null; }
  */
}

/// Parses `major.minor[.patch]` from a NUL-terminated string using `captures`
/// (`yynmatch` and `yypmatch`) and a non-capturing group `(!...)`.
Version? parseVersionArray(String yyinput) {
  var yycursor = 0;
  var yymarker = 0;
  var yynmatch = 0;
  final yypmatch = List.filled(yymaxnmatch * 2, -1);
  /*!stags:re2c:arr format = "var @@ = -1;\n"; */
  /*!local:re2c:arr
    re2c:captures = 1;
    re2c:eof = -1;
    re2c:YYPEEK = "yyinput.codeUnitAt(yycursor)";

    num = [0-9]+;

    (num) "." (num) (!"." (num))? "\x00" {
      return (
        major: _part(yyinput, yypmatch[2], yypmatch[3]),
        minor: _part(yyinput, yypmatch[4], yypmatch[5]),
        patch: _part(yyinput, yypmatch[6], yypmatch[7]),
      );
    }
    * { return null; }
  */
}

void main() {
  test('yymaxnmatch constant', () {
    check(yymaxnmatch).equals(4);
  });

  test('parseVersionVars (captvars = 1)', () {
    const v1 = (major: 23, minor: 34, patch: 0);
    const v2 = (major: 1, minor: 2, patch: 99999);
    check(parseVersionVars('23.34\x00')).equals(v1);
    check(parseVersionVars('1.2.99999\x00')).equals(v2);
    check(parseVersionVars('1.a\x00')).isNull();
  });

  test('parseVersionArray (captures = 1 + yypmatch)', () {
    const v1 = (major: 23, minor: 34, patch: 0);
    const v2 = (major: 1, minor: 2, patch: 99999);
    check(parseVersionArray('23.34\x00')).equals(v1);
    check(parseVersionArray('1.2.99999\x00')).equals(v2);
    check(parseVersionArray('1.a\x00')).isNull();
  });
}
