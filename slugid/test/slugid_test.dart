// Copyright 2019 Google LLC
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
import 'package:slugid/slugid.dart';

void testSlugid(String name, Slugid Function() create) {
  group(name, () {
    late final Slugid s;

    test('create', () {
      s = create();
    });

    test('uuid()', () {
      final uuid = s.uuid();
      expect(Slugid(uuid), equals(s));
      expect(Slugid(uuid).uuid(), equals(uuid));
      expect(Slugid(uuid).toString(), equals(s.toString()));
    });

    test('bytes()', () {
      final b = s.bytes();
      expect(b.length, equals(16));
    });

    test('toString()', () {
      expect(s.toString().length, equals(22));
      expect(s.toString().contains('='), isFalse);
    });
  });
}

void main() {
  group('from slugid', () {
    testSlugid(
        'aiJh4a8FRYSKaNeVTt4Euw', () => Slugid('aiJh4a8FRYSKaNeVTt4Euw'));
    testSlugid(
        'L_YriPk0RLuLyU8zb638oA', () => Slugid('L_YriPk0RLuLyU8zb638oA'));
    testSlugid(
        '-8prq-8rTGqKl2W9SSfyDQ', () => Slugid('-8prq-8rTGqKl2W9SSfyDQ'));
    testSlugid(
        'ZCHCGNvUTqq1Qr-TXMz5mw', () => Slugid('ZCHCGNvUTqq1Qr-TXMz5mw'));
  });

  group('from uuid', () {
    testSlugid('23416fac-a6d3-497f-98bb-1d0a3b7b0c13',
        () => Slugid('23416fac-a6d3-497f-98bb-1d0a3b7b0c13'));
    testSlugid('b7d2b815-d5be-43cb-829f-d66e6facb61a',
        () => Slugid('b7d2b815-d5be-43cb-829f-d66e6facb61a'));
    testSlugid('636d1113-0528-4777-aca9-23b204505beb',
        () => Slugid('636d1113-0528-4777-aca9-23b204505beb'));
    testSlugid('29fd0bdd-1d5d-4cee-afd4-901474e5e9b0',
        () => Slugid('29fd0bdd-1d5d-4cee-afd4-901474e5e9b0'));
  });

  group('v4()', () {
    for (var i = 0; i < 50; i++) {
      testSlugid('v4() ($i)', () => Slugid.v4());
    }
  });

  group('nice()', () {
    for (var i = 0; i < 50; i++) {
      testSlugid('nice() ($i)', () => Slugid.nice());
    }
    test('nice() format', () {
      for (var i = 0; i < 500; i++) {
        expect(Slugid.nice().toString()[0], isNot(equals('-')));
      }
    });
  });
}
