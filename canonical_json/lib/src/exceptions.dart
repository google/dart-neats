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

/// Exception thrown when encountering invalid input during decoding of
/// canonical JSON.
///
/// If accepting canonical JSON from an untrusted source, it's a good idea to
/// use the JSON decoder provided in this package to ensure that data was
/// encoded as canonical JSON and not just JSON. Catching this exception is
/// important for gracefully handling non-canonical JSON from untrusted sources.
abstract class InvalidCanonicalJsonException implements Exception {
  List<int> get input;
  int get offset;
  String get message;

  @override
  String toString() => '$message at $offset in input';
}
