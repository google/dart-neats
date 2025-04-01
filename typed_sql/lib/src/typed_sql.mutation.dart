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

final class UpdateSet<T extends Model> {
  final List<Expr?> _values;

  UpdateSet._(this._values);
}

/// A `UPDATE` statement to update at-most one row.
final class UpdateSingle<T extends Model> {
  final Update<T> _update;

  UpdateSingle._(this._update);

  /// Execute this `UPDATE` statement in the database.
  Future<void> execute() async => await _update.execute();

  /// Create a `UPDATE` statement that returns a projection of the update row,
  /// using the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// The [projectionBuilder] must return a [Record] where values are [Expr]
  /// objects.
  ReturnSingle<S> returning<S extends Record>(
    S Function(Expr<T> updated) projectionBuilder,
  ) =>
      _update.returning(projectionBuilder)._first;

  /// Create a `UPDATE` statement that returns the updated row, using the
  /// `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING *` clause in SQL.
  ReturnSingle<(Expr<T>,)> returnUpdated() => _update.returnUpdated()._first;
}

/// A `UPDATE` statement to update one or more rows.
final class Update<T extends Model> {
  final Query<(Expr<T>,)> _query;
  final TableDefinition<T> _table;
  final Object _handle;
  final UpdateSet<T> _set;

  Update._(this._query, this._table, this._handle, this._set);

  /// Execute this `UPDATE` statement in the database.
  Future<void> execute() async {
    final (sql, params) = _query._context._dialect.update(
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
    );

    await _query._context._query(sql, params).drain<void>();
  }

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
      ModelExpression._(0, _table, Object())._standin(0, handle),
    );

    final table = TableClause._(_table);

    return Return._(_query._context, projection, (e) {
      return _query._context._dialect.update(UpdateStatement._(
        table,
        table.columns
            .whereIndexed((index, value) => _set._values[index] != null)
            .toList(),
        _set._values.nonNulls.toList(),
        _handle,
        _query._from(_query._expressions.toList()),
        ReturningClause._(handle, table.columns, e),
      ));
    });
  }

  /// Create a `UPDATE` statement that returns the updated rows, using the
  /// `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING *` clause in SQL.
  Return<(Expr<T>,)> returnUpdated() => returning((updated) => (updated,));
}

/// A `INSERT` statement to insert a single row.
final class InsertSingle<T extends Model> {
  final Table<T> _table;
  final List<Expr?> _values;

  InsertSingle._(this._table, this._values);

  /// Execute this `INSERT` statement in the database.
  Future<void> execute() async {
    final (sql, params) = _table._context._dialect.insertInto(InsertStatement._(
      _table._tableClause.name,
      _table._tableClause.columns
          .whereIndexed((index, value) => _values[index] != null)
          .toList(),
      _values.nonNulls.toList(),
      null,
    ));
    await _table._context._query(sql, params).drain<void>();
  }

  /// Create a `INSERT` statement that returns a projection of the inserted row,
  /// using the `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING` clause in SQL.
  ///
  /// The [projectionBuilder] must return a [Record] where values are [Expr]
  /// objects.
  ReturnOne<S> returning<S extends Record>(
    S Function(Expr<T> inserted) projectionBuilder,
  ) {
    final handle = Object();
    final projection = projectionBuilder(
      _table._expressions.$1._standin(0, handle),
    );

    return ReturnOne._(Return._(_table._context, projection, (e) {
      return _table._context._dialect.insertInto(InsertStatement._(
        _table._tableClause.name,
        _table._tableClause.columns
            .whereIndexed((index, value) => _values[index] != null)
            .toList(),
        _values.nonNulls.toList(),
        ReturningClause._(handle, _table._tableClause.columns, e),
      ));
    }));
  }

  /// Create a `INSERT` statement that returns the inserted row, using the
  /// `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING *` clause in SQL.
  ReturnOne<(Expr<T>,)> returnInserted() =>
      returning((inserted) => (inserted,));
}

/// A `DELETE` statement to delete one or more rows.
final class Delete<T extends Model> {
  final Query<(Expr<T>,)> _query;
  final TableDefinition<T> _table;

  Delete._(this._query, this._table);

  /// Execute this `DELETE` statement in the database.
  Future<void> execute() async {
    final (sql, params) = _query._context._dialect.delete(
      DeleteStatement._(
        TableClause._(_table),
        _query._from(_query._expressions.toList()),
        null,
      ),
    );

    await _query._context._query(sql, params).drain<void>();
  }

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
      ModelExpression._(0, _table, Object())._standin(0, handle),
    );

    final table = TableClause._(_table);

    return Return._(_query._context, projection, (e) {
      return _query._context._dialect.delete(DeleteStatement._(
        table,
        _query._from(_query._expressions.toList()),
        ReturningClause._(handle, table.columns, e),
      ));
    });
  }

  /// Create a `DELETE` statement that returns the deleted rows, using the
  /// `RETURNING` clause.
  ///
  /// This is equivalent to the `RETURNING *` clause in SQL.
  Return<(Expr<T>,)> returnDeleted() => returning((deleted) => (deleted,));
}

/// A `DELETE` statement to delete at-most one row.
final class DeleteSingle<T extends Model> {
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
  ) =>
      _delete.returning(projectionBuilder)._first;

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
  final DatabaseContext _context;
  final (String, List<Object?>) Function(List<Expr> e) _render;
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
