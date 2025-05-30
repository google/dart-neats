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

// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:build/build.dart' show BuildStep, Builder, BuilderOptions, log;
import 'package:code_builder/code_builder.dart';
import 'package:collection/collection.dart';
import 'package:source_gen/source_gen.dart' as g;

import 'code_builder_ext.dart';
import 'docs.dart' as docs;
import 'type_args.dart';

/// A [Builder] that generates extension methods and classes for typed_sql.
Builder typedSqlExtensionBuilder(BuilderOptions options) => g.SharedPartBuilder(
      [_TypedSqlExtensionBuilder(options)],
      'typed_sql_extensions',
    );

final class _TypedSqlExtensionBuilder extends g.Generator {
  final BuilderOptions options;

  _TypedSqlExtensionBuilder(this.options);

  @override
  Future<String?> generate(
    g.LibraryReader libraryReader,
    BuildStep buildStep,
  ) async {
    log.info('Generating extensions for typed_sql.g.dart');
    return Library(
      (b) => b.body..addAll(_buildExtensions()),
    ).accept(DartEmitter(useNullSafetySyntax: true)).toString();
  }
}

/// Maximum number of expressions we generate extension methods for.
///
/// If  `N = 3` we support `Query<(Expr<A>, Expr<B>, Expr<C>)>`, but not
/// `Query<(Expr<A>, Expr<B>, Expr<C>, Expr<D>)>`.
const N = 8; // max = 24

Iterable<Spec> _buildExtensions() sync* {
  if (N > typeArg.length) {
    throw AssertionError('N must be less than ${typeArg.length}');
  }

  for (var i = 1; i < N + 1; i++) {
    yield* _buildQueryExtension(i);
    yield _buildSubQueryExtension(i);
    yield* _buildOrderedQueryExtensions(i);
  }

  for (var i = 1; i < N; i++) {
    for (var j = 1; j < N; j++) {
      if (i + j > N) {
        continue;
      }
      yield* _buildJoinExtension(i, j);
    }
  }

  for (var i = 1; i < N; i++) {
    for (var j = 1; j < N; j++) {
      if (i + j > N) {
        continue;
      }
      yield _buildGroupByExtension(i, j);
      yield _buildAggregationExtension(i, j);
    }
  }

  for (var i = 1; i < N + 1; i++) {
    yield _buildSingleQueryExtension(i);
  }

  for (var i = 1; i < N + 1; i++) {
    yield* _buildReturnExtension(i);
  }

  for (var i = 1; i < N + 1; i++) {
    yield _buildToListExtension(i);
  }
}

