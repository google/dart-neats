// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'covering_index_test.dart';

// **************************************************************************
// Generator: _TypedSqlBuilder
// **************************************************************************

/// Extension methods for a [Database] operating on [Directory].
extension DirectorySchema on Database<Directory> {
  static final _$tables = [_$Contact._$table];

  Table<Contact> get contacts =>
      $ForGeneratedCode.declareTable(this, _$Contact._$table);

  /// Create tables defined in [Directory].
  ///
  /// Calling this on an empty database will create the tables
  /// defined in [Directory]. In production it's often better to
  /// use [createDirectoryTables] and manage migrations using
  /// external tools.
  ///
  /// This method is mostly useful for testing.
  ///
  /// > [!WARNING]
  /// > If the database is **not empty** behavior is undefined, most
  /// > likely this operation will fail.
  Future<void> createTables() async =>
      $ForGeneratedCode.createTables(context: this, tables: _$tables);
}

/// Get SQL [DDL statements][1] for tables defined in [Directory].
///
/// This returns a SQL script with multiple DDL statements separated by `;`
/// using the specified [dialect].
///
/// Executing these statements in an empty database will create the tables
/// defined in [Directory]. In practice, this method is often used for
/// printing the DDL statements, such that migrations can be managed by
/// external tools.
///
/// [1]: https://en.wikipedia.org/wiki/Data_definition_language
String createDirectoryTables(SqlDialect dialect) => $ForGeneratedCode
    .createTableSchema(dialect: dialect, tables: DirectorySchema._$tables);

final class _$Contact extends Contact {
  _$Contact._(this.id, this.lastName, this.firstName, this.phone, this.email);

  @override
  final int id;

  @override
  final String lastName;

  @override
  final String firstName;

  @override
  final String phone;

  @override
  final String email;

  static final _$table = $ForGeneratedCode.tableDefinition(
    tableName: 'contacts',
    columns: <String>['id', 'lastName', 'firstName', 'phone', 'email'],
    columnInfo: [
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.integer,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: true,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [
          (
            dialect: 'mysql',
            columnType: 'VARCHAR(255)',
            defaultValue: null,
            collation: null,
          ),
        ],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [
          (
            dialect: 'mysql',
            columnType: 'VARCHAR(255)',
            defaultValue: null,
            collation: null,
          ),
        ],
      ),
      $ForGeneratedCode.columnDefinition(
        type: $ForGeneratedCode.text,
        isNotNull: true,
        defaultValue: null,
        autoIncrement: false,
        overrides: [],
      ),
    ],
    primaryKey: <String>['id'],
    unique: <List<String>>[],
    foreignKeys: [],
    indexes: [
      $ForGeneratedCode.indexDefinition(
        name: null,
        sqlName: null,
        columns: ['phone'],
        method: .btree,
        covering: ['lastName'],
      ),
      $ForGeneratedCode.indexDefinition(
        name: null,
        sqlName: null,
        columns: ['lastName'],
        method: .btree,
        covering: ['email'],
      ),
    ],
    readRow: _$Contact._$fromDatabase,
  );

  static Contact? _$fromDatabase(RowReader row) {
    final id = row.readInt();
    final lastName = row.readString();
    final firstName = row.readString();
    final phone = row.readString();
    final email = row.readString();
    if (id == null &&
        lastName == null &&
        firstName == null &&
        phone == null &&
        email == null) {
      return null;
    }
    return _$Contact._(id!, lastName!, firstName!, phone!, email!);
  }

  @override
  String toString() =>
      'Contact(id: "$id", lastName: "$lastName", firstName: "$firstName", phone: "$phone", email: "$email")';
}

