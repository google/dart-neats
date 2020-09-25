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
// limitations under the License.import 'constants.dart';

import 'dart:async';
import 'sparse_entry.dart';

/// Generates a stream of the sparse file contents of size [size], given
/// [sparseHoles] and the raw content in [source].
Stream<int> sparseStream(
    Stream<int> source, List<SparseEntry> sparseHoles, int size) async* {
  ArgumentError.checkNotNull(source, 'source');
  ArgumentError.checkNotNull(sparseHoles, 'sparseHoles');
  ArgumentError.checkNotNull(size, 'size');

  /// Current logical position in sparse file, including the bytes in
  /// [partialChunk].
  var position = 0;

  /// Index of the next sparse hole in [sparseHoles] to be processed.
  var sparseHoleIndex = 0;

  /// Iterator through [source] to obtain the data bytes.
  final iterator = StreamIterator(source);

  while (position < size) {
    /// Yield all the necessary sparse holes.
    while (sparseHoleIndex < sparseHoles.length &&
        sparseHoles[sparseHoleIndex].offset == position) {
      final sparseHole = sparseHoles[sparseHoleIndex];
      for (final byte in List<int>.filled(sparseHole.length, 0)) {
        yield byte;
      }
      position += sparseHole.length;
      sparseHoleIndex++;
    }

    if (position == size) break;

    /// Grab a new chunk from [source].
    if (!await iterator.moveNext()) {
      throw StateError('sparseStream size is larger than what the stream '
          'supports!');
    }
    yield iterator.current;
    position++;
  }
}

/// Implementation of a Stream iterator that reads a chunked stream of [List<T>].
class ChunkedStreamIterator<T> {
  /// Underlying iterator that iterates through the original stream.
  final StreamIterator<T> _iterator;

  /// Keeps track of the number of elements left in the current substream.
  int _toRead = 0;

  /// Keeps track of the current substream we are supporting.
  int _substreamId = 0;

  ChunkedStreamIterator(Stream<List<T>> stream)
      : _iterator = StreamIterator(stream.expand((element) => element));

  /// Returns a block of the next [size] elements.
  ///
  /// Returns a list with less than [size] elements if the end of stream is
  /// encounted before [size] elements are read.
  ///
  /// If an error is encountered before reading [size] elements, the error
  /// will be thrown.
  Future<List<T>> read(int size) async {
    /// Clears the remainder of elements if the user forgot to drain it.
    while (_toRead > 0 && await _iterator.moveNext()) {
      _toRead--;
    }

    final result = <T>[];

    while (size-- > 0 && await _iterator.moveNext()) {
      result.add(_iterator.current);
    }

    return result;
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
  Stream<T> substream(int size) {
    _toRead = size;
    _substreamId++;

    return _substream(_substreamId);
  }

  Stream<T> _substream(int substreamId) async* {
    /// Only yield when we are dealing with the same substream and there are
    /// elements to be read.
    while (_substreamId == substreamId &&
        _toRead > 0 &&
        await _iterator.moveNext()) {
      _toRead--;
      yield _iterator.current;
    }
  }
}
