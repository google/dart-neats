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

// By default `"..."` is case-sensitive and `'...'` is case-insensitive.
// `re2c:case-insensitive = 1;` makes both case-insensitive;
// `re2c:case-inverted = 1;` swaps them so `"..."` is case-insensitive and
// `'...'` is case-sensitive. Using `local:re2c` keeps options scoped to a
// single block.

/// By default, `"..."` is case-sensitive and `'...'` is case-insensitive.
bool isPxUnit(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!local:re2c
    "len:" 'px' $ { return true; }
    $             { return false; }
    *             { return false; }
  */
}

/// With `re2c:case-insensitive = 1;`, `"..."` literals are also
/// case-insensitive.
bool isBool(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!local:re2c
    re2c:case-insensitive = 1;
    ("true" | "false") $ { return true; }
    $                    { return false; }
    *                    { return false; }
  */
}

/// With `re2c:case-inverted = 1;`, `"..."` is case-insensitive and `'...'` is
/// case-sensitive.
bool isInverted(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!local:re2c
    re2c:case-inverted = 1;
    "len:" 'px' $ { return true; }
    $             { return false; }
    *             { return false; }
  */
}

void main() {
  test('default quote case sensitivity', () {
    check(isPxUnit('len:px')).isTrue();
    check(isPxUnit('len:PX')).isTrue();
    check(isPxUnit('LEN:px')).isFalse();
  });

  test('isBool (case-insensitive = 1)', () {
    check(isBool('TRUE')).isTrue();
    check(isBool('False')).isTrue();
    check(isBool('maybe')).isFalse();
  });

  test('isInverted (case-inverted = 1)', () {
    check(isInverted('len:px')).isTrue();
    check(isInverted('LEN:px')).isTrue();
    check(isInverted('len:PX')).isFalse();
  });
}
