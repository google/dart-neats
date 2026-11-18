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

// Submatch extraction with s-tags (`@name`), ported from the re2c examples.
// Naming blocks (`re2c:name`, `svars:re2c:name`, `stags:re2c:name`) scopes tag
// variable declarations to each function.

typedef Version = ({int major, int minor, int patch});

/// Parses `major.minor[.patch]`, or returns `null`.
Version? parseVersion(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!svars:re2c:ver format = "var @@ = -1;\n"; */
  /*!stags:re2c:ver format = "var @@ = -1;\n"; */
  /*!local:re2c:ver
    re2c:tags = 1;

    num = [0-9]+;

    @t1 num @t2 "." @t3 num @t4 ("." @t5 num)? $ {
      return (
        major: int.parse(yyinput.substring(t1, t2)),
        minor: int.parse(yyinput.substring(t3, t4)),
        patch: t5 == -1 ? 0 : int.parse(yyinput.substring(t5, yycursor)),
      );
    }
    $ { return null; }
    * { return null; }
  */
}

/// Parses an optional fixed-length prefix `(@a [a-z] @b ":")?` before `[0-9]+`,
/// exercising nested fixed-offset tag shifting (`code:yyshiftstag` with `.nested`).
(int, int)? parseOptionalPrefix(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!svars:re2c:pfx format = "var @@ = -1;\n"; */
  /*!stags:re2c:pfx format = "var @@ = -1;\n"; */
  /*!local:re2c:pfx
    re2c:tags = 1;

    (@a [a-z] @b ":")? [0-9]+ $ { return (a, b); }
    $                           { return null; }
    *                           { return null; }
  */
}

void main() {
  test('parseVersion', () {
    check(parseVersion('23.34')).equals((major: 23, minor: 34, patch: 0));
    check(parseVersion('1.2.99999')).equals((major: 1, minor: 2, patch: 99999));
    check(parseVersion('1.a')).isNull();
    check(parseVersion('1.2.')).isNull();
  });

  test('parseOptionalPrefix (nested yyshiftstag)', () {
    check(parseOptionalPrefix('x:42')).equals((0, 1));
    check(parseOptionalPrefix('42')).equals((-1, -1));
    check(parseOptionalPrefix('xy:42')).isNull();
  });
}
