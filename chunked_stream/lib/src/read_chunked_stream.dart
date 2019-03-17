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

import 'dart:async' show Stream, Future;

/// Read all chunks from [input] and return a list consistent of items from all
/// chunks.
///
/// If the maximum number of items exceeded [maxSize] this will stop reading and
/// throw [MaximumSizeExceeded].
///
/// **Example**
/// ```dart
/// import 'dart:io';
///
/// List<int> readFile(String filePath) async {
///   Stream<List<int>> fileStream = File(filePath).openRead();
///   List<int> contents = await readChunkedStream(fileStream);
///   return contents;
/// }
/// ```
Future<List<T>> readChunkedStream<T>(
  Stream<List<T>> input, {
  int maxSize,
}) async {
  ArgumentError.checkNotNull(input, 'input');
  if (maxSize != null && maxSize < 0) {
    throw ArgumentError.value(maxSize, 'maxSize must be positive, if given');
  }

  final result = <T>[];
  await for (final chunk in input) {
    result.addAll(chunk);
    if (maxSize != null && result.length > maxSize) {
      throw MaximumSizeExceeded(maxSize);
    }
  }
  return result;
}

/// Create a _chunked stream_ limited to the first [maxSize] items from [input].
///
/// Throws [MaximumSizeExceeded] if [input] contains more than [maxSize] items.
Stream<List<T>> limitChunkedStream<T>(
  Stream<List<T>> input, {
  int maxSize,
}) async* {
  ArgumentError.checkNotNull(input, 'input');
  if (maxSize != null && maxSize < 0) {
    throw ArgumentError.value(maxSize, 'maxSize must be positive, if given');
  }

  int count = 0;
  await for (final chunk in input) {
    if (maxSize != null && maxSize - count < chunk.length) {
      yield chunk.sublist(0, maxSize - count);
      throw MaximumSizeExceeded(maxSize);
    }
    count += chunk.length;
    yield chunk;
  }
}

/// Exception thrown if [maxSize] was exceeded while reading a _chunked stream_.
class MaximumSizeExceeded implements Exception {
  final int maxSize;
  const MaximumSizeExceeded(this.maxSize);
  @override
  String toString() =>
      'Input stream exceeded the maxSize: $maxSize passed to readChunkedStream';
}
