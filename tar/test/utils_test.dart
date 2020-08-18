// Copyright 2020
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

import 'package:tar/src/constants.dart';
import 'package:tar/src/utils.dart';
import 'package:test/test.dart';

import 'test_utils.dart';

void main() {
  group('Fits in base 256', () {
    final tests = [
      [1, 8, true],
      [0, 8, true],
      [-1, 8, true],
      [1 << 56, 8, false],
      [(1 << 56) - 1, 8, true],
      [-1 << 56, 8, true],
      [(-1 << 56), 8, true],
      [121654, 8, true],
      [-9849849, 8, true],
      [int64MaxValue, 9, true],
      [0, 9, true],
      [int64MinValue, 9, true],
      [int64MaxValue, 12, true],
      [0, 12, true],
      [int64MinValue, 12, true]
    ];

    for (final testParams in tests) {
      test('fitsInBase256(${testParams[1]}, ${testParams[0]})', () {
        expect(fitsInBase256(testParams[1], testParams[0]), testParams[2]);
      });
    }
  });

  group('parseNumeric', () {
    final tests = [
      /// Test base-256 (binary) encoded values.
      ['', 0, true],
      ['\x80', 0, true],
      ['\x80\x00', 0, true],
      ['\x80\x00\x00', 0, true],
      ['\xbf', (1 << 6) - 1, true],
      ['\xbf\xff', (1 << 14) - 1, true],
      ['\xbf\xff\xff', (1 << 22) - 1, true],
      ['\xff', -1, true],
      ['\xff\xff', -1, true],
      ['\xff\xff\xff', -1, true],
      ['\xc0', -1 * (1 << 6), true],
      ['\xc0\x00', -1 * (1 << 14), true],
      ['\xc0\x00\x00', -1 * (1 << 22), true],
      ['\x87\x76\xa2\x22\xeb\x8a\x72\x61', 537795476381659745, true],
      [
        '\x80\x00\x00\x00\x07\x76\xa2\x22\xeb\x8a\x72\x61',
        537795476381659745,
        true
      ],
      ['\xf7\x76\xa2\x22\xeb\x8a\x72\x61', -615126028225187231, true],
      [
        '\xff\xff\xff\xff\xf7\x76\xa2\x22\xeb\x8a\x72\x61',
        -615126028225187231,
        true
      ],
      ['\x80\x7f\xff\xff\xff\xff\xff\xff\xff', int64MaxValue, true],
      ['\x80\x80\x00\x00\x00\x00\x00\x00\x00', 0, false],
      ['\xff\x80\x00\x00\x00\x00\x00\x00\x00', int64MinValue, true],
      ['\xff\x7f\xff\xff\xff\xff\xff\xff\xff', 0, false],
      ['\xf5\xec\xd1\xc7\x7e\x5f\x26\x48\x81\x9f\x8f\x9b', 0, false],

      /// Test base-8 (octal) encoded values.
      ['0000000\x00', 0, true],
      [' \x0000000\x00', 0, true],
      [' \x0000003\x00', 3, true],
      ['00000000227\x00', 151, true],
      ['032033\x00 ', 13339, true],
      ['320330\x00 ', 106712, true],
      ['0000660\x00 ', 432, true],
      ['\x00 0000660\x00 ', 432, true],
      ['0123456789abcdef', 0, false],
      ['0123456789\x00abcdef', 0, false],
      ['01234567\x0089abcdef', 342391, true],
      ['0123\x7e\x5f\x264123', 0, false],
    ];

    for (final testInput in tests) {
      test('parseNumeric(${testInput[0]})', () {
        final inputString = testInput[0] as String;
        if (testInput[2]) {
          expect(parseNumeric(inputString.codeUnits), testInput[1]);
        } else {
          expect(() => parseNumeric(inputString.codeUnits),
              anyOf(throwsFormatException, throwsArgumentError));
        }
      });
    }
  });

  group('format numeric', () {
    final tests = [
      // Test base-8 (octal) encoded values.
      [0, '0\x00', true],
      [7, '7\x00', true],
      [8, '\x80\x08', true],
      [63, '77\x00', true],
      [64, '\x80\x00\x40', true],
      [0, '0000000\x00', true],
      [83, '0000123\x00', true],
      [2054353, '7654321\x00', true],
      [2097151, '7777777\x00', true],
      [2097152, '\x80\x00\x00\x00\x00\x20\x00\x00', true],
      [0, '00000000000\x00', true],
      [342391, '00001234567\x00', true],
      [8414630097, '76543210321\x00', true],
      [1402433619, '12345670123\x00', true],
      [8589934591, '77777777777\x00', true],
      [8589934592, '\x80\x00\x00\x00\x00\x00\x00\x02\x00\x00\x00\x00', true],
      [int64MaxValue, '777777777777777777777\x00', true],

      // Test base-256 (binary) encoded values.
      [-1, '\xff', true],
      [-1, '\xff\xff', true],
      [-1, '\xff\xff\xff', true],
      [(1 << 0), '0', false],
      [(1 << 8) - 1, '\x80\xff', true],
      [(1 << 8), '0\x00', false],
      [(1 << 16) - 1, '\x80\xff\xff', true],
      [(1 << 16), '00\x00', false],
      [-1 * (1 << 0), '\xff', true],
      [-1 * (1 << 0) - 1, '0', false],
      [-1 * (1 << 8), '\xff\x00', true],
      [-1 * (1 << 8) - 1, '0\x00', false],
      [-1 * (1 << 16), '\xff\x00\x00', true],
      [-1 * (1 << 16) - 1, '00\x00', false],
      [537795476381659745, '0000000\x00', false],
      [
        537795476381659745,
        '\x80\x00\x00\x00\x07\x76\xa2\x22\xeb\x8a\x72\x61',
        true
      ],
      [-615126028225187231, '0000000\x00', false],
      [
        -615126028225187231,
        '\xff\xff\xff\xff\xf7\x76\xa2\x22\xeb\x8a\x72\x61',
        true
      ],
      [int64MaxValue, '0000000\x00', false],
      [int64MaxValue, '\x80\x00\x00\x00\x7f\xff\xff\xff\xff\xff\xff\xff', true],
      [int64MinValue, '0000000\x00', false],
      [int64MinValue, '\xff\xff\xff\xff\x80\x00\x00\x00\x00\x00\x00\x00', true],
      [int64MaxValue, '\x80\x7f\xff\xff\xff\xff\xff\xff\xff', true],
      [int64MinValue, '\xff\x80\x00\x00\x00\x00\x00\x00\x00', true],
    ];

    for (final testInputs in tests) {
      final expectedResult = testInputs[1] as String;
      test('formatNumeric(${testInputs[0]}, ${expectedResult.length})', () {
        if (testInputs[2]) {
          expect(formatNumeric(testInputs[0], expectedResult.length),
              expectedResult.codeUnits);
        } else {
          expect(() => formatNumeric(testInputs[0], expectedResult.length),
              throwsArgumentError);
        }
      });
    }
  });

  group('Fits in octal', () {
    final tests = [
      [-1, 1, false],
      [-1, 2, false],
      [-1, 3, false],
      [0, 1, true],
      [1, 1, false],
      [0, 2, true],
      [7, 2, true],
      [8, 2, false],
      [0, 4, true],
      [511, 4, true],
      [512, 4, false],
      [0, 8, true],
      [2097151, 8, true],
      [2097152, 8, false],
      [0, 12, true],
      [8589934591, 12, true],
      [8589934592, 12, false],
      [int64MaxValue, 22, true],
      [1402433619, 12, true],
      [452724, 12, true],
      [-1402433619, 12, false],
      [-452724, 12, false],
      [-1564164, 30, false],
    ];

    for (final testParams in tests) {
      test('fitsInOctal(${testParams[1]}, ${testParams[0]})', () {
        expect(fitsInOctal(testParams[1], testParams[0]), testParams[2]);
      });
    }
  });

  group('PAX Time Parsing', () {
    final tests = [
      ['1350244992.023960108', microsecondsSinceEpoch(1350244992023960), true],
      ['1350244992.02396010', microsecondsSinceEpoch(1350244992023960), true],
      ['1350244992.0239601089', microsecondsSinceEpoch(1350244992023960), true],
      ['1350244992.3', microsecondsSinceEpoch(1350244992300000), true],
      ['1350244992', microsecondsSinceEpoch(1350244992000000), true],
      ['-1.000000001', microsecondsSinceEpoch(-1000000), true],
      ['-1.000001', microsecondsSinceEpoch(-1000001), true],
      ['-1.001000', microsecondsSinceEpoch(-1001000), true],
      ['-1', microsecondsSinceEpoch(-1000000), true],
      ['-1.999000', microsecondsSinceEpoch(-1999000), true],
      ['-1.999999', microsecondsSinceEpoch(-1999999), true],
      ['-1.999999999', microsecondsSinceEpoch(-1999999), true],
      ['0.000000001', microsecondsSinceEpoch(0), true],
      ['0.000001', microsecondsSinceEpoch(1), true],
      ['0.001000', microsecondsSinceEpoch(1000), true],
      ['0', microsecondsSinceEpoch(0), true],
      ['0.999000', microsecondsSinceEpoch(999000), true],
      ['0.999999', microsecondsSinceEpoch(999999), true],
      ['0.999999999', microsecondsSinceEpoch(999999), true],
      ['1.000000001', microsecondsSinceEpoch(1000000), true],
      ['1.000001', microsecondsSinceEpoch(1000001), true],
      ['1.001000', microsecondsSinceEpoch(1001000), true],
      ['1', microsecondsSinceEpoch(1000000), true],
      ['1.999000', microsecondsSinceEpoch(1999000), true],
      ['1.999999', microsecondsSinceEpoch(1999999), true],
      ['1.999999999', microsecondsSinceEpoch(1999999), true],
      [
        '-1350244992.023960108',
        microsecondsSinceEpoch(-1350244992023960),
        true
      ],
      ['-1350244992.02396010', microsecondsSinceEpoch(-1350244992023960), true],
      [
        '-1350244992.0239601089',
        microsecondsSinceEpoch(-1350244992023960),
        true
      ],
      ['-1350244992.3', microsecondsSinceEpoch(-1350244992300000), true],
      ['-1350244992', microsecondsSinceEpoch(-1350244992000000), true],
      ['', null, false],
      ['0', microsecondsSinceEpoch(0), true],
      ['1.', microsecondsSinceEpoch(1000000), true],
      ['0.0', microsecondsSinceEpoch(0), true],
      ['.5', null, false],
      ['-1.', microsecondsSinceEpoch(-1000000), true],
      ['-1.0', microsecondsSinceEpoch(-1000000), true],
      ['-0.0', microsecondsSinceEpoch(-0), true],
      ['-0.1', microsecondsSinceEpoch(-100000), true],
      ['-0.01', microsecondsSinceEpoch(-10000), true],
      ['-0.99', microsecondsSinceEpoch(-990000), true],
      ['-0.98', microsecondsSinceEpoch(-980000), true],
      ['-1.1', microsecondsSinceEpoch(-1100000), true],
      ['-1.01', microsecondsSinceEpoch(-1010000), true],
      ['-2.99', microsecondsSinceEpoch(-2990000), true],
      ['-5.98', microsecondsSinceEpoch(-5980000), true],
      ['-', null, false],
      ['+', null, false],
      ['-1.-1', null, false],
      ['99999999999999999999999999999999999999999999999', null, false],
      ['0.123456789abcdef', null, false],
      ['foo', null, false],
      ['\x00', null, false],
      [
        '𝟵𝟴𝟳𝟲𝟱.𝟰𝟯𝟮𝟭𝟬',
        null,
        false
      ], // Unicode numbers (U+1D7EC to U+1D7F5)
      ['98765﹒43210', null, false], // Unicode period (U+FE52)];
    ];

    for (final testInput in tests) {
      test('parsePAXTime(${testInput[0]})', () {
        if (testInput[2]) {
          expect(parsePAXTime(testInput[0]), testInput[1]);
        } else {
          expect(() => parsePAXTime(testInput[0]), throwsTarHeaderException);
        }
      });
    }
  });

  group('format PAX Time', () {
    final tests = [
      [microsecondsSinceEpoch(1350244992000000), '1350244992'],
      [microsecondsSinceEpoch(1350244992300000), '1350244992.3'],
      [microsecondsSinceEpoch(1350244992023960), '1350244992.02396'],
      [microsecondsSinceEpoch(1999999), '1.999999'],
      [microsecondsSinceEpoch(1999000), '1.999'],
      [microsecondsSinceEpoch(1000000), '1'],
      [microsecondsSinceEpoch(1001000), '1.001'],
      [microsecondsSinceEpoch(1000001), '1.000001'],
      [microsecondsSinceEpoch(999999), '0.999999'],
      [microsecondsSinceEpoch(999000), '0.999'],
      [microsecondsSinceEpoch(0), '0'],
      [microsecondsSinceEpoch(1000), '0.001'],
      [microsecondsSinceEpoch(1), '0.000001'],
      [microsecondsSinceEpoch(-1999999), '-1.999999'],
      [microsecondsSinceEpoch(-1999000), '-1.999'],
      [microsecondsSinceEpoch(-1000000), '-1'],
      [microsecondsSinceEpoch(-1001000), '-1.001'],
      [microsecondsSinceEpoch(-1000001), '-1.000001'],
      [microsecondsSinceEpoch(-1350244992000000), '-1350244992'],
      [microsecondsSinceEpoch(-1350244992300000), '-1350244992.3'],
      [microsecondsSinceEpoch(-1350244992023960), '-1350244992.02396'],
    ];

    for (final testInputs in tests) {
      test('', () {
        expect(formatPAXTime(testInputs[0]), testInputs[1]);
      });
    }
  });

  /// Tests the parsing of individual PAX record.
  ///
  /// Our implementation differs from the Go implementation where we parse
  /// the raw bytes, and do not return the remainder, but rather keep track of
  /// the index for the next parsing instead.
  group('parse PAX Record', () {
    final mediumName = 'CD' * 50;
    final longName = 'AB' * 100;

    final tests = [
      ['6 k=v\n\n', 'k', 'v', true],
      ['19 path=/etc/hosts\n', 'path', '/etc/hosts', true],
      ['210 path=' + longName + '\nabc', 'path', longName, true],
      ['110 path=' + mediumName + '\n', 'path', mediumName, true],
      ['9 foo=ba\n', 'foo', 'ba', true],
      ['11 foo=bar\n\x00', 'foo', 'bar', true],
      ['18 foo=b=\nar=\n==\x00\n', 'foo', 'b=\nar=\n==\x00', true],
      ['27 foo=hello9 foo=ba\nworld\n', 'foo', 'hello9 foo=ba\nworld', true],
      ['27 ☺☻☹=日a本b語ç\n', '☺☻☹', '日a本b語ç', true],
      ['17 \x00hello=\x00world\n', '', '', false],
      ['1 k=1\n', '', '', false],
      ['6 k~1\n', '', '', false],

      /// Excluding the next test case because it will just be ignored.
      /// ['6_k=1\n', '', '', false],
      ['6 k=1 ', '', '', false],
      ['632 k=1\n', '', '', false],
      ['16 longkeyname=hahaha\n', '', '', false],
      ['3 somelongkey=\n', '', '', false],
      ['50 tooshort=\n', '', '', false],
    ];

    for (final testInput in tests) {
      final inputString = testInput[0] as String;
      test('parsePAX', () {
        if (testInput[3]) {
          expect(
              parsePAX(utf8.encode(inputString)), {testInput[1]: testInput[2]});
        } else {
          expect(() => parsePAX(utf8.encode(inputString)),
              throwsTarHeaderException);
        }
      });
    }
  });

  group('Format PAX Record', () {
    final mediumName = 'CD' * 50;
    final longName = 'AB' * 100;

    final tests = [
      ['k', 'v', '6 k=v\n', true],
      ['path', '/etc/hosts', '19 path=/etc/hosts\n', true],
      ['path', longName, '210 path=' + longName + '\n', true],
      ['path', mediumName, '110 path=' + mediumName + '\n', true],
      ['foo', 'ba', '9 foo=ba\n', true],
      ['foo', 'bar', '11 foo=bar\n', true],
      ['foo', 'b=\nar=\n==\x00', '18 foo=b=\nar=\n==\x00\n', true],
      ['foo', 'hello9 foo=ba\nworld', '27 foo=hello9 foo=ba\nworld\n', true],
      ['☺☻☹', '日a本b語ç', '27 ☺☻☹=日a本b語ç\n', true],
      ['xhello', '\x00world', '17 xhello=\x00world\n', true],
      ['path', 'null\x00', '', false],
      ['null\x00', 'value', '', false],
      [
        paxSchilyXattr + 'key',
        'null\x00',
        '26 SCHILY.xattr.key=null\x00\n',
        true
      ],
    ];

    for (final testInputs in tests) {
      test('format PAX Records', () {
        if (testInputs[3]) {
          expect(formatPAXRecord(testInputs[0], testInputs[1]), testInputs[2]);
        } else {
          expect(() => formatPAXRecord(testInputs[0], testInputs[1]),
              throwsTarHeaderException);
        }
      });
    }
  });
}
