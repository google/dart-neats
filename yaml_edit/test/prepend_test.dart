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
import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

import 'test_utils.dart';

void main() {
  group('throws PathError', () {
    test('if it is a map', () {
      final doc = YamlEditor('a:1');
      expect(() => doc.prependToList([], 4), throwsPathError);
    });

    test('if it is a scalar', () {
      final doc = YamlEditor('1');
      expect(() => doc.prependToList([], 4), throwsPathError);
    });
  });

  group('flow list', () {
    test('(1)', () {
      final doc = YamlEditor('[1, 2]');
      doc.prependToList([], 0);
      expect(doc.toString(), equals('[0, 1, 2]'));
      expectYamlBuilderValue(doc, [0, 1, 2]);
    });

    test('null value', () {
      final doc = YamlEditor('[1, 2]');
      doc.prependToList([], null);
      expect(doc.toString(), equals('[null, 1, 2]'));
      expectYamlBuilderValue(doc, [null, 1, 2]);
    });

    test('with spaces (1)', () {
      final doc = YamlEditor('[ 1 , 2 ]');
      doc.prependToList([], 0);
      expect(doc.toString(), equals('[ 0, 1 , 2 ]'));
      expectYamlBuilderValue(doc, [0, 1, 2]);
    });
  });

  group('block list', () {
    test('(1)', () {
      final doc = YamlEditor('''
- 1
- 2''');
      doc.prependToList([], 0);
      expect(doc.toString(), equals('''
- 0
- 1
- 2'''));
      expectYamlBuilderValue(doc, [0, 1, 2]);
    });

    /// Regression testing for no trailing spaces.
    test('(2)', () {
      final doc = YamlEditor('''- 1
- 2''');
      doc.prependToList([], 0);
      expect(doc.toString(), equals('''- 0
- 1
- 2'''));
      expectYamlBuilderValue(doc, [0, 1, 2]);
    });

    test('(3)', () {
      final doc = YamlEditor('''
- 1
- 2
''');
      doc.prependToList([], [4, 5, 6]);
      expect(doc.toString(), equals('''
- - 4
  - 5
  - 6
- 1
- 2
'''));
      expectYamlBuilderValue(doc, [
        [4, 5, 6],
        1,
        2
      ]);
    });

    test('(4)', () {
      final doc = YamlEditor('''
a:
 - b
 - - c
   - d
''');
      doc.prependToList(
          ['a'], wrapAsYamlNode({1: 2}, collectionStyle: CollectionStyle.FLOW));

      expect(doc.toString(), equals('''
a:
 - {1: 2}
 - b
 - - c
   - d
'''));
      expectYamlBuilderValue(doc, {
        'a': [
          {1: 2},
          'b',
          ['c', 'd']
        ]
      });
    });

    test('with comments ', () {
      final doc = YamlEditor('''
# comments
- 1 # comments
- 2
''');
      doc.prependToList([], 0);
      expect(doc.toString(), equals('''
# comments
- 0
- 1 # comments
- 2
'''));
      expectYamlBuilderValue(doc, [0, 1, 2]);
    });

    test('nested in map', () {
      final doc = YamlEditor('''
a:
  - 1
  - 2
''');
      doc.prependToList(['a'], 0);
      expect(doc.toString(), equals('''
a:
  - 0
  - 1
  - 2
'''));
      expectYamlBuilderValue(doc, {
        'a': [0, 1, 2]
      });
    });

    test('nested in map with comments ', () {
      final doc = YamlEditor('''
a: # comments
  - 1 # comments
  - 2
''');
      doc.prependToList(['a'], 0);
      expect(doc.toString(), equals('''
a: # comments
  - 0
  - 1 # comments
  - 2
'''));
      expectYamlBuilderValue(doc, {
        'a': [0, 1, 2]
      });
    });
  });
}
