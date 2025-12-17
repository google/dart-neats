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

import 'dart:convert' show json;
import 'dart:typed_data';

import 'package:collection/collection.dart';

import '../utils/normalize_json.dart';
import 'dialect.dart';

SqlDialect mysqlDialect() => _MysqlSqlDialect();

String _literal(dynamic value) => switch (value) {
      null => 'NULL',
      true => 'TRUE',
      false => 'FALSE',
      int i => i.toString(),
      double d => d.toString(),
      String s => "'${s.replaceAll("'", "''").replaceAll("\\", "\\\\")}'",
      DateTime d =>
        "'${d.toIso8601String().substring(0, 19).replaceFirst('T', ' ')}'",
      Uint8List b =>
        "X'${b.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}'",
      JsonValue j =>
        '(\'${json.encode(normalizeJson(j.value)).replaceAll("'", "''").replaceAll("\\", "\\\\")}\')',
      _ => throw UnsupportedError('Unable to encode "$value" as a literal'),
    };

final class _MysqlSqlDialect extends SqlDialect {
  @override
  String createTables(List<CreateTableStatement> statements) {
    final resolver = ExpressionResolver(PlainSqlContext());
    return [
      ...statements.map((table) {
        final resolvedColumnDefinitions = table.columns.map((c) {
          final override =
              c.overrides.firstWhereOrNull((o) => o.dialect == 'mysql');
          final generic =
              c.overrides.firstWhereOrNull((o) => o.dialect == null);
          final sqlType =
              override?.columnType ?? generic?.columnType ?? c.type.sqlType;
          return (
            name: c.name,
            sqlType: sqlType,
            originalColumnType: c.type,
            isNotNull: c.isNotNull,
            autoIncrement: c.autoIncrement,
            defaultValue: c.defaultValue,
          );
        }).toList();

        final indexedColumnNames = {
          ...table.primaryKey,
          ...table.unique.expand((u) => u),
          ...table.foreignKeys.expand((fk) => fk.columns),
        }.toSet();

        for (final colDef in resolvedColumnDefinitions) {
          if (indexedColumnNames.contains(colDef.name) &&
              colDef.originalColumnType == ColumnType.text &&
              colDef.sqlType == 'TEXT') {
            throw ArgumentError(
              'Column \'${colDef.name}\' in table \'${table.tableName}\' cannot be '
              'of type TEXT because it is used in a key constraint. MySQL '
              'does not support indexing full TEXT columns. Consider using an '
              '"@SqlOverride(dialect: \'mysql\', columnType: \'VARCHAR(255)\')" '
              'annotation on the field to specify an indexable type.',
            );
          }
        }

        return [
          'CREATE TABLE ${escape(table.tableName)} (',
          [
            // Columns
            ...resolvedColumnDefinitions.map((c) {
              final defaultValue = c.defaultValue;
              return [
                escape(c.name),
                c.sqlType,
                if (c.isNotNull) 'NOT NULL',
                if (c.autoIncrement) 'AUTO_INCREMENT',
                if (c.defaultValue != null)
                  if (defaultValue != null)
                    'DEFAULT ${resolver.expr(defaultValue)}',
              ].join(' ');
            }),
            // Primary key (composite)
            'PRIMARY KEY (${table.primaryKey.map(escape).join(', ')})',
            // Unique constraints - MySQL uses UNIQUE KEY syntax
            ...table.unique
                .map((u) => 'UNIQUE KEY (${u.map(escape).join(', ')})'),
          ].map((l) => '  $l').join(',\n'),
          ')',
        ].join('\n');
      }),
      ...statements.expand((table) {
        return table.foreignKeys.map(
          (fk) => [
            'ALTER TABLE ${escape(table.tableName)}',
            'ADD',
            'FOREIGN KEY (${fk.columns.map(escape).join(', ')})',
            'REFERENCES ${escape(fk.referencedTable)}',
            '(${fk.referencedColumns.map(escape).join(', ')})',
          ].join(' '),
        );
      }),
    ].join(';\n');
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
            .join(' AND '),
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
            .join(' AND '),
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
/// Example: 'my string' -> '`my string`'
///
/// Throws if [name] cannot be safely escaped.
String escape(String name) => '`$name`'; // TODO: escape `

abstract class SqlContext {
  String addParameter(Object? value);
}

final class StatmentContext extends SqlContext {
  final parameters = <Object?>[];

  @override
  String addParameter(Object? value) {
    switch (value) {
      case bool _:
        parameters.add(value);
        final index = parameters.length;
        return 'CAST(?$index AS SIGNED)';
      case int _:
        parameters.add(value);
        final index = parameters.length;
        return 'CAST(?$index AS SIGNED)';
      case double _:
        parameters.add(value);
        final index = parameters.length;
        return 'CAST(?$index AS DOUBLE)';
      case Uint8List _:
        parameters.add(value);
        final index = parameters.length;
        return 'CAST(?$index AS BINARY)';
      case DateTime _:
        parameters.add(value.toUtc());
        final index = parameters.length;
        return 'CAST(?$index AS DATETIME)';
      case String _:
        parameters.add(value);
        final index = parameters.length;
        return 'CAST(?$index AS CHAR)';
    }
    parameters.add(value);
    final index = parameters.length;
    return '?$index';
  }
}

final class PlainSqlContext extends SqlContext {
  final parameters = <Object?>[];

  @override
  String addParameter(Object? value) => _literal(value);
}

extension on ExpressionResolver<SqlContext> {
  String get tableAlias => 't$depth';
  String get tableAlias1 => 't${depth}_1';
  String get tableAlias2 => 't${depth}_2';

  List<String> columnAliases(int N) => List.generate(N, (i) => 'c$i');

  /// Return someting you can use in `SELECT ... FROM <sql>`
  (String sql, List<String> columns) tableExpression(QueryClause q) {
    if (q is TableClause) {
      return (escape(q.name), q.columns);
    }
    if (q is CompositeQueryClause) {
      final (sql, columns) = selectExpression(q);
      return ('($sql)', columns);
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
    if (q is CompositeQueryClause) {
      final (sql1, columns) = selectExpression(q.left);
      final (sql2, _) = selectExpression(q.right);
      return ('($sql1) ${q.operator} ($sql2)', columns);
    }
    if (q is TableClause || q is JoinClause) {
      final (sql, columns) = tableExpression(q);
      final alias = tableAlias;
      return (
        'SELECT ${columns.map((c) => '$alias.${escape(c)}').join(', ')} FROM $sql AS $alias',
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
        final expr = ctx.expr(e);
        final direction = order == Order.descending ? 'DESC' : 'ASC';
        return '($expr IS NULL) ASC, $expr $direction';
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
        '$sql AS $alias',
        if (where != null) 'WHERE $where',
        if (grouping != null) 'GROUP BY $grouping',
        if (ordering != null) 'ORDER BY $ordering',
        if (range.limit != null) 'LIMIT ${range.limit}',
        if (range.offset != 0) 'OFFSET ${range.offset}',
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
        Literal<CustomDataType?>(value: final value) =>
          context.addParameter(value?.toDatabase()),
        Literal<T>(value: final value) => context.addParameter(value),
        ExpressionBlobLength(:final value) => 'LENGTH(${expr(value)})',
        ExpressionBlobToHex(:final value) => 'HEX(${expr(value)})',
        ExpressionBlobDecodeUtf8(:final value) =>
          'CONVERT(${expr(value)} USING utf8mb4)',
        ExpressionBlobSublist(:final value, :final start, :final length) =>
          'CAST(SUBSTRING(${expr(value)}, ${expr(start)} + 1 ${length != null ? ', ${expr(length)}' : ''}) AS BINARY)',
        ExpressionBlobConcat(left: final l, right: final r) =>
          'CAST(CONCAT(${expr(l)}, ${expr(r)}) AS BINARY)',
        final ExpressionNumDivide e =>
          '( CAST(${expr(e.left)} AS DOUBLE) ${e.operator} ${expr(e.right)} )',
        final BinaryOperationExpression e =>
          '( ${expr(e.left)} ${e.operator} ${expr(e.right)} )',
        ExpressionBoolNot(value: final value) => '( NOT ${expr(value)} )',
        ExpressionStringIsEmpty(value: final value) =>
          '( ${expr(value)} = \'\' )',
        ExpressionStringLength(value: final value) =>
          'LENGTH( ${expr(value)} )',
        ExpressionStringStartsWith(value: final value, prefix: final prefix) =>
          'INSTR(${expr(value)}, ${expr(prefix)}) <=> 1',
        ExpressionStringEndsWith(value: final value, suffix: final suffix) =>
          'INSTR(REVERSE(${expr(value)}), REVERSE(${expr(suffix)})) <=> 1',
        ExpressionStringLike(value: final value, pattern: final pattern) =>
          '( ${expr(value)} LIKE ${context.addParameter(pattern)} )',
        ExpressionStringContains(value: final value, needle: final needle) =>
          '( INSTR( ${expr(value)} , ${expr(needle)} ) > 0 )',
        ExpressionStringToUpperCase(value: final value) =>
          'UPPER( ${expr(value)} )',
        ExpressionStringToLowerCase(value: final value) =>
          'LOWER( ${expr(value)} )',
        RowExpression<Row>() => throw AssertionError(
            'RowExpression exist in a context where they are rendered',
          ),
        ExistsExpression(:final query) =>
          'EXISTS (${selectExpression(query).$1})',
        SumExpression<int>(:final value) =>
          'CAST(COALESCE(SUM(${expr(value)}), 0.0) AS SIGNED)',
        SumExpression<num>(:final value) =>
          'CAST(COALESCE(SUM(${expr(value)}), 0.0) AS DOUBLE)',
        // database driver can't read DECIMAL so we cast to DOUBLE
        AvgExpression(:final value) => 'CAST(AVG(${expr(value)}) AS DOUBLE)',
        MinExpression<Comparable>(:final value) => 'MIN(${expr(value)})',
        MaxExpression<Comparable>(:final value) => 'MAX(${expr(value)})',
        CountAllExpression() => 'COUNT(*)',
        OrElseExpression<T>(:final value, :final orElse) =>
          'COALESCE(${expr(value)}, ${expr(orElse)})',
        NotNullExpression<T>(:final value) => expr(value),
        final CastExpression e =>
          'CAST(${expr(e.value)} AS ${e.type.sqlCastType})',
        EncodedCustomDataTypeExpression(:final value) => expr(value),
        CurrentTimestampExpression _ => 'UTC_TIMESTAMP()',
        ExpressionJsonRef e => _extract(e, ColumnType.jsonValue),
        ExpressionJsonExtract(:final ref, type: final t) => _extract(ref, t),
      };

  /// Extract JSON using JSON_EXTRACT for objects or JSON_VALUE for scalars.
  String _extract(ExpressionJsonRef ref, ColumnType type) {
    final (root, path) = jsonPath(ref);
    final rootSql = expr(root);
    final pathSql = context.addParameter(path);
    final extract = 'JSON_EXTRACT($rootSql, $pathSql)';

    if (type == ColumnType.jsonValue) {
      return extract;
    }

    // For MySQL (not MariaDB, yet) we should be able to use JSON_VALUE:
    // final returningType = switch (type) {
    //   ColumnType.integer => 'SIGNED',
    //   ColumnType.real => 'DOUBLE',
    //   ColumnType.boolean => 'SIGNED', // Maps bools to 1/0
    //   ColumnType.text =>
    //     'CHAR', // CHAR/TEXT depending on version, CHAR implies string
    //   _ => throw UnsupportedError('Unsupported JSON extract type: $type'),
    // };
    // return 'JSON_VALUE($rootSql, $pathSql RETURNING $returningType)'
    String strictExtract(String condition, String result) =>
        '(SELECT IF(JSON_TYPE(v) $condition, $result, NULL) FROM (SELECT $extract AS v) AS sub)';

    return switch (type) {
      ColumnType.jsonValue => extract,
      ColumnType.integer => strictExtract(
          "= 'INTEGER'",
          'CAST(v AS SIGNED)',
        ),
      ColumnType.real => strictExtract(
          "IN ('INTEGER', 'DOUBLE')",
          'CAST(v AS DOUBLE)',
        ),
      ColumnType.boolean => strictExtract(
          "= 'BOOLEAN'",
          "JSON_UNQUOTE(v) = 'true'",
        ),
      ColumnType.text => strictExtract(
          "= 'STRING'",
          'JSON_UNQUOTE(v)',
        ),
      _ => throw UnsupportedError('Unsupported JSON extract type: $type'),
    };
  }

  (Expr<JsonValue?>, String) jsonPath(ExpressionJsonRef ref) {
    switch (ref) {
      case ExpressionJsonRefRoot(:final value):
        return (value, r'$');
      case ExpressionJsonRefKey(:final value, :final key):
        final (root, path) = jsonPath(value);
        return (root, '$path.${_escapeJsonPathKey(key)}');
      case ExpressionJsonRefIndex(:final value, :final index):
        final (root, path) = jsonPath(value);
        return (root, '$path[$index]');
    }
  }

  String _escapeJsonPathKey(String key) {
    if (RegExp(r'^[a-zA-Z_][a-zA-Z0-9_]*$').hasMatch(key)) {
      return key;
    }
    return '"${key.replaceAll('"', '\\"')}"';
  }
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
        ExpressionEquals() => '=',
        ExpressionIsNotDistinctFrom() => '<=>',
        ExpressionLessThan() => '<',
        ExpressionLessThanOrEqual() => '<=',
        ExpressionGreaterThan() => '>',
        ExpressionGreaterThanOrEqual() => '>=',
        ExpressionNumAdd<num>() => '+',
        ExpressionNumSubtract<num>() => '-',
        ExpressionNumMultiply<num>() => '*',
        ExpressionNumDivide<num>() => '/',
        ExpressionBlobConcat() => throw AssertionError(
            'ExpressionBlobConcat must be explicitly handled',
          ),
      };
}

extension on ColumnType {
  String get sqlType => switch (this) {
        ColumnType<Uint8List> _ => 'BLOB',
        ColumnType<bool> _ => 'BOOLEAN',
        ColumnType<DateTime> _ => 'DATETIME(6)',
        ColumnType<int> _ => 'BIGINT',
        ColumnType<double> _ => 'DOUBLE',
        ColumnType<String> _ => 'TEXT',
        ColumnType<JsonValue> _ => 'JSON',
        ColumnType<Null> _ => throw UnsupportedError(
            'Null type cannot be used as column type',
          ),
      };

  String get sqlCastType => switch (this) {
        ColumnType<Uint8List> _ => 'BINARY',
        ColumnType<bool> _ => 'SIGNED',
        ColumnType<DateTime> _ => 'DATETIME',
        ColumnType<int> _ => 'SIGNED',
        ColumnType<double> _ => 'DOUBLE',
        ColumnType<String> _ => 'CHAR',
        ColumnType<JsonValue> _ => 'CHAR',
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
