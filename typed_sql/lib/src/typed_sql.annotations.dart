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

part of 'typed_sql.dart';

/// Annotation for a table specifying it's primary key.
final class PrimaryKey {
  const PrimaryKey(List<String> fields);
}

/// Annotation for references within a table.
final class References {
  const References(Type table, String field);
}

/// Annotation for a property that is unique `given` a few other properties.
final class Unique {
  const Unique({List<String> given = const <String>[]});
}
