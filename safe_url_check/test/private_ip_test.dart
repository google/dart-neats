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
import 'package:safe_url_check/src/private_ip.dart';

void main() {
  test('isPrivateIpV4', () {
    expect(isPrivateIpV4(InternetAddress('1.1.1.1')), isFalse);
    expect(isPrivateIpV4(InternetAddress('127.0.0.1')), isFalse);

    expect(isPrivateIpV4(InternetAddress('10.0.0.0')), isTrue);
    expect(isPrivateIpV4(InternetAddress('10.255.0.0')), isTrue);
    expect(isPrivateIpV4(InternetAddress('192.168.255.0')), isTrue);
    expect(isPrivateIpV4(InternetAddress('192.168.0.0')), isTrue);
    expect(isPrivateIpV4(InternetAddress('192.168.0.100')), isTrue);

    expect(isPrivateIpV4(InternetAddress('168.255.0.0')), isFalse);
    expect(isPrivateIpV4(InternetAddress('192.169.255.0')), isFalse);
  });
}
