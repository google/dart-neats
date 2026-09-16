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

import 'package:checks_ext/src/core/match.dart';
import '../util.dart';

void main() {
  group('MatchChecks', () {
    final regExp = RegExp(r'(\w+) (\d+)');
    const input = 'hello 42';
    final match = regExp.firstMatch(input)!;

    test('properties extract correct values', () {
      check(match)
        ..start.equals(0)
        ..end.equals(8)
        ..groupCount.equals(2)
        ..input.equals(input);
    });

    test('group extracts correct group', () {
      check(match)
        ..group(0).equals('hello 42')
        ..group(1).equals('hello')
        ..group(2).equals('42');
    });

    test('operator [] works like group', () {
      check(match)
        ..[0].equals('hello 42')
        ..[1].equals('hello')
        ..[2].equals('42');
    });
  });
}
