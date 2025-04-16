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
                'Sqlite does not support AUTOINCREMENT in composite primary keys',
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
    final resolver = ExpressionResolver(StatmentContext());

    String? returnProjection;
    final returning = statement.returning;
    if (returning != null) {
      final r = resolver.withScope(
        returning,
        returning.columns.map((c) => (null, c)).toList(),
      );
      returnProjection = returning.projection.map(r.expr).join(', ');
    }

    return (
      [
        'INSERT INTO ${escape(statement.table)}',
        '(${statement.columns.map(escape).join(', ')})',
        'VALUES (${statement.values.map(resolver.expr).join(', ')})',
        if (returnProjection != null) 'RETURNING $returnProjection',
      ].join(' '),
      resolver.context.parameters,
    );
  }

  @override
  (String, List<Object?>) update(UpdateStatement statement) {
    final resolver = ExpressionResolver(StatmentContext());
    final a1 = resolver.tableAlias1;
    final a2 = resolver.tableAlias2;

    final (sql, _) = resolver.selectExpression(statement.where);

    String? returnProjection;
    final returning = statement.returning;
    if (returning != null) {
      final r = resolver.withScope(
        returning,
        returning.columns.map((c) => (null, c)).toList(),
      );
      returnProjection = returning.projection.map(r.expr).join(', ');
    }

    final r = resolver.withScope(
      statement,
      statement.table.columns.map((c) => (a1, c)).toList(),
    );

    return (
      [
        'UPDATE ${escape(statement.table.name)} AS $a1',
        'SET',
        statement.columns
            .mapIndexed(
              (i, column) =>
                  '${escape(column)} = (${r.expr(statement.values[i])})',
            )
            .join(', '),
        'WHERE EXISTS (SELECT TRUE FROM ($sql) AS $a2 WHERE',
        statement.table.primaryKey
            .map((f) => '$a1.${escape(f)} = $a2.${escape(f)}')
            .join(', '),
        ')',
        if (returnProjection != null) 'RETURNING $returnProjection',
      ].join(' '),
      resolver.context.parameters,
    );
  }

  @override
  (String, List<Object?>) delete(DeleteStatement statement) {
    final resolver = ExpressionResolver(StatmentContext());
    final a1 = resolver.tableAlias1;
    final a2 = resolver.tableAlias2;

    final (sql, _) = resolver.selectExpression(statement.where);

    String? returnProjection;
    final returning = statement.returning;
    if (returning != null) {
      final r = resolver.withScope(
        returning,
        returning.columns.map((c) => (null, c)).toList(),
      );
      returnProjection = returning.projection.map(r.expr).join(', ');
    }

    return (
      [
        'DELETE FROM ${escape(statement.table.name)} AS $a1',
        'WHERE EXISTS (SELECT TRUE FROM ($sql) AS $a2 WHERE',
        statement.table.primaryKey
            .map((f) => '$a1.${escape(f)} = $a2.${escape(f)}')
            .join(', '),
        ')',
        if (returnProjection != null) 'RETURNING $returnProjection',
      ].join(' '),
      resolver.context.parameters,
    );
  }

  @override
  (String sql, List<Object?> params) select(
    SelectStatement statement,
  ) {
    final resolver = ExpressionResolver(StatmentContext());
    final (sql, columns) = resolver.selectExpression(statement.query);
    return (sql, resolver.context.parameters);
  }
}

/// Escape [name] for use as identifier in SQL.
///
/// Example: 'my string' -> '"my string"'
///
/// Throws if [name] cannot be safely escaped.
String escape(String name) => '"${name.replaceAll('"', '""')}"';

final class StatmentContext {
  final parameters = <Object?>[];

  String addParameter(Object? value) {
    parameters.add(value);
    final index = parameters.length;
    return '?$index';
  }
}

extension on ExpressionResolver<StatmentContext> {
  String get tableAlias => 't$depth';
  String get tableAlias1 => 't${depth}_1';
  String get tableAlias2 => 't${depth}_2';

  List<String> columnAliases(int N) => List.generate(N, (i) => 'c$i');

  /// Return someting you can use in `SELECT ... FROM <sql>`
  (String sql, List<String> columns) tableExpression(QueryClause q) {
    if (q is TableClause) {
      return (q.name, q.columns);
    }
    if (q is CompositeQueryClause) {
      final (sql1, columns) = tableExpression(q.left);
      final (sql2, _) = tableExpression(q.right);
      return (
        '(SELECT * FROM ($sql1) ${q.operator} SELECT * FROM ($sql2))',
        columns
      );
    }
    if (q is JoinClause) {
      final (sql1, columns1) = tableExpression(q.from);
      final (sql2, columns2) = tableExpression(q.join);

      final a1 = tableAlias1;
      final a2 = tableAlias2;

      final ctx = withScope(q, [
        ...columns1.map((c) => (a1, c)),
        ...columns2.map((c) => (a2, c)),
      ]);
      final columns = columnAliases(
        columns1.length + columns2.length,
      );
      return (
        [
          '(SELECT',
          [
            ...columns1.mapIndexed((i, c) => '$a1.${escape(c)}'),
            ...columns2.mapIndexed((i, c) => '$a2.${escape(c)}'),
          ].mapIndexed((i, e) => '$e AS ${columns[i]}').join(', '),
          'FROM $sql1 AS $a1',
          q.type.kind,
          'JOIN $sql2 AS $a2',
          'ON ${ctx.expr(q.on)})',
        ].join(' '),
        columns,
      );
    }

    final (sql, columns) = selectExpression(q);
    return ('($sql)', columns);
  }

