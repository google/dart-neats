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

/// A set of mutations to be applied when updating rows.
///
/// Instances of this object are always created using the `set` callback passed
/// to the `updateBuilder` callback in `.update` _extension methods_. These
/// objects should always be passed back immediately. Meaning, `.update` should
/// always be called as `.update((row, set) => set(...`, as illustrated below:
///
/// ```dart
/// await db.myTable
///     .update((row, set) => set(column: toExpr(value)))
///     .execute();
/// ```
///
/// This is always an opaque object that serves to make the signatures in
/// `.update` easy to use.
final class UpdateSet<T extends Row> {
  final List<Expr?> _values;

  UpdateSet._(this._values);
}

/// A `UPDATE` statement to update at-most one row.
final class UpdateSingle<T extends Row> {
  final Update<T> _update;

  UpdateSingle._(this._update);

  /// Execute this `UPDATE` statement in the database.
  Future<void> execute() async => await _update.execute();

  /// Create a `UPDATE` statement that returns a projection of the updated row,
  /// using the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// The [projectionBuilder] must return a [Record] where values are [Expr]
  /// objects.
  ReturnSingle<S> returning<S extends Record>(
    S Function(Expr<T> updated) projectionBuilder,
  ) => _update.returning(projectionBuilder)._first;

  /// Create a `UPDATE` statement that returns the updated row, using the
  /// `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING *` clause in SQL.
  ReturnSingle<(Expr<T>,)> returnUpdated() => _update.returnUpdated()._first;
}

/// A `UPDATE` statement to update multiple rows.
final class Update<T extends Row> {
  final Query<(Expr<T>,)> _query;
  final TableDefinition<T> _table;
  final Object _handle;
  final UpdateSet<T> _set;

  Update._(this._query, this._table, this._handle, this._set);

  /// Execute this `UPDATE` statement in the database.
  Future<void> execute() async => await _query._context._execute(
    _query._context._dialect.update(
      UpdateStatement._(
        TableClause._(_table),
        _table.columns
            .whereIndexed((index, value) => _set._values[index] != null)
            .toList(),
        _set._values.nonNulls.toList(),
        _handle,
        _query._from(_query._expressions.toList()),
        null,
      ),
    ),
  );

  /// Create a `UPDATE` statement that returns a projection of the updated rows,
  /// using the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// The [projectionBuilder] must return a [Record] where values are [Expr]
  /// objects.
  Return<S> returning<S extends Record>(
    S Function(Expr<T> updated) projectionBuilder,
  ) {
    final handle = Object();
    final projection = projectionBuilder(
      RowExpression._(0, _table, Object())._standin(0, handle),
    );

    final table = TableClause._(_table);

    return Return._(_query._context, projection, (e) {
      return _query._context._dialect.update(
        UpdateStatement._(
          table,
          table.columns
              .whereIndexed((index, value) => _set._values[index] != null)
              .toList(),
          _set._values.nonNulls.toList(),
          _handle,
          _query._from(_query._expressions.toList()),
          ReturningClause._(handle, table.columns, e),
        ),
      );
    });
  }

  /// Create a `UPDATE` statement that returns the updated rows, using the
  /// `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING *` clause in SQL.
  Return<(Expr<T>,)> returnUpdated() => returning((updated) => (updated,));
}

/// An `INSERT` statement to insert multiple rows.
final class Insert<T extends Row> {
  final Table<T> _table;
  final ValuesSource _values;
  final ConflictClause? _onConflictClause;

  Insert._({
    required Table<T> table,
    required ValuesSource values,
    ConflictClause? onConflictClause,
  }) : _table = table,
       _values = values,
       _onConflictClause = onConflictClause;

  Insert<T> _with({
    Table<T>? table,
    ValuesSource? values,
    ConflictClause? onConflictClause,
  }) => Insert._(
    table: table ?? _table,
    values: values ?? _values,
    onConflictClause: onConflictClause ?? _onConflictClause,
  );

