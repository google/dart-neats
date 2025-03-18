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

final class InsertSingle<T extends Model> {
  final Table<T> _table;
  final List<Expr?> _values;

  InsertSingle._(this._table, this._values);
}

extension InsertSingleExtension<T extends Model> on InsertSingle<T> {
  Future<void> execute() async {
    final (sql, params) = _table._context._dialect.insertInto(InsertStatement._(
      _table._tableClause.name,
      _table._tableClause.columns
          .whereIndexed((index, value) => _values[index] != null)
          .toList(),
      _values.nonNulls.toList(),
      const [],
    ));
    await _table._context._query(sql, params).drain<void>();
  }
}
