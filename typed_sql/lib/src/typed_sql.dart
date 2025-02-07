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

import 'dart:async';
import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'package:typed_sql/adaptor/adaptor.dart';

import '../sql_dialect/sql_dialect.dart';

part 'typed_sql.annotations.dart';
part 'typed_sql.database.dart';
part 'typed_sql.expression.dart';
part 'typed_sql.query.dart';

/// Name which tables must always be aliased as.
/// Example: `SELECT ... FROM users AS table`.
///
/// For now this hardcoded to 't', we can change it later if we ever support
/// some sort of joins or subqueries in conditions.
const _tableAliasName = 't';

// TODO: All classes in this file should be final!!!
final class Table<T> extends Query<T> {
  final DatabaseContext _context;

  final String _tableName;
  final List<String> _columns;
  final T Function(Object? Function(int index) get) _deserialize;

  Table._(
    this._context,
    this._tableName,
    this._columns,
    this._deserialize,
  );

  /// Create a [Table] wrapper, exposed for use by generated code.
  ///
  /// This should be hidden in dartdoc!
  /// <nodoc>
  // TODO: Consider making a single ExposedForCodeGen class where all methods
  //       like this are exposed as static methods. That way users won't
  //       discover these methods in dartdoc or when using code completion.
}

abstract base class Schema {
  Schema() {
    throw UnsupportedError(
      'Schema classes cannot be instantiated, '
      'the Schema type and all subclasses only exists to be used as '
      'type-argument on Database<T>.',
    );
  }
}

//final class View<T> extends Query<T> {}

/// Class from which all model classes must implement.
abstract base class Model {}

/// Methods exclusively exposed for use by generated code.
///
/// @nodoc
final class ExposedForCodeGen {
  /// Create [Table] object.
  ///
  /// @nodoc
  static Table<T> declareTable<T>({
    required DatabaseContext context,
    required String tableName,
    required List<String> columns,
    required T Function(Object? Function(int index) get) deserialize,
  }) =>
      Table._(
        context,
        tableName,
        columns,
        deserialize,
      );

  // TODO: Design a solution for migrations using atlas creating dialect
  //       specific migraiton files in a folder, such that we just have to
  //       apply the migrations.
  static Future<void> applyMigration(
    DatabaseContext context,
    String migration,
  ) async {
    await context._query(migration, const []).drain();
  }

  static Future<T> insertInto<T>({
    required Table<T> table,
    required List<Object> values,
  }) async {
    final (sql, params) = table._context._dialect.insertInto(
      table._tableName,
      table._columns,
      values,
      table._columns,
    );
    final returned = await table._context._query(sql, params).first;
    return table._deserialize((i) => returned[i]);
  }

  // TODO: we can't set anything to null
  static Future<void> update<T extends Model>(
    Query<T> query,
    List<Object?> values,
  ) async {
    final q = query._query();

    final (sql, params) = q._table._context._dialect.update(
      q._table._tableName,
      _tableAliasName,
      q._table._columns
          .whereIndexed((index, value) => values[index] != null)
          .toList(),
      values.nonNulls.map((v) => Literal(v)).toList(),
      q._limit,
      q._offset,
      q._where,
      q._orderBy,
    );
    await q._table._context._query(sql, params).drain();
  }

  static Query<T> where<T extends Model>(
    Query<T> query,
    Expr<bool> Function(Expr<T> row) conditionBuilder,
  ) =>
      query
          ._query()
          ._update(where: conditionBuilder(RowExpression(_tableAliasName)));

  static Query<T> orderBy<T extends Model>(
    Query<T> query,
    Expr Function(Expr<T> row) fieldBuilder, {
    bool descending = false,
  }) =>
      query._query()._update(orderBy: (
        descending: descending,
        term: fieldBuilder(RowExpression(_tableAliasName)),
      ));

  static Expr<T> field<T, M extends Model>(
    Expr<M> row,
    String name,
  ) =>
      FieldExpression(
        switch (row) {
          final RowExpression row => row.alias,
          _ => throw UnsupportedError('Only referenced rows can be used'),
        },
        name,
      );
}