/// Extension for Query
///
/// ```dart
/// extension QueryABC<A, B, C> on Query<(Expr<A>, Expr<B>, Expr<C>)> {...}
/// ```
Iterable<Spec> _buildQueryExtension(int i) sync* {
  yield Extension((b) => b
    ..name = 'Query$i'
    ..types.addAll(typeArg.take(i).map(refer))
    ..on = refer('Query<${typArgedExprTuple(i, 0)}>')
    ..documentation('''
      Extension methods for a query returning zero or more rows with
      $i expression${i > 1 ? 's' : ''}.
    ''')

    //   (Object, T) _build<T>(T Function(Expr<A> a, Expr<B> b, Expr<C> c) builder) {
    //     final handle = Object();
    //     var offset = 0;
    //     final a = _expressions.$1._standin(offset, handle);
    //     offset += _expressions.$1._columns;
    //     final b = _expressions.$2._standin(offset, handle);
    //     offset += _expressions.$2._columns;
    //     final c = _expressions.$3._standin(offset, handle);
    //     return (handle, builder(a, b, c));
    //   }
    ..methods.addAll([
      Method(
        (b) => b
          ..name = '_build'
          ..returns = refer('(Object, T)')
          ..types.add(refer('T'))
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'builder'
              ..type = refer('T Function(${typArgedExprArgumentList(i)})'),
          ))
          ..body = Code([
            'final handle = Object();',
            'var offset = 0;',
            ...arg
                .take(i)
                .mapIndexed((i, a) => [
                      'final $a = _expressions.\$${i + 1}._standin(offset, handle);',
                      'offset += _expressions.\$${i + 1}._columns;',
                    ])
                .flattened
                .take(i * 2 - 1),
            'return (handle, builder(${arg.take(i).join(',')}));',
          ].join('')),
      ),

      //   Query<(Expr<A>, Expr<B>, Expr<C>)> where(
      //     Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c) conditionBuilder,
      //   ) {
      //     final (handle, where) = _build(conditionBuilder);
      //     return Query._(
      //       _context,
      //       _expressions,
      //       (e) => WhereClause._(_from(e), handle, where),
      //     );
      //   }
      Method(
        (b) => b
          ..name = 'where'
          ..documentation(docs.where('Query'))
          ..returns = refer('Query<${typArgedExprTuple(i, 0)}>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'conditionBuilder'
              ..type =
                  refer('Expr<bool> Function(${typArgedExprArgumentList(i)})'),
          ))
          ..body = Code('''
            final (handle, where) = _build(conditionBuilder);
            return Query._(
              _context,
              _expressions,
              (e) => WhereClause._(_from(e), handle, where),
            );
          '''),
      ),

      //   Query<(Expr<A>, Expr<B>, Expr<C>)> orderBy(
      //     List<(Expr<Comparable?>, Order)> Function(Expr<A> a, Expr<B> b, Expr<C> c) builder,
      //   ) {
      //     final (handle, orderBy) = _build(builder);
      //     if (orderBy.isEmpty) {
      //       return this;
      //     }
      //     return Query._(
      //       _context,
      //       _expressions,
      //       (e) => OrderByClause._(_from(e), handle, orderBy, descending),
      //     );
      //   }
      Method(
        (b) => b
          ..name = 'orderBy'
          ..documentation(docs.orderBy('Query'))
          ..returns = refer('OrderedQuery<${typArgedExprTuple(i, 0)}>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'builder'
              ..type = refer(
                'List<(Expr<Comparable?>, Order)> Function(${typArgedExprArgumentList(i)})',
              ),
          ))
          ..body = Code('''
            final (handle, orderBy) = _build(builder);
            if (orderBy.isEmpty) {
              return OrderedQuery._(this);
            }
            return OrderedQuery._(Query._(
              _context,
              _expressions,
              (e) => OrderByClause._(_from(e), handle, orderBy),
            ));
          '''),
      ),

      //   Query<(Expr<A>, Expr<B>, Expr<C>)> limit(int limit) => Query._(
      //         _context,
      //         _expressions,
      //         (e) => LimitClause._(_from(e), limit),
      //       );
      Method(
        (b) => b
          ..name = 'limit'
          ..documentation(docs.limit('Query'))
          ..returns = refer('Query<${typArgedExprTuple(i, 0)}>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'limit'
              ..type = refer('int'),
          ))
          ..lambda = true
          ..body = Code('''
            Query._(
              _context,
              _expressions,
              (e) => LimitClause._(_from(e), limit),
            )
          '''),
      ),

      //   Query<(Expr<A>, Expr<B>, Expr<C>)> offset(int offset) => Query._(
      //         _context,
      //         _expressions,
      //         (e) => OffsetClause._(_from(e), offset),
      //       );
      Method(
        (b) => b
          ..name = 'offset'
          ..documentation(docs.offset('Query'))
          ..returns = refer('Query<${typArgedExprTuple(i, 0)}>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'offset'
              ..type = refer('int'),
          ))
          ..lambda = true
          ..body = Code('''
            Query._(
              _context,
              _expressions,
              (e) => OffsetClause._(_from(e), offset),
            )
          '''),
      ),

      //   QuerySingle<(Expr<A>, Expr<B>, Expr<C>)> get first => QuerySingle._(limit(1));
      Method(
        (b) => b
          ..name = 'first'
          ..documentation(docs.firstQuery)
          ..returns = refer('QuerySingle<${typArgedExprTuple(i, 0)}>')
          ..type = MethodType.getter
          ..lambda = true
          ..body = Code('''
            QuerySingle._(limit(1))
          '''),
      ),

      //   QuerySingle<(Expr<int>)> count() =>
      Method(
        (b) => b
          ..name = 'count'
          ..documentation(docs.countQuery)
          ..returns = refer('QuerySingle<(Expr<int>,)>')
          ..lambda = true
          ..body = Code('''
            select((${arg.take(i).join(',')}) => (CountAllExpression._(),)).first
          '''),
      ),

      //   Query<T> select<T extends Record>(
      //     T Function(Expr<A> a, Expr<B> b, Expr<C> c) projectionBuilder,
      //   ) {
      //     final (handle, projection) = _build(projectionBuilder);
      //     return Query._(
      //       _context,
      //       projection,
      //       (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
      //     );
      //   }
      Method(
        (b) => b
          ..name = 'select'
          ..documentation(docs.select('Query'))
          ..types.add(refer('T extends Record'))
          ..returns = refer('Query<T>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'projectionBuilder'
              ..type = refer('T Function(${typArgedExprArgumentList(i)})'),
          ))
          ..body = Code('''
            final (handle, projection) = _build(projectionBuilder);
            return Query._(
              _context,
              projection,
              (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
            );
          '''),
      ),

      //   Join<(Expr<A>, Expr<B>, Expr<C>), T> join<T extends Record>(Query<T> query) =>
      //       InnerJoin._(this, query);
      Method(
        (b) => b
          ..name = 'join'
          ..documentation(docs.innerJoinQuery)
          ..types.add(refer('T extends Record'))
          ..returns = refer('InnerJoin<${typArgedExprTuple(i)}, T>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'query'
              ..type = refer('Query<T>'),
          ))
          ..lambda = true
          ..body = Code('InnerJoin._(this, query)'),
      ),

      Method(
        (b) => b
          ..name = 'leftJoin'
          ..documentation(docs.leftJoinQuery)
          ..types.add(refer('T extends Record'))
          ..returns = refer('LeftJoin<${typArgedExprTuple(i)}, T>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'query'
              ..type = refer('Query<T>'),
          ))
          ..lambda = true
          ..body = Code('LeftJoin._(this, query)'),
      ),

      Method(
        (b) => b
          ..name = 'rightJoin'
          ..documentation(docs.rightJoinQuery)
          ..types.add(refer('T extends Record'))
          ..returns = refer('RightJoin<${typArgedExprTuple(i)}, T>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'query'
              ..type = refer('Query<T>'),
          ))
          ..lambda = true
          ..body = Code('RightJoin._(this, query)'),
      ),

      Method(
        (b) => b
          ..name = 'exists'
          ..documentation(docs.existsQuery)
          ..returns = refer('QuerySingle<(Expr<bool>,)>')
          ..lambda = true
          ..body = Code('''
            QuerySingle._(Query._(
              _context,
              (
                ExistsExpression._(_from(_expressions.toList())),
              ),
              SelectClause._,
              )
            )
          '''),
      ),

      // QueryClause _castAs(Query<(Expr<A>,)> other)
      Method(
        (b) => b
          ..name = '_castAs'
          ..returns = refer('QueryClause')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'as'
              ..type = refer('Query<${typArgedExprTuple(i)}>'),
          ))
          ..body = Code('''
            final (handle, projection) = _build((${arg.take(i).join(',')}) => [
              ${arg.take(i).mapIndexed((i, a) => '''
                if ($a._type is _ExprType<Null>)
                  ..._NullExprType._explodedCastAs($a, as._expressions.\$${i + 1}._type)
                else
                  $a
              ''').join(', ')}
            ]);
            return SelectFromClause._(
              _from(_expressions.toList()),
              handle,
              projection,
            );
          '''),
      ),

      //    Query<(Expr<A>, Expr<B>, Expr<C>)> $op(
      //      Query<(Expr<A>, Expr<B>, Expr<C>)> other,
      //    )
      for (final (method, clause, docs) in [
        ('union', 'UnionClause', docs.union),
        ('unionAll', 'UnionAllClause', docs.unionAll),
        ('intersect', 'IntersectClause', docs.intersection),
        ('except', 'ExceptClause', docs.except),
      ])
        Method(
          (b) => b
            ..name = method
            ..documentation(docs('Query'))
            ..returns = refer('Query<${typArgedExprTuple(i)}>')
            ..requiredParameters.add(Parameter(
              (b) => b
                ..name = 'other'
                ..type = refer('Query<${typArgedExprTuple(i)}>'),
            ))
            ..lambda = true
            ..body = Code('''
            Query._(
              _context,
              _expressions,
              (e) => $clause._(
                _from(_expressions.toList()),
                other._castAs(this),
              ),
            )
          '''),
        ),

      //    Query<T> operator +(Query<T> other) => unionAll(other);
      //    Query<T> operator -(Query<T> other) => except(other);
      //    Query<T> operator &(Query<T> other) => intersect(other);
      //    Query<T> operator |(Query<T> other) => union(other);
      for (final (op, method, docs) in [
        ('-', 'except', docs.union),
        ('+', 'unionAll', docs.unionAll),
        ('&', 'intersect', docs.intersection),
        ('|', 'union', docs.except),
      ])
        Method(
          (b) => b
            ..name = 'operator $op'
            ..documentation(docs('Query'))
            ..returns = refer('Query<${typArgedExprTuple(i)}>')
            ..requiredParameters.add(Parameter(
              (b) => b
                ..name = 'other'
                ..type = refer('Query<${typArgedExprTuple(i)}>'),
            ))
            ..lambda = true
            ..body = Code('$method(other)'),
        ),

      //    Group<T, (Expr<A>, Expr<B>)> groupBy<T extends Record>(
      //      T Function(Expr<A> a, Expr<B> b) groupBuilder,
      //    ) {
      //      final (handle, (group, standins)) = _build((a, b) {
      //        return (groupBuilder(a, b), (a, b));
      //      });
      //      return Group._(this, handle, group, standins);
      //    }
      Method(
        (b) => b
          ..name = 'groupBy'
          ..documentation(docs.groupBy)
          ..types.add(refer('T extends Record'))
          ..returns = refer('Group<T, ${typArgedExprTuple(i)}>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'groupBuilder'
              ..type = refer('T Function(${typArgedExprArgumentList(i)})'),
          ))
          ..body = Code('''
            final (handle, (group, standins)) = _build((${arg.take(i).join(',')}) {
              return (groupBuilder(${arg.take(i).join(',')}), (${arg.take(i).join(',')},));
            });
            return Group._(this, handle, group, standins);
          '''),
      ),

      //   Stream<(A, B, C)> stream() async* {
      //     final from = _from(_expressions.toList());
      //     final decode1 = _expressions.$1._decode;
      //     final decode2 = _expressions.$2._decode;
      //     final decode3 = _expressions.$3._decode;
      //
      //     final (sql, columns, params) = _context._dialect.select(
      //       SelectStatement._(from),
      //     );
      //
      //     await for (final row in _context._query(sql, params)) {
      //       yield (
      //         decode1(row) as A,
      //         decode2(row) as B,
      //         decode3(row) as C,
      //       );
      //     }
      //   }
      Method(
        (b) => b
          ..name = 'stream'
          ..documentation(docs.streamQuery)
          ..returns = refer(
            // Query1 return A, while Query2 returns (A, B)
            'Stream<${i == 1 ? typeArg[0] : '(${typeArg.take(i).join(',')})'}>',
          )
          ..modifier = MethodModifier.asyncStar
          ..body = Code([
            'final from = _from(_expressions.toList());',
            ...List.generate(
              i,
              (i) => 'final decode${i + 1} = _expressions.\$${i + 1}._decode;',
            ),
            'final (sql, params) = _context._dialect.select(SelectStatement._(from));',
            'await for (final row in _context._query(sql, params)) {',
            if (i == 1) ...[
              'yield decode1(row) as ${typeArg[0]};',
            ] else ...[
              'yield (',
              List.generate(i, (i) => 'decode${i + 1}(row) as ${typeArg[i]}')
                  .join(','),
              ');',
            ],
            '}',
          ].join('')),
      ),

      Method(
        (b) => b
          ..name = 'fetch'
          ..documentation(docs.fetchQuery)
          ..returns = refer(
            // Query1 return A, while Query2 returns (A, B)
            'Future<List<${i == 1 ? typeArg[0] : '(${typeArg.take(i).join(',')})'}>>',
          )
          ..modifier = MethodModifier.async
          ..lambda = true
          ..body = Code('await stream().toList()'),
      ),
    ]));
}

