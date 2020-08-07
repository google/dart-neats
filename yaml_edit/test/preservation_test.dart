// Copyright 2020 Google LLC
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

import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('preserves original yaml: ', () {
    test('number', expectLoadPreservesYAML('2'));
    test('number with leading and trailing lines', expectLoadPreservesYAML('''
      
      2
      
      '''));
    test('octal numbers', expectLoadPreservesYAML('0o14'));
    test('negative numbers', expectLoadPreservesYAML('-345'));
    test('hexadecimal numbers', expectLoadPreservesYAML('0x123abc'));
    test('floating point numbers', expectLoadPreservesYAML('345.678'));
    test('exponential numbers', expectLoadPreservesYAML('12.3015e+02'));
    test('string', expectLoadPreservesYAML('a string'));
    test('string with control characters',
        expectLoadPreservesYAML('a string \\n'));
    test('string with control characters',
        expectLoadPreservesYAML('a string \n\r'));
    test('string with hex escapes',
        expectLoadPreservesYAML('\\x0d\\x0a is \\r\\n'));
    test('flow map', expectLoadPreservesYAML('{a: 2}'));
    test('flow list', expectLoadPreservesYAML('[1, 2]'));
    test('flow list with different types of elements',
        expectLoadPreservesYAML('[1, a]'));
    test('flow list with weird spaces',
        expectLoadPreservesYAML('[ 1 ,      2]'));
    test('multiline string', expectLoadPreservesYAML('''
      Mark set a major league
      home run record in 1998.'''));
    test('tilde', expectLoadPreservesYAML('~'));
    test('false', expectLoadPreservesYAML('false'));

    test('block map', expectLoadPreservesYAML('''a: 
    b: 1
    '''));
    test('block list', expectLoadPreservesYAML('''a: 
    - 1
    '''));
    test('complicated example', () {
      expectLoadPreservesYAML('''verb: RecommendCafes
map:
  a: 
    b: 1
recipe:
  - verb: Score
    outputs: ["DishOffering[]/Scored", "Suggestions"]
    name: Hotpot
  - verb: Rate
    inputs: Dish
    ''');
    });
  });
}
