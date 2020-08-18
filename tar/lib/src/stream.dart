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

import 'constants.dart';
import 'header.dart';

/// Generates a stream of the sparse file contents given [sparseHoles] and
/// the raw content in [source].
Stream<List<int>> sparseStream(
    Stream<List<int>> source, List<SparseEntry> sparseHoles, int size) async* {
  ArgumentError.checkNotNull(source, 'source');
  ArgumentError.checkNotNull(sparseHoles, 'sparseHoles');
  ArgumentError.checkNotNull(size, 'size');

  /// Current logical position in sparse file, including the bytes in
  /// [partialChunk].
  var position = 0;

  /// Part of chunk left over after each chunk in source.
  /// Guaranteed to have a length <= [blockSize].
  var partialChunk = <int>[];

  /// Index of the next sparse hole to be processed.
  var sparseHoleIndex = 0;

  /// Grab a new chunk from [source].
  await for (final chunk in source) {
    /// Index of the chunk element we are examining.
    /// Satisfies `0 <= chunkIndex < blockSize`.
    var chunkIndex = 0;

    /// While we haven't processed the full chunk
    while (chunkIndex < chunk.length) {
      /// Add all the sparse holes to [partialChunk] if necessary.
      while (sparseHoleIndex < sparseHoles.length) {
        final sparseHole = sparseHoles[sparseHoleIndex];
        if (sparseHole.offset == position) {
          partialChunk.addAll(List<int>.filled(sparseHole.length, 0));
          position += sparseHole.length;
          sparseHoleIndex++;
        } else {
          break;
        }
      }

      partialChunk.add(chunk[chunkIndex]);
      chunkIndex++;
      position++;
    }

    /// At this point the full chunk is processed. Yield as many sparse
    /// chunks as required.
    var partialChunkIndex = 0;
    while (partialChunkIndex + blockSize <= partialChunk.length &&
        partialChunkIndex + blockSize < size) {
      yield partialChunk.sublist(
          partialChunkIndex, partialChunkIndex + blockSize);
      partialChunkIndex += blockSize;
    }

    if (partialChunk.length >= size) {
      yield partialChunk.sublist(partialChunkIndex, size);
      return;
    }

    /// Remove the chunks that have been yielded.
    partialChunk = partialChunk.sublist(partialChunkIndex);
  }

  /// Add final partial chunk to output stream, if any.
  if (partialChunk.isNotEmpty) yield partialChunk;
}
