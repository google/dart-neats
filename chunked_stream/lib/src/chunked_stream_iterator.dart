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
import 'dart:math';

import 'package:chunked_stream/src/read_chunked_stream.dart';

/// Auxiliary class for iterating over the items in a chunked stream.
///
/// A _chunked stream_ is a stream in which items arrives in chunks with each
/// event from the stream. A common example is a byte stream with the type
/// `Stream<List<int>>`. In such a byte stream bytes arrives in chunks
/// `List<int>` for each event.
///
/// Note. methods on this class may not be called concurrently.
abstract class ChunkedStreamIterator<T> {
  factory ChunkedStreamIterator(Stream<List<T>> stream) {
    return _ChunkedStreamIterator<T>(stream);
  }

  /// Returns a list of the next [size] elements.
  ///
  /// Returns a list with less than [size] elements if the end of stream is
  /// encounted before [size] elements are read.
  ///
  /// If an error is encountered before reading [size] elements, the error
  /// will be thrown.
  Future<List<T>> read(int size);

  /// Cancels the stream iterator (and the underlying stream subscription)
  /// early.
  ///
  /// The [ChunkedStreamIterator] is automatically cancelled if [read] reaches
  /// the end of the stream or an error.
  ///
  /// Users should call [cancel] to ensure that the stream is properly closed
  /// if they need to stop listening earlier than the end of the stream.
  Future<void> cancel();

  /// Creates a sub-[Stream] with the next [size] elements.
  ///
  /// The resulting stream may contain less than [size] elements if the
  /// underlying stream has less than [size] elements before the end of stream.
  ///
  /// If [read] is called before the sub-[Stream] is fully read, the remainder
  /// of the elements in the sub-[Stream] will be automatically drained.
  Stream<List<T>> substream(int size);
}

/// General purpose _chunked stream iterator_.
class _ChunkedStreamIterator<T> implements ChunkedStreamIterator<T> {
  /// Underlying iterator that iterates through the original stream.
  final StreamIterator<List<T>> _iterator;

  /// Keeps track of the number of elements left in the current substream.
  int _toRead = 0;

  /// Keeps track of the current substream we are supporting.
  int _substreamId = 0;

  /// Instance variable representing an empty list object, used as the empty
  /// default state for [_buffered]. Take caution not to write code that
  /// directly modify the [_buffered] list by adding elements to it.
  final List<T> _emptyList = [];

  /// Buffered items from a previous chunk. Items in this list should not have
  /// been read by the user.
  List<T> _buffered;

  _ChunkedStreamIterator(Stream<List<T>> stream)
      : _iterator = StreamIterator(stream) {
    _buffered = _emptyList;
  }

  /// Returns a list of the next [size] elements.
  ///
  /// Returns a list with less than [size] elements if the end of stream is
  /// encounted before [size] elements are read.
  ///
  /// If an error is encountered before reading [size] elements, the error
  /// will be thrown.
  @override
  Future<List<T>> read(int size) async {
    /// Clears the remainder of elements if the user did not drain it.
    final readToIndex = min(_toRead, _buffered.length);
    _buffered = (readToIndex == _buffered.length)
        ? _emptyList
        : _buffered.sublist(readToIndex);
    _toRead -= readToIndex;

    while (_toRead > 0 && await _iterator.moveNext()) {
      if (_toRead < _iterator.current.length) {
        _buffered = _iterator.current.sublist(_toRead);
        _toRead = 0;
      } else {
        _toRead -= _iterator.current.length;
        _buffered = _emptyList;
      }
    }

    return readChunkedStream(substream(size));
  }

  /// Cancels the stream iterator (and the underlying stream subscription)
  /// early.
  ///
  /// The [ChunkedStreamIterator] is automatically cancelled if [read]
  /// reaches the end of the stream or an error.
  ///
  /// Users should call [cancel] to ensure that the stream is properly closed
  /// if they need to stop listening earlier than the end of the stream.
  @override
  Future<void> cancel() async => await _iterator.cancel();

  /// Creates a sub-[Stream] with the next [size] elements.
  ///
  /// The resulting stream may contain less than [size] elements if the
  /// underlying stream has less than [size] elements before the end of stream.
  ///
  /// If [read] is called before the sub-[Stream] is fully read, the remainder
  /// of the elements in the sub-[Stream] will be automatically drained.
  @override
  Stream<List<T>> substream(int size) {
    _toRead = size;
    _substreamId++;

    return _substream(_substreamId);
  }

  Stream<List<T>> _substream(int substreamId) async* {
    /// Only yield when we are dealing with the same substream and there are
    /// elements to be read.
    while (_substreamId == substreamId && _toRead > 0) {
      /// If [_buffered] is empty, set it to the next element in the stream if
      /// possible.
      if (_buffered.isEmpty) {
        if (!(await _iterator.moveNext())) {
          break;
        }

        _buffered = _iterator.current;
      }

      List<T> toYield;
      if (_toRead < _buffered.length) {
        /// If there are less than [_buffered.length] elements left to be read
        /// in the substream, sublist the chunk from [_buffered] accordingly.
        toYield = _buffered.sublist(0, _toRead);
        _buffered = _buffered.sublist(_toRead);
        _toRead = 0;
      } else {
        /// Otherwise prepare to yield the full [_buffered] chunk, updating
        /// the other variables accordingly
        toYield = _buffered;
        _toRead -= _buffered.length;
        _buffered = _emptyList;
      }

      yield toYield;
    }
  }
}
