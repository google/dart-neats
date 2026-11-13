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

// Submatch extraction with m-tags (`#name`), which record every position a tag
// passes through in a repetition. Returning a new list `[...tag, ...]` from
// `yymtagp` and `yymtagn` keeps tag histories immutable when the DFA copies
// tag registers (`yytm2 = yytm1;`) and backtracks.

/// Appends [position] to [tag].
List<int> yymtagp(List<int> tag, int position) => [...tag, position];

/// Records `-1` when an optional m-tag branch is not taken.
List<int> yymtagn(List<int> tag) => [...tag, -1];

/// Parses a dotted list of numbers, or returns `null`.
List<int>? parseVersion(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!svars:re2c:ver format = "var @@ = -1;\n"; */
  /*!mvars:re2c:ver format = "var @@ = const <int>[];\n"; */
  /*!stags:re2c:ver format = "var @@ = -1;\n"; */
  /*!mtags:re2c:ver format = "var @@ = const <int>[];\n"; */
  /*!local:re2c:ver
    re2c:tags = 1;

    num = [0-9]+;

    @t1 num @t2 ("." #t3 num #t4)* $ {
      return [
        int.parse(yyinput.substring(t1, t2)),
        for (var i = 0; i < t3.length; i++)
          if (t3[i] != -1) int.parse(yyinput.substring(t3[i], t4[i])),
      ];
    }
    $ { return null; }
    * { return null; }
  */
}

/// Parses semicolon-terminated `[key=]value;` items at the start of [yyinput],
/// exercising optional m-tags (`yymtagn`) and backtracking (`code:yycopymtag`).
List<(String?, String)>? parseItems(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!mvars:re2c:items format = "var @@ = const <int>[];\n"; */
  /*!mtags:re2c:items format = "var @@ = const <int>[];\n"; */
  /*!local:re2c:items
    re2c:tags = 1;

    ((#k1 [a-z]+ #k2 "=")? #v1 [0-9]+ #v2 ";")+ {
      return [
        for (var i = 0; i < v1.length; i++)
          (
            k1[i] == -1 ? null : yyinput.substring(k1[i], k2[i]),
            yyinput.substring(v1[i], v2[i]),
          ),
      ];
    }
    $ { return null; }
    * { return null; }
  */
}

void main() {
  test('parseVersion', () {
    check(parseVersion('1')).isNotNull().deepEquals([1]);
    check(
      parseVersion('1.2.3.4.5.6.7'),
    ).isNotNull().deepEquals([1, 2, 3, 4, 5, 6, 7]);
    check(parseVersion('1.2.')).isNull();
  });

  test('parseItems (optional m-tags and backtracking)', () {
    // Trailing `c=4` without `;` forces the DFA to backtrack after recording `k1`/`k2`.
    check(
      parseItems('a=1;2;b=3;c=4'),
    ).isNotNull().deepEquals([('a', '1'), (null, '2'), ('b', '3')]);
    check(parseItems('invalid')).isNull();
  });
}