  /// Return something on the form `SELECT ...`
  (String sql, List<String> columns) selectExpression(QueryClause q) {
    if (q is TableClause || q is CompositeQueryClause || q is JoinClause) {
      final (sql, columns) = tableExpression(q);
      return (
        'SELECT ${columns.map(escape).join(', ')} FROM $sql',
        columns,
      );
    }

    if (q is SelectClause) {
      final columns = columnAliases(q.expressions.length);
      return (
        [
          'SELECT',
          q.expressions
              .mapIndexed((i, e) => '${expr(e)} AS ${columns[i]}')
              .join(', '),
        ].join(' '),
        columns,
      );
    }

    final alias = tableAlias;
    final ranging = <QueryClause>[];

    loop:
    while (true) {
      switch (q) {
        case LimitClause():
          ranging.add(q);
          q = q.from;

        case OffsetClause():
          ranging.add(q);
          q = q.from;

        default:
          break loop;
      }
    }

    var distinct = false;
    while (q is DistinctClause) {
      distinct = true;
      q = q.from;
    }

    QueryClause? projection;

    if (q is SelectFromClause) {
      projection = q;
      q = q.from;

      loop:
      while (!distinct) {
        switch (q) {
          case LimitClause():
            ranging.add(q);
            q = q.from;

          case OffsetClause():
            ranging.add(q);
            q = q.from;

          default:
            break loop;
        }
      }
    } else if (q is GroupByClause) {
      projection = q;
      q = q.from;
    }

    final range = _RangeTracker();
    for (final q in ranging.reversed) {
      switch (q) {
        case LimitClause(:final limit):
          range.applyLimit(limit);
        case OffsetClause(:final offset):
          range.applyOffset(offset);
        default:
          AssertionError('unreachable');
      }
    }

    OrderByClause? order;
    final filters = <WhereClause>[];

    loop:
    while (true) {
      switch (q) {
        case WhereClause():
          filters.add(q);
          q = q.from;

        case OrderByClause() when projection is! GroupByClause:
          // Only the last orderBy clause as any effect
          order ??= q;
          q = q.from;

        default:
          break loop;
      }
    }

    final (sql, columns) = tableExpression(q);
    final columnsAndAlias = columns.map((c) => (alias, c)).toList();

    final List<String> resultColumns;
    final String selection;
    String? grouping;
    if (projection == null) {
      resultColumns = columns;
      selection = columns.map((c) => '$alias.${escape(c)}').join(', ');
    } else if (projection case SelectFromClause p) {
      resultColumns = columnAliases(p.projection.length);
      final ctx = withScope(p, columnsAndAlias);
      selection = p.projection
          .mapIndexed((i, e) => '(${ctx.expr(e)}) AS ${resultColumns[i]}')
          .join(', ');
    } else if (projection case GroupByClause g) {
      resultColumns = columnAliases(g.projection.length);
      final ctx = withScope(g, columnsAndAlias);
      selection = g.projection
          .mapIndexed((i, e) => '(${ctx.expr(e)}) AS ${resultColumns[i]}')
          .join(', ');
      grouping = g.groupBy.map(ctx.expr).join(', ');
    } else {
      throw AssertionError('unreachable');
    }

    String? ordering;
    if (order != null) {
      final ctx = withScope(order, columnsAndAlias);
      ordering = order.orderBy.map((key) {
        final (e, order) = key;
        return '${ctx.expr(e)} ${order == Order.descending ? 'DESC' : 'ASC'} NULLS LAST';
      }).join(', ');
    }

    String? where;
    if (filters.isNotEmpty) {
      where = filters.map((w) {
        final ctx = withScope(w, columnsAndAlias);
        return '( ${ctx.expr(w.where)} )';
      }).join(' AND ');
    }

    return (
      [
        'SELECT',
        if (distinct) 'DISTINCT',
        selection,
        'FROM',
        '($sql) AS $alias',
        if (where != null) 'WHERE $where',
        if (grouping != null) 'GROUP BY $grouping',
        if (ordering != null) 'ORDER BY $ordering',
        if (range.hasRange) 'LIMIT ${range.limit ?? -1} OFFSET ${range.offset}',
      ].join(' '),
      resultColumns,
    );
  }

