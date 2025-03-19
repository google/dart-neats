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

import 'dart:typed_data' show Uint8List;

import 'package:collection/collection.dart';

import 'dialect.dart';

SqlDialect sqliteDialect() => _Sqlite();

String _literal(Object? value) => switch (value) {
      null => 'NULL',
      true => 'TRUE',
      false => 'TRUE',
      int i => i.toString(),
      double d => d.toString(),
      String s => '\'${s.replaceAll('\'', '\'\'')}\'',
      DateTime d => '\'${d.toIso8601String()}\'',
      _ => throw UnsupportedError('message'),
    };

final class _Sqlite extends SqlDialect {
  @override
  String createTables(List<CreateTableStatement> statements) {
    return statements.map((table) {
      return [
        'CREATE TABLE ${escape(table.tableName)} (',
        [
          // Columns
          ...table.columns.map((c) {
            final isPrimaryKey = table.primaryKey.contains(c.name) &&
                table.primaryKey.length == 1;

            if (c.autoIncrement &&
                table.primaryKey.contains(c.name) &&
                table.primaryKey.length > 1) {
              throw UnsupportedError(
                'sqlite does not support AUTOINCREMENT in composite primary keys',
              );
            }

            return [
              escape(c.name),
              c.type.sqlType,
              c.isNotNull ? 'NOT NULL' : '',
              if (isPrimaryKey) 'PRIMARY KEY',
              if (c.autoIncrement && isPrimaryKey) 'AUTOINCREMENT',
              if (c.autoIncrement && !isPrimaryKey)
                'GENERATED ALWAYS AS (rowid) STORED',
              if (c.defaultValue != null) 'DEFAULT ${_literal(c.defaultValue)}',
            ].join(' ');
          }),
          // Primary key
          if (table.primaryKey.length > 1)
            'PRIMARY KEY (${table.primaryKey.map(escape).join(', ')})',
          // Unique constraints
          ...table.unique.map((u) => 'UNIQUE (${u.map(escape).join(', ')})'),
          // Foreign keys
          ...table.foreignKeys.map(
            (fk) => [
              'FOREIGN KEY (${fk.columns.map(escape).join(', ')})',
              'REFERENCES ${escape(fk.referencedTable)}',
              '(${fk.referencedColumns.map(escape).join(', ')})',
            ].join(' '),
          ),
        ].map((l) => '  $l').join(',\n'),
        ');\n',
      ].join('\n');
    }).join('\n');
  }

  @override
  (String, List<Object?>) insertInto(InsertStatement statement) {
    final (params, ctx) = QueryContext.create();

    var returnProjection = '';
    final returning = statement.returning;
    if (returning != null) {
      final c = ctx.scope(returning, returning.columns);
      returnProjection = returning.projection.map((e) => expr(e, c)).join(', ');
    }

    // TODO: Is it possible to insert a ModelExpression
    //       It probably is, if copying a row from one table to another!
    return (
      [
        'INSERT INTO ${escape(statement.table)}',
        '(${statement.columns.map(escape).join(', ')})',
        'VALUES (${statement.values.map((e) => expr(e, ctx)).join(', ')})',
        if (returnProjection.isNotEmpty) 'RETURNING $returnProjection',
      ].join(' '),
      params,
    );
  }

  @override
  (String, List<Object?>) update(UpdateStatement statement) {
    final (params, ctx) = QueryContext.create();
    final (alias, c) = ctx.alias(statement, statement.table.columns);
    final (sql, _) = clause(statement.where, ctx);

    var returnProjection = '';
    final returning = statement.returning;
    if (returning != null) {
      final c = ctx.scope(returning, returning.columns);
      returnProjection = returning.projection.map((e) => expr(e, c)).join(', ');
    }

    return (
      [
        'UPDATE ${escape(statement.table.name)} AS $alias',
        'SET',
        statement.columns
            .mapIndexed(
              (i, column) => '$column = (${expr(statement.values[i], c)})',
            )
            .join(', '),
        'WHERE EXISTS (SELECT TRUE FROM ($sql) AS _subq WHERE',
        statement.table.primaryKey
            .map((f) => '$alias.${escape(f)} = _subq.${escape(f)}')
            .join(', '),
        ')',
        if (returnProjection.isNotEmpty) 'RETURNING $returnProjection',
      ].join(' '),
      params,
    );
  }

