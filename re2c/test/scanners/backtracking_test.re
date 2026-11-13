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

// When a longer rule fails after passing through multiple shorter accepting
// rules, re2c records the last accepting rule in `yyaccept` and the fallback
// cursor position in `yymarker`.

typedef NumberToken = ({String kind, int end});

/// Scans an integer, decimal, float, or float32 literal at the start of
/// [yyinput].
NumberToken? scanNumber(String yyinput) {
  var yycursor = 0;
  final yylimit = yyinput.length;
  var yymarker = 0;
  /*!re2c
    digit = [0-9];
    exp   = [eE] [+-]? digit+;

    digit+                        { return (kind: 'int', end: yycursor); }
    digit+ "." digit+             { return (kind: 'decimal', end: yycursor); }
    digit+ ("." digit+)? exp      { return (kind: 'exp', end: yycursor); }
    digit+ ("." digit+)? exp "f32" { return (kind: 'f32', end: yycursor); }
    $                             { return null; }
    *                             { return null; }
  */
}

void main() {
  test('scanNumber backtracks to the longest valid prefix', () {
    check(scanNumber('42')).equals((kind: 'int', end: 2));
    // Trailing dot fails `digit+ "." digit+`, falls back to `digit+` (yyaccept = 0).
    check(scanNumber('42.')).equals((kind: 'int', end: 2));
    check(scanNumber('42.5')).equals((kind: 'decimal', end: 4));
    // Incomplete exponent fails `exp`, falls back to `decimal` (yyaccept = 1).
    check(scanNumber('42.5e+')).equals((kind: 'decimal', end: 4));
    check(scanNumber('42.5e+2')).equals((kind: 'exp', end: 7));
    // Incomplete `f32` suffix falls back to `exp` (yyaccept = 2).
    check(scanNumber('42.5e+2f3')).equals((kind: 'exp', end: 7));
    check(scanNumber('42.5e+2f32')).equals((kind: 'f32', end: 10));
    check(scanNumber('abc')).isNull();
    check(scanNumber('')).isNull();
  });
}
