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
  ///  * [int],
  ///  * [double], or,
  ///  * [JsonValue].
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

/// Represents the referential actions applied to a foreign key
/// or a reference, during an UPDATE or DELETE operation on the
/// parent table.
///
/// {@category schema}
/// {@category foreign_keys}
enum ReferentialAction {
  /// Delete or update the child table when the referenced row is deleted or updated.
  ///
  /// This is the equivalent of `ON DELETE CASCADE` or `ON UPDATE CASCADE` in SQL.
  cascade,

  /// Prevent the deletion or update of a referenced row.
  ///
  /// This is the equivalent of `ON DELETE RESTRICT` or `ON UPDATE RESTRICT` in
  /// SQL. The check is performed immediately.
  restrict,

  /// Set the foreign key columns in the child table to `NULL` when the
  /// referenced row is deleted or updated.
  ///
  /// This is the equivalent of `ON DELETE SET NULL` or `ON UPDATE SET NULL` in SQL.
  setNull,

  /// Set the foreign key columns in the child table to their default values
  /// when the referenced row is deleted or updated.
  ///
  /// This is the equivalent of `ON DELETE SET DEFAULT` or
  /// `ON UPDATE SET DEFAULT` in SQL.
  setDefault,

  /// Similar to [restrict], but the check is deferred until the end of the
  /// transaction.
  ///
  /// This is the equivalent of `ON DELETE NO ACTION` or `ON UPDATE NO ACTION` in SQL.
  noAction,
}

/// Defines the deferrability and initial state of a database constraint.
///
/// {@category schema}
/// {@category foreign_keys}
enum Deferrability {
  /// The constraint is checked immediately after every individual SQL statement.
  /// It cannot be deferred to the end of a transaction.
  ///
  /// This is the equivalent of `NOT DEFERRABLE`.
  alwaysImmediate,

  /// The constraint check can be deferred, but by default, it is checked
  /// immediately after every statement.
  ///
  /// This is the equivalent of `DEFERRABLE INITIALLY IMMEDIATE`.
  initiallyImmediate,

  /// The constraint check is deferred by default and is only validated
  /// at the end of the transaction (COMMIT).
  ///
  /// This is the equivalent of `DEFERRABLE INITIALLY DEFERRED`.
  initiallyDeferred,
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
  final ReferentialAction onDelete;
  final ReferentialAction onUpdate;
  final Deferrability deferrability;

  const References({
    required this.table,
    required this.field,
    this.as,
    this.name,
    ReferentialAction? onDelete,
    ReferentialAction? onUpdate,
    Deferrability? deferrability,
  }) : onDelete = onDelete ?? .noAction,
       onUpdate = onUpdate ?? .noAction,
       deferrability = deferrability ?? .alwaysImmediate;
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
  final ReferentialAction onDelete;
  final ReferentialAction onUpdate;
  final Deferrability deferrability;

  const ForeignKey(
    this.foreignKey, {
    required this.table,
    required this.fields,
    this.name,
    this.as,
    ReferentialAction? onDelete,
    ReferentialAction? onUpdate,
    Deferrability? deferrability,
  }) : onDelete = onDelete ?? .noAction,
       onUpdate = onUpdate ?? .noAction,
       deferrability = deferrability ?? .alwaysImmediate;
}

/// Annotation to define `UNIQUE` constraints.
///
/// {@category schema}
final class Unique {
  // ignore: unused_field
  final String? _name; // used by code-gen
  // ignore: unused_field
  final List<String>? _fields; // used by code-gen

  /// Add a composite `UNIQUE` constraint covering multiple fields.
  ///
  /// The optional [name] parameter specifies the [name] used when generating
  /// auxiliary `.by<name>(...)` methods to lookup rows using the covered
  /// fields.
  ///
  /// In the example below `db.users.byFullName(String firstName, String lastName)`
  /// will be generated, and allow lookup of `User` rows by `firstName` and
  /// `lastName`.
  ///
  /// **Example:**
  /// ```dart
  /// @PrimaryKey(['id'])
  /// @Unique(
  ///   name: 'fullname',
  ///   // Enforce unique `firstName` and `lastName` for each row!
  ///   fields: ['firstName', 'lastName'],
  /// )
  /// abstract final class User extends Row {
  ///   int get id;
  ///
  ///   String get firstName;
  ///   String get lastName;
  /// }
  /// ```
  ///
  /// > [!TIP]
  /// > If you only want to make a single field `UNIQUE`, you may use the
  /// > [Unique.field] annotation instead.
  const Unique({String? name, required List<String> fields})
    : _name = name ?? '-',
      _fields = fields;

  /// Add `UNIQUE` constraint to a single field.
  ///
  /// To create a _composite `UNIQUE`_ constraint, use the [Unique] annotation
  /// at the _row class_ level.
  ///
  /// The optional [name] parameter specifies the [name] used when generating
  /// auxiliary `.by<name>(...)` methods to lookup rows using the unique field.
  ///
  /// If [name] is not specified, it'll default to the name of the field.
  /// Specify dash `'-'` as name, to omit generation of the `.by<name>` method.
  ///
  /// In the example, below `db.accounts.byAccountNumber(String accountNumber)`
  /// will be generated, and allow lookup of `Account` rows by `accountNumber`.
  ///
  /// **Example:**
  /// ```dart
  /// @PrimaryKey(['accountId'])
  /// abstract final class Account extends Row {
  ///   int get accountId;
  ///
  ///   // Enforce unique `accountNumber` for each row!
  ///   @Unique.field()
  ///   String get accountNumber;
  /// }
  /// ```
  const Unique.field({String? name}) : _name = name, _fields = null;
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
