// Copyright 2022 Google LLC
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

extension MapExt<K, V> on Map<K, V> {
  /// Returns [Map] that only retains key/value pairs satisfying [test].
  Map<K, V> where(bool Function(K key, V value) test) =>
      Map.fromEntries(entries.where((e) => test(e.key, e.value)));

  /// Map key/value pairs to a list.
  Iterable<T> mapPairs<T>(T Function(K key, V value) fn) =>
      entries.map((e) => fn(e.key, e.value));
}
