// Copyright 2026 Google LLC
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

import 'package:checks_ext/src/core/uridata.dart';
import '../util.dart';

void main() {
  group('UriDataChecks', () {
    test('properties extract correct values', () {
      final data = UriData.parse(
        'data:text/plain;charset=utf-8;base64,aGVsbG8=',
      );
      check(data)
        ..mimeType.equals('text/plain')
        ..charset.equals('utf-8')
        ..isBase64()
        ..contentText.equals('aGVsbG8=')
        ..contentAsString.equals('hello')
        ..contentAsBytes.deepEquals([
          104,
          101,
          108,
          108,
          111,
        ]); // 'hello' in ASCII
    });

    test('isBase64 succeeds when base64', () {
      final data = UriData.parse('data:text/plain;base64,aGVsbG8=');
      check(data).isBase64();
    });

    test('isBase64 fails when not base64', () {
      final data = UriData.parse('data:text/plain,hello');
      check(data).isRejectedBy((it) => it.isBase64(), which: ['is not base64']);
    });
  });
}