/// Extension methods for table defined in [Contact].
extension TableContactExt on Table<Contact> {
  /// Insert row into the `contacts` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Contact> insert({
    Expr<int>? id,
    required Expr<String> lastName,
    required Expr<String> firstName,
    required Expr<String> phone,
    required Expr<String> email,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [id, lastName, firstName, phone, email],
  );

  /// Insert row into the `contacts` table.
  ///
  /// Returns a [InsertSingle] statement on which `.execute` must be
  /// called for the row to be inserted.
  InsertSingle<Contact> insertValue({
    int? id,
    required String lastName,
    required String firstName,
    required String phone,
    required String email,
  }) => $ForGeneratedCode.insertInto(
    table: this,
    values: [
      id?.asExpr,
      lastName.asExpr,
      firstName.asExpr,
      phone.asExpr,
      email.asExpr,
    ],
  );

  /// Bulk insert rows into the `contacts` table.
  ///
  /// This method takes an `Iterable<T>` and requires that you provide
  /// a _mapping function_ from `T` to each column to be inserted.
  ///
  /// If a mapping function is omitted, the _default value_ will be
  /// inserted, or `NULL` if column is nullable and as no default value.
  /// To explicitely insert `NULL`, use a _mapping function_ that maps
  /// `T` to `null`.
  ///
  /// > [!NOTE]
  /// > This method aims utilize database specific bulk insertion logic
  /// > to ensure good performance. Database adapters may pipeline bulk
  /// > insertions through multiple statements inside a transaction.
  ///
  /// Returns a [Insert] statement on which `.execute` must be
  /// called for the rows to be inserted.
  Insert<Contact> insertValuesMapped<T>(
    Iterable<T> rows, {
    int Function(T row)? id,
    required String Function(T row) lastName,
    required String Function(T row) firstName,
    required String Function(T row) phone,
    required String Function(T row) email,
  }) => $ForGeneratedCode.insertValuesMapped(
    table: this,
    rows: rows,
    mappings: [id, lastName, firstName, phone, email],
  );

  /// Delete a single row from the `contacts` table, specified by
  /// _primary key_.
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be
  /// called for the row to be deleted.
  ///
  /// To delete multiple rows, using `.where()` to filter which rows
  /// should be deleted. If you wish to delete all rows, use
  /// `.where((_) => toExpr(true)).delete()`.
  DeleteSingle<Contact> delete(int id) =>
      $ForGeneratedCode.deleteSingle(byKey(id), _$Contact._$table);
}

/// Extension methods for building queries against the `contacts` table.
extension QueryContactExt on Query<(Expr<Contact>,)> {
  /// Lookup a single row in `contacts` table using the _primary key_.
  ///
  /// Returns a [QuerySingle] object, which returns at-most one row,
  /// when `.fetch()` is called.
  QuerySingle<(Expr<Contact>,)> byKey(int id) =>
      where((contact) => contact.id.equalsValue(id)).first;