Iterable<Spec> _buildOrderedQueryExtensions(int i) sync* {
  Method where(String targetType, String returnType) => Method((b) => b
    ..name = 'where'
    ..documentation(docs.where(targetType))
    ..returns = refer('$returnType<${typArgedExprTuple(i, 0)}>')
    ..requiredParameters.add(Parameter(
      (b) => b
        ..name = 'conditionBuilder'
        ..type = refer('Expr<bool> Function(${typArgedExprArgumentList(i)})'),
    ))
    ..lambda = true
    ..body = Code('$returnType._(_query.where(conditionBuilder))'));

  Method select(String targetType, String returnType) => Method((b) => b
    ..name = 'select'
    ..documentation(docs.select(targetType))
    ..types.add(refer('T extends Record'))
    ..returns = refer('$returnType<T>')
    ..requiredParameters.add(Parameter(
      (b) => b
        ..name = 'projectionBuilder'
        ..type = refer('T Function(${typArgedExprArgumentList(i)})'),
    ))
    ..lambda = true
    ..body = Code('$returnType._(_query.select(projectionBuilder))'));

  Method orderBy(String targetType, String returnType) => Method((b) => b
    ..name = 'orderBy'
    ..documentation(docs.orderBy(targetType))
    ..returns = refer('$returnType<${typArgedExprTuple(i, 0)}>')
    ..requiredParameters.add(Parameter(
      (b) => b
        ..name = 'builder'
        ..type = refer(
          'List<(Expr<Comparable?>, Order)> Function(${typArgedExprArgumentList(i)})',
        ),
    ))
    ..lambda = true
    ..body = Code('_query.orderBy(builder)'));

  Method limit(String targetType, String returnType) => Method((b) => b
    ..name = 'limit'
    ..documentation(docs.limit(targetType))
    ..returns = refer('$returnType<${typArgedExprTuple(i, 0)}>')
    ..requiredParameters.add(Parameter(
      (b) => b
        ..name = 'limit'
        ..type = refer('int'),
    ))
    ..lambda = true
    ..body = Code('$returnType._(_query.limit(limit))'));

  Method offset(String targetType, String returnType) => Method((b) => b
    ..name = 'offset'
    ..documentation(docs.offset(targetType))
    ..returns = refer('$returnType<${typArgedExprTuple(i, 0)}>')
    ..requiredParameters.add(Parameter(
      (b) => b
        ..name = 'offset'
        ..type = refer('int'),
    ))
    ..lambda = true
    ..body = Code('$returnType._(_query.offset(offset))'));

  Method fetch() => Method((b) => b
    ..name = 'fetch'
    ..documentation(docs.fetchQuery)
    ..returns = refer(
      'Future<List<${i == 1 ? typeArg[0] : '(${typeArg.take(i).join(',')})'}>>',
    )
    ..lambda = true
    ..body = Code('_query.fetch()'));

  Method stream() => Method((b) => b
    ..name = 'stream'
    ..documentation(docs.streamQuery)
    ..returns = refer(
      'Stream<${i == 1 ? typeArg[0] : '(${typeArg.take(i).join(',')})'}>',
    )
    ..lambda = true
    ..body = Code('_query.stream()'));

  Method first() => Method((b) => b
    ..name = 'first'
    ..documentation(docs.firstQuery)
    ..returns = refer('QuerySingle<${typArgedExprTuple(i, 0)}>')
    ..type = MethodType.getter
    ..lambda = true
    ..body = Code('_query.first'));

  yield Extension((b) => b
    ..name = 'OrderedQuery$i'
    ..types.addAll(typeArg.take(i).map(refer))
    ..on = refer('OrderedQuery<${typArgedExprTuple(i, 0)}>')
    ..documentation('''
      Extension methods for a query returning zero or more rows with
      $i expression${i > 1 ? 's' : ''}.
    ''')
    ..methods.addAll([
      where('OrderedQuery', 'OrderedQuery'),
      select('OrderedQuery', 'ProjectedOrderedQuery'),
      limit('OrderedQuery', 'OrderedQueryRange'),
      offset('OrderedQuery', 'OrderedQueryRange'),
      orderBy('OrderedQuery', 'OrderedQuery'),
      fetch(),
      stream(),
      first(),
    ]));

  yield Extension((b) => b
    ..name = 'OrderedQueryRange$i'
    ..types.addAll(typeArg.take(i).map(refer))
    ..on = refer('OrderedQueryRange<${typArgedExprTuple(i, 0)}>')
    ..documentation('''
      Extension methods for a query returning zero or more rows with
      $i expression${i > 1 ? 's' : ''}.
    ''')
    ..methods.addAll([
      select('OrderedQueryRange', 'ProjectedOrderedQueryRange'),
      limit('OrderedQueryRange', 'OrderedQueryRange'),
      offset('OrderedQueryRange', 'OrderedQueryRange'),
      orderBy('OrderedQueryRange', 'OrderedQuery'),
      fetch(),
      stream(),
      first(),
    ]));

  yield Extension((b) => b
    ..name = 'ProjectedOrderedQuery$i'
    ..types.addAll(typeArg.take(i).map(refer))
    ..on = refer('ProjectedOrderedQuery<${typArgedExprTuple(i, 0)}>')
    ..documentation('''
      Extension methods for a query returning zero or more rows with
      $i expression${i > 1 ? 's' : ''}.
    ''')
    ..methods.addAll([
      limit('ProjectedOrderedQuery', 'ProjectedOrderedQueryRange'),
      offset('ProjectedOrderedQuery', 'ProjectedOrderedQueryRange'),
      orderBy('ProjectedOrderedQuery', 'OrderedQuery'),
      fetch(),
      stream(),
      first(),
    ]));

  yield Extension((b) => b
    ..name = 'ProjectedOrderedQueryRange$i'
    ..types.addAll(typeArg.take(i).map(refer))
    ..on = refer('ProjectedOrderedQueryRange<${typArgedExprTuple(i, 0)}>')
    ..documentation('''
      Extension methods for a query returning zero or more rows with
      $i expression${i > 1 ? 's' : ''}.
    ''')
    ..methods.addAll([
      limit('ProjectedOrderedQueryRange', 'ProjectedOrderedQueryRange'),
      offset('ProjectedOrderedQueryRange', 'ProjectedOrderedQueryRange'),
      orderBy('ProjectedOrderedQueryRange', 'OrderedQuery'),
      fetch(),
      stream(),
      first(),
    ]));

  // OrderedSubQuery

  yield Extension((b) => b
    ..name = 'OrderedSubQuery$i'
    ..types.addAll(typeArg.take(i).map(refer))
    ..on = refer('OrderedSubQuery<${typArgedExprTuple(i, 0)}>')
    ..documentation('''
      Extension methods for a ordered subquery of zero or more rows with
      $i expression${i > 1 ? 's' : ''}.
    ''')
    ..methods.addAll([
      where('OrderedSubQuery', 'OrderedSubQuery'),
      select('OrderedSubQuery', 'ProjectedOrderedSubQuery'),
      limit('OrderedSubQuery', 'OrderedSubQueryRange'),
      offset('OrderedSubQuery', 'OrderedSubQueryRange'),
      orderBy('OrderedSubQuery', 'OrderedSubQuery'),
    ]));

  yield Extension((b) => b
    ..name = 'OrderedSubQueryRange$i'
    ..types.addAll(typeArg.take(i).map(refer))
    ..on = refer('OrderedSubQueryRange<${typArgedExprTuple(i, 0)}>')
    ..documentation('''
      Extension methods for a ordered subquery of zero or more rows with
      $i expression${i > 1 ? 's' : ''}.
    ''')
    ..methods.addAll([
      select('OrderedSubQueryRange', 'ProjectedOrderedSubQueryRange'),
      limit('OrderedSubQueryRange', 'OrderedSubQueryRange'),
      offset('OrderedSubQueryRange', 'OrderedSubQueryRange'),
      orderBy('OrderedSubQueryRange', 'OrderedSubQuery'),
    ]));

  yield Extension((b) => b
    ..name = 'ProjectedOrderedSubQuery$i'
    ..types.addAll(typeArg.take(i).map(refer))
    ..on = refer('ProjectedOrderedSubQuery<${typArgedExprTuple(i, 0)}>')
    ..documentation('''
      Extension methods for a ordered subquery of zero or more rows with
      $i expression${i > 1 ? 's' : ''}.
    ''')
    ..methods.addAll([
      limit('ProjectedOrderedSubQuery', 'ProjectedOrderedSubQueryRange'),
      offset('ProjectedOrderedSubQuery', 'ProjectedOrderedSubQueryRange'),
      orderBy('ProjectedOrderedSubQuery', 'OrderedSubQuery'),
    ]));

  yield Extension((b) => b
    ..name = 'ProjectedOrderedSubQueryRange$i'
    ..types.addAll(typeArg.take(i).map(refer))
    ..on = refer('ProjectedOrderedSubQueryRange<${typArgedExprTuple(i, 0)}>')
    ..documentation('''
      Extension methods for a ordered subquery of zero or more rows with
      $i expression${i > 1 ? 's' : ''}.
    ''')
    ..methods.addAll([
      limit('ProjectedOrderedSubQueryRange', 'ProjectedOrderedSubQueryRange'),
      offset('ProjectedOrderedSubQueryRange', 'ProjectedOrderedSubQueryRange'),
      orderBy('ProjectedOrderedSubQueryRange', 'OrderedSubQuery'),
    ]));
}