  SqlTask _render({
    ReturningClause? returning,
  }) => _table._context._dialect.insertInto(
    InsertStatement._(
      _table._tableClause.name,
      _values,
      _onConflictClause,
      returning,
    ),
  );

  InsertOnConflict<T> _onConflict(
    List<String> conflictTarget,
  ) => InsertOnConflict._(this, conflictTarget);

  /// Execute this `INSERT` statement in the database.
  Future<void> execute() async => await _table._context._execute(_render());

  /// Create a `INSERT` statement that returns a projection of the inserted
  /// rows, using the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// The [projectionBuilder] must return a [Record] where values are [Expr]
  /// objects.
  Return<S> returning<S extends Record>(
    S Function(Expr<T> inserted) projectionBuilder,
  ) {
    final handle = Object();
    final projection = projectionBuilder(
      _table._expressions.$1._standin(0, handle),
    );

    return Return._(
      _table._context,
      projection,
      (e) => _render(
        returning: ReturningClause._(handle, _table._tableClause.columns, e),
      ),
    );
  }

  /// Create a `INSERT` statement that returns the inserted rows, using the
  /// `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING *` clause in SQL.
  Return<(Expr<T>,)> returnInserted() => returning((inserted) => (inserted,));
}

/// An `INSERT ... ON CONFLICT ...` statement builder.
///
/// Holding an [InsertOnConflict] builder, you may:
///  * Use `.doNothing()` to build an `INSERT` statement that ignores rows that
///     trigger a conflict on the previously specified _conflict target_.
///  * Use `.update((row, excluded, set) => set(...))` to specify an mutation on
///    the conflicting rows in the database.
final class InsertOnConflict<T extends Row> {
  final Insert<T> _insert;
  final List<String> _conflictTarget;

  InsertOnConflict._(this._insert, this._conflictTarget);

  /// Create an `INSERT` statement that skips rows to be inserted, if they
  /// conflict with existing an existing row on the _conflict target_.
  ///
  /// The _conflict target_, previously declared with `.onConflict` specifies
  /// a single `UNIQUE` constraint (or `PRIMARY KEY` constraint).
  /// Any row to be inserted that violates the constraint specified in the
  /// _conflict target_ will be skipped.
  ///
  /// If a row to be inserted violates other constraints, the `INSERT` statement
  /// will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...) DO NOTHING` in SQL.
  InsertOrIgnore<T> doNothing() => InsertOrIgnore._(
    _insert._with(
      onConflictClause: DoNothingOnConflictClause._(_conflictTarget),
    ),
  );

  Upsert<T> _update(
    UpdateSet<T> Function(Expr<T> row, Expr<T> excluded) updateBuilder,
  ) {
    final table = _insert._table;

    final handle = Object();
    final row = table._expressions.$1._standin(0, handle);
    final excludedHandle = Object();
    final excluded = table._expressions.$1._standin(0, excludedHandle);

    final set = updateBuilder(row, excluded);

    return Upsert._(
      _insert._with(
        onConflictClause: UpdateOnConflictClause._(
          handle,
          _conflictTarget,
          table._tableClause,
          ExpressionContext._(excludedHandle),
          table._tableClause._definition.columns
              .whereIndexed((index, value) => set._values[index] != null)
              .toList(),
          set._values.nonNulls.toList(),
          Expr.true$,
        ),
      ),
    );
  }
}

/// An `INSERT ... ON CONFLICT (...) DO NOTHING` statement.
final class InsertOrIgnore<T extends Row> {
  final Insert<T> _insert;
  InsertOrIgnore._(this._insert);

  /// Execute this `INSERT` statement in the database.
  Future<void> execute() => _insert.execute();

  /// Create a `INSERT` statement that returns a projection of the inserted
  /// rows, using the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// > [!NOTE]
  /// > This is an `INSERT ... ON CONFLICT (...) DO NOTHING RETURNING ...`
  /// > statement, and if inserted rows have a conflict matching the
  /// > _conflict target_ they will be skipped. Skipped rows are not inserted,
  /// > and thus, will not be included in the result from `RETURNING`.
  ///
  /// The [projectionBuilder] must return a [Record] where values are [Expr]
  /// objects.
  Return<S> returning<S extends Record>(
    S Function(Expr<T> inserted) projectionBuilder,
  ) => _insert.returning(projectionBuilder);

