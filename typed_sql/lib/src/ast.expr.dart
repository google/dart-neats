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

/// The SQL expression AST shared between the query-builder
/// (`typed_sql.dart`) and the SQL dialects (`dialect/`).
///
/// This library is never exported from `package:typed_sql/typed_sql.dart`
/// (except for [Expr] itself, which is genuinely public API).
library;

import 'dart:typed_data' show Uint8List;

import 'adapter/adapter.dart' show RowReader;
import 'ast.expr_types.dart'
    show
        ColumnType,
        CustomExprType,
        CustomExprTypeInternal,
        ExprType,
        ExprTypeInternal,
        FieldType,
        rowExprType,
        rowFieldsOf;
import 'ast.query.dart' show QueryClause, SelectFromClause;
import 'typed_sql.dart' show DefaultValue, Row, TableDefinition;
import 'types/custom_data_type.dart' show CustomDataType;
import 'types/json_value.dart' show JsonValue;

abstract final class _ExprTyped<T extends Object?> {
  ExprType<T> get _type;
}

/// A representation of an SQL expression with type `T`.
///
/// {@category inserting_rows}
/// {@category writing_queries}
/// {@category update_and_delete}
sealed class Expr<T extends Object?> implements _ExprTyped<T> {
  factory Expr(T value) => toExpr(value);

  const Expr.internal();

  int get _columns;

  Expr<T> _standin(int index, Object handle);
  Expr<R> _field<R>(int index, FieldType<R> type);
  T? _decode(RowReader r) => _type.$read(r);

  Iterable<Expr<Object?>> _explode();

  static final Expr<bool> true$ = LiteralExpression._true$;
  static final Expr<bool> false$ = LiteralExpression._false$;

  /// Get an [Expr<DateTime>] that represents the current timestamp in UTC.
  ///
  /// This [Expr<DateTime>] will be evaluated in the database. Semantically,
  /// it's supposed to be equivalent to:
  /// ```dart
  /// final currentTimestamp = toExpr(DateTime.now());
  /// ```
  /// where [toExpr] will normalize [DateTime] values to UTC.
  ///
  /// However, in practice many databases will render timestamps with fewer
  /// decimals than `DateTime.now()` in Dart.
  ///
  /// This is mainly intended if you want to use the database clock.
  /// For example, this is how [DefaultValue.now] is encoded.
  static const Expr<DateTime> currentTimestamp =
      CurrentTimestampExpression.currentTimestamp;
}

sealed class SingleValueExpr<T extends Object?> extends Expr<T> {
  const SingleValueExpr.internal() : super.internal();

  @override
  Iterable<Expr<T>> _explode() => [this];

  @override
  Expr<T> _standin(int index, Object handle) =>
      FieldExpression.internal(index, handle, _type);

  @override
  Expr<R> _field<R>(int index, FieldType<R> type) =>
      // This should never happen!
      throw AssertionError('Only Expr<Row> can have fields');

  @override
  int get _columns => 1;
}

base mixin _ExprBoolean implements _ExprTyped<bool> {
  @override
  final _type = ColumnType.boolean;
}

base mixin _ExprText implements _ExprTyped<String> {
  @override
  final _type = ColumnType.text;
}

base mixin _ExprInteger implements _ExprTyped<int> {
  @override
  final _type = ColumnType.integer;
}

base mixin _ExprReal implements _ExprTyped<double> {
  @override
  final _type = ColumnType.real;
}

// ignore: unused_element
base mixin _ExprDateTime implements _ExprTyped<DateTime> {
  @override
  final _type = ColumnType.dateTime;
}

base mixin _ExprBlob implements _ExprTyped<Uint8List> {
  @override
  final _type = ColumnType.blob;
}

// ignore: unused_element
base mixin _ExprJsonValue implements _ExprTyped<JsonValue> {
  @override
  final _type = ColumnType.jsonValue;
}

