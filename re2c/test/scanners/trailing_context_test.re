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

// Trailing contexts (`a / b`): `b` must follow `a`, but is not consumed.
// re2c restores `yycursor` to the end of `a` in three ways:
//  * Fixed-length `b`: shifts `yycursor` back (`YYSHIFT`, `yycursor += -n;`).
//  * Variable-length `b`: saves and restores `yyctxmarker` (`YYBACKUPCTX` /
//    `YYRESTORECTX`).
//  * Variable-length `b` with `re2c:tags = 1;`: restores `yycursor` from an
//    s-tag (`YYRESTORETAG`, `yycursor = yyt1;`).

/// Scans digits followed by `"px"` using a fixed-length trailing context
/// (`YYSHIFT`, no `yyctxmarker` needed).
int pixelsValueEnd(String yyinput, int yycursor, int yylimit) {
  var yymarker = yycursor;
  /*!local:re2c
    [0-9]+ / "px" { return yycursor; }
    $             { return -1; }
    *             { return -1; }
  */
}

/// The number of `#` characters at [yycursor] if they are followed by a
/// space, a newline or the end of input, otherwise 0 (`yyctxmarker`).
int atxOpener(String yyinput, int yycursor, int yylimit) {
  final start = yycursor;
  var yymarker = yycursor;
  var yyctxmarker = yycursor;
  /*!local:re2c
    [#]{1,6} / ([ \n] | $) { return yycursor - start; }
    $                       { return 0; }
    *                       { return 0; }
  */
}

/// Extracts a trimmed key before `[ ]* "="` while combining `re2c:tags = 1;`
/// with a variable-length trailing context (`YYRESTORETAG`).
String? taggedKeyBeforeEquals(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!svars:re2c:key format = "var @@ = -1;\n"; */
  /*!stags:re2c:key format = "var @@ = -1;\n"; */
  /*!local:re2c:key
    re2c:tags = 1;

    [ ]* @k [a-z]+ / [ ]* "=" { return yyinput.substring(k, yycursor); }
    $                         { return null; }
    *                         { return null; }
  */
}

void main() {
  test('pixelsValueEnd (fixed trailing context / YYSHIFT)', () {
    check(pixelsValueEnd('120px', 0, 5)).equals(3);
    check(pixelsValueEnd('120em', 0, 5)).equals(-1);
  });

  test('atxOpener (variable trailing context / yyctxmarker)', () {
    check(atxOpener('## Title', 0, 8)).equals(2);
    check(atxOpener('######', 0, 6)).equals(6);
    check(atxOpener('#######', 0, 7)).equals(0);
    check(atxOpener('#x', 0, 2)).equals(0);
  });

  test('taggedKeyBeforeEquals (tags + trailing context / YYRESTORETAG)', () {
    check(taggedKeyBeforeEquals('  key   = 1')).equals('key');
    check(taggedKeyBeforeEquals('key=1')).equals('key');
    check(taggedKeyBeforeEquals('  key  1')).isNull();
  });
}
