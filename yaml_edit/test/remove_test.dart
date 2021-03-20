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
  group('throws', () {
    test('PathError if collectionPath points to a scalar', () {
      final doc = YamlEditor('''
a: 1
b: 2
c: 3
''');

      expect(() => doc.remove(['a', 0]), throwsPathError);
    });

    test('PathError if collectionPath is invalid', () {
      final doc = YamlEditor('''
a: 1
b: 2
c: 3
''');

      expect(() => doc.remove(['d']), throwsPathError);
    });

    test('PathError if collectionPath is invalid in nested path', () {
      final doc = YamlEditor('''
a:
  b: 'foo'
''');

      expect(() => doc.remove(['d']), throwsPathError);
    });

    test('PathError if collectionPath is invalid - list', () {
      final doc = YamlEditor('''
[1, 2, 3]
''');

      expect(() => doc.remove([4]), throwsPathError);
    });

    test('PathError in list if using a non-integer as index', () {
      final doc = YamlEditor("{ a: ['b', 'c'] }");
      expect(() => doc.remove(['a', 'b']), throwsPathError);
    });

    test('PathError if path is invalid', () {
      final doc = YamlEditor("{ a: ['b', 'c'] }");
      expect(() => doc.remove(['a', 0, '1']), throwsPathError);
    });
  });

  group('returns', () {
    test('returns the removed node when successful', () {
      final doc = YamlEditor('{ a: { b: foo } }');
      final node = doc.remove(['a', 'b']);
      expect(node.value, equals('foo'));
    });

    test('returns null-value node when doc is empty and path is empty', () {
      final doc = YamlEditor('');
      final node = doc.remove([]);
      expect(node.value, equals(null));
    });
  });

  test('empty path should clear string', () {
    final doc = YamlEditor('''
a: 1
b: 2
c: [3, 4]
''');
    doc.remove([]);
    expect(doc.toString(), equals(''));
  });

  group('block map', () {
    test('(1)', () {
      final doc = YamlEditor('''
a: 1
b: 2
c: 3
''');
      doc.remove(['b']);
      expect(doc.toString(), equals('''
a: 1
c: 3
'''));
    });

    test('empty value', () {
      final doc = YamlEditor('''
a: 1
b:
c: 3
''');
      doc.remove(['b']);
      expect(doc.toString(), equals('''
a: 1
c: 3
'''));
    });

    test('empty value (2)', () {
      final doc = YamlEditor('''
- a: 1
  b:
  c: 3
''');
      doc.remove([0, 'b']);
      expect(doc.toString(), equals('''
- a: 1
  c: 3
'''));
    });

    test('empty value (3)', () {
      final doc = YamlEditor('''
- a: 1
  b:

  c: 3
''');
      doc.remove([0, 'b']);
      expect(doc.toString(), equals('''
- a: 1

  c: 3
'''));
    });

    test('preserves comments', () {
      final doc = YamlEditor('''
a: 1 # preserved 1
# preserved 2
b: 2
# preserved 3
c: 3 # preserved 4
''');
      doc.remove(['b']);
      expect(doc.toString(), equals('''
a: 1 # preserved 1
# preserved 2
# preserved 3
c: 3 # preserved 4
'''));
    });

    test('final element in map', () {
      final doc = YamlEditor('''
a: 1
b: 2
''');
      doc.remove(['b']);
      expect(doc.toString(), equals('''
a: 1
'''));
    });

    test('final element in nested map', () {
      final doc = YamlEditor('''
a:
  aa: 11
  bb: 22
b: 2
''');
      doc.remove(['a', 'bb']);
      expect(doc.toString(), equals('''
a:
  aa: 11
b: 2
'''));
    });

    test('last element should return flow empty map', () {
      final doc = YamlEditor('''
a: 1
''');
      doc.remove(['a']);
      expect(doc.toString(), equals('''
{}
'''));
    });

    test('last element should return flow empty map (2)', () {
      final doc = YamlEditor('''
- a: 1
- b: 2
''');
      doc.remove([0, 'a']);
      expect(doc.toString(), equals('''
- {}
- b: 2
'''));
    });

    test('nested', () {
      final doc = YamlEditor('''
a: 1
b:
  d: 4
  e: 5
c: 3
''');
      doc.remove(['b', 'd']);
      expect(doc.toString(), equals('''
a: 1
b:
  e: 5
c: 3
'''));
    });
  });

  group('flow map', () {
    test('(1)', () {
      final doc = YamlEditor('{a: 1, b: 2, c: 3}');
      doc.remove(['b']);
      expect(doc.toString(), equals('{a: 1, c: 3}'));
    });

    test('(2) ', () {
      final doc = YamlEditor('{a: 1}');
      doc.remove(['a']);
      expect(doc.toString(), equals('{}'));
    });

    test('(3) ', () {
      final doc = YamlEditor('{a: 1, b: 2}');
      doc.remove(['a']);
      expect(doc.toString(), equals('{ b: 2}'));
    });

    test('(4) ', () {
      final doc =
          YamlEditor('{"{}[],": {"{}[],": 1, b: "}{[]},", "}{[],": 3}}');
      doc.remove(['{}[],', 'b']);
      expect(doc.toString(), equals('{"{}[],": {"{}[],": 1, "}{[],": 3}}'));
    });

    test('empty value', () {
      final doc = YamlEditor('{a: 1, b:, c: 3}');
      doc.remove(['b']);
      expect(doc.toString(), equals('{a: 1, c: 3}'));
    });

    test('nested flow map ', () {
      final doc = YamlEditor('{a: 1, b: {d: 4, e: 5}, c: 3}');
      doc.remove(['b', 'd']);
      expect(doc.toString(), equals('{a: 1, b: { e: 5}, c: 3}'));
    });

    test('nested flow map (2)', () {
      final doc = YamlEditor('{a: {{[1] : 2}: 3, b: 2}}');
      doc.remove([
        'a',
        {
          [1]: 2
        }
      ]);
      expect(doc.toString(), equals('{a: { b: 2}}'));
    });
  });

  group('block list', () {
    test('empty value', () {
      final doc = YamlEditor('''
- 0
-
- 2
''');
      doc.remove([1]);
      expect(doc.toString(), equals('''
- 0
- 2
'''));
    });

    test('last element should return flow empty list', () {
      final doc = YamlEditor('''
- 0
''');
      doc.remove([0]);
      expect(doc.toString(), equals('''
[]
'''));
    });

    test('last element should return flow empty list (2)', () {
      final doc = YamlEditor('''
a:
  - 1
b: [3]
''');
      doc.remove(['a', 0]);
      expect(doc.toString(), equals('''
a:
  []
b: [3]
'''));
    });

    test('last element should return flow empty list (3)', () {
      final doc = YamlEditor('''
a:
  - 1
b:
  - 3
''');
      doc.remove(['a', 0]);
      expect(doc.toString(), equals('''
a:
  []
b:
  - 3
'''));
    });

    test('(1) ', () {
      final doc = YamlEditor('''
- 0
- 1
- 2
- 3
''');
      doc.remove([1]);
      expect(doc.toString(), equals('''
- 0
- 2
- 3
'''));
      expectYamlBuilderValue(doc, [0, 2, 3]);
    });

    test('(2)', () {
      final doc = YamlEditor('''
- 0
- [1,2,3]
- 2
- 3
''');
      doc.remove([1]);
      expect(doc.toString(), equals('''
- 0
- 2
- 3
'''));
      expectYamlBuilderValue(doc, [0, 2, 3]);
    });

    test('(3)', () {
      final doc = YamlEditor('''
- 0
- {a: 1, b: 2}
- 2
- 3
''');
      doc.remove([1]);
      expect(doc.toString(), equals('''
- 0
- 2
- 3
'''));
      expectYamlBuilderValue(doc, [0, 2, 3]);
    });

    test('last element', () {
      final doc = YamlEditor('''
- 0
- 1
''');
      doc.remove([1]);
      expect(doc.toString(), equals('''
- 0
'''));
      expectYamlBuilderValue(doc, [0]);
    });

    test('with comments', () {
      final doc = YamlEditor('''
- 0 # comment 0
# comment 1
- 1 # comment 2
# comment 3
- 2 # comment 4
- 3
''');
      doc.remove([1]);
      expect(doc.toString(), equals('''
- 0 # comment 0
# comment 1
# comment 3
- 2 # comment 4
- 3
'''));
      expectYamlBuilderValue(doc, [0, 2, 3]);
    });

    test('nested list', () {
      final doc = YamlEditor('''
- - - 0
    - 1
''');
      doc.remove([0, 0, 0]);
      expect(doc.toString(), equals('''
- - - 1
'''));
      expectYamlBuilderValue(doc, [
        [
          [1]
        ]
      ]);
    });

    test('nested list (2)', () {
      final doc = YamlEditor('''
- - 0
  - 1
- 2
''');
      doc.remove([0]);
      expect(doc.toString(), equals('''
- 2
'''));
      expectYamlBuilderValue(doc, [2]);
    });

    test('nested list (3)', () {
      final doc = YamlEditor('''
- - 0
  - 1
- 2
''');
      doc.remove([0, 1]);
      expect(doc.toString(), equals('''
- - 0
- 2
'''));
      expectYamlBuilderValue(doc, [
        [0],
        2
      ]);
    });

    test('nested list (4)', () {
      final doc = YamlEditor('''
-
  - - 0
    - 1
  - 2
''');
      doc.remove([0, 0, 1]);
      expect(doc.toString(), equals('''
-
  - - 0
  - 2
'''));
      expectYamlBuilderValue(doc, [
        [
          [0],
          2
        ]
      ]);
    });

    test('nested list (5)', () {
      final doc = YamlEditor('''
- - 0
  -
    1
''');
      doc.remove([0, 0]);
      expect(doc.toString(), equals('''
- -
    1
'''));
      expectYamlBuilderValue(doc, [
        [1]
      ]);
    });

    test('nested list (6)', () {
      final doc = YamlEditor('''
- - 0 # -
  # -
  -
    1
''');
      doc.remove([0, 0]);
      expect(doc.toString(), equals('''
-   # -
  -
    1
'''));
      expectYamlBuilderValue(doc, [
        [1]
      ]);
    });

    test('nested map', () {
      final doc = YamlEditor('''
- - a: b
    c: d
''');
      doc.remove([0, 0, 'a']);
      expect(doc.toString(), equals('''
- - c: d
'''));
      expectYamlBuilderValue(doc, [
        [
          {'c': 'd'}
        ]
      ]);
    });

    test('nested map (2)', () {
      final doc = YamlEditor('''
- a:
    - 0
    - 1
  c: d
''');
      doc.remove([0, 'a', 1]);
      expect(doc.toString(), equals('''
- a:
    - 0
  c: d
'''));
      expectYamlBuilderValue(doc, [
        {
          'a': [0],
          'c': 'd'
        }
      ]);
    });
  });

  group('flow list', () {
    test('(1)', () {
      final doc = YamlEditor('[1, 2, 3]');
      doc.remove([1]);
      expect(doc.toString(), equals('[1, 3]'));
      expectYamlBuilderValue(doc, [1, 3]);
    });

    test('(2)', () {
      final doc = YamlEditor('[1, "b", "c"]');
      doc.remove([0]);
      expect(doc.toString(), equals('[ "b", "c"]'));
      expectYamlBuilderValue(doc, ['b', 'c']);
    });

    test('(3)', () {
      final doc = YamlEditor('[1, {a: 1}, "c"]');
      doc.remove([1]);
      expect(doc.toString(), equals('[1, "c"]'));
      expectYamlBuilderValue(doc, [1, 'c']);
    });

    test('(4) ', () {
      final doc = YamlEditor('["{}", b, "}{"]');
      doc.remove([1]);
      expect(doc.toString(), equals('["{}", "}{"]'));
    });

    test('(5) ', () {
      final doc = YamlEditor('["{}[],", [test, "{}[],", "{}[],"], "{}[],"]');
      doc.remove([1, 0]);
      expect(doc.toString(), equals('["{}[],", [ "{}[],", "{}[],"], "{}[],"]'));
    });
  });
}
