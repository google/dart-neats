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

/// Annotation that assigns a _default value_ to a field.
///
/// Using this annotation on a non-nullable field, also causes the field
/// to be _optional_ when inserting rows.
///
/// {@category schema}
final class DefaultValue {
  // ignore: unused_field
  final ({String kind, Object value}) _value; // decoded by code-gen

  // Note:
  // The encoding of default value here is read by code-generation.
  // This encoding matches the one used in table definition, though this is
  // not strictly a requirement. However, there is reason to use two different
  // encodings.

  const DefaultValue._(String kind, Object value)
      : _value = (kind: kind, value: value);

  /// Annotate a field with a constant default value.
  ///
  /// The [value] must be one of the following types:
  ///  * [String],
  ///  * [bool],
  ///  * [int], or,
  ///  * [double].
  ///
  /// Consequently, this constructor can only be used to annotate a
  /// _default value_ to a field of a matching type.
  const DefaultValue(Object value) : _value = (kind: 'raw', value: value);

  /// Annotate a [DateTime] field with a fixed default value.
  ///
  /// This constructor behaves similar to [DateTime.utc], as arguments will all
  /// be interpreted as UTC.
  ///
  /// To use `CURRENT_TIMESTAMP` as default value for a field, see
  /// [DefaultValue.now].
  const DefaultValue.dateTime(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) : _value = (
          kind: 'datetime',
          value: (
            year,
            month,
            day,
            hour,
            minute,
            second,
            millisecond,
            microsecond,
          ),
        );

  /// Annotate a [DateTime] field with a default value of
  /// `1970-01-01T00:00:00Z`.
  static const DefaultValue epoch = DefaultValue._('datetime', 'epoch');

  /// Annotate a [DateTime] field with a default value of `CURRENT_TIMESTAMP`.
  ///
  /// This will cause the field to have a default value of the current timestamp
  /// in UTC, when a row is inserted.
  ///
  /// See [Expr.currentTimestamp] for further details.
  static const DefaultValue now = DefaultValue._('datetime', 'now');
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

/// An annotation to provide overrides for SQL schema generation.
///
/// This can be used multiple times on a single field to specify different
/// overrides for different dialects.
final class SqlOverride {
  /// The dialect this override applies to (e.g. 'mysql', 'postgres', 'sqlite').
  /// If omitted (`null`), the override applies to all dialects.
  final String? dialect;

  /// Overrides the SQL data type definition for the annotated column.
  ///
  /// Example:
  ///  * `VARCHAR(255)`,
  ///  * `DECIMAL(10, 2)`, etc.
  final String? columnType;

  const SqlOverride({
    this.dialect,
    this.columnType,
  });
}
