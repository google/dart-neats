// Copyright 2018 Google LLC
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

import 'dart:ffi';

import 'package:test/test.dart';
import 'package:retry/retry.dart';

void main() {
  group('RetryOptions', () {
    test('default delay', () {
      // Since this test is random we'll run it a 1k times...
      for (var j = 0; j < 1000; j++) {
        final ivt = [
          0,
          400,
          800,
          1600,
          3200,
          6400,
          12800,
          25600,
        ];
        var r = RetryOptions();
        for (var i = 0; i < ivt.length; i++) {
          final d = r.delay(i).inMilliseconds;
          expect(d, inInclusiveRange(ivt[i] * 0.74, ivt[i] * 1.26));
        }
      }
    });
    
    test('avoid overflow', () {
      final r = RetryOptions();
      expect(r.delay(64), r.maxDelay);
    });

    test('retry (success)', () async {
      var count = 0;
      final r = RetryOptions();
      final f = r.retry(() {
        count++;
        return true;
      });
      expect(f, completion(isTrue));
      expect(count, equals(1));
    });

    test ('stream (success)', () async {
      s() async *{
        yield 1;
        yield 2;
        yield 3;
      }
      final r = RetryOptions();
      final rStream = r.stream(s);
      final results = await rStream.toList();
      expect(results, equals([1, 2, 3]));
    });


    test('retry (unhandled exception)', () async {
      var count = 0;
      final r = RetryOptions(
        maxAttempts: 5,
      );
      final f = r.retry(() {
        count++;
        throw Exception('Retry will fail');
      }, retryIf: (e) => false);
      await expectLater(f, throwsA(isException));
      expect(count, equals(1));
    });


    test ('stream (unhandled exception)', () async {
      var count = 0;
      s() async *{
        yield 1;
        count++;
        throw Exception('Stream will fail');
      }
      final r = RetryOptions(
        maxAttempts: 5,
      );
      final rStream = r.stream(s,
        retryIf: (e) => false
      );
      await expectLater(rStream.toList(), throwsA(isException));
      expect(count, equals(1));
    });

    test('retry (retryIf, exhaust retries)', () async {
      var count = 0;
      final r = RetryOptions(
        maxAttempts: 5,
        maxDelay: Duration(),
      );
      final f = r.retry(() {
        count++;
        throw FormatException('Retry will fail');
      }, retryIf: (e) => e is FormatException);
      await expectLater(f, throwsA(isFormatException));
      expect(count, equals(5));
    });
    test ('stream (retryIf, exhaust retries)', () async {
      var count = 0;
      s() async *{
        yield 1;
        count++;
        throw FormatException('Retry will fail');
      }
      final r = RetryOptions(
        maxAttempts: 5,
        maxDelay: Duration(),
      );
      final rStream = r.stream(s,
        retryIf: (e) => e is FormatException
      );
      await expectLater(rStream.toList, throwsA(isFormatException));
      expect(count, equals(5));
    });
    test('retry (success after 2)', () async {
      var count = 0;
      final r = RetryOptions(
        maxAttempts: 5,
        maxDelay: Duration(),
      );
      final f = r.retry(() {
        count++;
        if (count == 1) {
          throw FormatException('Retry will be okay');
        }
        return true;
      }, retryIf: (e) => e is FormatException);
      await expectLater(f, completion(isTrue));
      expect(count, equals(2));
    });
    test ('stream (success after 2)', () async {
      var count = 0;
      final r = RetryOptions(
        maxAttempts: 5,
        maxDelay: Duration(),
      );
      final rStream = r.stream(() async *{
        count++;
        if (count == 1) {
          throw FormatException('Retry will be okay');
        }
        yield true;
      }, retryIf: (e) => e is FormatException);
      expect(await rStream.toList(), equals([true]));
      expect(count, equals(2));
    });
    test('retry (no retryIf)', () async {
      var count = 0;
      final r = RetryOptions(
        maxAttempts: 5,
        maxDelay: Duration(),
      );
      final f = r.retry(() {
        count++;
        if (count == 1) {
          throw FormatException('Retry will be okay');
        }
        return true;
      });
      await expectLater(f, completion(isTrue));
      expect(count, equals(2));
    });
    test('stream (no retryIf)', () async {
      var count = 0;
      final r = RetryOptions(
        maxAttempts: 5,
        maxDelay: Duration(),
      );
      final rStream = r.stream(() async *{
        count++;
        if (count == 1) {
          throw FormatException('Retry will be okay');
        }
        yield true;
      });
      final results = await rStream.toList();
      expect(count, equals(2));
      expect(results, equals([true]));
    });
    test('retry (unhandled on 2nd try)', () async {
      var count = 0;
      final r = RetryOptions(
        maxAttempts: 5,
        maxDelay: Duration(),
      );
      final f = r.retry(() {
        count++;
        if (count == 1) {
          throw FormatException('Retry will be okay');
        }
        throw Exception('unhandled thing');
      }, retryIf: (e) => e is FormatException);
      await expectLater(f, throwsA(isException));
      expect(count, equals(2));
    });
    test('stream (unhandled on 2nd try)', () async {
      var count = 0;
      final r = RetryOptions(
        maxAttempts: 5,
        maxDelay: Duration(),
      );
      final f = r.stream(() async *{
        count++;
        if (count == 1) {
          throw FormatException('Retry will be okay');
        }
        throw RangeError('unhandled thing');
      }, retryIf: (e) => e is FormatException);
      await expectLater(f.toList, throwsA(isRangeError));
      expect(count, equals(2));
    });

  });
}
