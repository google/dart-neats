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

import 'package:typed_sql/sql_dialect/sql_dialect.dart';
import 'package:typed_sql/src/typed_sql.dart';

typedef _ParamFn = String Function(Object? param);

SqlDialect sqliteDialect() => _Sqlite();

final class _Sqlite extends SqlDialect {
  @override
  (String, List<Object?>) insertInto(
    String table,
    List<String> columns,
    List<Object?> values,
    List<String> returning,
  ) {
    return (
      [
        'INSERT INTO ${escape(table)}',
        '(${columns.map(escape).join(', ')})',
        'VALUES (${columns.map((_) => '?').join(', ')})',
        'RETURNING ${returning.map(escape).join(', ')}',
      ].join(' '),
      values
    );
  }

  void _checkOffsetAndLimit(int offset, int limit) {
    // This shouldn't be necessary, because an SqlDialect shall never be called
    // with invalid values! But we should be defensive when writing an
    // SqlDialect. That said, it could be argued that this should be assertions!
    if (offset < 0) {
      throw ArgumentError.value(
        offset,
        'offset',
        'must be non-negative',
      );
    }
    if (limit <= 0 && limit != -1) {
      throw ArgumentError.value(
        limit,
        'limit',
        'must be positive (or -1 for no limit)',
      );
    }
  }

  @override
  (String, List<Object?>) selectFrom(
    String table,
    String alias,
    List<String> columns,
    int limit,
    int offset,
    Expr<bool> where,
    ({bool descending, Expr term})? orderBy,
  ) {
    _checkOffsetAndLimit(offset, limit);

    final params = <Object?>[];
    String param(Object? param) {
      params.add(param);
      return '?';
    }

    return (
      [
        'SELECT ${columns.map((name) => '${escape(alias)}.${escape(name)}').join(', ')}',
        'FROM ${escape(table)} AS ${escape(alias)}',
        if (where != literal(true)) 'WHERE ${_expr(where, param)}',
        if (orderBy != null)
          'ORDER BY ${_expr(orderBy.term, param)} ${orderBy.descending ? 'DESC' : 'ASC'}',
        if (offset > 0) 'OFFSET ${param(offset)}',
        if (limit != -1) 'LIMIT ${param(limit)}',
      ].join(' '),
      params,
    );
  }

  @override
  (String, List<Object?>) update(
    String table,
    String alias,
    List<String> columns,
    List<Expr> values,
    int limit,
    int offset,
    Expr<bool> where,
    ({bool descending, Expr term})? orderBy,
  ) {
    _checkOffsetAndLimit(offset, limit);

    if (columns.length != values.length) {
      throw ArgumentError.value(
        values,
        'values',
        'number of columns and values must match',
      );
    }

    final params = <Object?>[];
    String param(Object? param) {
      params.add(param);
      return '?';
    }

    return (
      [
        'UPDATE ${escape(table)} AS ${escape(alias)}',
        'SET',
        for (var i = 0; i < columns.length; i++)
          '${escape(columns[i])} = ${_expr(values[i], param)}',
        if (where != literal(true)) 'WHERE ${_expr(where, param)}',
        if (orderBy != null)
          'ORDER BY ${_expr(orderBy.term, param)} ${orderBy.descending ? 'DESC' : 'ASC'}',
        if (offset > 0) 'OFFSET ${param(offset)}',
        if (limit != -1) 'LIMIT ${param(limit)}',
      ].join(' '),
      params,
    );
  }

  @override
  (String, List<Object?>) deleteFrom(
    String table,
    String alias,
    int limit,
    int offset,
    Expr<bool> where,
    ({bool descending, Expr term})? orderBy,
  ) {
    _checkOffsetAndLimit(offset, limit);

    final params = <Object?>[];
    String param(Object? param) {
      params.add(param);
      return '?';
    }

    // By default sqlite doesn't include support for ORDER BY/OFFSET/LIMIT in
    // DELETE FROM, it can be activated with a compile-time option.
    // But said option is not available in the amalgamation and other
    // pre-packaged C files, so it's best to assume it's not available.
    //
    // We work around this limitation by emulating ORDER BY/OFFSET/LIMIT using
    // a subquery. But we only do this if limit, offset or order by is given.
    //
    // For details see:
    // https://www.sqlite.org/compile.html#enable_update_delete_limit
    if (limit != -1 || offset != 0 || orderBy == null) {
      return (
        [
          'DELETE FROM ${escape(table)}',
          'WHERE rowid IN (',
          [
            'SELECT ${escape(alias)}.rowid',
            'FROM ${escape(table)} AS ${escape(alias)}',
            if (where != literal(true)) 'WHERE ${_expr(where, param)}',
            if (orderBy != null)
              'ORDER BY ${_expr(orderBy.term, param)} ${orderBy.descending ? 'DESC' : 'ASC'}',
            if (offset > 0) 'OFFSET ${param(offset)}',
            if (limit != -1) 'LIMIT ${param(limit)}',
          ].join(' '),
          ')',
        ].join(' '),
        params,
      );
    }

    // Handle the simple sane and common case!
    return (
      [
        'DELETE FROM ${escape(table)} AS ${escape(alias)}',
        if (where != literal(true)) 'WHERE ${_expr(where, param)}',
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

  String _expr<T>(
    Expr<T> expr,
    _ParamFn param,
  ) =>
      switch (expr) {
        RowExpression<Model>() => throw UnsupportedError(
            'Rows cannot be used in expressions, but fields of rows can be!',
          ),
        FieldExpression<T>(alias: final alias, name: final name) =>
          '${escape(alias)}.${escape(name)}',
        Literal<T>(value: final value) => param(value),
        final BinaryOperationExpression e =>
          '( ${_expr(e.left, param)} ${e.operator} ${_expr(e.right, param)} )',
        ExpressionBoolNot(value: final value) =>
          '( NOT ${_expr(value, param)} )',
        ExpressionStringIsEmpty(value: final value) =>
          '( ${_expr(value, param)} = ' ' )',
        ExpressionStringLength(value: final value) =>
          'LENGTH( ${_expr(value, param)} )',
        ExpressionStringStartsWith(value: final value, prefix: final prefix) =>
          '( ${_expr(value, param)} GLOB ${_expr(prefix, param)} || \'*\' )',
        ExpressionStringEndsWith(value: final value, suffix: final suffix) =>
          '( ${_expr(value, param)} GLOB \'*\' || ${_expr(suffix, param)} )',
        ExpressionStringLike(value: final value, pattern: final pattern) =>
          '( ${_expr(value, param)} LIKE ${param(pattern)} )',
        ExpressionStringContains(value: final value, needle: final needle) =>
          '( INSTR( ${_expr(value, param)} , ${_expr(needle, param)} ) = 0 )',
        ExpressionStringToUpperCase(value: final value) =>
          'UPPER( ${_expr(value, param)} )',
        ExpressionStringToLowerCase(value: final value) =>
          'LOWER( ${_expr(value, param)} )',
      };
}

final _sqlSafe = RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$');

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