  /// Update all rows in the `contacts` table matching this [Query].
  ///
  /// The changes to be applied to each row matching this [Query] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [Update] statement on which `.execute()` must be called
  /// for the rows to be updated.
  ///
  /// **Example:** decrementing `1` from the `value` field for each row
  /// where `value > 0`.
  /// ```dart
  /// await db.mytable
  ///   .where((row) => row.value > toExpr(0))
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  Update<Contact> update(
    UpdateSet<Contact> Function(
      Expr<Contact> contact,
      UpdateSet<Contact> Function({
        Expr<int> id,
        Expr<String> lastName,
        Expr<String> firstName,
        Expr<String> phone,
        Expr<String> email,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.update<Contact>(
    this,
    _$Contact._$table,
    (contact) => updateBuilder(
      contact,
      ({
        Expr<int>? id,
        Expr<String>? lastName,
        Expr<String>? firstName,
        Expr<String>? phone,
        Expr<String>? email,
      }) => $ForGeneratedCode.buildUpdate<Contact>([
        id,
        lastName,
        firstName,
        phone,
        email,
      ]),
    ),
  );

  /// Delete all rows in the `contacts` table matching this [Query].
  ///
  /// Returns a [Delete] statement on which `.execute()` must be called
  /// for the rows to be deleted.
  Delete<Contact> delete() => $ForGeneratedCode.delete(this, _$Contact._$table);
}

/// Extension methods for building point queries against the `contacts` table.
extension QuerySingleContactExt on QuerySingle<(Expr<Contact>,)> {
  /// Update the row (if any) in the `contacts` table matching this
  /// [QuerySingle].
  ///
  /// The changes to be applied to the row matching this [QuerySingle] are
  /// defined using the [updateBuilder], which is given an [Expr]
  /// representation of the row being updated and a `set` function to
  /// specify which fields should be updated. The result of the `set`
  /// function should always be returned from the `updateBuilder`.
  ///
  /// Returns an [UpdateSingle] statement on which `.execute()` must be
  /// called for the row to be updated. The resulting statement will
  /// **not** fail, if there are no rows matching this query exists.
  ///
  /// **Example:** decrementing `1` from the `value` field the row with
  /// `id = 1`.
  /// ```dart
  /// await db.mytable
  ///   .byKey(1)
  ///   .update((row, set) => set(
  ///     value: row.value - toExpr(1),
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  UpdateSingle<Contact> update(
    UpdateSet<Contact> Function(
      Expr<Contact> contact,
      UpdateSet<Contact> Function({
        Expr<int> id,
        Expr<String> lastName,
        Expr<String> firstName,
        Expr<String> phone,
        Expr<String> email,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateSingle<Contact>(
    this,
    _$Contact._$table,
    (contact) => updateBuilder(
      contact,
      ({
        Expr<int>? id,
        Expr<String>? lastName,
        Expr<String>? firstName,
        Expr<String>? phone,
        Expr<String>? email,
      }) => $ForGeneratedCode.buildUpdate<Contact>([
        id,
        lastName,
        firstName,
        phone,
        email,
      ]),
    ),
  );

  /// Delete the row (if any) in the `contacts` table matching this [QuerySingle].
  ///
  /// Returns a [DeleteSingle] statement on which `.execute()` must be called
  /// for the row to be deleted. The resulting statement will **not**
  /// fail, if there are no rows matching this query exists.
  DeleteSingle<Contact> delete() =>
      $ForGeneratedCode.deleteSingle(this, _$Contact._$table);
}

/// Extension methods for expressions on a row in the `contacts` table.
extension ExpressionContactExt on Expr<Contact> {
  Expr<int> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String> get lastName =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String> get firstName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String> get phone =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<String> get email =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.text);
}

extension ExpressionNullableContactExt on Expr<Contact?> {
  Expr<int?> get id =>
      $ForGeneratedCode.field(this, 0, $ForGeneratedCode.integer);

  Expr<String?> get lastName =>
      $ForGeneratedCode.field(this, 1, $ForGeneratedCode.text);

  Expr<String?> get firstName =>
      $ForGeneratedCode.field(this, 2, $ForGeneratedCode.text);

  Expr<String?> get phone =>
      $ForGeneratedCode.field(this, 3, $ForGeneratedCode.text);

  Expr<String?> get email =>
      $ForGeneratedCode.field(this, 4, $ForGeneratedCode.text);

  /// Check if the row is not `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNotNull() => id.isNotNull();

  /// Check if the row is `NULL`.
  ///
  /// This will check if _primary key_ fields in this row are `NULL`.
  ///
  /// If this is a reference lookup by subquery it might be more efficient
  /// to check if the referencing field is `NULL`.
  Expr<bool> isNull() => isNotNull().not();
}

/// `Table<Contact>` conflict targets for use with `.onConflict`.
enum ContactConflict {
  /// Conflict with an existing row that has a matching primary key.
  ///
  /// Thus, the other row has matching values for:
  /// `id`.
  primaryKey(['id']);

  const ContactConflict(this._fields);

  final List<String> _fields;
}

extension InsertContactExt on Insert<Contact> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((contact, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflict<Contact> onConflict(ContactConflict target) =>
      $ForGeneratedCode.insertOnConflict(this, target._fields);
}

extension InsertOnConflictContactExt on InsertOnConflict<Contact> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `contact` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  Upsert<Contact> update(
    UpdateSet<Contact> Function(
      Expr<Contact> contact,
      Expr<Contact> excluded,
      UpdateSet<Contact> Function({
        Expr<int> id,
        Expr<String> lastName,
        Expr<String> firstName,
        Expr<String> phone,
        Expr<String> email,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflict<Contact>(
    this,
    (contact, excluded) => updateBuilder(
      contact,
      excluded,
      ({
        Expr<int>? id,
        Expr<String>? lastName,
        Expr<String>? firstName,
        Expr<String>? phone,
        Expr<String>? email,
      }) => $ForGeneratedCode.buildUpdate<Contact>([
        id,
        lastName,
        firstName,
        phone,
        email,
      ]),
    ),
  );
}

extension InsertSingleContactExt on InsertSingle<Contact> {
  /// Build an `INSERT` statement with an `ON CONFLICT` clause.
  ///
  /// The [target] argument specifies the _conflict target_ to be
  /// handled. The _conflict target_ is always a `UNIQUE` constraint or
  /// `PRIMARY KEY` constraint.
  ///
  /// If a row to be inserted violates the _conflict target_ constraint,
  /// then the conflict action is triggered:
  /// * `.doNothing()` to skip insertion of the new row, and,
  /// * `.update((contact, excluded, set) => set(...))` to
  ///   update the conflicting row.
  ///
  /// If a row to be inserted violates a constraint other than the one
  /// specified in _conflict target_ then the entire `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...)` in SQL.
  InsertOnConflictSingle<Contact> onConflict(ContactConflict target) =>
      $ForGeneratedCode.insertOnConflictSingle(this, target._fields);
}

extension InsertOnConflictSingleContactExt on InsertOnConflictSingle<Contact> {
  /// Build an `INSERT` statement an [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing
  /// row is updated using the expressions defined with the
  /// [updateBuilder]. The [updateBuilder] is given 3 parameters:
  ///   * `contact` an [Expr] representing the existing row in
  ///     the database,
  ///   * `excluded` an [Expr] representing the row to be inserted in the
  ///     database, and,
  ///   * `set` a function to specify which fields should be updated and
  ///     build the [UpdateSet].
  ///
  /// The result of the `set` function should always be immediately
  /// returned from the [updateBuilder].
  ///
  /// **Example:** Insert a counter with `count = 2` or increment the
  /// existing row, if a `PRIMARY KEY` conflict occurs.
  /// ```dart
  /// await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .execute();
  /// ```
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ...` in SQL.
  ///
  /// > [!WARNING]
  /// > The `updateBuilder` callback does not make the update, it builds
  /// > the expressions for updating the rows. You should **never** invoke
  /// > the `set` function more than once, and the result should always
  /// > be returned immediately.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  UpsertSingle<Contact> update(
    UpdateSet<Contact> Function(
      Expr<Contact> contact,
      Expr<Contact> excluded,
      UpdateSet<Contact> Function({
        Expr<int> id,
        Expr<String> lastName,
        Expr<String> firstName,
        Expr<String> phone,
        Expr<String> email,
      })
      set,
    )
    updateBuilder,
  ) => $ForGeneratedCode.updateOnConflictSingle<Contact>(
    this,
    (contact, excluded) => updateBuilder(
      contact,
      excluded,
      ({
        Expr<int>? id,
        Expr<String>? lastName,
        Expr<String>? firstName,
        Expr<String>? phone,
        Expr<String>? email,
      }) => $ForGeneratedCode.buildUpdate<Contact>([
        id,
        lastName,
        firstName,
        phone,
        email,
      ]),
    ),
  );
}

/// Extension methods for assertions on [Contact] using
/// [`package:checks`][1].
///
/// [1]: https://pub.dev/packages/checks
extension ContactChecks on Subject<Contact> {
  /// Create assertions on [Contact.id].
  Subject<int> get id => has((m) => m.id, 'id');

  /// Create assertions on [Contact.lastName].
  Subject<String> get lastName => has((m) => m.lastName, 'lastName');

  /// Create assertions on [Contact.firstName].
  Subject<String> get firstName => has((m) => m.firstName, 'firstName');

  /// Create assertions on [Contact.phone].
  Subject<String> get phone => has((m) => m.phone, 'phone');

  /// Create assertions on [Contact.email].
  Subject<String> get email => has((m) => m.email, 'email');
}
