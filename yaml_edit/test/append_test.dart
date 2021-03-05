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
import 'package:yaml_edit/yaml_edit.dart';

import 'test_utils.dart';

void main() {
  group('throws PathError', () {
    test('if it is a map', () {
      final doc = YamlEditor('a:1');
      expect(() => doc.appendToList([], 4), throwsPathError);
    });

    test('if it is a scalar', () {
      final doc = YamlEditor('1');
      expect(() => doc.appendToList([], 4), throwsPathError);
    });
  });

  group('block list', () {
    test('(1)', () {
      final doc = YamlEditor('''
- 0
- 1
- 2
- 3
''');
      doc.appendToList([], 4);
      expect(doc.toString(), equals('''
- 0
- 1
- 2
- 3
- 4
'''));
      expectYamlBuilderValue(doc, [0, 1, 2, 3, 4]);
    });

    test('null path', () {
      final doc = YamlEditor('''
~:
  - 0
  - 1
  - 2
  - 3
''');
      doc.appendToList([null], 4);
      expect(doc.toString(), equals('''
~:
  - 0
  - 1
  - 2
  - 3
  - 4
'''));
      expectYamlBuilderValue(doc, {
        null: [0, 1, 2, 3, 4]
      });
    });

    test('element to simple block list ', () {
      final doc = YamlEditor('''
- 0
- 1
- 2
- 3
''');
      doc.appendToList([], [4, 5, 6]);
      expect(doc.toString(), equals('''
- 0
- 1
- 2
- 3
- - 4
  - 5
  - 6
'''));
      expectYamlBuilderValue(doc, [
        0,
        1,
        2,
        3,
        [4, 5, 6]
      ]);
    });

    test('nested', () {
      final doc = YamlEditor('''
- 0
- - 1
  - 2
''');
      doc.appendToList([1], 3);
      expect(doc.toString(), equals('''
- 0
- - 1
  - 2
  - 3
'''));
      expectYamlBuilderValue(doc, [
        0,
        [1, 2, 3]
      ]);
    });

    test('block list element to nested block list ', () {
      final doc = YamlEditor('''
- 0
- - 1
  - 2
''');
      doc.appendToList([1], [3, 4, 5]);

      expect(doc.toString(), equals('''
- 0
- - 1
  - 2
  - - 3
    - 4
    - 5
'''));
      expectYamlBuilderValue(doc, [
        0,
        [
          1,
          2,
          [3, 4, 5]
        ]
      ]);
    });

    test('nested', () {
      final yamlEditor = YamlEditor('''
a:
  1:
    - null
  2: null
''');
      yamlEditor.appendToList(['a', 1], false);

      expect(yamlEditor.toString(), equals('''
a:
  1:
    - null
    - false
  2: null
'''));
    });
  });

  group('flow list', () {
    test('(1)', () {
      final doc = YamlEditor('[0, 1, 2]');
      doc.appendToList([], 3);
      expect(doc.toString(), equals('[0, 1, 2, 3]'));
      expectYamlBuilderValue(doc, [0, 1, 2, 3]);
    });

    test('null value', () {
      final doc = YamlEditor('[0, 1, 2]');
      doc.appendToList([], null);
      expect(doc.toString(), equals('[0, 1, 2, null]'));
      expectYamlBuilderValue(doc, [0, 1, 2, null]);
    });

    test('empty ', () {
      final doc = YamlEditor('[]');
      doc.appendToList([], 0);
      expect(doc.toString(), equals('[0]'));
      expectYamlBuilderValue(doc, [0]);
    });
  });
}
