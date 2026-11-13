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

// Codegen configuration overrides in `dart.syntax`:
//  * `re2c:debug-output = 1;`: calls user-defined `yydebug(int state, int yych)`.
//  * `re2c:label:yyloop = "yyl";`: labels the generated state loop (`yyl: while (true)`
//    and `continue yyl;`).
//  * `re2c:case-ranges = 0;`: emits stacked `case 0x30: case 0x31: ...` labels
//    instead of Dart 3 relational `case >= 0x30 && <= 0x39:` patterns.

/// Scans digits while recording `(state, yych)` transitions via `yydebug`
/// and using a labelled inner state loop (`yyl`).
int scanWithDebugAndLabel(String yyinput, List<(int, int)> trace) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  void yydebug(int state, int yych) => trace.add((state, yych));
  /*!local:re2c
    re2c:debug-output = 1;
    re2c:label:yyloop = "yyl";

    [0-9]+ { return yycursor; }
    $      { return 0; }
    *      { return -1; }
  */
}

/// Scans a hex/octal run using a `switch` without relational case ranges.
int scanOctalWithoutCaseRanges(String yyinput) {
  var yycursor = 0;
  /*!local:re2c
    re2c:encoding:ucs2 = 0;
    re2c:nested-ifs = 0;
    re2c:case-ranges = 0;
    re2c:eof = -1;
    re2c:YYPEEK = "yyinput.codeUnitAt(yycursor)";

    [0-3a-cA-C]+ { return yycursor; }
    "\x00"       { return 0; }
    *            { return -1; }
  */
}

void main() {
  test('scanWithDebugAndLabel', () {
    final trace = <(int, int)>[];
    check(scanWithDebugAndLabel('42a', trace)).equals(2);
    check(trace).isNotEmpty();
  });

  test('scanOctalWithoutCaseRanges', () {
    check(scanOctalWithoutCaseRanges('0123\x00')).equals(4);
    check(scanOctalWithoutCaseRanges('aBc\x00')).equals(3);
    check(scanOctalWithoutCaseRanges('8\x00')).equals(-1);
  });
}
