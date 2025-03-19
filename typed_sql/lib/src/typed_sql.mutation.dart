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

final class UpdateSingle<T extends Model> {
  final Update<T> _update;

  UpdateSingle._(this._update);

  Future<void> execute() async => await _update.execute();

  ReturnSingle<S> returning<S extends Record>(
    S Function(Expr<T> updated) projectionBuilder,
  ) =>
      _update.returning(projectionBuilder).first;

  ReturnSingle<(Expr<T>,)> returnUpdated() => _update.returnUpdated().first;
}

final class Update<T extends Model> {
  final Query<(Expr<T>,)> _query;
  final TableDefinition<T> _table;
  final Object _handle;
  final UpdateSet<T> _set;

  Update._(this._query, this._table, this._handle, this._set);

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

  Return<(Expr<T>,)> returnUpdated() => returning((updated) => (updated,));
}

final class InsertSingle<T extends Model> {
  final Table<T> _table;
  final List<Expr?> _values;

  InsertSingle._(this._table, this._values);

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

  ReturnSingle<S> returning<S extends Record>(
    S Function(Expr<T> inserted) projectionBuilder,
  ) {
    final handle = Object();
    final projection = projectionBuilder(
      _table._expressions.$1._standin(0, handle),
    );

    return Return._(_table._context, projection, (e) {
      return _table._context._dialect.insertInto(InsertStatement._(
        _table._tableClause.name,
        _table._tableClause.columns
            .whereIndexed((index, value) => _values[index] != null)
            .toList(),
        _values.nonNulls.toList(),
        ReturningClause._(handle, _table._tableClause.columns, e),
      ));
    }).first;
  }

  ReturnSingle<(Expr<T>,)> returnInserted() =>
      returning((inserted) => (inserted,));
}

final class Delete<T extends Model> {
  final Query<(Expr<T>,)> _query;
  final TableDefinition<T> _table;

  Delete._(this._query, this._table);

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

  Return<(Expr<T>,)> returnDeleted() => returning((deleted) => (deleted,));
}

final class DeleteSingle<T extends Model> {
  final Delete<T> _delete;
  DeleteSingle._(this._delete);

  Future<void> execute() async => await _delete.execute();

  ReturnSingle<S> returning<S extends Record>(
    S Function(Expr<T> deleted) projectionBuilder,
  ) =>
      _delete.returning(projectionBuilder).first;

  ReturnSingle<(Expr<T>,)> returnDeleted() => _delete.returnDeleted().first;
}

final class ReturnSingle<T extends Record> {
  final Return<T> _return;
  ReturnSingle._(this._return);
}

final class Return<T extends Record> {
  final DatabaseContext _context;
  final (String, List<Object?>) Function(List<Expr> e) _render;
  final T _expressions;

  Return._(this._context, this._expressions, this._render);

  ReturnSingle<T> get first => ReturnSingle._(this);
}
