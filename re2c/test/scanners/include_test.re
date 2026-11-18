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

// Definitions can be shared between files with an include directive,
// resolved relative to the including file.

/*!include:re2c "include_definitions.re.inc" */

/// 1 for an identifier, 2 for a number, 0 otherwise.
int classify(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!re2c
    identifier $ { return 1; }
    number $     { return 2; }
    $            { return 0; }
    *            { return 0; }
  */
}

void main() {
  test('classify', () {
    check(classify('foo_1')).equals(1);
    check(classify('42')).equals(2);
    check(classify('4x')).equals(0);
  });
}