/// Create an [Expr<T>] wrapping [value] as SQL parameter.
///
/// The type of [value] must be one of:
///  * [String],
///  * [int],
///  * [double],
///  * [bool],
///  * [DateTime] (will be normalized to UTC),
///  * [Uint8List],
///  * `null`
///
/// > [!NOTE]
/// > If you want to use a [CustomDataType], use the `.asExpr`
/// > _extension method_ instead.
///
/// When wrapping a [DateTime] object using [toExpr], it will be normalized to
/// UTC before encoding to the database.
///
/// {@category inserting_rows}
/// {@category writing_queries}
/// {@category update_and_delete}
Expr<T> toExpr<T extends Object?>(T value) => ValueExpression(value);

/// Create an [Expr<T>] wrapping [value] as SQL literal.
///
/// The type of [value] must be one of:
///  * [String],
///  * [int],
///  * [double],
///  * [bool],
///  * [DateTime] (will be normalized to UTC),
///  * [Uint8List],
///  * `null`
///
/// > [!NOTE]
/// > If you want to use a [CustomDataType], use the `.asExprLiteral`
/// > _extension method_ instead.
///
/// When wrapping a [DateTime] object using [toExprLiteral], it will be
/// normalized to UTC before encoding to the database.
///
/// {@category inserting_rows}
/// {@category writing_queries}
/// {@category update_and_delete}
Expr<T> toExprLiteral<T extends Object?>(T value) => LiteralExpression(value);

final class RowExpression<T extends Row> extends Expr<T> {
  final TableDefinition<T> _table;
  final int _index;
  final Object _handle;

  @override
  Expr<T> _standin(int index, Object handle) =>
      RowExpression.internal(index, _table, handle);

  @override
  int get _columns => _table.columns.length;

  @override
  Expr<R> _field<R>(int index, ExprType<R> type) {
    if (index < 0 || index >= _table.columns.length) {
      throw ArgumentError.value(
        index,
        'index',
        'Table "${_table.tableName}" does not have a field '
            'at index $index',
      );
    }
    return FieldExpression.internal(_index + index, _handle, type);
  }

  @override
  Iterable<Expr<Object?>> _explode() => Iterable.generate(
    _columns,
    (index) => _field<void>(index, _table.columnInfo[index].type),
  );

  RowExpression.internal(this._index, this._table, this._handle)
    : super.internal();

  @override
  ExprType<T> get _type => rowExprType(_table);
}

final class FieldExpression<T> extends SingleValueExpr<T> {
  final int _index;
  final Object _handle;
  @override
  final ExprType<T> _type;

  FieldExpression.internal(this._index, this._handle, this._type)
    : super.internal();
}

final class SubQueryExpression<T> extends Expr<T> {
  final QueryClause query;
  final Expr<T> _value;

  SubQueryExpression.internal(this.query, this._value) : super.internal();

  @override
  int get _columns => _value._columns;

  @override
  Iterable<Expr<Object?>> _explode() {
    final fields = rowFieldsOf(_type);
    if (fields != null) {
      return Iterable.generate(
        _columns,
        (index) => _field<void>(index, fields[index]),
      );
    }
    return [this];
  }

  @override
  Expr<R> _field<R>(int index, FieldType<R> type) {
    final handle = Object();
    return SubQueryExpression.internal(
      SelectFromClause.internal(
        query,
        handle,
        [FieldExpression.internal(index, handle, type)],
      ),
      _value._field<R>(index, type), // TODO: Is this correct?
    );
  }

  @override
  Expr<T> _standin(int index, Object handle) => _value._standin(index, handle);

  @override
  ExprType<T> get _type => _value._type;
}

final class ExistsExpression extends SingleValueExpr<bool> with _ExprBoolean {
  final QueryClause query;
  ExistsExpression.internal(this.query) : super.internal();
}

final class SumExpression<T extends num> extends SingleValueExpr<T> {
  final Expr<T?> value;
  SumExpression.internal(this.value) : super.internal();

  @override
  ExprType<T> get _type => value._type as ExprType<T>;
}

