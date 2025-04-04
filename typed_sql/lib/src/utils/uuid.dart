// Copyright 2025 Google LLC
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

import 'dart:math' show Random;
import 'dart:typed_data';

import 'package:convert/convert.dart';

final _rng = Random.secure();

/// Fill a buffer of cryptographically random bytes.
Uint8List _randomBytes(int length) {
  final b = Uint8List(length);
  for (var i = 0; i < length; i++) {
    b[i] = _rng.nextInt(255);
  }
  return b;
}

/// Create a new random UUIDv4.
String uuid() {
  final bytes = _randomBytes(16);
  // Set V4 bits according to:
  // https://tools.ietf.org/html/rfc4122#section-4.4
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;

  // Encode as UUIDv4
  final s = hex.encode(bytes).substring;
  return '${s(0, 8)}-${s(8, 12)}-${s(12, 16)}-${s(16, 20)}-${s(20)}';
}
