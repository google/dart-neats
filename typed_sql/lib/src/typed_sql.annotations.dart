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
  ///
  /// Note for Mysql/Mariadb: This is recognized by the parser, but **IS NOT** supported
  /// by the InnoDB engine. Using this will generally result in an error or be ignored.
  setDefault,

  /// Similar to [restrict], but the check is deferred until the end of the
  /// transaction.
  ///
  /// This is the equivalent of `ON DELETE NO ACTION` or `ON UPDATE NO ACTION` in SQL.
  noAction,
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

  const References({
    required this.table,
    required this.field,
    this.as,
    this.name,
    this.onDelete = .noAction,
    this.onUpdate = .noAction,
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
  final ReferentialAction onDelete;
  final ReferentialAction onUpdate;

  const ForeignKey(
    this.foreignKey, {
    required this.table,
    required this.fields,
    this.name,
    this.as,
    this.onDelete = .noAction,
    this.onUpdate = .noAction,
  });
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
  ///   name: 'fullName',
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

/// Naming scheme for deriving SQL _table_ and _column_ names from Dart
/// identifiers.
///
/// The naming scheme assumes that Dart identifiers follow
/// [Effective Dart][effective-dart], that is:
///  * Class names are in `UpperCamelCase`, and,
///  * Field names are in `lowerCamelCase`.
///
/// The _default_ naming scheme, if not overriden is [camelCase], which uses
/// Dart identifiers as SQL table and column names.
///
/// The [snake_case] naming scheme converts Dart identifiers to lowercase with
/// underscores, as illustrated below:
///  * `userId` becomes `user_id`
///  * `createdAt` becomes `created_at`,
///  * `IPAddress` becomes `ip_address`, and,
///  * `ShoppingCartItem` becomes `shopping_cart_item`.
///
/// > [!NOTE]
/// > To make [snake_case] work well, only capitalize the first letter of
/// > acronyms longer than two characters.
/// > Prefer `HttpParser` over `HTTPParser` as per [Effective Dart][acronyms].
///
/// You can override the naming scheme for a schema, table or field using the
/// appropriate [SqlOverride] annotation.
///
/// [effective-dart]: https://dart.dev/effective-dart/style#identifiers
/// [acronyms]: https://dart.dev/effective-dart/style#do-capitalize-acronyms-and-abbreviations-longer-than-two-letters-like-words
enum Naming {
  /// Use `camelCase` for SQL table and column names.
  ///
  /// This is the default naming scheme, and it is effectively a pass-thru, as
  /// we assume Dart identifiers to be `camelCase`.
  camelCase,

  /// Use `snake_case` for SQL table and column names.
  ///
  /// The `snake_case` is derived from Dart identifiers to lowercase with
  /// underscores, as illustrated below:
  ///  * `userId` becomes `user_id`
  ///  * `createdAt` becomes `created_at`,
  ///  * `IPAddress` becomes `ip_address`, and,
  ///  * `ShoppingCartItem` becomes `shopping_cart_item`.
  ///
  /// > [!NOTE]
  /// > To make [snake_case] work well, only capitalize the first letter of
  /// > acronyms longer than two characters.
  /// > Prefer `HttpParser` over `HTTPParser` as per [Effective Dart][acronyms].
  ///
  /// [acronyms]: https://dart.dev/effective-dart/style#do-capitalize-acronyms-and-abbreviations-longer-than-two-letters-like-words
  snake_case, // ignore: constant_identifier_names
}

/// An annotation to provide overrides for SQL schema DDL generation.
///
/// The `SqlOverride` annotation is used to customize the generated SQL.
/// It provides different named constructors depending on where it is applied:
///
///  * [SqlOverride.schema]: Applied to a _schema class_ to override schema-wide
///    defaults.
///  * [SqlOverride.tableName]: Applied to a table declaration inside a
///    _schema class_ to override the table name.
///  * [SqlOverride.table]: Applied to a _row class_ to override table-wide
///    defaults.
///  * [SqlOverride.field]: Applied to a field declaration inside a _row class_
///    to override column-specific details.
///
/// Overrides are hierarchical. For example, a [Naming] scheme defined on a
/// _schema class_ using [SqlOverride.schema] applies to all its tables and
/// fields, unless specifically overridden at the _row class_ or field level.
///
/// {@category schema}
final class SqlOverride {
  // ignore: unused_field
  final String? _dialect; // used by code-gen
  // ignore: unused_field
  final String? _columnType; // used by code-gen
  // ignore: unused_field
  final String? _defaultValue; // used by code-gen
  // ignore: unused_field
  final String? _collation; // used by code-gen
  // ignore: unused_field
  final String? _name; // used by code-gen
  // ignore: unused_field
  final Naming? _naming; // used by code-gen

  const SqlOverride._({
    String? dialect,
    String? columnType,
    String? defaultValue,
    String? collation,
    String? name,
    Naming? naming,
  }) : // TODO(jonasfj): Consider having an assert, when analyze highlights
       //                it correctly in source code. For now code-gen errors
       //                are actually better.
       // assert(dialect == null || (name == null && naming == null)),
       _dialect = dialect,
       _columnType = columnType,
       _defaultValue = defaultValue,
       _collation = collation,
       _name = name,
       _naming = naming;

  @Deprecated(
    'Use SqlOverride.field(), SqlOverride.table() or SqlOverride.schema() instead',
  )
  const factory SqlOverride({
    String? dialect,
    String? columnType,
  }) = SqlOverride._;

  /// Specify schema-wide [Naming] scheme.
  ///
  /// This annotaiton can be used on a _schema class_ ([Schema] subclass).
  /// It allowed overriding the _default_ [naming] scheme.
  ///
  /// **Example:**
  /// ```dart
  /// @SqlOverride.schema(naming: .snake_case)
  /// abstract final class Bookstore extends Schema {
  ///  Table<Author> get authors;
  ///  Table<Book> get books;
  /// }
  /// ```
  const factory SqlOverride.schema({
    Naming naming,
  }) = SqlOverride._;

  /// Specify overrides for a table in a `Schema`.
  ///
  /// This annotation can be used on a table declaration inside a
  /// _schema class_ ([Schema] subclass). It allows overriding the:
  ///  * SQL table [name] directly, or,
  ///  * [naming] scheme for deriving the SQL table name.
  ///
  /// **Example:**
  /// ```dart
  /// abstract final class Bookstore extends Schema {
  ///   @SqlOverride.tableName(name: 'tbl_books')
  ///   Table<Book> get books;
  /// }
  /// ```
  ///
  /// > [!NOTE]
  /// > This only affects the SQL table name. It does not override the naming
  /// > convention used for the columns within the table.
  /// > To specify a naming convention for the columns, use [SqlOverride.table]
  /// > on the _row class_.
  const factory SqlOverride.tableName({
    String name,
    Naming naming,
  }) = SqlOverride._;

  /// Specify overrides for a _row class_.
  ///
  /// This annotation can be used on a _row class_ (`Row` subclass).
  /// It allows overriding the:
  ///  * [naming] scheme used to derive SQL column names for fields.
  ///
  /// **Example:**
  /// ```dart
  /// @SqlOverride.table(naming: .snake_case)
  /// @PrimaryKey(['id'])
  /// abstract final class Book extends Row {
  ///   // ...
  /// }
  /// ```
  const factory SqlOverride.table({
    Naming naming,
  }) = SqlOverride._;

  /// Specify overrides for a field in a _row class_.
  ///
  /// This annotation can be used on a field declaration inside a _row class_.
  /// It allows overriding the generated SQL:
  ///  * [columnType],
  ///  * [defaultValue],
  ///  * [collation],
  ///  * SQL column [name], or,
  ///  * [naming] scheme used to derive the SQL column name.
  ///
  /// Providing a [dialect] (e.g., `'postgres'` or `'sqlite'`) restricts the
  /// overrides to only apply when generating SQL for that specific dialect.
  ///
  /// **Example:**
  /// ```dart
  /// @PrimaryKey(['id'])
  /// abstract final class Book extends Row {
  ///   int get id;
  ///
  ///   @SqlOverride.field(name: 'book_title')
  ///   @SqlOverride.field(dialect: 'postgres', columnType: 'VARCHAR(255)')
  ///   String get title;
  /// }
  /// ```
  ///
  /// > [!WARNING]
  /// > Overriding [name] or [naming] is not allowed when a [dialect] is
  /// > provided, as SQL column names cannot be dialect-specific.
  const factory SqlOverride.field({
    String dialect,
    String columnType,
    String defaultValue,
    String collation,
    String name,
    Naming naming,
  }) = SqlOverride._;
}
