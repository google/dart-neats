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

// With `re2c:encoding:utf8 = 1;`, patterns are compiled into a UTF-8 byte
// automaton over 8-bit code units (such as a `Uint8List`), and re2c emits
// `switch (yych)` with Dart 3 relational case ranges (`case >= 0xC2 && <= 0xDF:`).

/// Counts Unicode scalar values in UTF-8 [yyinput], or returns -1 on invalid
/// UTF-8.
int countUtf8Runes(Uint8List yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  var count = 0;
  loop:
  while (true) {
    /*!local:re2c
      re2c:encoding:utf8 = 1;
      re2c:YYPEEK = "yycursor < yylimit ? yyinput[yycursor] : 0";

      [^] { count++; continue loop; }
      $   { return count; }
      *   { return -1; }
    */
  }
}

void main() {
  test('countUtf8Runes', () {
    check(countUtf8Runes(utf8.encode(''))).equals(0);
    check(countUtf8Runes(utf8.encode('hello'))).equals(5);
    check(countUtf8Runes(utf8.encode('é € 😀'))).equals(5);
    // Invalid standalone continuation byte (0x80) and truncated 2-byte sequence (0xC2).
    check(countUtf8Runes(Uint8List.fromList([0x80]))).equals(-1);
    check(countUtf8Runes(Uint8List.fromList([0xC2]))).equals(-1);
  });
}
