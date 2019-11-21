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

import 'dart:async' show Future;
import 'package:safe_url_check/safe_url_check.dart';

Future<void> main() async {
  // Check if https://google.com is a broken URL.
  final exists = await safeUrlCheck(
    Uri.parse('https://google.com'),
    userAgent: 'myexample/1.0.0 (+https://example.com)',
  );
  if (exists) {
    print('The url: https://google.com is NOT broken');
  }
}