  @override
  (String, List<Object?>) delete(DeleteStatement statement) {
    final (params, ctx) = QueryContext.create();
    final (sql, _) = clause(statement.where, ctx);

    var returnProjection = '';
    final returning = statement.returning;
    if (returning != null) {
      final c = ctx.scope(returning, returning.columns);
      returnProjection = returning.projection.map((e) => expr(e, c)).join(', ');
    }

    return (
      [
        'DELETE FROM ${escape(statement.table.name)} as _topq',
        'WHERE EXISTS (SELECT TRUE FROM ($sql) AS _subq WHERE',
        statement.table.primaryKey
            .map((f) => '_topq.${escape(f)} = _subq.${escape(f)}')
            .join(', '),
        ')',
        if (returnProjection.isNotEmpty) 'RETURNING $returnProjection',
      ].join(' '),
      params,
    );
  }

  /// Escape [name] for use as identifier in SQL.
  ///
  /// Example: 'my string' -> '"my string"'
  ///
  /// Throws if [name] cannot be safely escaped.
  String escape(String name) {
    // TODO: Escaping is not exactly super consistent, some things that comes
    //       out of QueryContext.field() are not escaped further.
    //       We can debate what is sane, perhaps we should just not support
    //       field names that require escaping!
    //       Or pass an escape method to QueryContext when creating an instance!
    if (_sqlSafe.hasMatch(name) &&
        !_sqliteReservedKeywords.contains(name.toUpperCase())) {
      return name;
    }
    // TODO: Add support for escaping " and backslashes
    if (name.contains('"') || name.contains(r'\')) {
      throw UnsupportedError('Names with " are not supported');
    }
    return '"$name"';
  }

  @override
  (String sql, List<String> columns, List<Object?> params) select(
    SelectStatement statement,
  ) {
    final (params, ctx) = QueryContext.create();
    final (sql, columns) = clause(statement.query, ctx);
    return (sql, columns, params);
  }

  (String sql, List<String> columns) clause(QueryClause q, QueryContext ctx) {
    switch (q) {
      case TableClause(:var name, :var columns):
        return (
          'SELECT ${columns.map(escape).join(', ')} '
              'FROM ${escape(name)}',
          columns,
        );

      case OffsetClause(:final LimitClause from, :final offset):
        final (sql, columns) = clause(from, ctx);
        return ('$sql OFFSET $offset', columns);

      case OffsetClause(:final WhereClause from, :final offset):
        final (sql, columns) = clause(from, ctx);
        return ('$sql LIMIT -1 OFFSET $offset', columns);

      case OffsetClause(:final from, offset: 0):
        return clause(from, ctx);

      case OffsetClause(:final from, :final offset):
        final (sql, columns) = clause(from, ctx);
        return (
          'SELECT ${columns.map(escape).join(', ')} '
              'FROM ($sql) '
              'LIMIT -1 OFFSET $offset',
          columns,
        );

      case LimitClause(:final WhereClause from, :final limit):
        final (sql, columns) = clause(from, ctx);
        return ('$sql LIMIT $limit', columns);

      case LimitClause(:final from, :final limit):
        final (sql, columns) = clause(from, ctx);
        return (
          'SELECT ${columns.map(escape).join(', ')} '
              'FROM ($sql) '
              'LIMIT $limit',
          columns,
        );

      case DistinctClause(:final from):
        final (sql, columns) = clause(from, ctx);
        return (
          'SELECT DISTINCT ${columns.map(escape).join(', ')} '
              'FROM ($sql) ',
          columns,
        );

      case SelectFromClause(:final from, :final projection):
        final (sql, columns) = clause(from, ctx);
        final (alias, c) = ctx.alias(q, columns);
        return (
          'SELECT ${projection.mapIndexed(
                    (i, e) => '(${expr(e, c)}) AS c_$i',
                  ).join(', ')} '
              'FROM ($sql) AS $alias',
          projection.mapIndexed((i, e) => 'c_$i').toList(),
        );

      case WhereClause(
          from: TableClause(:var name, :var columns),
          :final where
        ):
        final (a, c) = ctx.alias(q, columns);
        return (
          'SELECT ${columns.map(escape).join(', ')} '
              'FROM $name AS $a '
              'WHERE ${expr(where, c)}',
          columns,
        );

      case WhereClause(:final from, :final where):
        final (sql, columns) = clause(from, ctx);
        final (a, c) = ctx.alias(q, columns);
        return (
          'SELECT ${columns.map(escape).join(', ')} '
              'FROM ($sql) AS $a '
              'WHERE ${expr(where, c)}',
          columns,
        );

      case OrderByClause(:final from, :final orderBy, :final descending):
        final (sql, columns) = clause(from, ctx);
        final (a, c) = ctx.alias(q, columns);
        return (
          'SELECT ${columns.map(escape).join(', ')} '
              'FROM ($sql) AS $a '
              'ORDER BY ${expr(orderBy, c)} '
              '${descending ? 'DESC' : 'ASC'}',
          columns,
        );

      case JoinClause(:final from, :final join):
        final (sql1, columns1) = clause(from, ctx);
        final (sql2, columns2) = clause(join, ctx);
        return (
          [
            'SELECT',
            [
              ...columns1.mapIndexed((i, c) => 't1.${escape(c)} AS t1_$i'),
              ...columns2.mapIndexed((i, c) => 't2.${escape(c)} AS t2_$i'),
            ].join(', '),
            'FROM ($sql1) as t1 JOIN ($sql2) as t2',
          ].join(' '),
          [
            ...columns1.mapIndexed((i, c) => 't1_$i'),
            ...columns2.mapIndexed((i, c) => 't2_$i'),
          ]
        );
      case SelectClause(:final expressions):
        return (
          [
            'SELECT',
            expressions
                .mapIndexed((i, e) => '( ${expr(e, ctx)} ) AS c_$i')
                .join(','),
          ].join(' '),
          expressions.mapIndexed((i, e) => 'c_$i').toList(),
        );

      case CompositeQueryClause(:final left, :final right):
        final (sql1, columns1) = clause(left, ctx);
        final (sql2, columns2) = clause(right, ctx);
        return (
          'SELECT ${columns1.join(', ')} FROM ($sql1) '
              '${q.operator} '
              'SELECT ${columns2.join(', ')} FROM ($sql2)',
          columns1
        );

      case GroupByClause(:final projection, :final from, :final groupBy):
        final (sql, columns) = clause(from, ctx);
        final (alias, c) = ctx.alias(q, columns);
        return (
          'SELECT ${projection.mapIndexed(
                    (i, e) => '(${expr(e, c)}) AS c_$i',
                  ).join(', ')} '
              'FROM ($sql) AS $alias '
              'GROUP BY ${groupBy.map((e) => expr(e, c)).join(', ')}',
          projection.mapIndexed((i, e) => 'c_$i').toList(),
        );
    }
  }

  String expr<T>(
    Expr<T> e,
    QueryContext ctx,
  ) =>
      switch (e) {
        FieldExpression<T>() => ctx.field(e),
        SubQueryExpression<T>(:final query) => '(${clause(query, ctx).$1})',
        Literal.false$ => 'FALSE',
        Literal.true$ => 'TRUE',
        Literal.null$ => 'NULL',
        Literal<CustomDataType>(value: final value) =>
          ctx.parameter(value.toDatabase()),
        Literal<T>(value: final value) => ctx.parameter(value),
        final ExpressionNumDivide e =>
          '( CAST(${expr(e.left, ctx)} AS REAL) ${e.operator} ${expr(e.right, ctx)} )',
        final BinaryOperationExpression e =>
          '( ${expr(e.left, ctx)} ${e.operator} ${expr(e.right, ctx)} )',
        ExpressionBoolNot(value: final value) => '( NOT ${expr(value, ctx)} )',
        ExpressionStringIsEmpty(value: final value) =>
          '( ${expr(value, ctx)} = \'\' )',
        ExpressionStringLength(value: final value) =>
          'LENGTH( ${expr(value, ctx)} )',
        ExpressionStringStartsWith(value: final value, prefix: final prefix) =>
          '( ${expr(value, ctx)} GLOB ${expr(prefix, ctx)} || \'*\' )',
        ExpressionStringEndsWith(value: final value, suffix: final suffix) =>
          '( ${expr(value, ctx)} GLOB \'*\' || ${expr(suffix, ctx)} )',
        ExpressionStringLike(value: final value, pattern: final pattern) =>
          '( ${expr(value, ctx)} LIKE ${ctx.parameter(pattern)} )',
        ExpressionStringContains(value: final value, needle: final needle) =>
          '( INSTR( ${expr(value, ctx)} , ${expr(needle, ctx)} ) > 0 )',
        ExpressionStringToUpperCase(value: final value) =>
          'UPPER( ${expr(value, ctx)} )',
        ExpressionStringToLowerCase(value: final value) =>
          'LOWER( ${expr(value, ctx)} )',
        ModelExpression<Model>() => throw AssertionError(
            'ModelExpression exist in a context where they are rendered',
          ),
        ExistsExpression(:final query) => 'EXISTS (${clause(query, ctx).$1})',
        SumExpression<num>(:final value) =>
          'TOTAL(${expr(value, ctx)})', // We'll need to use COALESCE(SUM(a), 0.0) in postgres!
        AvgExpression(:final value) => 'AVG(${expr(value, ctx)})',
        MinExpression<Comparable>(:final value) => 'MIN(${expr(value, ctx)})',
        MaxExpression<Comparable>(:final value) => 'MAX(${expr(value, ctx)})',
        CountAllExpression() => 'COUNT(*)',
        OrElseExpression<T>(:final value, :final orElse) =>
          'COALESCE(${expr(value, ctx)}, ${expr(orElse, ctx)})',
        // Null assertions do nothing!
        NullAssertionExpression<T>(:final value) => expr(value, ctx),
        final CastExpression e =>
          'CAST(${expr(e.value, ctx)} AS ${e.type.sqlType})',
      };
}

