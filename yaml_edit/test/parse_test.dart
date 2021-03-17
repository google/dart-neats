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
  group('throws', () {
    test('PathError if key does not exist', () {
      final doc = YamlEditor('{a: 4}');
      final path = ['b'];

      expect(() => doc.parseAt(path), throwsPathError);
    });

    test('PathError if path tries to go deeper into a scalar', () {
      final doc = YamlEditor('{a: 4}');
      final path = ['a', 'b'];

      expect(() => doc.parseAt(path), throwsPathError);
    });

    test('PathError if index is out of bounds', () {
      final doc = YamlEditor('[0,1]');
      final path = [2];

      expect(() => doc.parseAt(path), throwsPathError);
    });

    test('PathError if index is not an integer', () {
      final doc = YamlEditor('[0,1]');
      final path = ['2'];

      expect(() => doc.parseAt(path), throwsPathError);
    });
  });

  group('orElse provides a default value', () {
    test('simple example with null node return ', () {
      final doc = YamlEditor('{a: {d: 4}, c: ~}');
      final result = doc.parseAt(['b'], orElse: () => wrapAsYamlNode(null));

      expect(result.value, equals(null));
    });

    test('simple example with map return', () {
      final doc = YamlEditor('{a: {d: 4}, c: ~}');
      final result =
          doc.parseAt(['b'], orElse: () => wrapAsYamlNode({'a': 42}));

      expect(result, isA<YamlMap>());
      expect(result.value, equals({'a': 42}));
    });

    test('simple example with scalar return', () {
      final doc = YamlEditor('{a: {d: 4}, c: ~}');
      final result = doc.parseAt(['b'], orElse: () => wrapAsYamlNode(42));

      expect(result, isA<YamlScalar>());
      expect(result.value, equals(42));
    });

    test('simple example with list return', () {
      final doc = YamlEditor('{a: {d: 4}, c: ~}');
      final result = doc.parseAt(['b'], orElse: () => wrapAsYamlNode([42]));

      expect(result, isA<YamlList>());
      expect(result.value, equals([42]));
    });
  });

  group('returns a YamlNode', () {
    test('with the correct type', () {
      final doc = YamlEditor("YAML: YAML Ain't Markup Language");
      final expectedYamlScalar = doc.parseAt(['YAML']);

      expect(expectedYamlScalar, isA<YamlScalar>());
    });

    test('with the correct value', () {
      final doc = YamlEditor("YAML: YAML Ain't Markup Language");

      expect(doc.parseAt(['YAML']).value, "YAML Ain't Markup Language");
    });

    test('with the correct value in nested collection', () {
      final doc = YamlEditor('''
a: 1
b:
  d: 4
  e: [5, 6, 7]
c: 3
''');

      expect(doc.parseAt(['b', 'e', 2]).value, 7);
    });

    test('with a null value in nested collection', () {
      final doc = YamlEditor('''
key1:
  key2: null
''');

      expect(doc.parseAt(['key1', 'key2']).value, null);
    });

    test('with the correct type (2)', () {
      final doc = YamlEditor("YAML: YAML Ain't Markup Language");
      final expectedYamlMap = doc.parseAt([]);

      expect(expectedYamlMap is YamlMap, equals(true));
    });

    test('that is immutable', () {
      final doc = YamlEditor("YAML: YAML Ain't Markup Language");
      final expectedYamlMap = doc.parseAt([]);

      expect(() => (expectedYamlMap as YamlMap)['YAML'] = 'test',
          throwsUnsupportedError);
    });

    test('that has immutable children', () {
      final doc = YamlEditor("YAML: ['Y', 'A', 'M', 'L']");
      final expectedYamlMap = doc.parseAt([]);

      expect(() => (expectedYamlMap as YamlMap)['YAML'][0] = 'X',
          throwsUnsupportedError);
    });
  });

  test('works with map keys', () {
    final doc = YamlEditor('{a: {{[1, 2]: 3}: 4}}');
    expect(
        doc.parseAt([
          'a',
          {
            [1, 2]: 3
          }
        ]).value,
        equals(4));
  });

  test('works with null in path', () {
    final doc = YamlEditor('{a: { ~: 4}}');
    expect(doc.parseAt(['a', null]).value, equals(4));
  });

  test('works with null value', () {
    final doc = YamlEditor('{a: null}');
    expect(doc.parseAt(['a']).value, equals(null));
  });
}
