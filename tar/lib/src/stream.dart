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

import 'dart:async';
import 'dart:math';
import 'sparse_entry.dart';

/// Generates a stream of the sparse file contents of size [size], given
/// [sparseHoles] and the raw content in [source].
Stream<List<int>> sparseStream(
    Stream<List<int>> source, List<SparseEntry> sparseHoles, int size) {
  ArgumentError.checkNotNull(source, 'source');
  ArgumentError.checkNotNull(sparseHoles, 'sparseHoles');
  ArgumentError.checkNotNull(size, 'size');

  if (sparseHoles.isEmpty) {
    return ChunkedStreamIterator(source).substream(size);
  }

  return _sparseStream(source, sparseHoles, size);
}

/// Generates a stream of the sparse file contents of size [size], given
/// [sparseHoles] and the raw content in [source].
///
/// [sparseHoles] has to be non-empty.
Stream<List<int>> _sparseStream(
    Stream<List<int>> source, List<SparseEntry> sparseHoles, int size) async* {
  ArgumentError.checkNotNull(source, 'source');
  ArgumentError.checkNotNull(sparseHoles, 'sparseHoles');
  ArgumentError.checkNotNull(size, 'size');

  if (sparseHoles.isEmpty) {
    ArgumentError.value(
        sparseHoles, 'sparseHoles', 'sparseHoles should not be empty!');
  }

  /// Current logical position in sparse file.
  var position = 0;

  /// Index of the next sparse hole in [sparseHoles] to be processed.
  var sparseHoleIndex = 0;

  /// Iterator through [source] to obtain the data bytes.
  final iterator = ChunkedStreamIterator(source);

  while (position < size) {
    /// Yield all the necessary sparse holes.
    while (sparseHoleIndex < sparseHoles.length &&
        sparseHoles[sparseHoleIndex].offset == position) {
      final sparseHole = sparseHoles[sparseHoleIndex];
      yield List<int>.filled(sparseHole.length, 0);
      position += sparseHole.length;
      sparseHoleIndex++;
    }

    if (position == size) break;

    /// Yield up to the next sparse hole's offset, or all the way to the end
    /// if there are no sparse holes left.
    var yieldTo = size;
    if (sparseHoleIndex < sparseHoles.length) {
      yieldTo = sparseHoles[sparseHoleIndex].offset;
    }

    for (final chunk in await iterator.read(yieldTo - position)) {
      yield chunk;
    }
    position = yieldTo;
  }
}

/// Implementation of a Stream iterator that reads a chunked stream of [List<T>].
class ChunkedStreamIterator<T> {
  /// Underlying iterator that iterates through the original stream.
  final StreamIterator<List<T>> _iterator;

  /// Keeps track of the number of elements left in the current substream.
  int _toRead = 0;

  /// Keeps track of the current substream we are supporting.
  int _substreamId = 0;

  /// Buffered items from a previous chunk. Items in this list should not have
  /// been read by the user.
  List<T> _buffered = [];

  ChunkedStreamIterator(Stream<List<T>> stream)
      : _iterator = StreamIterator(stream);

  /// Returns a list of the next [size] elements in original chunks. The size of
  /// the chunks are not guaranteed to be consistent.
  ///
  /// Returns a list with a total of less than [size] elements split in chunks
  /// if the end of stream is encounted before [size] elements are read.
  ///
  /// If an error is encountered before reading [size] elements, the error
  /// will be thrown.
  Future<List<List<T>>> read(int size) async {
    /// Clears the remainder of elements if the user did not drain it.
    final readToIndex = min(_toRead, _buffered.length);
    _buffered = _buffered.sublist(readToIndex);
    _toRead -= readToIndex;

    while (_toRead > 0 && await _iterator.moveNext()) {
      if (_toRead < _iterator.current.length) {
        _buffered = _iterator.current.sublist(_toRead);
        _toRead = 0;
      } else {
        _toRead -= _iterator.current.length;
        _buffered = [];
      }
    }

    final result = <List<T>>[];

    /// Starts by adding from the buffer if there are buffered elements
    /// remaining.
    if (_buffered.isNotEmpty) {
      final addToIndex = min(size, _buffered.length);
      result.add(_buffered.sublist(0, addToIndex));
      _buffered = _buffered.sublist(addToIndex);
      size -= addToIndex;
    }

    /// Grab as many chunks as needed and add them to [result], updating
    /// [_buffered] as necessary.
    while (size > 0 && await _iterator.moveNext()) {
      _buffered = _iterator.current;

      final addToIndex = min(size, _buffered.length);
      result.add(_buffered.sublist(0, addToIndex));
      _buffered = _buffered.sublist(addToIndex);
      size -= addToIndex;
    }

    return result;
  }

  /// Returns a list of the next [size] elements.
  ///
  /// Returns a list with less than [size] elements if the end of stream is
  /// encounted before [size] elements are read.
  ///
  /// If an error is encountered before reading [size] elements, the error
  /// will be thrown.
  Future<List<T>> readAsBlock(int size) async {
    return (await read(size)).expand((element) => element).toList();
  }

  /// Cancels the stream iterator (and the underlying stream subscription) early.
  ///
  /// The [ChunkedStreamIterator] is automatically cancelled if [read] goes
  /// reaches the end of the stream or an error.
  ///
  /// Users should call [cancel] to ensure that the stream is properly closed
  /// if they need to stop listening earlier than the end of the stream.
  Future<void> cancel() async => await _iterator.cancel();

  /// Creates a sub-[Stream] with the next [size] elements.
  ///
  /// The resulting stream may contain less than [size] elements if the
  /// underlying stream has less than [size] elements before the end of stream.
  ///
  /// If [read] is called before the sub-[Stream] is fully read, the remainder
  /// of the elements in the sub-[Stream] will be automatically drained.
  Stream<List<T>> substream(int size) {
    _toRead = size;
    _substreamId++;

    return _substream(_substreamId);
  }

  Stream<List<T>> _substream(int substreamId) async* {
    /// Only yield when we are dealing with the same substream and there are
    /// elements to be read.
    while (_substreamId == substreamId && _toRead > 0) {
      if (_buffered.isEmpty) {
        if (!(await _iterator.moveNext())) {
          break;
        }

        _buffered = _iterator.current;
      }

      final yieldBlockEnd = min(_toRead, _buffered.length);
      final toYield = _buffered.sublist(0, yieldBlockEnd);
      _buffered = _buffered.sublist(yieldBlockEnd);

      _toRead -= yieldBlockEnd;

      yield toYield;
    }
  }
}