// NOTE: AVG returns NULL, if applied to the empty set of values, also it
//       ignores NULL and will return NULL if applied to set of NULLs.
final class AvgExpression extends SingleValueExpr<double?> {
  final Expr<num?> value;
  AvgExpression.internal(this.value) : super.internal();

  @override
  final _type = ColumnType.real;
}

final class MinExpression<T extends Comparable> extends SingleValueExpr<T?> {
  final Expr<T?> value;
  MinExpression.internal(this.value) : super.internal();

  @override
  ExprType<T?> get _type => value._type;
}

final class MaxExpression<T extends Comparable> extends SingleValueExpr<T?> {
  final Expr<T?> value;
  MaxExpression.internal(this.value) : super.internal();

  @override
  ExprType<T?> get _type => value._type;
}

final class CountAllExpression extends SingleValueExpr<int> with _ExprInteger {
  CountAllExpression.internal() : super.internal();
}

final class OrElseExpression<T> extends SingleValueExpr<T> {
  final Expr<T?> value;
  final Expr<T> orElse;

  OrElseExpression.internal(this.value, this.orElse) : super.internal();

  @override
  ExprType<T> get _type {
    if (value._type == ColumnType.nullType) {
      return orElse._type;
    }
    return value._type as ExprType<T>; // TODO: Is this actually correct?
  }
}

final class NotNullExpression<T> extends Expr<T> {
  final Expr<T?> value;

  @override
  int get _columns => value._columns;

  // TODO: Does this actually work?
  @override
  ExprType<T> get _type => value._type as ExprType<T>;

  @override
  Iterable<Expr<Object?>> _explode() => value._explode();

  @override
  Expr<T> _standin(int index, Object handle) =>
      NotNullExpression.internal(value._standin(index, handle));

  @override
  Expr<R> _field<R>(int index, FieldType<R> type) => value._field(index, type);

  NotNullExpression.internal(this.value) : super.internal();
}

final class EncodedCustomDataTypeExpression<S, T extends CustomDataType<S>>
    extends SingleValueExpr<S?> {
  final Expr<T?> value;

  @override
  int get _columns => value._columns;

  @override
  ExprType<S> get _type => (value._type as CustomExprType<S, T>).$backingType;

  EncodedCustomDataTypeExpression.internal(this.value) : super.internal();
}

final class CastExpression<T, R> extends SingleValueExpr<R> {
  final Expr<T> value;
  final ColumnType<R> type;

  CastExpression.internal(this.value, this.type) : super.internal();

  @override
  ExprType<R> get _type => type;
}

final class LiteralExpression<T> extends SingleValueExpr<T> {
  final T value;

  @override
  final FieldType<T> _type;

  ColumnType<Object?> get type => switch (_type) {
    ColumnType<T> t => t,
    CustomExprType t => t.$backingType,
  };

  static final _true$ = LiteralExpression.internal(true, ColumnType.boolean);
  static final _false$ = LiteralExpression.internal(false, ColumnType.boolean);

  LiteralExpression.internal(this.value, this._type) : super.internal();

