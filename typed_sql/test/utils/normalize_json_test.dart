import 'dart:convert' show json;

import 'package:test/test.dart';
import 'package:typed_sql/src/utils/normalize_json.dart';

import '../typed_sql/testrunner.dart';

final _cases = [
  (
    name: 'Normalize key ordering',
    inputs: [
      '{"a": 1, "b": 2}',
      '{"b": 2, "a": 1}',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Normalize int-compatible doubles',
    inputs: [
      '1.0',
      '1',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Do not normalize non-int-compatible doubles',
    inputs: [
      '1.1',
    ],
    count: 1,
    output: '1.1',
  ),
  (
    name: 'Normalize nested structures',
    inputs: [
      '{"a": 1.0, "b": {"c": 2.0, "d": 3}}',
      '{"b": {"d": 3, "c": 2}, "a": 1}',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Handle lists of numbers',
    inputs: [
      '[1.0, 2.0, 3.0]',
      '[1, 2, 3]',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Handle lists of mixed types',
    inputs: [
      '[1.0, "a", {"b": 2.0}]',
      '[1, "a", {"b": 2}]',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Empty map',
    inputs: [
      '{}',
      '{ }',
      ' { }',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Empty list',
    inputs: [
      '[]',
      '[ ]',
      ' [ ]',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Null value',
    inputs: [
      'null',
      ' null ',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'String value',
    inputs: [
      '"test"',
      ' "test" ',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'String escapings',
    inputs: [
      r'"\n"',
      r'"\u000a"',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Boolean value (true)',
    inputs: [
      'true',
      ' true ',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Boolean value (false)',
    inputs: [
      'false',
      ' false ',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Complex object',
    inputs: [
      '{"a": 1.0, "b": [true, false, null, "test", {"c": 2.0}]}',
      '{"b": [true, false, null, "test", {"c": 2}], "a": 1}',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Different types',
    inputs: [
      '{"a": 1}',
      '{"a": "1"}',
    ],
    count: 2,
    output: null,
  ),
  (
    name: 'Different types (int vs double)',
    inputs: [
      '1',
      '1.0',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Different types (int vs double, negative)',
    inputs: [
      '-1',
      '-1.0',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Different types (0 vs 0.0)',
    inputs: [
      '0',
      '0.0',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Whitespace in objects',
    inputs: [
      '{"a":1, "b":2}',
      '{ "a": 1, "b": 2 }',
      ' { "a" : 1 , "b" : 2 } ',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Whitespace in arrays',
    inputs: [
      '[1,2,3]',
      '[ 1, 2, 3 ]',
      '[ 1 , 2 , 3 ]',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Unicode strings',
    inputs: [
      '"你好世界"',
      '"\u4F60\u597D\u4E16\u754C"', // Equivalent unicode escape sequences
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Unicode keys',
    inputs: [
      '{"你好": 1}',
      '{"\u4F60\u597D": 1}',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Large double that CAN be represented as int',
    inputs: [
      '9007199254740991.0', // Max Safe Integer
      '9007199254740991',
    ],
    count: 1,
    output: '9007199254740991',
  ),
  (
    name: 'Double with decimal precision preserved',
    // 9007199254740991.1 loses precision in IEEE 754 and becomes 9007199254740991.0
    // We use a smaller number where .1 is significant.
    inputs: [
      '123456789.1',
    ],
    count: 1,
    output: '123456789.1',
  ),
  (
    name: 'Complex mixed structure',
    inputs: [
      '{"a": [1.0, "b", {"c": true, "d": null}], "e": 2.0}',
      '{"e": 2, "a": [1, "b", {"d": null, "c": true}]}',
    ],
    count: 1,
    output: null,
  ),
  (
    name: 'Keys with spaces',
    inputs: [
      '{"key with space": 1}',
    ],
    count: 1,
    output: '{"key with space":1}',
  ),
  (
    name: 'Empty string, and single space string',
    inputs: [
      '""',
      '" "',
    ],
    count: 2,
    output: null,
  ),
  (
    name: 'Scientific Notation Int',
    inputs: ['100', '1e2', '1.0e2'],
    count: 1,
    output: '100',
  ),
  (
    name: 'Scientific Notation Double',
    inputs: ['0.01', '1e-2'],
    count: 1,
    output: '0.01',
  ),
  (
    name: 'Negative Zeros',
    // In Dart 0.0 == -0.0 is true, and 0 == -0 is true.
    // Normalized JSON prefers the simplest representation: 0
    inputs: ['0', '0.0', '-0.0', '-0'],
    count: 1,
    output: '0',
  ),
  (
    name: 'Deeply Nested Map Sorting',
    inputs: [
      '{"x": {"b": 1, "a": 1}, "y": [{"d": 2, "c": 2}]}',
      '{"y": [{"c": 2, "d": 2}], "x": {"a": 1, "b": 1}}',
    ],
    count: 1,
    output: '{"x":{"a":1,"b":1},"y":[{"c":2,"d":2}]}',
  ),
  (
    name: 'Lists containing nulls',
    inputs: [
      '[null, 1.0, null]',
      '[null, 1, null]',
    ],
    count: 1,
    output: '[null,1,null]',
  ),
  (
    name: 'Map with null values',
    inputs: [
      '{"a": null, "b": 1.0}',
      '{"b": 1, "a": null}',
    ],
    count: 1,
    output: '{"a":null,"b":1}',
  ),
  (
    name: 'Empty Key',
    // An empty string is a valid JSON key
    inputs: [
      '{"": 1, "a": 2}',
      '{"a": 2, "": 1}',
    ],
    count: 1,
    output: '{"":1,"a":2}', // Empty string sorts before "a"
  ),
  (
    name: 'Escaped Characters in Keys',
    // Ensures sorting works on the actual string value, not the raw input
    inputs: [
      r'{"b": 1, "\u0061": 2}', // \u0061 is "a"
      '{"a": 2, "b": 1}',
    ],
    count: 1,
    output: '{"a":2,"b":1}',
  ),
];

void main() {
  for (final c in _cases) {
    test(c.name, () {
      final outputs = c.inputs
          .map((input) => json.encode(normalizeJson(json.decode(input))))
          .toSet();

      check(outputs).length.equals(c.count);

      final expectedOutput = c.output;
      if (expectedOutput != null) {
        for (final output in outputs) {
          check(output).equals(expectedOutput);
        }
      }
    });
  }
}