extension on QueryContext {
  String parameter(Object? value) {
    final index = param(value);
    return '?$index';
  }
}

final _sqlSafe = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$');

extension on CompositeQueryClause {
  String get operator => switch (this) {
        UnionClause() => 'UNION',
        UnionAllClause() => 'UNION ALL',
        IntersectClause() => 'INTERSECT',
        ExceptClause() => 'EXCEPT',
      };
}

extension on BinaryOperationExpression {
  String get operator => switch (this) {
        // TODO: Consider if some sort of type hierachy could possibly make this
        //       even smarter.
        ExpressionBoolAnd() => 'AND',
        ExpressionBoolOr() => 'OR',
        ExpressionStringEquals() => '=',
        ExpressionStringLessThan() => '<',
        ExpressionStringLessThanOrEqual() => '<=',
        ExpressionStringGreaterThan() => '>',
        ExpressionStringGreaterThanOrEqual() => '>=',
        ExpressionNumEquals<num>() => '=',
        ExpressionNumAdd<num>() => '+',
        ExpressionNumSubtract<num>() => '-',
        ExpressionNumMultiply<num>() => '*',
        ExpressionNumDivide<num>() => '/',
        ExpressionNumLessThan<num>() => '<',
        ExpressionNumLessThanOrEqual<num>() => '<=',
        ExpressionNumGreaterThan<num>() => '>',
        ExpressionNumGreaterThanOrEqual<num>() => '>=',
        ExpressionDateTimeEquals() => '=',
        ExpressionDateTimeLessThan() => '<',
        ExpressionDateTimeLessThanOrEqual() => '<=',
        ExpressionDateTimeGreaterThan() => '>',
        ExpressionDateTimeGreaterThanOrEqual() => '>=',
      };
}

