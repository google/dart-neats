// Copyright 2020 Google LLC
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

import 'buffer_factory.dart';

/// Wrap [input] as a chunked stream with chunks the size of [N].
///
/// This function returns a [Stream<List<T>>] where each event is a [List<T>]
/// with [N] elements. The last chunk of the resulting stream may contain less
/// than [N] elements.
///
/// This is useful for batch processing elements from a stream.
///
/// A custom [BufferFactory] can be provided via [newBuffer]. A specialized
/// buffer based on `typed_data` can improve memory efficiency.
Stream<List<T>> asChunkedStream<T>(int N, Stream<T> input,
    {BufferFactory<T>? newBuffer}) async* {
  ArgumentError.checkNotNull(N, 'N');
  ArgumentError.checkNotNull(input, 'input');
  if (N <= 0) {
    throw ArgumentError.value(N, 'N', 'chunk size must be >= 0');
  }

  List<T> createBuffer() => newBuffer?.call() ?? <T>[];

  var events = createBuffer();
  await for (final event in input) {
    events.add(event);
    if (events.length >= N) {
      assert(events.length == N);
      yield events;
      events = createBuffer();
    }
  }
  assert(events.length <= N);
  if (events.isNotEmpty) {
    yield events;
  }
}
