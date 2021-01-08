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

import 'package:test/test.dart';
import 'package:chunked_stream/chunked_stream.dart';
import 'package:typed_data/typed_buffers.dart';

void main() {
  test('readChunkedStream', () async {
    final s = (() async* {
      yield ['a'];
      yield ['b'];
      yield ['c'];
    })();
    expect(await readChunkedStream(s), equals(['a', 'b', 'c']));
  });

  test('readChunkedStream with custom buffer', () {
    final s = (() async* {
      yield [1, 2, 3];
      yield [4, 5];
      yield [6];
    })();

    expect(readChunkedStream(s, newBuffer: () => Uint8Buffer()),
        completion(isA<Uint8Buffer>().having((b) => b.length, 'length', 6)));
  });
}
