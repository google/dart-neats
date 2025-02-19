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

const N = 8; // max = 24

Iterable<Spec> _buildExtensions() sync* {
  if (N > _typeArg.length) {
    throw AssertionError('N must be less than ${_typeArg.length}');
  }

  for (var i = 1; i < N + 1; i++) {
    yield _buildQueryExtension(i);
  }

  for (var i = 1; i < N; i++) {
    for (var j = 1; j < N; j++) {
      if (i + j > N) {
        continue;
      }
      yield _buildJoinExtension(i, j);
    }
  }

  for (var i = 1; i < N + 1; i++) {
    yield _buildSingleQueryExtension(i);
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
Spec _buildQueryExtension(int i) => Extension(
      (b) => b
        ..name = 'Query$i'
        ..on = refer('Query<${_typArgedExprTuple(i, 0)}>')
        ..types.addAll(_typeArg.take(i).map(refer))

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
        ..methods.add(Method(
          (b) => b
            ..name = '_build'
            ..returns = refer('(Object, T)')
            ..types.add(refer('T'))
            ..requiredParameters.add(Parameter(
              (b) => b
                ..name = 'builder'
                ..type = refer('T Function(${_typArgedExprArgumentList(i)})'),
            ))
            ..body = Code([
              'final handle = Object();',
              'var offset = 0;',
              ..._arg
                  .take(i)
                  .mapIndexed((i, a) => [
                        'final $a = _expressions.\$${i + 1}._standin(offset, handle);',
                        'offset += _expressions.\$${i + 1}._columns;',
                      ])
                  .flattened
                  .take(i * 2 - 1),
              'return (handle, builder(${_arg.take(i).join(',')}));',
            ].join('')),
        ))

        //   Query<(Expr<A>, Expr<B>, Expr<C>)> where(
        //     Expr<bool> Function(Expr<A> a, Expr<B> b, Expr<C> c) conditionBuilder,
        //   ) {
        //     final (handle, where) = _build(conditionBuilder);
        //     return _Query(
        //       _context,
        //       _expressions,
        //       (e) => WhereClause._(_from(e), handle, where),
        //     );
        //   }
        ..methods.add(Method(
          (b) => b
            ..name = 'where'
            ..returns = refer('Query<${_typArgedExprTuple(i, 0)}>')
            ..requiredParameters.add(Parameter(
              (b) => b
                ..name = 'conditionBuilder'
                ..type = refer(
                    'Expr<bool> Function(${_typArgedExprArgumentList(i)})'),
            ))
            ..body = Code('''
            final (handle, where) = _build(conditionBuilder);
            return _Query(
              _context,
              _expressions,
              (e) => WhereClause._(_from(e), handle, where),
            );
          '''),
        ))

        //   Query<(Expr<A>, Expr<B>, Expr<C>)> orderBy<T extends Object?>(
        //     Expr<T> Function(Expr<A> a, Expr<B> b, Expr<C> c) expressionBuilder, {
        //     bool descending = false,
        //   }) {
        //     final (handle, orderBy) = _build(expressionBuilder);
        //     return _Query(
        //       _context,
        //       _expressions,
        //       (e) => OrderByClause._(_from(e), handle, orderBy, descending),
        //     );
        //   }
        ..methods.add(Method(
          (b) => b
            ..name = 'orderBy'
            ..types.add(refer('T'))
            ..returns = refer('Query<${_typArgedExprTuple(i, 0)}>')
            ..requiredParameters.add(Parameter(
              (b) => b
                ..name = 'expressionBuilder'
                ..type =
                    refer('Expr<T> Function(${_typArgedExprArgumentList(i)})'),
            ))
            ..optionalParameters.add(Parameter(
              (b) => b
                ..name = 'descending'
                ..required = false
                ..named = true
                ..type = refer('bool')
                ..defaultTo = Code('false'),
            ))
            ..body = Code('''
            final (handle, orderBy) = _build(expressionBuilder);
            return _Query(
              _context,
              _expressions,
              (e) => OrderByClause._(_from(e), handle, orderBy, descending),
            );
          '''),
        ))

        //   Query<(Expr<A>, Expr<B>, Expr<C>)> limit(int limit) => _Query(
        //         _context,
        //         _expressions,
        //         (e) => LimitClause._(_from(e), limit),
        //       );
        ..methods.add(Method(
          (b) => b
            ..name = 'limit'
            ..returns = refer('Query<${_typArgedExprTuple(i, 0)}>')
            ..requiredParameters.add(Parameter(
              (b) => b
                ..name = 'limit'
                ..type = refer('int'),
            ))
            ..lambda = true
            ..body = Code('''
            _Query(
              _context,
              _expressions,
              (e) => LimitClause._(_from(e), limit),
            )
          '''),
        ))

        //   Query<(Expr<A>, Expr<B>, Expr<C>)> offset(int offset) => _Query(
        //         _context,
        //         _expressions,
        //         (e) => OffsetClause._(_from(e), offset),
        //       );
        ..methods.add(Method(
          (b) => b
            ..name = 'offset'
            ..returns = refer('Query<${_typArgedExprTuple(i, 0)}>')
            ..requiredParameters.add(Parameter(
              (b) => b
                ..name = 'offset'
                ..type = refer('int'),
            ))
            ..lambda = true
            ..body = Code('''
            _Query(
              _context,
              _expressions,
              (e) => OffsetClause._(_from(e), offset),
            )
          '''),
        ))

        //   QuerySingle<(Expr<A>, Expr<B>, Expr<C>)> get first => QuerySingle._(limit(1));
        ..methods.add(Method(
          (b) => b
            ..name = 'first'
            ..returns = refer('QuerySingle<${_typArgedExprTuple(i, 0)}>')
            ..type = MethodType.getter
            ..lambda = true
            ..body = Code('''
            QuerySingle._(limit(1))
          '''),
        ))

        //   Query<T> select<T extends Record>(
        //     T Function(Expr<A> a, Expr<B> b, Expr<C> c) projectionBuilder,
        //   ) {
        //     final (handle, projection) = _build(projectionBuilder);
        //     return _Query(
        //       _context,
        //       projection,
        //       (e) => SelectClause._(_from(_expressions.toList()), handle, e),
        //     );
        //   }
        ..methods.add(Method(
          (b) => b
            ..name = 'select'
            ..types.add(refer('T extends Record'))
            ..returns = refer('Query<T>')
            ..requiredParameters.add(Parameter(
              (b) => b
                ..name = 'projectionBuilder'
                ..type = refer('T Function(${_typArgedExprArgumentList(i)})'),
            ))
            ..body = Code('''
            final (handle, projection) = _build(projectionBuilder);
            return _Query(
              _context,
              projection,
              (e) => SelectClause._(_from(_expressions.toList()), handle, e),
            );
          '''),
        ))

        //   Join<(Expr<A>, Expr<B>, Expr<C>), T> join<T extends Record>(Query<T> query) =>
        //       Join._(this, query);
        ..methods.add(Method(
          (b) => b
            ..name = 'join'
            ..types.add(refer('T extends Record'))
            ..returns = refer('Join<${_typArgedExprTuple(i, 0)}, T>')
            ..requiredParameters.add(Parameter(
              (b) => b
                ..name = 'query'
                ..type = refer('Query<T>'),
            ))
            ..lambda = true
            ..body = Code('Join._(this, query)'),
        ))

        //   Stream<(A, B, C)> fetch() async* {
        //     final from = _from(_expressions.toList());
        //     final offset1 = 0;
        //     final decode1 = _expressions.$1._decode;
        //     final offset2 = offset1 + _expressions.$1._columns;
        //     final decode2 = _expressions.$2._decode;
        //     final offset3 = offset2 + _expressions.$2._columns;
        //     final decode3 = _expressions.$3._decode;
        //
        //     final (sql, columns, params) = _context._dialect.select(
        //       SelectStatement._(from),
        //     );
        //
        //     await for (final row in _context._db.query(sql, params)) {
        //       yield (
        //         decode1((i) => row[offset1 + i]),
        //         decode2((i) => row[offset2 + i]),
        //         decode3((i) => row[offset3 + i]),
        //       );
        //     }
        //   }
        ..methods.add(Method(
          (b) => b
            ..name = 'fetch'
            ..returns = refer(
              // Query1 return A, while Query2 returns (A, B)
              'Stream<${i == 1 ? _typeArg[0] : '(${_typeArg.take(i).join(',')})'}>',
            )
            ..modifier = MethodModifier.asyncStar
            ..body = Code([
              'final from = _from(_expressions.toList());',
              'final offset1 = 0;',
              ...List.generate(
                i,
                (i) => [
                  'final decode${i + 1} = _expressions.\$${i + 1}._decode;',
                  'final offset${i + 2} = offset${i + 1} + _expressions.\$${i + 1}._columns;',
                ],
              ).flattened.take(i * 2 - 1),
              'final (sql, columns, params) = _context._dialect.select(SelectStatement._(from));',
              'await for (final row in _context._db.query(sql, params)) {',
              'yield (',
              List.generate(
                i,
                (i) => 'decode${i + 1}((i) => row[offset${i + 1} + i])',
              ).join(','),
              ');',
              '}',
            ].join('')),
        )),
    );

/// Build extension for `toList` on tuple.
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
///   Future<(A, B)?> fetch() async => (await asQuery.fetch().toList()).firstOrNull;
/// }
/// ```
Spec _buildSingleQueryExtension(int i) => Extension(
      (b) => b
        ..name = 'QuerySingle$i'
        ..types.addAll(_typeArg.take(i).map(refer))
        ..on = refer('QuerySingle<${_typArgedExprTuple(i, 0)}>')
        ..methods.add(Method(
          (b) => b
            ..name = 'asQuery'
            ..returns = refer('Query<${_typArgedExprTuple(i, 0)}>')
            ..type = MethodType.getter
            ..lambda = true
            ..body = Code('_query'),
        ))
        ..methods.add(Method(
          (b) => b
            ..name = 'where'
            ..returns = refer('QuerySingle<${_typArgedExprTuple(i, 0)}>')
            ..requiredParameters.add(Parameter(
              (b) => b
                ..name = 'conditionBuilder'
                ..type = refer(
                  'Expr<bool> Function(${_typArgedExprArgumentList(i)})',
                ),
            ))
            ..lambda = true
            ..body = Code('asQuery.where(conditionBuilder).first'),
        ))
        ..methods.add(Method(
          (b) => b
            ..name = 'select'
            ..types.add(refer('T extends Record'))
            ..returns = refer('QuerySingle<T>')
            ..requiredParameters.add(Parameter(
              (b) => b
                ..name = 'projectionBuilder'
                ..type = refer(
                  'T Function(${_typArgedExprArgumentList(i)})',
                ),
            ))
            ..lambda = true
            ..body = Code('QuerySingle._(asQuery.select(projectionBuilder))'),
        ))
        ..methods.add(Method(
          (b) => b
            ..name = 'fetch'
            ..returns = refer(
              'Future<${i == 1 ? _typeArg[0] : '(${_typeArg.take(i).join(',')})'}?>',
            )
            ..modifier = MethodModifier.async
            ..lambda = true
            ..body = Code('(await asQuery.fetch().toList()).firstOrNull'),
        )),
    );

/// Build extension for `toList` on tuple.
///
/// ```dart
/// extension<A, B, C> on (Expr<A>, Expr<B>, Expr<C>) {
///   List<Expr> toList() => [$1, $2, $3];
/// }
/// ```
Spec _buildToListExtension(int i) => Extension(
      (b) => b
        ..types.addAll(_typeArg.take(i).map(refer))
        ..on = refer(_typArgedExprTuple(i, 0))
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
///   Query<(Expr<A>, Expr<B>, Expr<C>)> get all => _Query(
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
Spec _buildJoinExtension(int i, int j) {
  return Extension((b) => b
    ..name = 'Join${i}On$j'
    ..types.addAll(_typeArg.take(i + j).map(refer))
    ..on =
        refer('Join<${_typArgedExprTuple(i, 0)}, ${_typArgedExprTuple(j, i)}>')
    ..methods.add(Method(
      (b) => b
        ..name = 'all'
        ..returns = refer('Query<${_typArgedExprTuple(i + j, 0)}>')
        ..type = MethodType.getter
        ..lambda = true
        ..body = Code('''
        _Query(
          _from._context,
          (
            ${List.generate(i, (i) => '_from._expressions.\$${i + 1}').join(',')},
            ${List.generate(j, (i) => '_join._expressions.\$${i + 1}').join(',')},
          ),
          (_) => JoinClause._(
            _from._from(_from._expressions.toList()),
            _join._from(_join._expressions.toList()),
          ),
        )
        '''),
    ))
    ..methods.add(Method(
      (b) => b
        ..name = 'on'
        ..returns = refer('Query<${_typArgedExprTuple(i + j, 0)}>')
        ..lambda = true
        ..requiredParameters.add(Parameter(
          (b) => b
            ..name = 'conditionBuilder'
            ..type = refer(
                'Expr<bool> Function(${_typArgedExprArgumentList(i + j)})'),
        ))
        ..body = Code('''
          all.where(conditionBuilder)
      '''),
    )));
}

/// (Expr<A>, Expr<B>) for i = 2
String _typArgedExprTuple(int i, int offset) {
  if (i == 1) {
    return '(Expr<${_typeArg[0 + offset]}>,)';
  }
  return '(${List.generate(i, (i) => 'Expr<${_typeArg[i + offset]}>').join(',')})';
}

String _typArgedExprArgumentList(int i) {
  return List.generate(i, (i) => 'Expr<${_typeArg[i]}> ${_arg[i]}').join(',');
}

const _typeArg = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  //'S', // reserved for use in method templates
  //'T', // reserved for use in method templates
  'U',
  'V',
  'W',
  'X',
  'Y',
  'Z'
];

final _arg = _typeArg.map((s) => s.toLowerCase()).toList();
