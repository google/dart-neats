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

/// Wraps a JSON [value].
///
/// {@template JsonValue-allows-types}
/// A _JSON value_ can be one of the following types:
/// - `null`
/// - [bool] (`true` or `false`),
/// - [int],
/// - [double],
/// - [String],
/// - [List] (where entries are _JSON values_), and,
/// - [Map] (where keys are [String] and values are _JSON values_).
/// {@endtemplate}
final class JsonValue {
  /// The JSON value held by this object.
  ///
  /// {@macro JsonValue-allows-types}
  final Object? value;

  JsonValue(this.value) : assert(_isJsonValue(value));

  /// Check if [value] is a valid JSON value.
  ///
  /// That is check if it can be encoded as JSON.
  static bool _isJsonValue(Object? value) {
    if (value == null ||
        value is bool ||
        value is int ||
        value is double ||
        value is String) {
      return true;
    }
    if (value is List) {
      return value.every(_isJsonValue);
    }
    if (value is Map) {
      return value.entries
          .every((e) => e.key is String && _isJsonValue(e.value));
    }
    return false;
  }
}
