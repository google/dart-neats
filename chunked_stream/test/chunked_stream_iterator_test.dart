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

import 'dart:async';
import 'package:test/test.dart';
import 'package:chunked_stream/chunked_stream.dart';

Stream<List<T>> _chunkedStream<T>(List<List<T>> chunks) async* {
  for (final chunk in chunks) {
    yield chunk;
  }
}

void main() {
  test('readAsBlock() -- chunk in given size', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(await s.readAsBlock(3), equals(['a', 'b', 'c']));
    expect(await s.readAsBlock(2), equals(['1', '2']));
    expect(await s.readAsBlock(1), equals([]));
  });

  test('readAsBlock() -- chunks one item at the time', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(await s.readAsBlock(1), equals(['a']));
    expect(await s.readAsBlock(1), equals(['b']));
    expect(await s.readAsBlock(1), equals(['c']));
    expect(await s.readAsBlock(1), equals(['1']));
    expect(await s.readAsBlock(1), equals(['2']));
    expect(await s.readAsBlock(1), equals([]));
  });

  test('readAsBlock() -- one big chunk', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(await s.readAsBlock(6), equals(['a', 'b', 'c', '1', '2']));
  });

  test('substream() + readChunkedStream()', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(await readChunkedStream(s.substream(5)),
        equals(['a', 'b', 'c', '1', '2']));
    expect(await s.readAsBlock(1), equals([]));
  });

  test('substream() + readChunkedStream() x 2', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(await readChunkedStream(s.substream(2)), equals(['a', 'b']));
    expect(await readChunkedStream(s.substream(3)), equals(['c', '1', '2']));
  });

  test('substream() + readChunkedStream() -- past end', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(await readChunkedStream(s.substream(6)),
        equals(['a', 'b', 'c', '1', '2']));
    expect(await s.readAsBlock(1), equals([]));
  });

  test('readAsBlock() substream() + readChunkedStream() readAsBlock()',
      () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(await s.readAsBlock(1), equals(['a']));
    expect(await readChunkedStream(s.substream(3)), equals(['b', 'c', '1']));
    expect(await s.readAsBlock(2), equals(['2']));
  });

  test(
      'readAsBlock() substream().cancel() readAsBlock() -- one item at the time',
      () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(await s.readAsBlock(1), equals(['a']));
    final i = StreamIterator(s.substream(3));
    expect(await i.moveNext(), isTrue);
    await i.cancel();
    expect(await s.readAsBlock(1), equals(['2']));
    expect(await s.readAsBlock(1), equals([]));
  });

  test('read() -- chunk in given size', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(
        await s.read(3),
        equals([
          ['a', 'b', 'c']
        ]));
    expect(
        await s.read(2),
        equals([
          ['1', '2']
        ]));
    expect(await s.read(1), equals([]));
  });

  test('read() -- chunks one item at the time', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(
        await s.read(1),
        equals([
          ['a']
        ]));
    expect(
        await s.read(1),
        equals([
          ['b']
        ]));
    expect(
        await s.read(1),
        equals([
          ['c']
        ]));
    expect(
        await s.read(1),
        equals([
          ['1']
        ]));
    expect(
        await s.read(1),
        equals([
          ['2']
        ]));
    expect(await s.read(1), equals([]));
  });

  test('read() -- one big chunk', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(
        await s.read(6),
        equals([
          ['a', 'b', 'c'],
          ['1', '2']
        ]));
  });

  test('substream()', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(
        await s.substream(5).toList(),
        equals([
          ['a', 'b', 'c'],
          ['1', '2']
        ]));
    expect(await s.read(1), equals([]));
  });

  test('substream() x 2', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(
        await s.substream(2).toList(),
        equals([
          ['a', 'b']
        ]));
    expect(
        await s.substream(3).toList(),
        equals([
          ['c'],
          ['1', '2']
        ]));
  });

  test('substream() + readChunkedStream() -- past end', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(
        await s.substream(6).toList(),
        equals([
          ['a', 'b', 'c'],
          ['1', '2']
        ]));
    expect(await s.read(1), equals([]));
  });

  test('read() substream() + readChunkedStream() read()', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(
        await s.read(1),
        equals([
          ['a']
        ]));
    expect(
        await s.substream(3).toList(),
        equals([
          ['b', 'c'],
          ['1']
        ]));
    expect(
        await s.read(2),
        equals([
          ['2']
        ]));
  });

  test('read() substream().cancel() read() -- one item at the time', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(
        await s.read(1),
        equals([
          ['a']
        ]));
    final i = StreamIterator(s.substream(3));
    expect(await i.moveNext(), isTrue);
    await i.cancel();
    expect(
        await s.read(1),
        equals([
          ['2']
        ]));
    expect(await s.read(1), equals([]));
  });

  test('read() substream().cancel() read() -- cancellation without reading',
      () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(
        await s.read(1),
        equals([
          ['a']
        ]));
    final i = StreamIterator(s.substream(3));
    await i.cancel();
    expect(
        await s.read(1),
        equals([
          ['2']
        ]));
    expect(await s.read(1), equals([]));
  });

  test(
      'read() substream().cancel() read() -- not cancelling still produces '
      'correct behavior', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(
        await s.read(1),
        equals([
          ['a']
        ]));
    final i = StreamIterator(s.substream(3));
    expect(
        await s.read(1),
        equals([
          ['2']
        ]));
    expect(await i.moveNext(), false);
    expect(await s.read(1), equals([]));
  });

  test(
      'read() substream().cancel() read() -- not cancelling still produces '
      'correct behavior (2)', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2', '3'],
    ]));
    expect(
        await s.read(1),
        equals([
          ['a']
        ]));
    final i = StreamIterator(s.substream(2));
    expect(
        await s.read(1),
        equals([
          ['1']
        ]));
    // ignore: unused_local_variable
    final i2 = StreamIterator(s.substream(2));
    expect(await i.moveNext(), false);
    expect(await s.read(1), equals([]));
  });

  test(
      'read() substream() that ends with first chunk + readChunkedStream() '
      'read()', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(
        await s.read(1),
        equals([
          ['a']
        ]));
    expect(
        await s.substream(2).toList(),
        equals([
          ['b', 'c']
        ]));
    expect(
        await s.read(3),
        equals([
          ['1', '2']
        ]));
  });

  test(
      'read() substream() that ends with first chunk + drain() '
      'read()', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
    ]));
    expect(
        await s.read(1),
        equals([
          ['a']
        ]));
    final sub = s.substream(2);
    await sub.drain();
    expect(
        await s.read(3),
        equals([
          ['1', '2']
        ]));
  });

  test(
      'read() substream() that ends with second chunk + readChunkedStream() '
      'read()', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
      ['3', '4']
    ]));
    expect(
        await s.read(1),
        equals([
          ['a']
        ]));
    expect(
        await s.substream(4).toList(),
        equals([
          ['b', 'c'],
          ['1', '2']
        ]));
    expect(
        await s.read(3),
        equals([
          ['3', '4']
        ]));
  });

  test(
      'read() substream() that ends with second chunk + drain() '
      'read()', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
      ['3', '4'],
    ]));
    expect(
        await s.read(1),
        equals([
          ['a']
        ]));
    final substream = s.substream(4);
    await substream.drain();
    expect(
        await s.read(3),
        equals([
          ['3', '4']
        ]));
  });

  test('read() substream() read() before draining substream', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b', 'c'],
      ['1', '2'],
      ['3', '4'],
    ]));
    expect(
        await s.read(1),
        equals([
          ['a']
        ]));
    final substream = s.substream(4);
    expect(
        await s.read(3),
        equals([
          ['3', '4']
        ]));
    expect(await substream.length, 0);
  });

  test('nested ChunkedStreamIterator', () async {
    final s = ChunkedStreamIterator(_chunkedStream([
      ['a', 'b'],
      ['1', '2'],
      ['3', '4'],
    ]));
    expect(
        await s.read(1),
        equals([
          ['a']
        ]));
    final substream = s.substream(4);
    final nested = ChunkedStreamIterator(substream);
    expect(
        await nested.read(2),
        equals([
          ['b'],
          ['1']
        ]));
    expect(
        await nested.read(3),
        equals([
          ['2'],
          ['3']
        ]));
    expect(await nested.read(2), equals([]));
    expect(
        await s.read(1),
        equals([
          ['4']
        ]));
  });
}
