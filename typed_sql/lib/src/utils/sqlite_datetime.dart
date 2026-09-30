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

/// Encode [value] as `YYYY-MM-DDTHH:MM:SS.ffffffZ` in UTC for SQLite.
///
/// SQLite stores timestamps as text and compares them as strings, so all
/// timestamps must have the same number of fractional digits for string order
/// to match chronological order. [DateTime.toIso8601String] omits the
/// microseconds when they are zero.
String encodeSqliteDateTime(DateTime value) {
  final s = value.toUtc().toIso8601String();
  if (value.microsecond == 0) {
    return '${s.substring(0, s.length - 1)}000Z';
  }
  return s;
}
