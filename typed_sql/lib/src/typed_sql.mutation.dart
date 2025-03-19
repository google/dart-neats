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