/// Extension for Query
///
/// ```dart
/// extension SubQueryABC<A, B, C> on Query<(Expr<A>, Expr<B>, Expr<C>)> {...}
/// ```
Spec _buildSubQueryExtension(int i) {
  return Extension((b) => b
    ..name = 'SubQuery$i'
    ..on = refer('SubQuery<${typArgedExprTuple(i, 0)}>')
    ..types.addAll(typeArg.take(i).map(refer))
    ..documentation('''
      Extension methods for a subquery returning zero or more rows with
      $i expression${i > 1 ? 's' : ''}.
    ''')
    ..methods.addAll([
      Method(
        (b) => b
          ..name = '_build'
          ..returns = refer('(Object, T)')
          ..types.add(refer('T'))
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'builder'
              ..type = refer('T Function(${typArgedExprArgumentList(i)})'),
          ))
          ..body = Code([
            'final handle = Object();',
            'var offset = 0;',
            ...arg
                .take(i)
                .mapIndexed((i, a) => [
                      'final $a = _expressions.\$${i + 1}._standin(offset, handle);',
                      'offset += _expressions.\$${i + 1}._columns;',
                    ])
                .flattened
                .take(i * 2 - 1),
            'return (handle, builder(${arg.take(i).join(',')}));',
          ].join('')),
      ),

      Method(
        (b) => b
          ..name = 'where'
          ..documentation(docs.where('SubQuery'))
          ..returns = refer('SubQuery<${typArgedExprTuple(i, 0)}>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'conditionBuilder'
              ..type =
                  refer('Expr<bool> Function(${typArgedExprArgumentList(i)})'),
          ))
          ..body = Code('''
            final (handle, where) = _build(conditionBuilder);
            return SubQuery._(
              _expressions,
              (e) => WhereClause._(_from(e), handle, where),
            );
          '''),
      ),

      Method(
        (b) => b
          ..name = 'orderBy'
          ..documentation(docs.orderBy('SubQuery'))
          ..returns = refer('OrderedSubQuery<${typArgedExprTuple(i, 0)}>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'builder'
              ..type = refer(
                'List<(Expr<Comparable?>, Order)> Function(${typArgedExprArgumentList(i)})',
              ),
          ))
          ..body = Code('''
            final (handle, orderBy) = _build(builder);
            if (orderBy.isEmpty) {
              return OrderedSubQuery._(this);
            }
            return OrderedSubQuery._(SubQuery._(
              _expressions,
              (e) => OrderByClause._(_from(e), handle, orderBy),
            ));
          '''),
      ),

      Method(
        (b) => b
          ..name = 'limit'
          ..documentation(docs.limit('SubQuery'))
          ..returns = refer('SubQuery<${typArgedExprTuple(i, 0)}>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'limit'
              ..type = refer('int'),
          ))
          ..lambda = true
          ..body = Code('''
            SubQuery._(
              _expressions,
              (e) => LimitClause._(_from(e), limit),
            )
          '''),
      ),

      Method(
        (b) => b
          ..name = 'offset'
          ..documentation(docs.offset('SubQuery'))
          ..returns = refer('SubQuery<${typArgedExprTuple(i, 0)}>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'offset'
              ..type = refer('int'),
          ))
          ..lambda = true
          ..body = Code('''
            SubQuery._(
              _expressions,
              (e) => OffsetClause._(_from(e), offset),
            )
          '''),
      ),

      // TODO: Consider a .first method that returns Expr<(A, B, C, ...)>

      Method(
        (b) => b
          ..name = 'count'
          ..documentation(docs.countSubQuery)
          ..returns = refer('Expr<int>')
          ..lambda = true
          ..body = Code('''
            select((${arg.take(i).join(',')}) => (CountAllExpression._(),)).first.asNotNull()
          '''),
      ),

      Method(
        (b) => b
          ..name = 'select'
          ..documentation(docs.select('SubQuery'))
          ..types.add(refer('T extends Record'))
          ..returns = refer('SubQuery<T>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'projectionBuilder'
              ..type = refer('T Function(${typArgedExprArgumentList(i)})'),
          ))
          ..body = Code('''
            final (handle, projection) = _build(projectionBuilder);
            return SubQuery._(
              projection,
              (e) => SelectFromClause._(_from(_expressions.toList()), handle, e),
            );
          '''),
      ),

      // TODO: Consider introducing support for .union, .intersect, .except
      // TODO: Consider introducing support for .groupBy
      // TODO: Consider introducing SubJoin

      Method(
        (b) => b
          ..name = 'exists'
          ..documentation(docs.existsSubQuery)
          ..returns = refer('Expr<bool>')
          ..lambda = true
          ..body = Code('''
            ExistsExpression._(_from(_expressions.toList()))
          '''),
      ),
    ]));
}

