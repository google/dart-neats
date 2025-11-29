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

import 'dart:convert';

import 'package:checks/context.dart';
import 'package:collection/collection.dart';
import 'package:typed_sql/typed_sql.dart';

extension JsonValueSubjectExt on Subject<JsonValue> {
  void deepEquals(JsonValue other) =>
      context.expect(() => ['matches JSON'], (v) {
        final equality = const DeepCollectionEquality();
        final a = json.decode(json.encode(v.value));
        final b = json.decode(json.encode(other.value));
        if (equality.equals(a, b)) {
          return null;
        }
        return Rejection();
      });
}