  /// Create a `INSERT` statement that returns the inserted rows, using the
  /// `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING *` clause in SQL.
  ///
  /// > [!NOTE]
  /// > This is an `INSERT ... ON CONFLICT (...) DO NOTHING RETURNING ...`
  /// > statement, and if inserted rows have a conflict matching the
  /// > _conflict target_ they will be skipped. Skipped rows are not inserted,
  /// > and thus, will not be included in the result from `RETURNING`.
  Return<(Expr<T>,)> returnInserted() => returning((inserted) => (inserted,));
}

/// An `INSERT .. ON CONFLICT (...) UPDATE SET ...` statement.
///
/// This is also called an _upsert_ statment, because if the constraint specified
/// in the _conflict target_ is violated, then the conflicting row is updated.
final class Upsert<T extends Row> {
  final Insert<T> _insert;
  Upsert._(this._insert);

  /// Execute this `INSERT` statement in the database.
  Future<void> execute() => _insert.execute();

  /// Create a `INSERT` statement that returns a projection of the upserted
  /// rows, using the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// > [!NOTE]
  /// > This is an `INSERT ... ON CONFLICT (...) DO UPDATE SET ... RETURNING ...`
  /// > statement, and the resulting rows are either _inserted_ or _updated_.
  ///
  /// The [projectionBuilder] must return a [Record] where values are [Expr]
  /// objects.
  Return<S> returning<S extends Record>(
    S Function(Expr<T> inserted) projectionBuilder,
  ) => _insert.returning(projectionBuilder);

  /// Create a `INSERT` statement that returns a projection of the upserted
  /// rows, using the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// > [!NOTE]
  /// > This is an `INSERT ... ON CONFLICT (...) DO UPDATE SET ... RETURNING ...`
  /// > statement, and the resulting rows are either _inserted_ or _updated_.
  Return<(Expr<T>,)> returnUpserted() => returning((inserted) => (inserted,));