  String resolveField<T>(FieldExpression<T> field) {
    final (alias, column) = resolve(field);
    if (alias == null) {
      return escape(column);
    }
    return '$alias.${escape(column)}';
  }

  String expr<T>(Expr<T> e) => switch (e) {
        FieldExpression<T>() => resolveField(e),
        SubQueryExpression<T>(:final query) =>
          '(${selectExpression(query).$1})',
        Literal.false$ => 'FALSE',
        Literal.true$ => 'TRUE',
        Literal.null$ => 'NULL',
        Literal<CustomDataType?>(value: final value) =>
          context.addParameter(value?.toDatabase()),
        Literal<T>(value: final value) => context.addParameter(value),
        final ExpressionNumDivide e =>
          '( CAST(${expr(e.left)} AS REAL) ${e.operator} ${expr(e.right)} )',
        final BinaryOperationExpression e =>
          '( ${expr(e.left)} ${e.operator} ${expr(e.right)} )',
        ExpressionBoolNot(value: final value) => '( NOT ${expr(value)} )',
        ExpressionStringIsEmpty(value: final value) =>
          '( ${expr(value)} = \'\' )',
        ExpressionStringLength(value: final value) =>
          'LENGTH( ${expr(value)} )',
        ExpressionStringStartsWith(value: final value, prefix: final prefix) =>
          '( ${expr(value)} GLOB ${expr(prefix)} || \'*\' )',
        ExpressionStringEndsWith(value: final value, suffix: final suffix) =>
          '( ${expr(value)} GLOB \'*\' || ${expr(suffix)} )',
        ExpressionStringLike(value: final value, pattern: final pattern) =>
          '( ${expr(value)} LIKE ${context.addParameter(pattern)} )',
        ExpressionStringContains(value: final value, needle: final needle) =>
          '( INSTR( ${expr(value)} , ${expr(needle)} ) > 0 )',
        ExpressionStringToUpperCase(value: final value) =>
          'UPPER( ${expr(value)} )',
        ExpressionStringToLowerCase(value: final value) =>
          'LOWER( ${expr(value)} )',
        ModelExpression<Model>() => throw AssertionError(
            'ModelExpression exist in a context where they are rendered',
          ),
        ExistsExpression(:final query) =>
          'EXISTS (${selectExpression(query).$1})',
        SumExpression<num>(:final value) =>
          'TOTAL(${expr(value)})', // We'll need to use COALESCE(SUM(a), 0.0) in postgres!
        AvgExpression(:final value) => 'AVG(${expr(value)})',
        MinExpression<Comparable>(:final value) => 'MIN(${expr(value)})',
        MaxExpression<Comparable>(:final value) => 'MAX(${expr(value)})',
        CountAllExpression() => 'COUNT(*)',
        OrElseExpression<T>(:final value, :final orElse) =>
          'COALESCE(${expr(value)}, ${expr(orElse)})',
        NotNullExpression<T>(:final value) => expr(value),
        final CastExpression e => 'CAST(${expr(e.value)} AS ${e.type.sqlType})',
        EncodedCustomDataTypeExpression(:final value) => expr(value),
      };
}

final class _RangeTracker {
  int offset = 0;
  int? limit;

  _RangeTracker();

  bool get hasRange => offset > 0 || limit != null;

  void applyLimit(int value) {
    final l = limit;
    if (l == null || l > value) {
      limit = value;
    }
  }

  void applyOffset(int value) {
    offset += value;
    var l = limit;
    if (l != null) {
      l = l - value;
      if (l < 0) {
        l = 0;
      }
      limit = l;
    }
  }
}

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
        ExpressionStringEquals() => 'IS NOT DISTINCT FROM',
        ExpressionStringLessThan() => '<',
        ExpressionStringLessThanOrEqual() => '<=',
        ExpressionStringGreaterThan() => '>',
        ExpressionStringGreaterThanOrEqual() => '>=',
        ExpressionNumEquals<num>() => 'IS NOT DISTINCT FROM',
        ExpressionNumAdd<num>() => '+',
        ExpressionNumSubtract<num>() => '-',
        ExpressionNumMultiply<num>() => '*',
        ExpressionNumDivide<num>() => '/',
        ExpressionNumLessThan<num>() => '<',
        ExpressionNumLessThanOrEqual<num>() => '<=',
        ExpressionNumGreaterThan<num>() => '>',
        ExpressionNumGreaterThanOrEqual<num>() => '>=',
        ExpressionDateTimeEquals() => 'IS NOT DISTINCT FROM',
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

extension on JoinType {
  String get kind => switch (this) {
        JoinType.inner => 'INNER',
        JoinType.left => 'LEFT',
        JoinType.right => 'RIGHT',
      };
}
