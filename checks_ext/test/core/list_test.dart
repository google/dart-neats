// Copyright 2026 Google LLC
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

import 'dart:typed_data';
import 'dart:convert';
import 'package:checks_ext/src/core/list.dart';
import '../util.dart';

void main() {
  group('Uint8ListChecks', () {
    test('asUtf8 decodes string', () {
      final bytes = Uint8List.fromList(utf8.encode('hello'));
      check(bytes).asUtf8.equals('hello');
    });

    test('asUtf8 fails for invalid UTF-8', () {
      final bytes = Uint8List.fromList([0xFF, 0xFE]);
      check(bytes).isRejectedBy(
        (it) => it.asUtf8.equals(''),
        which: ['is not valid UTF-8'],
      );
    });

    test('isValidUtf8 succeeds for valid UTF-8', () {
      final bytes = Uint8List.fromList(utf8.encode('hello'));
      check(bytes).isValidUtf8();
    });

    test('isValidUtf8 fails for invalid UTF-8', () {
      final bytes = Uint8List.fromList([0xFF, 0xFE]);
      check(
        bytes,
      ).isRejectedBy((it) => it.isValidUtf8(), which: ['is not valid UTF-8']);
    });

    test('containsBytes succeeds when containing sequence', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      check(bytes).containsBytes([2, 3, 4]);
    });

    test('containsBytes fails when not containing sequence', () {
      final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
      check(bytes).isRejectedBy(
        (it) => it.containsBytes([2, 4]),
        which: [
          'does not contain the sequence: 02 04',
          'Actual bytes:                 01 02 03 04 05',
        ],
      );
    });

    test('equalsBytes succeeds when equal', () {
      final bytes = Uint8List.fromList([1, 2, 3]);
      check(bytes).equalsBytes([1, 2, 3]);
    });

    testCheckGolden(
      () {
        final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        check(bytes).equalsBytes([1, 2, 99, 4, 5]);
      },
      '''
# equalsBytes failure message golden
Expected: a Uint8List that:
  equals [1, 2, 99, 4, 5]
Actual: [1, 2, 3, 4, 5]
Which: differs at offset 2:
Actual:   01 02 [03] 04 05
Expected: 01 02 [63] 04 05''',
    );

    testCheckGolden(
      () {
        final bytes = Uint8List.fromList(utf8.encode('hello world'));
        check(
          bytes,
        ).equalsBytes(Uint8List.fromList(utf8.encode('hello World')));
      },
      '''
# equalsBytes failure message golden with ASCII
Expected: a Uint8List that:
  equals [104, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100]
Actual: [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100]
Which: differs at offset 6:
Actual:   ... e l l o   [w] o r l d
Expected: ... e l l o   [W] o r l d''',
    );

    testCheckGolden(
      () {
        final bytes = Uint8List.fromList(utf8.encode('hello\nworld'));
        check(
          bytes,
        ).equalsBytes(Uint8List.fromList(utf8.encode('hello\nWorld')));
      },
      '''
# equalsBytes failure message golden with control character falls back to hex
Expected: a Uint8List that:
  equals [104, 101, 108, 108, 111, 10, 87, 111, 114, 108, 100]
Actual: [104, 101, 108, 108, 111, 10, 119, 111, 114, 108, 100]
Which: differs at offset 6:
Actual:   ... 65 6c 6c 6f 0a [77] 6f 72 6c 64
Expected: ... 65 6c 6c 6f 0a [57] 6f 72 6c 64''',
    );
    test('works on regular List<int>', () {
      final list = [104, 101, 108, 108, 111];
      check(list).asUtf8.equals('hello');
    });

    testCheckGolden(
      () {
        final bytes = Uint8List.fromList(utf8.encode('hello world'));
        check(bytes).containsBytes(Uint8List.fromList(utf8.encode('word')));
      },
      '''
# containsBytes failure message golden with ASCII
Expected: a Uint8List that:
  contains bytes [119, 111, 114, 100]
Actual: [104, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100]
Which: does not contain the sequence: w o r d
Actual bytes:                 h e l l o   w o r l d''',
    );
  });
}
