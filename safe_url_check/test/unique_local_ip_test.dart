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

import 'dart:io';
import 'package:test/test.dart';
import 'package:safe_url_check/src/unique_local_ip.dart';

void main() {
  test('isUniqueLocalIpV6', () {
    expect(isUniqueLocalIpV6(InternetAddress('::1')), isFalse);

    expect(isUniqueLocalIpV6(InternetAddress('2001:db8::1')), isFalse);
    expect(
        isUniqueLocalIpV6(
            InternetAddress('fd07:a47c:3742:823e:3b02:76:982b:463')),
        isTrue);
  });
}
