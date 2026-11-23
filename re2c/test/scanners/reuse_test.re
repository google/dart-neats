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

import 'dart:convert';
import 'dart:typed_data';

import 'package:checks/checks.dart';
import 'package:test/scaffolding.dart';

// Reusable rule blocks (`rules:re2c:name`) can be instantiated with
// `use:re2c:name` (for example, to generate both a UTF-16 `String`
// scanner and a UTF-8 `Uint8List` scanner from the same rules) or merged into
// a `re2c` block with `!use:name;`.

/*!rules:re2c:math
  "∀x ∃y" { return yycursor; }
  $       { return -1; }
  *       { return -1; }
*/

/// Scans [yyinput] as a Dart `String` (UTF-16 code units).
int scanUtf16(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!use:re2c:math*/
}

/// Scans [yyinput] as UTF-8 bytes using the same `math` rules block.
int scanUtf8(Uint8List yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!use:re2c:math
    re2c:encoding:utf8 = 1;
    re2c:YYPEEK = "yycursor < yylimit ? yyinput[yycursor] : 0";
  */
}

/*!rules:re2c:keywords
  "if" | "else" | "while" { return 'keyword'; }
*/

/*!rules:re2c:identifiers
  [a-z]+ { return 'ident'; }
*/

/// Combines `keywords` and `identifiers` with `!use:`, giving `keywords`
/// priority because it is listed first.
String classifyWord(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!local:re2c
    !use:keywords;
    !use:identifiers;
    $ { return 'empty'; }
    * { return 'other'; }
  */
}

void main() {
  test('reuse rules across UTF-16 String and UTF-8 Uint8List', () {
    const text = '∀x ∃y!';
    check(scanUtf16(text)).equals(5);
    check(scanUtf8(utf8.encode(text))).equals(9);
    check(scanUtf16('other')).equals(-1);
  });

  test('combine rule blocks with !use:', () {
    check(classifyWord('while')).equals('keyword');
    check(classifyWord('whiles')).equals('ident');
    check(classifyWord('')).equals('empty');
    check(classifyWord('123')).equals('other');
  });
}