  /// Create an `INSERT` statement with a _conditional_ [upsert-clause][1].
  ///
  /// When a row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing row is
  /// updated using the expressions previously constructed using
  /// `.update((row, excluded, set) => set(...))`, but only the [Expr] created
  /// with [conditionBuilder] evaluates to `true`.
  ///
  /// **Example:** Insert a counter with `count = 2`, if there is a
  /// `PRIMARY KEY` conflict, then increment `count` on the existing row, but
  /// only if the existing counter is less than `5` or the excluded row is
  /// negative (ie. decrementing).
  /// ```dart
  ///   await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .where((counter, excluded) =>
  ///     (counter.count < toExpr(5)) &
  ///     (excluded.count > toExpr(0)),
  ///   )
  ///   .execute();
  /// ```
  ///
  /// If the [Expr] created by the [conditionBuilder] evaluates to `false`, then
  /// the update of the existing row is skipped, with behavior equivalent to
  /// `.doNothing()`.
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ... WHERE ...` in SQL.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  UpsertConditional<T> where(
    Expr<bool> Function(Expr<T> row, Expr<T> excluded) conditionBuilder,
  ) {
    // Always a safe cast because InsertOnConflict._update is the only
    // place we create UpsertConditional instances!
    final conflictClause = _insert._onConflictClause as UpdateOnConflictClause;

    final expr = _insert._table._expressions.$1;
    final row = expr._standin(0, conflictClause._handle);
    final excluded = expr._standin(0, conflictClause.excluded._handle);

    return UpsertConditional._(
      _insert._with(
        onConflictClause: UpdateOnConflictClause._(
          conflictClause._handle,
          conflictClause.conflictTarget,
          conflictClause.table,
          conflictClause.excluded,
          conflictClause.columns,
          conflictClause.values,
          conditionBuilder(row, excluded),
        ),
      ),
    );
  }
}

/// An `INSERT ... ON CONFLICT (...) UPDATE SET ... WHERE ...` statement.
///
/// This is also called an _conditional upsert_ statment, because if the
/// constraint specified in the _conflict target_ is violated, then the
/// conflicting row is updated, if the condition is satisfied.
final class UpsertConditional<T extends Row> {
  final Insert<T> _insert;
  UpsertConditional._(this._insert);

  /// Execute this `INSERT` statement in the database.
  Future<void> execute() => _insert.execute();

  /// Create a `INSERT` statement that returns a projection of the conditionally
  /// upserted rows, using the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// > [!NOTE]
  /// > If a row is _inserted_ or _updated_, then it is returned, but if an
  /// > update is skipped because of condition, previously specified using
  /// > `.where`, then said row will not be returned.
  ///
  /// The [projectionBuilder] must return a [Record] where values are [Expr]
  /// objects.
  Return<S> returning<S extends Record>(
    S Function(Expr<T> inserted) projectionBuilder,
  ) => _insert.returning(projectionBuilder);

  /// Create a `INSERT` statement that returns the conditionally
  /// upserted rows, using the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// > [!NOTE]
  /// > If a row is _inserted_ or _updated_, then it is returned, but if an
  /// > update is skipped because of condition, previously specified using
  /// > `.where`, then said row will not be returned.
  Return<(Expr<T>,)> returnUpserted() => returning((inserted) => (inserted,));
}

/// A `INSERT` statement to insert a single row.
final class InsertSingle<T extends Row> {
  final Insert<T> _insert;

  InsertSingle._(this._insert);

  /// Execute this `INSERT` statement in the database.
  Future<void> execute() => _insert.execute();

  /// Create a `INSERT` statement that returns a projection of the inserted row,
  /// using the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// The [projectionBuilder] must return a [Record] where values are [Expr]
  /// objects.
  ReturnOne<S> returning<S extends Record>(
    S Function(Expr<T> inserted) projectionBuilder,
  ) => ReturnOne._(_insert.returning(projectionBuilder));

  /// Create a `INSERT` statement that returns the inserted row, using the
  /// `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING *` clause in SQL.
  ReturnOne<(Expr<T>,)> returnInserted() =>
      returning((inserted) => (inserted,));

  InsertOnConflictSingle<T> _onConflict(
    List<String> conflictTarget,
  ) => InsertOnConflictSingle._(_insert, conflictTarget);
}

/// An `INSERT ... ON CONFLICT ...` statement builder.
///
/// Holding an [InsertOnConflictSingle] builder, you may:
///  * Use `.doNothing()` to build an `INSERT` statement that ignores the row
///    if it triggers a conflict on the previously specified _conflict target_.
///  * Use `.update((row, excluded, set) => set(...))` to specify an mutation on
///    the conflicting row in the database.
final class InsertOnConflictSingle<T extends Row> {
  final Insert<T> _insert;
  final List<String> _conflictTarget;

  InsertOnConflictSingle._(this._insert, this._conflictTarget);

  /// Create an `INSERT` statement that skips the row to be inserted, if it
  /// conflicts with existing an existing row on the _conflict target_.
  ///
  /// The _conflict target_, previously declared with `.onConflict` specifies
  /// a single `UNIQUE` constraint (or `PRIMARY KEY` constraint).
  /// If the row to be inserted that violates the constraint specified in the
  /// _conflict target_, it will be skipped.
  ///
  /// If the row to be inserted violates other constraints, the `INSERT`
  /// statement will fail.
  ///
  /// This is equivalent to `INSERT ... ON CONFLICT (...) DO NOTHING` in SQL.
  InsertOrIgnoreSingle<T> doNothing() => InsertOrIgnoreSingle._(
    _insert._with(
      onConflictClause: DoNothingOnConflictClause._(_conflictTarget),
    ),
  );

  UpsertSingle<T> _update(
    UpdateSet<T> Function(Expr<T> row, Expr<T> excluded) updateBuilder,
  ) {
    final table = _insert._table;

    final handle = Object();
    final row = table._expressions.$1._standin(0, handle);
    final excludedHandle = Object();
    final excluded = table._expressions.$1._standin(0, excludedHandle);

    final set = updateBuilder(row, excluded);

    return UpsertSingle._(
      _insert._with(
        onConflictClause: UpdateOnConflictClause._(
          handle,
          _conflictTarget,
          table._tableClause,
          ExpressionContext._(excludedHandle),
          table._tableClause._definition.columns
              .whereIndexed((index, value) => set._values[index] != null)
              .toList(),
          set._values.nonNulls.toList(),
          Expr.true$,
        ),
      ),
    );
  }
}

/// An `INSERT ... ON CONFLICT (...) DO NOTHING` statement to insert at-most
/// one row.
final class InsertOrIgnoreSingle<T extends Row> {
  final Insert<T> _insert;
  InsertOrIgnoreSingle._(this._insert);

  /// Execute this `INSERT` statement in the database.
  Future<void> execute() => _insert.execute();

  /// Create a `INSERT` statement that returns a projection of the inserted row
  /// (if not ignored), using the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// > [!NOTE]
  /// > This is an `INSERT ... ON CONFLICT (...) DO NOTHING RETURNING ...`
  /// > statement, and if the row to be inserted has a conflict matching the
  /// > _conflict target_ it will be skipped. A skipped row is not inserted,
  /// > and thus, will not be included in the result from `RETURNING`.
  ///
  /// The [projectionBuilder] must return a [Record] where values are [Expr]
  /// objects.
  ReturnSingle<S> returning<S extends Record>(
    S Function(Expr<T> inserted) projectionBuilder,
  ) => ReturnSingle._(_insert.returning(projectionBuilder));

  /// Create a `INSERT` statement that returns the inserted row
  /// (if not ignored), using the `RETURNING` clause.
  ///
  /// > [!NOTE]
  /// > This is an `INSERT ... ON CONFLICT (...) DO NOTHING RETURNING ...`
  /// > statement, and if the row to be inserted has a conflict matching the
  /// > _conflict target_ it will be skipped. A skipped row is not inserted,
  /// > and thus, will not be included in the result from `RETURNING`.
  ///
  /// This is equivalent to the `RETURNING *` clause in SQL.
  ReturnSingle<(Expr<T>,)> returnInserted() =>
      returning((inserted) => (inserted,));
}

/// An `INSERT .. ON CONFLICT (...) UPDATE SET ...` statement.
///
/// This is also called an _upsert_ statment, because if the constraint specified
/// in the _conflict target_ is violated, then the conflicting row is updated.
final class UpsertSingle<T extends Row> {
  final Insert<T> _insert;
  UpsertSingle._(this._insert);

  /// Execute this `INSERT` statement in the database.
  Future<void> execute() => _insert.execute();

  /// Create a `INSERT` statement that returns a projection of the upserted
  /// row, using the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// > [!NOTE]
  /// > This is an `INSERT ... ON CONFLICT (...) DO UPDATE SET ... RETURNING ...`
  /// > statement, and the resulting row is either _inserted_ or _updated_.
  ///
  /// The [projectionBuilder] must return a [Record] where values are [Expr]
  /// objects.
  ReturnOne<S> returning<S extends Record>(
    S Function(Expr<T> inserted) projectionBuilder,
  ) => ReturnOne._(_insert.returning(projectionBuilder));

  /// Create a `INSERT` statement that returns a projection of the upserted
  /// row, using the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// > [!NOTE]
  /// > This is an `INSERT ... ON CONFLICT (...) DO UPDATE SET ... RETURNING ...`
  /// > statement, and the resulting row is either _inserted_ or _updated_.
  ReturnOne<(Expr<T>,)> returnUpserted() =>
      returning((inserted) => (inserted,));

  /// Create an `INSERT` statement with a _conditional_ [upsert-clause][1].
  ///
  /// When the row to be inserted violates the `UNIQUE` or `PRIMARY KEY`
  /// constraint previously specified as _conflict target_, the existing row is
  /// updated using the expressions previously constructed using
  /// `.update((row, excluded, set) => set(...))`, but only the [Expr] created
  /// with [conditionBuilder] evaluates to `true`.
  ///
  /// **Example:** Insert a counter with `count = 2`, if there is a
  /// `PRIMARY KEY` conflict, then increment `count` on the existing row, but
  /// only if the existing counter is less than `5` or the excluded row is
  /// negative (ie. decrementing).
  /// ```dart
  ///   await db.counters.insertValue(
  ///     name: 'my-counter', // primary key
  ///     count: 2,
  ///   )
  ///   .onConflict(.primaryKey)
  ///   .update((counter, excluded, set) => set(
  ///     count: counter.count + excluded.count,
  ///   ))
  ///   .where((counter, excluded) =>
  ///     (counter.count < toExpr(5)) &
  ///     (excluded.count > toExpr(0)),
  ///   )
  ///   .execute();
  /// ```
  ///
  /// If the [Expr] created by the [conditionBuilder] evaluates to `false`, then
  /// the update of the existing row is skipped, with behavior equivalent to
  /// `.doNothing()`.
  ///
  /// This is equivalent to
  /// `INSERT ... ON CONFLICT (...) UPDATE SET ... WHERE ...` in SQL.
  ///
  /// [1]: https://www.sqlite.org/lang_upsert.html
  UpsertConditionalSingle<T> where(
    Expr<bool> Function(Expr<T> row, Expr<T> excluded) conditionBuilder,
  ) {
    // Always a safe cast because InsertOnConflictSingle._update is the only
    // place we create UpsertConditionalSingle instances!
    final conflictClause = _insert._onConflictClause as UpdateOnConflictClause;

    final expr = _insert._table._expressions.$1;
    final row = expr._standin(0, conflictClause._handle);
    final excluded = expr._standin(0, conflictClause.excluded._handle);

    return UpsertConditionalSingle._(
      _insert._with(
        onConflictClause: UpdateOnConflictClause._(
          conflictClause._handle,
          conflictClause.conflictTarget,
          conflictClause.table,
          conflictClause.excluded,
          conflictClause.columns,
          conflictClause.values,
          conditionBuilder(row, excluded),
        ),
      ),
    );
  }
}

