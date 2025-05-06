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

/// Annotation for a table specifying its primary key.
///
/// {@category schema}
final class PrimaryKey {
  final List<String> fields;

  const PrimaryKey(this.fields);
}

/// Annotation for a field that has a default value, specified by [value].
///
/// {@category schema}
final class DefaultValue<T> {
  final T value;

  const DefaultValue(this.value);
}

/// Annotation for a field that should be auto-incremented (by default).
///
/// {@category schema}
final class AutoIncrement {
  const AutoIncrement();
}

/// Annotation for fields that references fields from another table.
///
/// {@category schema}
/// {@category foreign_keys}
final class References {
  final String table;
  final String field;
  final String? as;
  final String? name;

  const References({
    required this.table,
    required this.field,
    this.as,
    this.name,
  });
}

/// Annotation for declaring a _composite foreign key_.
///
/// {@category schema}
/// {@category foreign_keys}
final class ForeignKey {
  final List<String> foreignKey;
  final String table;
  final List<String> fields;
  final String? as;
  final String? name;

  const ForeignKey(
    this.foreignKey, {
    required this.table,
    required this.fields,
    this.name,
    this.as,
  });
}

/// Annotation for a unique field.
///
/// {@category schema}
final class Unique {
  // TODO: Consider allowing a `given: ['foo', 'bar']` argument for fields
  //       that are unique given fields 'foo' and 'bar'.
  const Unique();
}

/// Interface to be implemented by custom types that can be stored in a [Row]
/// for automatic (de)-serialization.
///
/// Subclasses must:
///  * specify a concrete `T` that will be the serialized representation type. As one of:
///    - String
///    - Uint8List
///    - bool
///    - int
///    - double
///    - DateTime
///  * have a `fromDatabase(T value)` constructor.
///
/// If a subclass implements [Comparable] then the encoded values returned by
/// [toDatabase] **must** also be comparable and have the same ordering!
///
/// > [!TIP]
/// > Custom types are not required to be _immutable_ but using an immutable
/// > type is recommended. The analyzer can help with you this if you use the
/// > `@immutable` annotation from [`package:meta`][1].
///
/// [1]: https://pub.dev/packages/meta
///
/// {@category schema}
/// {@category custom_data_types}
abstract interface class CustomDataType<T extends Object?> {
  T toDatabase();
}