  factory LiteralExpression(T value) {
    // Switch over _Dummy<T> such that toExprLiteral<T?>(value) becomes an
    // instance of Expr<T?> even if value is `null`.
    switch (_Dummy<T>()) {
      case _Dummy<Null>():
        return LiteralExpression.internal(
          value,
          ColumnType.nullType as FieldType<T>,
        );
      case _Dummy<String?>():
        return LiteralExpression.internal(
          value,
          ColumnType.text as FieldType<T>,
        );
      case _Dummy<int?>():
        return LiteralExpression.internal(
          value,
          ColumnType.integer as FieldType<T>,
        );
      case _Dummy<double?>():
        return LiteralExpression.internal(
          value,
          ColumnType.real as FieldType<T>,
        );
      case _Dummy<bool?>():
        switch (value) {
          case true:
            return _true$ as LiteralExpression<T>;
          case false:
            return _false$ as LiteralExpression<T>;
          default: // null
            return LiteralExpression.internal(
              value,
              ColumnType.boolean as FieldType<T>,
            );
        }
      case _Dummy<DateTime?>():
        return LiteralExpression.internal(
          value,
          ColumnType.dateTime as FieldType<T>,
        );
      case _Dummy<Uint8List?>():
        return LiteralExpression.internal(
          value,
          ColumnType.blob as FieldType<T>,
        );
      case _Dummy<JsonValue?>():
        return LiteralExpression.internal(
          value,
          ColumnType.jsonValue as FieldType<T>,
        );
      case _Dummy<CustomDataType?>():
        if (value == null) {
          return LiteralExpression<Null>.internal(null, ColumnType.nullType)
              as LiteralExpression<T>;
        }
        throw ArgumentError.value(
          value,
          'value',
          'Use CustomDataType.asExpr instead of toExpr()!',
        );
      default:
        // If there is no inferred T in toExprLiteral(value), for example when
        // user does:
        //    Expr<Object?> e = toExprLiteral(value);
        // then we infer T from value.
        // That does mean we loose the type if value is `null`, but otherwise
        // we shall recover it.
        switch (value) {
          case String v:
            return LiteralExpression<String>.internal(v, ColumnType.text)
                as LiteralExpression<T>;
          case int v:
            return LiteralExpression<int>.internal(v, ColumnType.integer)
                as LiteralExpression<T>;
          case double v:
            return LiteralExpression<double>.internal(v, ColumnType.real)
                as LiteralExpression<T>;
          case bool v:
            switch (v) {
              case true:
                return _true$ as LiteralExpression<T>;
              case false:
                return _false$ as LiteralExpression<T>;
            }
          case DateTime v:
            return LiteralExpression<DateTime>.internal(v, ColumnType.dateTime)
                as LiteralExpression<T>;
          case Uint8List v:
            return LiteralExpression<Uint8List>.internal(v, ColumnType.blob)
                as LiteralExpression<T>;
          case JsonValue v:
            return LiteralExpression<JsonValue>.internal(
                  v,
                  ColumnType.jsonValue,
                )
                as LiteralExpression<T>;
          case null:
            return LiteralExpression<Null>.internal(null, ColumnType.nullType)
                as LiteralExpression<T>;
          default:
            throw ArgumentError.value(
              value,
              'value',
              'Only String, int, double, bool, null, DateTime, Uint8List,'
                  ' JsonValue values are allowed',
            );
        }
    }
  }
}

final class ValueExpression<T> extends SingleValueExpr<T> {
  final T value;

  @override
  final FieldType<T> _type;

  ColumnType<Object?> get type => switch (_type) {
    ColumnType<T> t => t,
    CustomExprType t => t.$backingType,
  };

  ValueExpression.internal(this.value, this._type) : super.internal();