/// An `INSERT ... ON CONFLICT (...) UPDATE SET ... WHERE ...` statement.
///
/// This is also called an _conditional upsert_ statment, because if the
/// constraint specified in the _conflict target_ is violated, then the
/// conflicting row is updated, if the condition is satisfied.
final class UpsertConditionalSingle<T extends Row> {
  final Insert<T> _insert;
  UpsertConditionalSingle._(this._insert);

  /// Execute this `INSERT` statement in the database.
  Future<void> execute() => _insert.execute();

  /// Create a `INSERT` statement that returns a projection of the conditionally
  /// upserted row, using the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// > [!NOTE]
  /// > If the row is _inserted_ or _updated_, then it is returned, but if the
  /// > update is skipped because of condition, previously specified using
  /// > `.where`, then the row will not be returned.
  ///
  /// The [projectionBuilder] must return a [Record] where values are [Expr]
  /// objects.
  ReturnSingle<S> returning<S extends Record>(
    S Function(Expr<T> inserted) projectionBuilder,
  ) => ReturnSingle._(_insert.returning(projectionBuilder));

  /// Create a `INSERT` statement that the conditionally upserted row, using
  /// the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// > [!NOTE]
  /// > If the row is _inserted_ or _updated_, then it is returned, but if the
  /// > update is skipped because of condition, previously specified using
  /// > `.where`, then the row will not be returned.
  ReturnSingle<(Expr<T>,)> returnUpserted() =>
      returning((inserted) => (inserted,));
}

