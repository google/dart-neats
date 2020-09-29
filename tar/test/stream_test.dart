import 'dart:async';

import 'package:tar/src/stream.dart';
import 'package:test/test.dart';

Stream<List<T>> _chunkedStream<T>(List<List<T>> chunks) async* {
  for (final chunk in chunks) {
    yield chunk;
  }
}

void main() {
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