/// Build extension for `QuerySingle`.
///
/// ```dart
/// extension QuerySingleAB<A, B> on QuerySingle<(Expr<A>, Expr<B>)> {
///   Query<(Expr<A>, Expr<B>)> get asQuery => _query;
///
///   QuerySingle<(Expr<A>, Expr<B>)> where(
///     Expr<bool> Function(Expr<A> a, Expr<B> b) conditionBuilder,
///   ) =>
///       asQuery.where(conditionBuilder).first;
///
///   QuerySingle<T> select<T extends Record>(
///     T Function(Expr<A> a, Expr<B> b) projectionBuilder,
///   ) =>
///       QuerySingle._(asQuery.select(projectionBuilder));
///
///   Future<(A, B)?> fetch() async => (await asQuery.fetch()).firstOrNull;
/// }
/// ```
Spec _buildSingleQueryExtension(int i) {
  return Extension(
    (b) => b
      ..name = 'QuerySingle$i'
      ..types.addAll(typeArg.take(i).map(refer))
      ..on = refer('QuerySingle<${typArgedExprTuple(i, 0)}>')
      ..documentation('''
        Extensions for a query returning at-most one row with
        $i expression${i > 1 ? 's' : ''}.
      ''')
      ..methods.addAll(
        [
          Method(
            (b) => b
              ..name = 'asQuery'
              ..documentation(docs.asQueryQuerySingle)
              ..returns = refer('Query<${typArgedExprTuple(i, 0)}>')
              ..type = MethodType.getter
              ..lambda = true
              ..body = Code('_query'),
          ),
          Method(
            (b) => b
              ..name = 'where'
              ..documentation(docs.where('QuerySingle'))
              ..returns = refer('QuerySingle<${typArgedExprTuple(i, 0)}>')
              ..requiredParameters.add(Parameter(
                (b) => b
                  ..name = 'conditionBuilder'
                  ..type = refer(
                    'Expr<bool> Function(${typArgedExprArgumentList(i)})',
                  ),
              ))
              ..lambda = true
              ..body = Code('asQuery.where(conditionBuilder).first'),
          ),
          Method(
            (b) => b
              ..name = 'select'
              ..documentation(docs.select('QuerySingle'))
              ..types.add(refer('T extends Record'))
              ..returns = refer('QuerySingle<T>')
              ..requiredParameters.add(Parameter(
                (b) => b
                  ..name = 'projectionBuilder'
                  ..type = refer(
                    'T Function(${typArgedExprArgumentList(i)})',
                  ),
              ))
              ..lambda = true
              ..body = Code('QuerySingle._(asQuery.select(projectionBuilder))'),
          ),
          Method(
            (b) => b
              ..name = 'fetch'
              ..documentation(i > 1
                  ? docs.fetchQuerySingleWithFetchOrNullsTip
                  : docs.fetchQuerySingle)
              ..returns = refer(
                'Future<${i == 1 ? typeArg[0] : '(${typeArg.take(i).join(',')})'}?>',
              )
              ..modifier = MethodModifier.async
              ..lambda = true
              ..body = Code('(await asQuery.fetch()).firstOrNull'),
          ),
          if (i > 1)
            Method(
              (b) => b
                ..name = 'fetchOrNulls'
                ..documentation(docs.fetchOrNullsQuerySingle)
                ..returns = refer(
                  'Future<(${List.generate(i, (i) => '${typeArg[i]}?').join(',')})>',
                )
                ..modifier = MethodModifier.async
                ..lambda = true
                ..body = Code(
                  'await fetch() ?? (${List.generate(i, (i) => 'null').join(',')})',
                ),
            ),
        ],
      ),
  );
}