/// A `DELETE` statement deleting multiple rows.
final class Delete<T extends Row> {
  final Query<(Expr<T>,)> _query;
  final TableDefinition<T> _table;

  Delete._(this._query, this._table);

  /// Execute this `DELETE` statement in the database.
  Future<void> execute() async => await _query._context._execute(
    _query._context._dialect.delete(
      DeleteStatement._(
        TableClause._(_table),
        _query._from(_query._expressions.toList()),
        null,
      ),
    ),
  );

  /// Create a `DELETE` statement that returns a projection of the deleted rows,
  /// using the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// The [projectionBuilder] must return a [Record] where values are [Expr]
  /// objects.
  Return<S> returning<S extends Record>(
    S Function(Expr<T> updated) projectionBuilder,
  ) {
    final handle = Object();
    final projection = projectionBuilder(
      RowExpression._(0, _table, Object())._standin(0, handle),
    );

    final table = TableClause._(_table);

    return Return._(_query._context, projection, (e) {
      return _query._context._dialect.delete(
        DeleteStatement._(
          table,
          _query._from(_query._expressions.toList()),
          ReturningClause._(handle, table.columns, e),
        ),
      );
    });
  }

  /// Create a `DELETE` statement that returns the deleted rows, using the
  /// `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING *` clause in SQL.
  Return<(Expr<T>,)> returnDeleted() => returning((deleted) => (deleted,));
}