  factory ValueExpression(T value) {
    // Switch over _Dummy<T> such that toExpr<T?>(value) becomes an
    // instance of Expr<T?> even if value is `null`.
    switch (_Dummy<T>()) {
      case _Dummy<Null>():
        return ValueExpression.internal(
          value,
          ColumnType.nullType as ColumnType<T>,
        );
      case _Dummy<String?>():
        return ValueExpression.internal(
          value,
          ColumnType.text as ColumnType<T>,
        );
      case _Dummy<int?>():
        return ValueExpression.internal(
          value,
          ColumnType.integer as ColumnType<T>,
        );
      case _Dummy<double?>():
        return ValueExpression.internal(
          value,
          ColumnType.real as ColumnType<T>,
        );
      case _Dummy<bool?>():
        return ValueExpression.internal(
          value,
          ColumnType.boolean as ColumnType<T>,
        );
      case _Dummy<DateTime?>():
        return ValueExpression.internal(
          value,
          ColumnType.dateTime as ColumnType<T>,
        );
      case _Dummy<Uint8List?>():
        return ValueExpression.internal(
          value,
          ColumnType.blob as ColumnType<T>,
        );
      case _Dummy<JsonValue?>():
        return ValueExpression.internal(
          value,
          ColumnType.jsonValue as ColumnType<T>,
        );
      case _Dummy<CustomDataType?>():
        if (value == null) {
          return ValueExpression<Null>.internal(null, ColumnType.nullType)
              as ValueExpression<T>;
        }
        throw ArgumentError.value(
          value,
          'value',
          'Use CustomDataType.asExpr instead of toExpr()!',
        );
      default:
        // If there is no inferred T in toExpr(value), for example when
        // user does:
        //    Expr<Object?> e = toExpr(value);
        // then we infer T from value.
        // That does mean we loose the type if value is `null`, but otherwise
        // we shall recover it.
        switch (value) {
          case String v:
            return ValueExpression<String>.internal(v, ColumnType.text)
                as ValueExpression<T>;
          case int v:
            return ValueExpression<int>.internal(v, ColumnType.integer)
                as ValueExpression<T>;
          case double v:
            return ValueExpression<double>.internal(v, ColumnType.real)
                as ValueExpression<T>;
          case bool v:
            return ValueExpression<bool>.internal(v, ColumnType.boolean)
                as ValueExpression<T>;
          case DateTime v:
            return ValueExpression<DateTime>.internal(v, ColumnType.dateTime)
                as ValueExpression<T>;
          case Uint8List v:
            return ValueExpression<Uint8List>.internal(v, ColumnType.blob)
                as ValueExpression<T>;
          case JsonValue v:
            return ValueExpression<JsonValue>.internal(v, ColumnType.jsonValue)
                as ValueExpression<T>;
          case null:
            return ValueExpression<Null>.internal(null, ColumnType.nullType)
                as ValueExpression<T>;
          default:
            throw ArgumentError.value(
              value,
              'value',
              'Only String, int, double, bool, null, DateTime, Uint8List,'
                  ' JsonValue values are allowed',
            );
        }
    }
  }
}

final class _Dummy<T> {}

final class CurrentTimestampExpression extends SingleValueExpr<DateTime> {
  const CurrentTimestampExpression.internal() : super.internal();

  static const currentTimestamp = CurrentTimestampExpression.internal();

  @override
  final _type = ColumnType.dateTime;
}

sealed class BinaryOperationExpression<T, R> extends SingleValueExpr<R> {
  final Expr<T> left;
  final Expr<T> right;
  BinaryOperationExpression(this.left, this.right) : super.internal();
}

final class ExpressionBoolNot<T extends bool?> extends SingleValueExpr<T> {
  final Expr<T> value;
  ExpressionBoolNot(this.value) : super.internal();

  @override
  ExprType<T> get _type => ColumnType.boolean as ExprType<T>;
}

/// SQL Expression using `IS TRUE`.
///
/// Collapsing `Expr<bool?>` to `Expr<bool>` by interpreting `NULL` as `FALSE`.
final class ExpressionIsTrue extends SingleValueExpr<bool> with _ExprBoolean {
  final Expr<bool?> value;
  ExpressionIsTrue(this.value) : super.internal();
}

/// SQL Expression using `IS FALSE`.
///
/// Collapsing `Expr<bool?>` to `Expr<bool>` by interpreting `NULL` as `TRUE`.
final class ExpressionIsFalse extends SingleValueExpr<bool> with _ExprBoolean {
  final Expr<bool?> value;
  ExpressionIsFalse(this.value) : super.internal();
}

final class ExpressionBoolAnd<T extends bool?>
    extends BinaryOperationExpression<T, T> {
  @override
  ExprType<T> get _type => ColumnType.boolean as ExprType<T>;

  ExpressionBoolAnd(super.left, super.right);
}

final class ExpressionBoolOr<T extends bool?>
    extends BinaryOperationExpression<T, T> {
  @override
  ExprType<T> get _type => ColumnType.boolean as ExprType<T>;

  ExpressionBoolOr(super.left, super.right);
}

