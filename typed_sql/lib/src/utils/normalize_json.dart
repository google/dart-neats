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

import 'package:collection/collection.dart';

import 'fast_unorm.dart' show fastNfc;

/// Wrap JSON [value] such that encoding is likely to be normalized.
///
/// This is a _best-effort_ normalization, notably we shall ensure that:
///  * [Map] keys are sorted, and,
///  * [String] values are re-encoded as [Unicode Normalization Form C][1].
///
/// This method does not encode the JSON, because some databases employ
/// client side JSONB encoding (sqlite). Thus, using a normalized encoding,
/// we'd have to decode before we re-encode as JSONB; unless, we implement a
/// normalized JSONB encoding ourselves. While that might be attractive one day,
/// different databases use a different JSONB encoding.
///
/// A _JSON value_ can be one of the following types:
/// - `null`
/// - [bool] (`true` or `false`),
/// - [int],
/// - [double],
/// - [String],
/// - [List] (where entries are _JSON values_), and,
/// - [Map] (where keys are [String] and values are _JSON values_).
///
/// [1]: https://unicode.org/reports/tr15/
Object? normalizeJson(Object? value) {
  switch (value) {
    case null:
      return null;
    case bool():
      return value;
    case int():
      return value;
    case double():
      return value;
    case String():
      return fastNfc(value);
    case List():
      return value.map(normalizeJson).toList();
    case Map():
      return Map.fromEntries(value.entries.map((e) {
        final k = e.key;
        if (k is! String) {
          throw ArgumentError('Invalid JSON object: keys must be strings!');
        }
        return MapEntry(fastNfc(k), normalizeJson(e.value));
      }).sortedBy((e) => e.key));
    default:
      throw ArgumentError('Invalid JSON object: $value');
  }
}
