// Copyright 2023 Google LLC
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

import 'package:pub_semver/pub_semver.dart';

extension ExpectJson on Map<String, Object?> {
  bool expectBool(String key) {
    if (this[key] case bool v) return v;
    throw FormatException('"$key" must be a bool');
  }

  bool? optionalBool(String key) {
    final value = this[key];
    if (value == null) return null;
    if (value case bool v) return v;
    throw FormatException('"$key" must be a bool or null');
  }

  num expectNumber(String key) {
    if (this[key] case num v) return v;
    throw FormatException('"$key" must be a number');
  }

  String expectString(String key) {
    if (this[key] case String v) return v;
    throw FormatException('"$key" must be a string');
  }

  String? optionalString(String key) {
    final value = this[key];
    if (value == null) return null;
    if (value case String v) return v;
    throw FormatException('"$key" must be a string or null');
  }

  Uri expectUri(String key) {
    try {
      return Uri.parse(expectString(key));
    } on FormatException {
      throw FormatException('"$key" must be a URI');
    }
  }

  Version expectVersion(String key) {
    try {
      return Version.parse(expectString(key));
    } on FormatException {
      throw FormatException('"$key" must be a version');
    }
  }

  List<Object?> expectList(String key) {
    if (this[key] case List<Object?> v) return v;
    throw FormatException('"$key" must be a list');
  }

  Map<String, Object?> expectMap(String key) {
    if (this[key] case Map<String, Object?> v) return v;
    throw FormatException('"$key" must be a map');
  }

  Iterable<Map<String, Object?>> expectListObjects(String key) sync* {
    final list = expectList(key);
    for (final entry in list) {
      if (entry case Map<String, Object?> v) {
        yield v;
      } else {
        throw FormatException('"$key" must be a list of map');
      }
    }
  }

  Iterable<String> expectListStrings(String key) sync* {
    final list = expectList(key);
    for (final entry in list) {
      if (entry case String v) {
        yield v;
      } else {
        throw FormatException('"$key" must be a list of string');
      }
    }
  }
}
