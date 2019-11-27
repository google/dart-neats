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
import 'package:safe_url_check/safe_url_check.dart';

void testValidUrl(String url) => test('safeUrlCheck("$url")', () async {
      expect(await safeUrlCheck(Uri.parse(url)), isTrue);
    });

void testInvalidUrl(String url) => test('!safeUrlCheck("$url")', () async {
      expect(await safeUrlCheck(Uri.parse(url)), isFalse);
    });

void main() {
  testValidUrl('https://google.com');
  testValidUrl('https://github.com');
  testValidUrl('https://github.com/google/dart-neats.git');
  testInvalidUrl('https://github.com/google/dart-neats.git/bad-url');
}
