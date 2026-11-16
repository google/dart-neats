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
import 'package:example/src/indent.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('strips the shared indentation', () {
    check(stripIndentation('''
  final x = 1;
  if (x == 1) {
    print(x);
  }
''')).equals('''
final x = 1;
if (x == 1) {
  print(x);
}
''');
  });

  test('blank and whitespace-only lines do not defeat dedenting', () {
    check(stripIndentation('  a;\n\n    \n  b;\n')).equals('a;\n\n\nb;\n');
  });

  test('mixed tabs and spaces only lose what they share', () {
    check(stripIndentation('\t a;\n\t b;\n')).equals('a;\nb;\n');
    check(stripIndentation('\ta;\n  b;\n')).equals('\ta;\n  b;\n');
  });

  test('leaves unindented and empty strings alone', () {
    check(stripIndentation('')).equals('');
    check(stripIndentation('a;\nb;\n')).equals('a;\nb;\n');
  });
}
