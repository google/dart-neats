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

import 'dart:convert';
import 'dart:math';
import 'package:canonical_json/canonical_json.dart';
import 'package:test/test.dart';

void main() {
  void testValue(String name, Object value) => test(name, () {
        final encoded = canonicalJson.encode(value);
        final decoded = canonicalJson.decode(encoded);
        expect(decoded, equals(value));
        final encodedAgain = canonicalJson.encode(decoded);
        expect(encodedAgain, encoded);
        final decodedJson = json.fuse(utf8).decode(encoded);
        expect(decodedJson, equals(value));
      });

  testValue('string', 'hello world');
  testValue('string w. quote', 'hello "world');
  testValue('string w. backslash', r'hello \world');
  testValue('string w. double backslash', r'hello \\world');
  testValue('int (1)', 42);
  testValue('int (2)', -42);

  final prng = Random(42);
  for (var i = 0; i < 50; i++) {
    final chars = '{}[]abcd \0""""\\\\\\\\\$\$\'\''.split('');
    chars.shuffle(prng);
    testValue('shuffled string ($i)', chars.join(''));
    testValue('shuffled map key ($i)', {chars.join(''): 42});
  }

  [
    '""',
    '"hello world"',
    r'"test\"test"',
    r'"test\\test"',
    r'"test\\\\test"',
    r'"test\\\"test"',
    r'"test\"\"test"',
    r'"test\"\\test"',
    '42',
    '[]',
    '[1,2,3,4]',
    '{}',
    '{"test":42}',
    '{"a":1,"b":2,"c":3}',
    'true',
    'false',
    'null',
    '[true,false,null]',
    '[true,{"a":false},null]',
    '-1',
    '-120',
    '"Äffin"',
    // Test valid canonical JSON cases.
  ].forEach((String data) => test('isValidCanonicalJSON($data)', () {
        final value = json.decode(data);
        final encoded = canonicalJson.encode(value);
        expect(utf8.decode(encoded), equals(data));
        final decoded = canonicalJson.decode(encoded);
        expect(decoded, equals(value));
        final encodedAgain = canonicalJson.encode(decoded);
        expect(encodedAgain, encoded);
        // TODO: Use json.fuse(utf8) when: http://dartbug.com/46205 is fixed!
        // final decodedJson = json.fuse(utf8).decode(encoded);
        final decodedJson = json.decode(utf8.decode(encoded));
        expect(decodedJson, equals(value));
      }));

  [
    '42.1',
    't',
    'f',
    'n',
    'null ',
    'true ',
    'false ',
    ' false',
    ' true',
    ' null',
    '[,]',
    '{,}',
    '{]',
    '[}',
    '[',
    ']',
    '{',
    '}',
    '"indent:\\t"',
    '"\\"',
    '"\\" ',
    '[1,2,3,5.0]',
    '{"a":1,"c":2,"b":3}',
    '[true,false ,null]',
    '[true,{"a":false}, null]',
    '[true,false,null] ',
    '[true,{"a":false},null] ',
    '[true,false,null,]',
    '[true,{"a":false},null,]',
    '{"a":1,"b":2,"c":3} ',
    '{"a":1,"b":2,"c":3 }',
    '{"a":1,"b":2,"c":3,}',
    '',
    '-0',
    '"A\u0308ffin"', // not unicode normalization form C
    // Test invalid canonical JSON cases.
  ].forEach((String data) => test('isInvalidCanonicalJSON($data)', () {
        final raw = utf8.encode(data);
        expect(() => canonicalJson.decode(raw),
            throwsA(TypeMatcher<InvalidCanonicalJsonException>()));
      }));

  [
    1.2,
    -0.0,
  ].forEach((Object data) => test('cannotBeCanonicalized($data)', () {
        expect(() => canonicalJson.encode(data),
            throwsA(TypeMatcher<ArgumentError>()));
      }));

  test('unicode normalization form C', () {
    final nonFormC = 'A\u0308\uFB03n';
    final data = canonicalJson.encode(nonFormC);
    final value = canonicalJson.decode(data);
    expect(value, isNot(equals(nonFormC)));
    final data2 = canonicalJson.encode(value);
    expect(data2, equals(data));
  });
}
