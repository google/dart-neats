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

import 'dart:typed_data';
import '../util.dart';

extension EndianChecksExt on Subject<Endian> {
  /// Expects that the endianness is the host endianness.
  ///
  /// {@example /example/typed_data/endian/is_host.dart}
  void isHost() {
    context.expect(() => ['is Endian.host'], (actual) {
      if (actual == Endian.host) return null;
      return Rejection(
        which: ['is ${actual == Endian.big ? 'Endian.big' : 'Endian.little'}'],
      );
    });
  }

  /// Expects that the endianness is big-endian.
  ///
  /// {@example /example/typed_data/endian/is_big_endian.dart}
  void isBigEndian() {
    context.expect(() => ['is Endian.big'], (actual) {
      if (actual == Endian.big) return null;
      return Rejection(which: ['is Endian.little']);
    });
  }

  /// Expects that the endianness is little-endian.
  ///
  /// {@example /example/typed_data/endian/is_little_endian.dart}
  void isLittleEndian() {
    context.expect(() => ['is Endian.little'], (actual) {
      if (actual == Endian.little) return null;
      return Rejection(which: ['is Endian.big']);
    });
  }
}
