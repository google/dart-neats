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

/// This library provides a codec for encoding/decoding canonical JSON.
///
/// The [canoncialJson] constant provides a [Codec] for creating a canonical
/// encoding of a JSON value. This library does
/// **not support floating point numbers**. When decoding [canonicalJson.decode]
/// will throw [InvalidCanonicalJsonException] if the input is not valid a
/// canonical JSON encoding. This library is intended for scenarios where JSON
/// values are hashed and/or signed cryptographically.
///
/// JSON as specified in [RFC 8259](https://tools.ietf.org/html/rfc8259) allows
/// for many different encodings of the same JSON value. For example a JSON
/// value can be encoded with:
///  * an infinite combinations of insignificant whitespace,
///  * unnecessary character escaping in strings,
///  * scientific notation for numbers, or,
///  * any ordering of object keys.
///
/// [Canonical JSON](http://wiki.laptop.org/go/Canonical_JSON) is a
/// canonicalized encoding of JSON values, such that for any JSON value that is
/// exactly one _canonical JSON_ encoding of said value.
/// This library provides follows the specification used by the
/// [OLPC project](http://wiki.laptop.org/go/Canonical_JSON), but rather than
/// supporting arbitrary byte values as strings, strings are always encoded as
/// UTF-8 in Unicode Normalization Form C and decoded as UTF-8 causing an
/// [InvalidCanonicalJsonException] exception in case of strings not satisfying
/// this property.
library canonical_json;

import 'dart:convert' show Codec, json;
import 'src/codec.dart' show CanonicalJsonCodec;

export 'src/exceptions.dart' show InvalidCanonicalJsonException;

/// Encode/decode [canonical JSON](http://wiki.laptop.org/go/Canonical_JSON).
///
/// **Encoding** does not support floating-point numbers (including `-0.0`).
/// Encoding the same JSON value always produces the same representation. This
/// is useful when signing JSON objects.
///
/// **Decoding** decodes the value to [List<Object>], [Map<String,Object>],
/// [int], [bool], [String] and `null` similar to [json.Decode]. This also
/// validates that the bytes given is a valid canonical JSON encoding, throwing
/// [InvalidCanonicalJsonException] if this is not the case. Using the
/// [canonicalJson.decode] method ensures that the value returned could not have
/// a different encoding producing the same value. This is useful when
/// validating signed JSON objects.
///
/// **Example**
/// ```dart
/// import 'package:canonical_json/canonical_json.dart';
///
/// void main() {
///   // Encode a message
///   final bytes = canonicalJson.encode({
///     'from': 'alice',
///     'message': 'Hi Bob',
///   });
///   final hash = sha256(bytes); // using a sha256 from some library...
///
///   // Decode message
///   try {
///     final msg = canonicalJson.decode(bytes);
///     if (!fixedTimeEqual(sha256(canonicalJson.encode(msg)), bytes)) {
///       print('Expected a different hash!');
///     }
///     print(msg['message']);
///   } on InvalidCanonicalJsonException {
///     print('Message was not canonical JSON!');
///   }
/// }
/// ```
const Codec<Object?, List<int>> canonicalJson = CanonicalJsonCodec();
