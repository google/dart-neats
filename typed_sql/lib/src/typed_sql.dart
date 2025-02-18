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
import 'package:collection/collection.dart';
import 'package:typed_sql/adaptor/adaptor.dart';
import 'package:typed_sql/sql_dialect/sql_dialect.dart';

part 'typed_sql.annotations.dart';
part 'typed_sql.database.dart';
part 'typed_sql.expression.dart';
part 'typed_sql.query.dart';

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

final class Update<T extends Model> {
  final List<Expr?> _values;

  Update._(this._values);
}

/// Methods exclusively exposed for use by generated code.
///
/// @nodoc
final class ExposedForCodeGen {
  /// Create [Table] object.
  ///
  /// @nodoc
  static Table<T> declareTable<T extends Model>({
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

  static Future<T> insertInto<T extends Model>({
    required Table<T> table,
    required List<Expr> values,
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

  static Future<void> update<T extends Model>(
    Query<(Expr<T>,)> query,
    Update<T> Function(Expr<T> row) updateBuilder,
  ) async {
    final table = switch (query._expressions.$1) {
      final ModelExpression e => e.table,
      _ => throw AssertionError('Expr<Model> must be ModelExpression'),
    };

    final handle = Object();
    final row = query._expressions.$1._standin(0, handle);
    final values = updateBuilder(row)._values;

    final (sql, params) = table._context._dialect.update(
      UpdateStatement(
        TableClause(table._tableName, table._columns),
        table._columns
            .whereIndexed((index, value) => values[index] != null)
            .toList(),
        values.nonNulls.toList(),
        handle,
        query._from(query._expressions.toList()),
      ),
    );

    await table._context._query(sql, params).drain();
  }

  // TODO: Design a solution for migrations using atlas creating dialect
  //       specific migraiton files in a folder, such that we just have to
  //       apply the migrations.
  static Future<void> applyMigration(
    DatabaseContext context,
    String migration,
  ) async {
    await context._query(migration, const []).drain();
  }

  static Update<T> buildUpdate<T extends Model>(List<Expr?> values) =>
      Update._(values);

  static Expr<T> field<T extends Object?, M extends Model>(
    Expr<M> row,
    int index,
  ) =>
      switch (row) {
        final ModelExpression row => row.field(index),
        // This can't actually happen
        _ => throw AssertionError('Expr<Model> must be a ModelExpression'),
      };
}
