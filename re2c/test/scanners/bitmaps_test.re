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

// With `re2c:bit-vectors = 1;` (and `re2c:eof = -1;`), re2c emits a 256-entry
// `const yybm = <int>[...]` lookup table for character classes and guards it
// with `(yych & ~0xFF) != 0` for 16-bit code units above U+00FF.

/// Returns the length of an ASCII identifier or integer at the start of a
/// NUL-terminated [yyinput], or -1.
int scanAsciiToken(String yyinput) {
  var yycursor = 0;
  /*!local:re2c
    re2c:eof = -1;
    re2c:YYPEEK = "yyinput.codeUnitAt(yycursor)";
    re2c:bit-vectors = 1;

    [a-zA-Z_][a-zA-Z0-9_]* { return yycursor; }
    [0-9]+                 { return yycursor; }
    "\x00"                 { return 0; }
    *                      { return -1; }
  */
}

void main() {
  test('scanAsciiToken with yybm bitmap table', () {
    check(scanAsciiToken('foo_123\x00')).equals(7);
    check(scanAsciiToken('42\x00')).equals(2);
    // Code units > 0xFF (such as `€` U+20AC) must be filtered by `(yych & ~0xFF) != 0`
    // without indexing `yybm` out of range.
    check(scanAsciiToken('foo€\x00')).equals(3);
    check(scanAsciiToken('€\x00')).equals(-1);
    check(scanAsciiToken('\x00')).equals(0);
  });
}