/// Build extension for `ReturnSingle`.
///
/// ```dart
/// extension Return2<A, B> on Return<(Expr<A>, Expr<B>)> {
///   Stream<(A, B)> executeAndStream() async* {
///     final (sql, params) = _render(_expressions.toList());
///     await for (final r in _context._query(sql, params)) {
///       yield (_expressions.$1._decode(r) as A, _expressions.$2._decode(r) as B);
///     }
///   }
///
///   Future<List<(A, B)>> executeAndFetch() async =>
///       await executeAndStream().toList();
/// }
///
/// extension ReturnSingle2<A, B> on ReturnSingle<(Expr<A>, Expr<B>)> {
///   Future<(A, B)?> executeAndFetch() async =>
///       (await _return.executeAndFetch()).firstOrNull;
///
///   Future<(A?, B?)> executeAndFetchOrNulls() async =>
///       await executeAndFetch() ?? (null, null);
/// }
/// ```
Iterable<Spec> _buildReturnExtension(int i) sync* {
  yield Extension((b) => b
    ..name = 'Return$i'
    ..types.addAll(typeArg.take(i).map(refer))
    ..on = refer('Return<${typArgedExprTuple(i, 0)}>')
    ..documentation('''
      Extension methods for a statement returning zero or more rows with
      $i expression${i > 1 ? 's' : ''}.
    ''')
    ..methods.addAll([
      Method(
        (b) => b
          ..name = 'executeAndStream'
          ..documentation(docs.returnExecuteAndStream)
          ..returns = refer(
              'Stream<${i == 1 ? typeArg[0] : '(${typeArg.take(i).join(',')})'}>')
          ..modifier = MethodModifier.asyncStar
          ..body = Code('''
            final (sql, params) = _render(_expressions.toList());
            await for (final r in _context._query(sql, params)) {
              yield ${i == 1 ? '_expressions.\$1._decode(r) as ${typeArg[0]}' : '(${List.generate(i, (i) => '_expressions.\$${i + 1}._decode(r) as ${typeArg[i]}').join(',')})'};
            }
          '''),
      ),
      Method(
        (b) => b
          ..name = 'executeAndFetch'
          ..documentation(docs.returnExecuteAndFetch)
          ..returns = refer(
              'Future<List<${i == 1 ? typeArg[0] : '(${typeArg.take(i).join(',')})'}>>')
          ..modifier = MethodModifier.async
          ..lambda = true
          ..body = Code('await executeAndStream().toList()'),
      ),
    ]));

  yield Extension((b) => b
    ..name = 'ReturnSingle$i'
    ..types.addAll(typeArg.take(i).map(refer))
    ..on = refer('ReturnSingle<${typArgedExprTuple(i, 0)}>')
    ..documentation('''
      Extension methods for a statement returning at-most one row with
      $i expression${i > 1 ? 's' : ''}.
    ''')
    ..methods.addAll([
      Method(
        (b) => b
          ..name = 'executeAndFetch'
          ..documentation(docs.returnSingleExecuteAndFetch)
          ..returns = refer(
            'Future<${i == 1 ? typeArg[0] : '(${typeArg.take(i).join(',')})'}?>',
          )
          ..modifier = MethodModifier.async
          ..lambda = true
          ..body = Code('(await _return.executeAndFetch()).firstOrNull'),
      ),
      if (i > 1)
        Method(
          (b) => b
            ..name = 'executeAndFetchOrNulls'
            ..documentation(docs.returnSingleExecuteAndFetchOrNulls)
            ..returns = refer(
              'Future<(${List.generate(i, (i) => '${typeArg[i]}?').join(',')})>',
            )
            ..modifier = MethodModifier.async
            ..lambda = true
            ..body = Code(
              'await executeAndFetch() ?? (${List.generate(i, (i) => 'null').join(',')})',
            ),
        ),
    ]));

  yield Extension((b) => b
    ..name = 'ReturnOne$i'
    ..types.addAll(typeArg.take(i).map(refer))
    ..on = refer('ReturnOne<${typArgedExprTuple(i, 0)}>')
    ..documentation('''
      Extension methods for a statement returning exactly one row with
      $i expression${i > 1 ? 's' : ''}.
    ''')
    ..methods.addAll([
      Method(
        (b) => b
          ..name = 'executeAndFetch'
          ..documentation(docs.returnOneExecuteAndFetch)
          ..returns = refer(
            'Future<${i == 1 ? typeArg[0] : '(${typeArg.take(i).join(',')})'}>',
          )
          ..modifier = MethodModifier.async
          ..lambda = true
          ..body = Code('(await _return.executeAndFetch()).first'),
      ),
    ]));
}

