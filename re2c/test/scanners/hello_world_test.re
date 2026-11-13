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

/// Whether [yyinput] starts with a decimal number without leading zeros.
bool isNumber(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!re2c
    [1-9][0-9]* $ { return true; }
    $             { return false; }
    *             { return false; }
  */
}

void main() {
  test('isNumber', () {
    check(isNumber('1234')).isTrue();
    check(isNumber('1')).isTrue();
    check(isNumber('0123')).isFalse();
    check(isNumber('12a')).isFalse();
    check(isNumber('')).isFalse();
  });
}
