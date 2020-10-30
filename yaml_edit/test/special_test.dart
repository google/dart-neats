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
  test('test if "No" is recognized as false', () {
    final doc = YamlEditor('''
~: null
false: false
No: No
true: true
''');
    doc.update([null], 'tilde');
    doc.update([false], false);
    doc.update(['No'], 'no');
    doc.update([true], 'true');

    expect(doc.toString(), equals('''
~: tilde
false: false
No: no
true: "true"
'''));

    expectYamlBuilderValue(
        doc, {null: 'tilde', false: false, 'No': 'no', true: 'true'});
  });

  test('array keys are recognized', () {
    final doc = YamlEditor('{[1,2,3]: a}');
    doc.update([
      [1, 2, 3]
    ], 'sums to 6');

    expect(doc.toString(), equals('{[1,2,3]: sums to 6}'));
    expectYamlBuilderValue(doc, {
      [1, 2, 3]: 'sums to 6'
    });
  });

  test('map keys are recognized', () {
    final doc = YamlEditor('{{a: 1}: a}');
    doc.update([
      {'a': 1}
    ], 'sums to 6');

    expect(doc.toString(), equals('{{a: 1}: sums to 6}'));
    expectYamlBuilderValue(doc, {
      {'a': 1}: 'sums to 6'
    });
  });

  test('documents can have directives', () {
    final doc = YamlEditor('''%YAML 1.2
--- text''');
    doc.update([], 'test');

    expect(doc.toString(), equals('%YAML 1.2\n--- test'));
    expectYamlBuilderValue(doc, 'test');
  });

  test('tags should be removed if value is changed', () {
    final doc = YamlEditor('''
 - !!str a
 - b
 - !!int 42
 - d
''');
    doc.update([2], 'test');

    expect(doc.toString(), equals('''
 - !!str a
 - b
 - test
 - d
'''));
    expectYamlBuilderValue(doc, ['a', 'b', 'test', 'd']);
  });

  test('tags should be removed if key is changed', () {
    final doc = YamlEditor('''
!!str a: b
c: !!int 42
e: !!str f
g: h
!!str 23: !!bool false
''');
    doc.remove(['23']);

    expect(doc.toString(), equals('''
!!str a: b
c: !!int 42
e: !!str f
g: h
'''));
    expectYamlBuilderValue(doc, {'a': 'b', 'c': 42, 'e': 'f', 'g': 'h'});
  });

  test('detect invalid extra closing bracket', () {
    final doc = YamlEditor('''[ a, b ]''');
    doc.appendToList([], 'c ]');

    expect(doc.toString(), equals('''[ a, b , "c ]"]'''));
    expectYamlBuilderValue(doc, ['a', 'b', 'c ]']);
  });
}