extension on ColumnType {
  String get sqlType => switch (this) {
        ColumnType<Uint8List> _ => 'BLOB',
        ColumnType<bool> _ => 'BOOLEAN',
        ColumnType<DateTime> _ => 'DATETIME',
        ColumnType<int> _ => 'INTEGER',
        ColumnType<double> _ => 'REAL',
        ColumnType<String> _ => 'TEXT',
        ColumnType<Null> _ => throw UnsupportedError(
            'Null type cannot be used as column type',
          ),
      };
}

/// Reserved keywords in sqlite
///
/// See: https://sqlite.org/lang_keywords.html
final _sqliteReservedKeywords = [
  'ABORT',
  'ACTION',
  'ADD',
  'AFTER',
  'ALL',
  'ALTER',
  'ALWAYS',
  'ANALYZE',
  'AND',
  'AS',
  'ASC',
  'ATTACH',
  'AUTOINCREMENT',
  'BEFORE',
  'BEGIN',
  'BETWEEN',
  'BY',
  'CASCADE',
  'CASE',
  'CAST',
  'CHECK',
  'COLLATE',
  'COLUMN',
  'COMMIT',
  'CONFLICT',
  'CONSTRAINT',
  'CREATE',
  'CROSS',
  'CURRENT',
  'CURRENT_DATE',
  'CURRENT_TIME',
  'CURRENT_TIMESTAMP',
  'DATABASE',
  'DEFAULT',
  'DEFERRABLE',
  'DEFERRED',
  'DELETE',
  'DESC',
  'DETACH',
  'DISTINCT',
  'DO',
  'DROP',
  'EACH',
  'ELSE',
  'END',
  'ESCAPE',
  'EXCEPT',
  'EXCLUDE',
  'EXCLUSIVE',
  'EXISTS',
  'EXPLAIN',
  'FAIL',
  'FILTER',
  'FIRST',
  'FOLLOWING',
  'FOR',
  'FOREIGN',
  'FROM',
  'FULL',
  'GENERATED',
  'GLOB',
  'GROUP',
  'GROUPS',
  'HAVING',
  'IF',
  'IGNORE',
  'IMMEDIATE',
  'IN',
  'INDEX',
  'INDEXED',
  'INITIALLY',
  'INNER',
  'INSERT',
  'INSTEAD',
  'INTERSECT',
  'INTO',
  'IS',
  'ISNULL',
  'JOIN',
  'KEY',
  'LAST',
  'LEFT',
  'LIKE',
  'LIMIT',
  'MATCH',
  'MATERIALIZED',
  'NATURAL',
  'NO',
  'NOT',
  'NOTHING',
  'NOTNULL',
  'NULL',
  'NULLS',
  'OF',
  'OFFSET',
  'ON',
  'OR',
  'ORDER',
  'OTHERS',
  'OUTER',
  'OVER',
  'PARTITION',
  'PLAN',
  'PRAGMA',
  'PRECEDING',
  'PRIMARY',
  'QUERY',
  'RAISE',
  'RANGE',
  'RECURSIVE',
  'REFERENCES',
  'REGEXP',
  'REINDEX',
  'RELEASE',
  'RENAME',
  'REPLACE',
  'RESTRICT',
  'RETURNING',
  'RIGHT',
  'ROLLBACK',
  'ROW',
  'ROWS',
  'SAVEPOINT',
  'SELECT',
  'SET',
  'TABLE',
  'TEMP',
  'TEMPORARY',
  'THEN',
  'TIES',
  'TO',
  'TRANSACTION',
  'TRIGGER',
  'UNBOUNDED',
  'UNION',
  'UNIQUE',
  'UPDATE',
  'USING',
  'VACUUM',
  'VALUES',
  'VIEW',
  'VIRTUAL',
  'WHEN',
  'WHERE',
  'WINDOW',
  'WITH',
  'WITHOUT',
];
