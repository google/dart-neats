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

import 'dart:convert';
import 'dart:math';
import 'package:collection/collection.dart';
import '../util.dart';

extension ListIntChecksExt on Subject<List<int>> {
  /// Decodes the bytes as a UTF-8 string.
  ///
  /// {@example /example/core/list/as_utf8.dart}
  Subject<String> get asUtf8 =>
      context.nest(() => ['as UTF-8 string'], (bytes) {
        try {
          return Extracted.value(utf8.decode(bytes));
        } catch (e) {
          return Extracted.rejection(which: ['is not valid UTF-8']);
        }
      });

  /// Expects that this byte list is valid UTF-8.
  ///
  /// {@example /example/core/list/is_valid_utf8.dart}
  void isValidUtf8() {
    context.expect(() => ['is valid UTF-8'], (actual) {
      try {
        utf8.decode(actual);
        return null;
      } catch (e) {
        return Rejection(which: ['is not valid UTF-8']);
      }
    });
  }

  /// Expects that this byte list contains the given [sequence] of bytes.
  ///
  /// {@example /example/core/list/contains_bytes.dart}
  void containsBytes(List<int> sequence) {
    context.expect(() => prefixFirst('contains bytes ', literal(sequence)), (
      actual,
    ) {
      if (sequence.isEmpty) return null;

      for (var i = 0; i <= actual.length - sequence.length; i++) {
        var match = true;
        for (var j = 0; j < sequence.length; j++) {
          if (actual[i + j] != sequence[j]) {
            match = false;
            break;
          }
        }
        if (match) return null;
      }

      bool isPrintable(int byte) => byte >= 32 && byte <= 126;
      final allPrintable =
          actual.every(isPrintable) && sequence.every(isPrintable);

      String toDisplay(List<int> bytes) {
        return bytes
            .map((byte) {
              return allPrintable
                  ? String.fromCharCode(byte)
                  : byte.toRadixString(16).padLeft(2, '0');
            })
            .join(' ');
      }

      final actualDisplay = toDisplay(actual);
      final sequenceDisplay = toDisplay(sequence);

      return Rejection(
        which: [
          'does not contain the sequence: $sequenceDisplay',
          'Actual bytes:                 $actualDisplay',
        ],
      );
    });
  }

  /// Expects that this byte list equals [expected] bytes, showing diff in hex.
  ///
  /// {@example /example/core/list/equals_bytes.dart}
  void equalsBytes(List<int> expected) {
    context.expect(() => prefixFirst('equals ', literal(expected)), (actual) {
      if (const ListEquality().equals(actual, expected)) return null;

      int? diffIndex;
      final minLen = min(actual.length, expected.length);
      for (var i = 0; i < minLen; i++) {
        if (actual[i] != expected[i]) {
          diffIndex = i;
          break;
        }
      }

      diffIndex ??= minLen;

      final start = max(0, diffIndex - 5);
      final endActual = min(actual.length, diffIndex + 5);
      final endExpected = min(expected.length, diffIndex + 5);

      final actualSnippet = actual.sublist(start, endActual);
      final expectedSnippet = expected.sublist(start, endExpected);

      bool isPrintable(int byte) => byte >= 32 && byte <= 126;
      final allPrintable =
          actualSnippet.every(isPrintable) &&
          expectedSnippet.every(isPrintable);

      String toDisplay(
        List<int> bytes,
        int markIndex,
        int startOffset,
        int totalLength,
      ) {
        final parts = <String>[];
        if (startOffset > 0) parts.add('...');
        for (var i = 0; i < bytes.length; i++) {
          final byte = bytes[i];
          final representation = allPrintable
              ? String.fromCharCode(byte)
              : byte.toRadixString(16).padLeft(2, '0');
          if (startOffset + i == markIndex) {
            parts.add('[$representation]');
          } else {
            parts.add(representation);
          }
        }
        if (startOffset + bytes.length < totalLength) parts.add('...');
        return parts.join(' ');
      }

      final actualDisplay = toDisplay(
        actualSnippet,
        diffIndex,
        start,
        actual.length,
      );
      final expectedDisplay = toDisplay(
        expectedSnippet,
        diffIndex,
        start,
        expected.length,
      );

      return Rejection(
        which: [
          'differs at offset $diffIndex:',
          'Actual:   $actualDisplay',
          'Expected: $expectedDisplay',
        ],
      );
    });
  }
}
