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

/// This library contains the [Slugid] class for working slugids.
///
/// A slugid is a URL-safe base64 encoded UUId v4 stripped of `==` padding.
/// These are useful when embedding random UUIDs in URLs. The [Slugid] class in
/// this library wraps a slugid and allows you to obtain the string
/// representation, raw bytes, or the UUID representation.
library slugid;

import 'dart:convert';
import 'src/random.dart';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:meta/meta.dart' show sealed;

final _uuidPattern = RegExp(
    r'[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}');

final _slugidPattern = RegExp(
    r'[A-Za-z0-9_-]{8}[Q-T][A-Za-z0-9_-][CGKOSWaeimquy26-][A-Za-z0-9_-]{10}[AQgw]');

/// A slugid is a URL-safe base64 encoded UUID v4 stripped of `==` padding.
///
/// This is just a compact encoding of UUIDs, that makes them safe to embed in
/// URLs. A slugid is 22 characters long and looks as follows:
///  * `U_sWAEJnR4epXu-TK0FCYA`
///  * `-8prq-8rTGqKl2W9SSfyDQ`
///  * `ti8C-AKGQsq3rDjSuXe94w`
///  * `Fum-zBhASyO50rg3mtQcD`
///
/// As it is often useful to pass slugids as arguments to command line tools it
/// can be a good idea to use the _nice_ form, which ensures that the slugid
/// cannot start with a dash `-`. This comes at the cost of one bit of
/// randomness. _Nice_ slugids looks as follows:
///  * `fUKuE0DcTqOvgvgRl0JHTQ`
///  * `XT77loITSg6FYZjwoR7y8w`
///  * `KIIrne-pSFuFz-zIFtGMeA`
///  * `L_YriPk0RLuLyU8zb638oA`
///
/// Instances of the [Slugid] class can be serialized to string using the
/// [toString()] method. This is implicitely called when using string
/// interpolation in dart.
///
/// **Example**
/// ```dart
/// import 'package:slugid/slugid.dart';
///
/// print('New id: ${Slugid.nice()}');
/// ```
@sealed
class Slugid {
  final Uint8List _bytes;

  /// Create a [Slugid] from slugid string or UUID string.
  Slugid(String id) : _bytes = Uint8List(16) {
    ArgumentError.checkNotNull(id, 'id');

    if (id.length == 22 && _slugidPattern.hasMatch(id)) {
      _bytes.setAll(0, base64Url.decode('$id=='));
    } else if (id.length == 36 && _uuidPattern.hasMatch(id)) {
      _bytes.setAll(0, hex.decode(id.replaceAll('-', '')));
    } else {
      throw ArgumentError.value(id, 'id', 'id is not a uuid or slugid');
    }
  }

  /// Create a slugid from v4 UUID, that is a random slugid.
  ///
  /// This is a Url-safe base64 encoded UUID v4.
  Slugid.v4() : _bytes = randomBytes(16) {
    // Set V4 bits according to:
    // https://tools.ietf.org/html/rfc4122#section-4.4
    _bytes[6] = (_bytes[6] & 0x0f) | 0x40;
    _bytes[8] = (_bytes[8] & 0x3f) | 0x80;
  }

  /// Create a slugid in _nice_ format.
  ///
  /// This is a Url-safe base64 encoded UUID v4, with the first bit cleared to
  /// ensure that the base64 encoded identifier doesn't start with dash `-`.
  /// This costs some entropy, but makes the slugid _nice_ to use in command
  /// line utilitites, as it doesn't start with dash.
  Slugid.nice() : _bytes = Slugid.v4()._bytes {
    // Clear the first bit to ensure [A-Za-f] as first character
    _bytes[0] = _bytes[0] & 0x7f;
  }

  /// Render the slugid in it's UUID string representation.
  String uuid() {
    final s = hex.encode(_bytes).substring;
    return '${s(0, 8)}-${s(8, 12)}-${s(12, 16)}-${s(16, 20)}-${s(20)}';
  }

  /// Get the raw bytes forming the unencoded slugid.
  List<int> bytes() {
    return Uint8List.fromList(_bytes);
  }

  /// Get the Url-safe base64 encoded slugid.
  ///
  /// This is a 22 characters string with `==` padding stripped.
  @override
  String toString() => base64Url.encode(_bytes).substring(0, 22);

  /// Compare slugid to [other] slugid.
  ///
  /// This method also accepts string representations of slugids and UUIDs.
  @override
  bool operator ==(dynamic other) {
    // If other is a string we try to decode it.
    if (other is String) {
      try {
        other = Slugid(other);
      } on ArgumentError {
        return false;
      }
    }
    // If other is a slugid, we compare bytes.
    if (other is Slugid) {
      for (var i = 0; i < _bytes.length; i++) {
        if (_bytes[i] != other._bytes[i]) {
          return false;
        }
      }
      return true;
    }
    return false;
  }
}