/// SQL Expression using `=`.
final class ExpressionEquals<T extends Object>
    extends BinaryOperationExpression<T?, bool?> {
  @override
  final _type = ColumnType.boolean;

  ExpressionEquals(super.left, super.right);
}

/// SQL Expression using `<>`.
final class ExpressionNotEquals<T extends Object>
    extends BinaryOperationExpression<T?, bool?> {
  @override
  final _type = ColumnType.boolean;

  ExpressionNotEquals(super.left, super.right);
}

/// SQL Expression using `IS NOT DISTINCT FROM`.
final class ExpressionIsNotDistinctFrom<T extends Object>
    extends BinaryOperationExpression<T?, bool>
    with _ExprBoolean {
  ExpressionIsNotDistinctFrom(super.left, super.right);
}

/// SQL Expression using `<`.
final class ExpressionLessThan<T extends Object>
    extends BinaryOperationExpression<T, bool>
    with _ExprBoolean {
  ExpressionLessThan(super.left, super.right);
}

/// SQL Expression using `<=`.
final class ExpressionLessThanOrEqual<T extends Object>
    extends BinaryOperationExpression<T, bool>
    with _ExprBoolean {
  ExpressionLessThanOrEqual(super.left, super.right);
}

/// SQL Expression using `>`.
final class ExpressionGreaterThan<T extends Object>
    extends BinaryOperationExpression<T, bool>
    with _ExprBoolean {
  ExpressionGreaterThan(super.left, super.right);
}

/// SQL Expression using `>=`.
final class ExpressionGreaterThanOrEqual<T extends Object>
    extends BinaryOperationExpression<T, bool>
    with _ExprBoolean {
  ExpressionGreaterThanOrEqual(super.left, super.right);
}

final class ExpressionStringIsEmpty extends SingleValueExpr<bool>
    with _ExprBoolean {
  final Expr<String> value;
  ExpressionStringIsEmpty(this.value) : super.internal();
}

final class ExpressionStringLength extends SingleValueExpr<int>
    with _ExprInteger {
  final Expr<String> value;
  ExpressionStringLength(this.value) : super.internal();
}

final class ExpressionStringStartsWith extends SingleValueExpr<bool>
    with _ExprBoolean {
  final Expr<String> value;
  final Expr<String> prefix;
  ExpressionStringStartsWith(this.value, this.prefix) : super.internal();
}

final class ExpressionStringEndsWith extends SingleValueExpr<bool>
    with _ExprBoolean {
  final Expr<String> value;
  final Expr<String> suffix;
  ExpressionStringEndsWith(this.value, this.suffix) : super.internal();
}

final class ExpressionStringLike extends SingleValueExpr<bool>
    with _ExprBoolean {
  final Expr<String> value;
  final String pattern;
  ExpressionStringLike(this.value, this.pattern) : super.internal();
}

final class ExpressionStringContains extends SingleValueExpr<bool>
    with _ExprBoolean {
  final Expr<String> value;
  final Expr<String> needle;
  ExpressionStringContains(this.value, this.needle) : super.internal();
}

final class ExpressionStringToUpperCase extends SingleValueExpr<String>
    with _ExprText {
  final Expr<String> value;
  ExpressionStringToUpperCase(this.value) : super.internal();
}

final class ExpressionStringToLowerCase extends SingleValueExpr<String>
    with _ExprText {
  final Expr<String> value;
  ExpressionStringToLowerCase(this.value) : super.internal();
}

final class ExpressionNumAdd<T extends num>
    extends BinaryOperationExpression<T, T> {
  ExpressionNumAdd(super.left, super.right);

  @override
  ExprType<T> get _type => left._type;
}

final class ExpressionNumSubtract<T extends num>
    extends BinaryOperationExpression<T, T> {
  ExpressionNumSubtract(super.left, super.right);

  @override
  ExprType<T> get _type => left._type;
}