/// A `DELETE` statement deleting at-most one row.
final class DeleteSingle<T extends Row> {
  final Delete<T> _delete;
  DeleteSingle._(this._delete);

  /// Execute this `DELETE` statement in the database.
  Future<void> execute() async => await _delete.execute();

  /// Create a `DELETE` statement that returns a projection of the deleted row,
  /// using the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// The [projectionBuilder] must return a [Record] where values are [Expr]
  /// objects.
  ReturnSingle<S> returning<S extends Record>(
    S Function(Expr<T> deleted) projectionBuilder,
  ) => _delete.returning(projectionBuilder)._first;

  /// Create a `DELETE` statement that returns the deleted row, using the
  /// `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING *` clause in SQL.
  ReturnSingle<(Expr<T>,)> returnDeleted() => _delete.returnDeleted()._first;
}

/// An SQL statement that returns at-most one row.
///
/// This can be an `INSERT`, `UPDATE` or `DELETE` statement. This is not a
/// `SELECT` query, these are represented with [QuerySingle] objects.
///
/// Unlike a [QuerySingle] object which only returns values when evaluated, this
/// statement may have side-effects, and this statement cannot be extended with
/// additional clauses.
final class ReturnSingle<T extends Record> {
  final Return<T> _return;
  ReturnSingle._(this._return);
}

/// An SQL statement that returns exactly one row.
///
/// This can be an `INSERT` statement. This is not a
/// `SELECT` query, these are represented with [QuerySingle] objects.
///
/// Unlike a [QuerySingle] object which only returns values when evaluated, this
/// statement may have side-effects, and this statement cannot be extended with
/// additional clauses.
final class ReturnOne<T extends Record> {
  final Return<T> _return;
  ReturnOne._(this._return);
}

/// An SQL statement that returns zero or more rows.
///
/// This can be an `INSERT`, `UPDATE` or `DELETE` statement. This is not a
/// `SELECT` query, these are represented with [Query] objects.
///
/// Unlike a [Query] object which also only values when evaluated, this
/// statement may have side-effects, and this statement cannot be extended with
/// additional clauses.
final class Return<T extends Record> {
  final Database _context;
  final SqlTask Function(List<Expr> e) _render;
  final T _expressions;

  Return._(this._context, this._expressions, this._render);

  /// Internal method to represent this as a [ReturnSingle].
  ///
  /// This method should not be made public, because there is no mechanism that
  /// allows executing a statement and only reading the first row from a
  /// `RETURNING` clause. Exposing this method would give users such an
  /// impression.
  ReturnSingle<T> get _first => ReturnSingle._(this);
}