/// Build extension for `toList` on tuple.
///
/// ```dart
/// extension<A, B, C> on (Expr<A>, Expr<B>, Expr<C>) {
///   List<Expr> toList() => [$1, $2, $3];
/// }
/// ```
Spec _buildToListExtension(int i) => Extension(
      (b) => b
        ..types.addAll(typeArg.take(i).map(refer))
        ..on = refer(typArgedExprTuple(i, 0))
        ..methods.add(Method(
          (b) => b
            ..name = 'toList'
            ..returns = refer('List<Expr>')
            ..lambda = true
            ..body =
                Code('[${List.generate(i, (i) => '\$${i + 1}').join(',')}]'),
        )),
    );

/// Build extension for `Join`
///
/// ```dart
/// extension Join2On1<A, B, C> on Join<(Expr<A>, Expr<B>), (Expr<C>,)> {
///   Query<(Expr<A>, Expr<B>, Expr<C>)> get all => Query._(
///         _from._context,
///         (
///           _from._expressions.$1,
///           _from._expressions.$2,
///           _join._expressions.$1,
///         ),
///         (_) => JoinClause._(
///           _from._from(_from._expressions.toList()),
///           _join._from(_join._expressions.toList()),
///         ),
///       );
///
///   Query<(Expr<A>, Expr<B>, Expr<C>)> on(
///     Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c) conditionBuilder,
///   ) =>
///       all.where(conditionBuilder);
/// }
/// ```
Iterable<Spec> _buildJoinExtension(int i, int j) sync* {
  final kinds = [
    ('Inner', '', '', 'inner'),
    ('Left', '', '?', 'left'),
    ('Right', '?', '', 'right'),
  ];
  for (final (kind, ln, rn, type) in kinds) {
    yield Extension((b) => b
      ..name = '${kind}Join${i}On$j'
      ..types.addAll(typeArg.take(i + j).map(refer))
      ..on = refer(
          '${kind}Join<${typArgedExprTuple(i, 0)}, ${typArgedExprTuple(j, i)}>')
      ..documentation('''
        Extension methods for completing an `${kind.toUpperCase()} JOIN`.
      ''')
      ..methods.addAll([
        // We only have `all` on INNER JOIN
        if (type == 'inner')
          Method((b) => b
            ..name = 'all'
            ..documentation(docs.innerJoinAll)
            ..returns = refer('Query<${listToTuple(toArgedExprList([
                  ...typeArg.take(i).map((v) => '$v$ln'),
                  ...typeArg.skip(i).take(j).map((v) => '$v$rn'),
                ]))}>')
            ..type = MethodType.getter
            ..lambda = true
            ..body = Code('''
              Query._(
                _from._context,
                (
                  ${List.generate(i, (i) => '_from._expressions.\$${i + 1}').join(',')},
                  ${List.generate(j, (i) => '_join._expressions.\$${i + 1}').join(',')},
                ),
                (_) => JoinClause._(
                  Object(),
                  JoinType.$type,
                  _from._from(_from._expressions.toList()),
                  _join._from(_join._expressions.toList()),
                  Literal.true\$,
                ),
              )
           ''')),
        Method((b) => b
          ..name = 'on'
          ..documentation(docs.joinOn(kind.toLowerCase()))
          ..returns = refer('Query<${listToTuple(toArgedExprList([
                ...typeArg.take(i).map((v) => '$v$ln'),
                ...typeArg.skip(i).take(j).map((v) => '$v$rn'),
              ]))}>')
          ..requiredParameters.add(Parameter(
            (b) => b
              ..name = 'conditionBuilder'
              ..type = refer(
                  'Expr<bool> Function(${typArgedExprArgumentList(i + j)})'),
          ))
          ..body = Code('''
            late JoinClause join;
            final q = Query._(
              _from._context,
              (
                ${List.generate(i, (i) => '_from._expressions.\$${i + 1}').join(',')},
                ${List.generate(j, (i) => '_join._expressions.\$${i + 1}').join(',')},
              ),
              (_) => join,
            );
            final (handle, on) = q._build(conditionBuilder);
            join = JoinClause._(
              handle,
              JoinType.$type,
              _from._from(_from._expressions.toList()),
              _join._from(_join._expressions.toList()),
              on,
            );
            return q;
          '''))
      ]));
  }
}

/// Build extension for `Group`
///
/// ```dart
/// extension Group2By1<A, B, C> on Group<(Expr<A>,), (Expr<B>, Expr<C>)> {
///   Query<T> aggregate<T extends Record>(
///     Aggregation<(Expr<B>, Expr<C>), T> Function(
///       Aggregation<(Expr<B>, Expr<C>), (Expr<A>,)> agg,
///     ) aggregationBuilder,
///   ) {
///     final agg = aggregationBuilder(Aggregation._(_standins, _group));
///
///     return Query._(
///       _from._context,
///       agg._projection,
///       (e) => GroupByClause._(
///         _from._from(_from._expressions.toList()),
///         _handle,
///         _group.toList(),
///         e,
///       ),
///     );
///   }
/// }
/// ```
Spec _buildGroupByExtension(int i, int j) {
  final S = typArgedExprTuple(i);
  final T = typArgedExprTuple(j, i);

  return Extension((b) => b
    ..name = 'Group${j}By$i'
    ..types.addAll(typeArg.take(i + j).map(refer))
    ..on = refer('Group<$S, $T>')
    ..documentation('''
      Extension methods for completing a `GROUP BY`.
    ''')
    // Note. There is no need for a .having clause, it's functionally equivalent
    //       use .where on the resulting Query<R>.
    ..methods.add(Method(
      (b) => b
        ..name = 'aggregate'
        ..documentation(docs.groupByAggregate)
        ..returns = refer('Query<T>')
        ..types.add(refer('T extends Record'))
        ..requiredParameters.add(Parameter(
          (b) => b
            ..name = 'aggregationBuilder'
            ..type =
                refer('Aggregation<$T, T> Function(Aggregation<$T, $S> agg)'),
        ))
        ..body = Code('''
          final agg = aggregationBuilder(Aggregation._(_standins, _group));

          return Query._(
            _from._context,
            agg._projection,
            (e) => GroupByClause._(
              _from._from(_from._expressions.toList()),
              _handle,
              _group.toList(),
              e,
            ),
          );
        '''),
    )));
}

