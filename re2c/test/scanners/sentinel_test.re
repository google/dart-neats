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

// The classic re2c style: no bounds checks, the input is terminated by a
// sentinel character that no rule consumes. Faster, but the caller must
// guarantee the sentinel and the sentinel cannot appear in the input.

/*!re2c
  re2c:eof = -1;
  re2c:YYPEEK = "yyinput.codeUnitAt(yycursor)";
*/

/// Counts words in a NUL-terminated string.
int countWords(String yyinput) {
  var yycursor = 0;
  var count = 0;
  loop:
  while (true) {
    /*!re2c
      [a-zA-Z]+ { count++; continue loop; }
      [ \t\n]+  { continue loop; }
      "\x00"    { return count; }
      *         { return -1; }
    */
  }
}

void main() {
  test('countWords', () {
    check(countWords('\x00')).equals(0);
    check(countWords('hello big world\n\x00')).equals(3);
    check(countWords('hello 42\x00')).equals(-1);
  });
}
