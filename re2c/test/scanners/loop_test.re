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

// The idiomatic shape for a scanner that consumes a whole input: a labelled
// loop around the re2c block, and actions that `continue` it.

/// Counts single-quoted strings separated by spaces, or -1 on a syntax error.
int countStrings(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  var count = 0;
  loop:
  while (true) {
    /*!re2c
      str = ['] ([^'\\] | [\\][^])* ['];

      *    { return -1; }
      $    { return count; }
      [ ]+ { continue loop; }
      str  { count++; continue loop; }
    */
  }
}

void main() {
  test('countStrings', () {
    check(countStrings('')).equals(0);
    check(countStrings("'qu\x00tes' 'are' 'fine: \\'' ")).equals(3);
    check(countStrings("'unterminated\\'")).equals(-1);
    check(countStrings("'日本語' 'ok'")).equals(2);
  });
}
