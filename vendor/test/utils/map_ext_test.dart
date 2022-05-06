// Copyright 2022 Google LLC
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
import 'package:vendor/src/utils/map_ext.dart';

void main() {
  test('Map.where((k, v) => k == \'a\' && v == 1)', () {
    expect(
      {
        'a': 1,
        'b': 2,
      }.where((k, v) => k == 'a' && v == 1),
      equals({
        'a': 1,
      }),
    );
  });

  test('Map.where((k, v) => true)', () {
    expect(
      {
        'a': 1,
        'b': 2,
      }.where((k, v) => true),
      equals({
        'a': 1,
        'b': 2,
      }),
    );
  });

  test('Map.where((k, v) => false)', () {
    expect(
      {
        'a': 1,
        'b': 2,
      }.where((k, v) => false),
      equals({}),
    );
  });

  test('Map.where((k, v) => v > 3)', () {
    expect(
      {
        'a': 1,
        'b': 2,
        'A': 4,
        'B': 6,
      }.where((k, v) => v > 3),
      equals({
        'A': 4,
        'B': 6,
      }),
    );
  });

  test('Map.mapPairs((k, v) => k)', () {
    expect(
      {
        'a': 1,
        'b': 2,
      }.mapPairs((k, v) => k).toList(),
      equals([
        'a',
        'b',
      ]),
    );
  });

  test('Map.mapPairs((k, v) => v)', () {
    expect(
      {
        'a': 1,
        'b': 2,
      }.mapPairs((k, v) => v).toList(),
      equals([
        1,
        2,
      ]),
    );
  });

  test('Map.mapPairs((k, v) => \'\$k-\$v\')', () {
    expect(
      {
        'a': 1,
        'b': 2,
      }.mapPairs((k, v) => '$k-$v').toList(),
      equals([
        'a-1',
        'b-2',
      ]),
    );
  });
}