final class ExpressionNumMultiply<T extends num>
    extends BinaryOperationExpression<T, T> {
  ExpressionNumMultiply(super.left, super.right);

  @override
  ExprType<T> get _type => left._type;
}

final class ExpressionNumDivide<T extends num>
    extends BinaryOperationExpression<T, double>
    with _ExprReal {
  ExpressionNumDivide(super.left, super.right);
}

final class ExpressionBlobLength extends SingleValueExpr<int>
    with _ExprInteger {
  final Expr<Uint8List> value;
  ExpressionBlobLength(this.value) : super.internal();
}

final class ExpressionBlobConcat
    extends BinaryOperationExpression<Uint8List, Uint8List>
    with _ExprBlob {
  ExpressionBlobConcat(super.left, super.right);
}

final class ExpressionBlobToHex extends SingleValueExpr<String> with _ExprText {
  final Expr<Uint8List> value;
  ExpressionBlobToHex(this.value) : super.internal();
}

final class ExpressionBlobSublist extends SingleValueExpr<Uint8List>
    with _ExprBlob {
  final Expr<Uint8List> value;

  /// Start index of the substring, zero-indexed (like in Dart).
  final Expr<int> start;
  final Expr<int>? length;
  ExpressionBlobSublist(this.value, this.start, [this.length])
    : super.internal();
}

final class ExpressionBlobDecodeUtf8 extends SingleValueExpr<String>
    with _ExprText {
  final Expr<Uint8List> value;
  ExpressionBlobDecodeUtf8(this.value) : super.internal();
}

/// Base class for JSON expressions reference a property or index in a
/// [JsonValue].
sealed class ExpressionJsonRef extends SingleValueExpr<JsonValue?> {
  ExpressionJsonRef.internal() : super.internal();

  @override
  final _type = ColumnType.jsonValue;
}

/// The root of a JSON reference.
final class ExpressionJsonRefRoot extends ExpressionJsonRef {
  final Expr<JsonValue?> value;

  ExpressionJsonRefRoot.internal(this.value) : super.internal();
}

/// Accessing a key in a JSON object, using `value -> 'key'` in SQL.
final class ExpressionJsonRefKey extends ExpressionJsonRef {
  final ExpressionJsonRef value;
  final String key;

  ExpressionJsonRefKey.internal(this.value, this.key) : super.internal();
}

/// Accessing a key in a JSON object, using `value -> index` in SQL.
final class ExpressionJsonRefIndex extends ExpressionJsonRef {
  final ExpressionJsonRef value;
  final int index;

  ExpressionJsonRefIndex.internal(this.value, this.index) : super.internal();
}

/// Extract a raw TEXT representation from a ExpressionJsonRef into a
/// [JsonValue]
final class ExpressionJsonExtract extends SingleValueExpr<String?> {
  final Expr<JsonValue?> value;

  ExpressionJsonExtract.internal(this.value) : super.internal();

  @override
  ExprType<String?> get _type => ColumnType.text;
}

/// Package-internal view of [Expr], exposing members used by the
/// query-builder and SQL dialects without making them part of [Expr]'s own
/// (public) API.
///
/// Members are prefixed with `$` (matching the `$ForGeneratedCode`
/// convention) so they can't collide with a generated per-model extension
/// member named after a user's column (e.g. a column named `field`).
extension ExprInternal<T extends Object?> on Expr<T> {
  ExprType<T> get $exprType => _type;
  int get $columnCount => _columns;
  Expr<T> $standin(int index, Object handle) => _standin(index, handle);
  Expr<R> $field<R>(int index, FieldType<R> type) => _field(index, type);
  T? $decode(RowReader r) => _decode(r);
  Iterable<Expr<Object?>> $explode() => _explode();
}

/// Package-internal view of [FieldExpression], exposing members used by the
/// query-builder without making them part of [FieldExpression]'s own
/// (still private) API.
extension FieldExpressionInternal<T extends Object?> on FieldExpression<T> {
  Object get $handle => _handle;
  int get $index => _index;
}