/// Build extension for `Aggregation`.
///
/// ```dart
/// extension Aggregate2Project2<A, B, C, D>
///     on Aggregation<(Expr<A>, Expr<B>), (Expr<C>, Expr<D>)> {
///   ...
/// }
/// ```
Spec _buildAggregationExtension(int i, int j) {
  // Types that can be aggregated
  final S = typArgedExprTuple(i);
  // Types in the projection so far
  final t1 = typArgedExprTuple(j, i);
  // Types in the returned projection
  final t2 = typArgedExprTuple(j + 1, i);
  final T = typeArg[i + j]; // typeArg is zero indexed, so +1 is not necessary!

  // Types in the returned projection, where T is T?
  final t2nullable =
      listToTuple(toArgedExprList([...typeArg.skip(i).take(j), '$T?']));

  return Extension((b) => b
    ..name = 'Aggregate${i}Project$j'
    ..types.addAll(typeArg.take(i + j).map(refer))
    ..on = refer('Aggregation<$S, $t1>')
    ..documentation('''
      Extension methods for specifying aggregate functions over rows in a group.
    ''')
    ..methods.addAll([
      //  Aggregation<
      //      (
      //        Expr<A>,
      //        Expr<B>,
      //      ),
      //      (
      //        Expr<C>,
      //        Expr<D>,
      //        Expr<S>,
      //      )> _build<T, S>(
      //    Expr<T> Function(Expr<A> a, Expr<B> b) aggregateBuilder,
      //    Expr<S> Function(Expr<T> e) wrap,
      //  ) =>
      //      Aggregation._(
      //        _standins,
      //        (
      //          _projection.$1,
      //          _projection.$2,
      //          wrap(aggregateBuilder(_standins.$1, _standins.$2)),
      //        ),
      //      );
      Method((b) => b
        ..name = '_build'
        ..returns = refer('Aggregation<$S, $t2>')
        ..types.addAll([refer(T), refer('T')])
        ..requiredParameters.add(Parameter(
          (b) => b
            ..name = 'aggregateBuilder'
            ..type = refer('Expr<T> Function(${typArgedExprArgumentList(i)})'),
        ))
        ..requiredParameters.add(Parameter(
          (b) => b
            ..name = 'wrap'
            ..type = refer('Expr<$T> Function(Expr<T> e)'),
        ))
        ..lambda = true
        ..body = Code('''
          Aggregation._(
            _standins,
            (
              ${List.generate(j, (i) => '_projection.\$${i + 1}').join(', ')},
              wrap(aggregateBuilder(
                ${List.generate(i, (i) => '_standins.\$${i + 1}').join(', ')},
              )),
            ),
          )
        ''')),

      //  Aggregation<
      //      (
      //        Expr<A>,
      //        Expr<B>,
      //      ),
      //      (
      //        Expr<C>,
      //        Expr<D>,
      //        Expr<T>,
      //      )> sum<T extends num>(
      //    Expr<T> Function(Expr<A> a, Expr<B> b) aggregateBuilder,
      //  ) =>
      //      _build(aggregateBuilder, SumExpression._);
      Method((b) => b
        ..name = 'sum'
        ..documentation(docs.aggregationSum)
        ..returns = refer('Aggregation<$S, $t2>')
        ..types.add(refer('$T extends num'))
        ..requiredParameters.add(Parameter(
          (b) => b
            ..name = 'aggregateBuilder'
            ..type =
                refer('Expr<$T?> Function(${typArgedExprArgumentList(i)})'),
        ))
        ..lambda = true
        ..body = Code('_build(aggregateBuilder, SumExpression._)')),

      Method((b) => b
        ..name = 'avg'
        ..documentation(docs.aggregationAvg)
        ..returns = refer(
            'Aggregation<$S, ${listToTuple(typArgedExprAsList(j, i) + [
                  'Expr<double?>'
                ])}>')
        ..types.add(refer('$T extends num'))
        ..requiredParameters.add(Parameter(
          (b) => b
            ..name = 'aggregateBuilder'
            ..type =
                refer('Expr<$T?> Function(${typArgedExprArgumentList(i)})'),
        ))
        ..lambda = true
        ..body = Code('_build(aggregateBuilder, AvgExpression._)')),

      Method((b) => b
        ..name = 'min'
        ..documentation(docs.aggregationMin)
        ..returns = refer('Aggregation<$S, $t2nullable>')
        ..types.add(refer('$T extends Comparable'))
        ..requiredParameters.add(Parameter(
          (b) => b
            ..name = 'aggregateBuilder'
            ..type =
                refer('Expr<$T?> Function(${typArgedExprArgumentList(i)})'),
        ))
        ..lambda = true
        ..body = Code('_build(aggregateBuilder, MinExpression._)')),

      Method((b) => b
        ..name = 'max'
        ..documentation(docs.aggregationMax)
        ..returns = refer('Aggregation<$S, $t2nullable>')
        ..types.add(refer('$T extends Comparable'))
        ..requiredParameters.add(Parameter(
          (b) => b
            ..name = 'aggregateBuilder'
            ..type =
                refer('Expr<$T?> Function(${typArgedExprArgumentList(i)})'),
        ))
        ..lambda = true
        ..body = Code('_build(aggregateBuilder, MaxExpression._)')),

      Method((b) => b
        ..name = 'count'
        ..documentation(docs.aggregationCount)
        ..returns = refer(
            'Aggregation<$S, ${listToTuple(typArgedExprAsList(j, i) + [
                  'Expr<int>'
                ])}>')
        ..lambda = true
        ..body = Code('''
          _build(
            (${arg.take(i).join(',')}) => CountAllExpression._(),
            (a) => a
          )
        ''')),
    ]));
}
