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

sealed class _ExprType<T extends Object?> {
  T? _read(RowReader r);

  const _ExprType._();
}

sealed class FieldType<T extends Object?> extends _ExprType<T> {
  const FieldType._() : super._();
}

/// A type that can appear in a database column.
///
/// @nodoc
sealed class ColumnType<T extends Object?> extends FieldType<T> {
  const ColumnType._() : super._();

  static const ColumnType<Uint8List> blob = _BlobExprType._();
  static const ColumnType<bool> boolean = _BooleanExprType._();
  static const ColumnType<DateTime> dateTime = _DateTimeExprType._();
  static const ColumnType<int> integer = _IntegerExprType._();
  static const ColumnType<double> real = _RealExprType._();
  static const ColumnType<String> text = _TextExprType._();
  static const ColumnType<Null> nullType = _NullExprType._();
}

final class _BlobExprType extends ColumnType<Uint8List> {
  const _BlobExprType._() : super._();

  @override
  Uint8List? _read(RowReader r) => r.readUint8List();
}

final class _BooleanExprType extends ColumnType<bool> {
  const _BooleanExprType._() : super._();

  @override
  bool? _read(RowReader r) => r.readBool();
}

final class _DateTimeExprType extends ColumnType<DateTime> {
  const _DateTimeExprType._() : super._();

  @override
  DateTime? _read(RowReader r) => r.readDateTime();
}

final class _IntegerExprType extends ColumnType<int> {
  const _IntegerExprType._() : super._();

  @override
  int? _read(RowReader r) => r.readInt();
}

final class _RealExprType extends ColumnType<double> {
  const _RealExprType._() : super._();

  @override
  double? _read(RowReader r) => r.readDouble();
}

final class _TextExprType extends ColumnType<String> {
  const _TextExprType._() : super._();

  @override
  String? _read(RowReader r) => r.readString();
}

final class _NullExprType extends ColumnType<Null> {
  const _NullExprType._() : super._();

  @override
  Null _read(RowReader r) => r.tryReadNull()
      ? null
      : throw AssertionError(
          'Expr<Null> should always be `null`!',
        );

  static Iterable<Expr> _explodedCastAs<T, S>(
    Expr<T> value,
    _ExprType<S> type,
  ) =>
      switch (type) {
        _RowExprType<Row> type =>
          type.fields.map((f) => CastExpression._(value, f)),
        CustomExprType type => [CastExpression._(value, type._backingType)],
        ColumnType type => [CastExpression._(value, type)],
      };
}

final class CustomExprType<S, T extends CustomDataType<S>>
    extends FieldType<T> {
  final ColumnType<S> _backingType;
  final T Function(S value) _fromDatabase;

  const CustomExprType._(this._backingType, this._fromDatabase) : super._();

  @override
  T? _read(RowReader r) {
    final value = _backingType._read(r);
    if (value != null) {
      return _fromDatabase(value);
    }
    return null;
  }
}

final class _RowExprType<T extends Row> extends _ExprType<T> {
  final List<ColumnType> fields;
  final T? Function(RowReader r) _readRow;

  // TODO: This class should probably be part of a table
  // definition, instead of this way around, but we can refactor that later.
  _RowExprType._(TableDefinition<T> table)
      : _readRow = table.readRow,
        fields = table.columnInfo.map((c) => c.type).toList(),
        super._();

  @override
  T? _read(RowReader r) => _readRow(r);
}

abstract final class _ExprTyped<T extends Object?> {
  _ExprType<T> get _type;
}

/// A representation of an SQL expression with type `T`.
///
/// {@category inserting_rows}
/// {@category writing_queries}
/// {@category update_and_delete}
sealed class Expr<T extends Object?> implements _ExprTyped<T> {
  factory Expr(T value) => toExpr(value);

  const Expr._();

  int get _columns;

  Expr<T> _standin(int index, Object handle);
  Expr<R> _field<R>(int index, FieldType<R> type);
  T? _decode(RowReader r) => _type._read(r);

  Iterable<Expr<Object?>> _explode();

  static const Expr<Null> null$ = Literal.null$;
  static const Expr<bool> true$ = Literal.true$;
  static const Expr<bool> false$ = Literal.false$;
  static const Expr<DateTime> currentTimestamp =
      CurrentTimestampExpression.currentTimestamp;
}

sealed class SingleValueExpr<T extends Object?> extends Expr<T> {
  const SingleValueExpr._() : super._();

  @override
  Iterable<Expr<T>> _explode() => [this];

  @override
  Expr<T> _standin(int index, Object handle) =>
      FieldExpression._(index, handle, _type);

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

// ignore: unused_element
base mixin _ExprBlob implements _ExprTyped<Uint8List> {
  @override
  final _type = ColumnType.blob;
}

/// Create an [Expr<T>] wrapping [value].
///
/// The type of [value] must be one of:
///  * [String],
///  * [int],
///  * [double],
///  * [bool],
///  * [DateTime],
///  * [Uint8List],
///  * `null`
///
/// > [!NOTE]
/// > If you want to use a [CustomDataType], use the `.asExpr`
/// > _extension method_ instead.
///
/// {@category inserting_rows}
/// {@category writing_queries}
/// {@category update_and_delete}
Expr<T> toExpr<T extends Object?>(T value) => Literal(value);

final class RowExpression<T extends Row> extends Expr<T> {
  final TableDefinition<T> _table;
  final int _index;
  final Object _handle;

  @override
  Expr<T> _standin(int index, Object handle) =>
      RowExpression._(index, _table, handle);

  @override
  int get _columns => _table.columns.length;

  @override
  Expr<R> _field<R>(int index, _ExprType<R> type) {
    if (index < 0 || index >= _table.columns.length) {
      throw ArgumentError.value(
        index,
        'index',
        'Table "${_table.tableName}" does not have a field '
            'at index $index',
      );
    }
    return FieldExpression._(_index + index, _handle, type);
  }

  @override
  Iterable<Expr<Object?>> _explode() => Iterable.generate(
        _columns,
        (index) => _field<void>(index, _type.fields[index]),
      );

  RowExpression._(this._index, this._table, this._handle) : super._();

  @override
  _RowExprType<T> get _type => _RowExprType._(_table);
}

final class FieldExpression<T> extends SingleValueExpr<T> {
  final int _index;
  final Object _handle;
  @override
  final _ExprType<T> _type;

  FieldExpression._(this._index, this._handle, this._type) : super._();
}

final class SubQueryExpression<T> extends Expr<T> {
  final QueryClause query;
  final Expr<T> _value;

  SubQueryExpression._(this.query, this._value) : super._();

  @override
  int get _columns => _value._columns;

  @override
  Iterable<Expr<Object?>> _explode() => switch (_type) {
        _RowExprType<Row> type => Iterable.generate(
            _columns,
            (index) => _field<void>(index, type.fields[index]),
          ),
        _ => [this],
      };

  @override
  Expr<R> _field<R>(int index, FieldType<R> type) {
    final handle = Object();
    return SubQueryExpression._(
      SelectFromClause._(
        query,
        handle,
        [FieldExpression._(index, handle, type)],
      ),
      _value._field<R>(index, type), // TODO: Is this correct?
    );
  }

  @override
  Expr<T> _standin(int index, Object handle) => _value._standin(index, handle);

  @override
  _ExprType<T> get _type => _value._type;
}

final class ExistsExpression extends SingleValueExpr<bool> with _ExprBoolean {
  final QueryClause query;
  ExistsExpression._(this.query) : super._();
}

final class SumExpression<T extends num> extends SingleValueExpr<T> {
  final Expr<T?> value;
  SumExpression._(this.value) : super._();

  @override
  _ExprType<T> get _type => value._type as _ExprType<T>;
}

// NOTE: AVG returns NULL, if applied to the empty set of values, also it
//       ignores NULL and will return NULL if applied to set of NULLs.
final class AvgExpression extends SingleValueExpr<double?> {
  final Expr<num?> value;
  AvgExpression._(this.value) : super._();

  @override
  final _type = ColumnType.real;
}

final class MinExpression<T extends Comparable> extends SingleValueExpr<T?> {
  final Expr<T?> value;
  MinExpression._(this.value) : super._();

  @override
  _ExprType<T?> get _type => value._type;
}

final class MaxExpression<T extends Comparable> extends SingleValueExpr<T?> {
  final Expr<T?> value;
  MaxExpression._(this.value) : super._();

  @override
  _ExprType<T?> get _type => value._type;
}

final class CountAllExpression extends SingleValueExpr<int> with _ExprInteger {
  CountAllExpression._() : super._();
}

final class OrElseExpression<T> extends SingleValueExpr<T> {
  final Expr<T?> value;
  final Expr<T> orElse;

  OrElseExpression._(this.value, this.orElse) : super._();

  @override
  _ExprType<T> get _type {
    if (value._type == ColumnType.nullType) {
      return orElse._type;
    }
    return value._type as _ExprType<T>; // TODO: Is this actually correct?
  }
}

final class NotNullExpression<T> extends Expr<T> {
  final Expr<T?> value;

  @override
  int get _columns => value._columns;

  // TODO: Does this actually work?
  @override
  _ExprType<T> get _type => value._type as _ExprType<T>;

  @override
  Iterable<Expr<Object?>> _explode() => value._explode();

  @override
  Expr<T> _standin(int index, Object handle) =>
      NotNullExpression._(value._standin(index, handle));

  @override
  Expr<R> _field<R>(int index, FieldType<R> type) => value._field(index, type);

  NotNullExpression._(this.value) : super._();
}

final class EncodedCustomDataTypeExpression<S, T extends CustomDataType<S>>
    extends SingleValueExpr<S?> {
  final Expr<T?> value;

  @override
  int get _columns => value._columns;

  @override
  _ExprType<S> get _type => (value._type as CustomExprType<S, T>)._backingType;

  EncodedCustomDataTypeExpression._(this.value) : super._();
}

final class CastExpression<T, R> extends SingleValueExpr<R> {
  final Expr<T> value;
  final ColumnType<R> type;

  CastExpression._(this.value, this.type) : super._();

  @override
  _ExprType<R> get _type => type;
}

final class Literal<T> extends SingleValueExpr<T> {
  final T value;

  @override
  final _ExprType<T> _type;

  // TODO: Consider supporting a Constant expression subclass, currently we
  //       always encode literals as ? and attach them as parameters.
  //       This is fine, but if we ever use these query builders to create
  //       prepared statements that are executed more than once, then it matters
  //       whether a literal is encoded as value or a constant.
  //       If we do this, we might have to rename Literal to Value!

  static const null$ = Literal<Null>._(null, ColumnType.nullType);
  static const true$ = Literal._(true, ColumnType.boolean);
  static const false$ = Literal._(false, ColumnType.boolean);

  const Literal._(this.value, this._type) : super._();

  static Literal<T> custom<S, T extends CustomDataType<S>>(
    T value,
    T Function(S) fromDatabase,
  ) {
    final backingType = switch (value) {
      CustomDataType<bool> _ => ColumnType.boolean as ColumnType<S>,
      CustomDataType<String> _ => ColumnType.text as ColumnType<S>,
      CustomDataType<int> _ => ColumnType.integer as ColumnType<S>,
      CustomDataType<double> _ => ColumnType.real as ColumnType<S>,
      CustomDataType<Uint8List> _ => ColumnType.blob as ColumnType<S>,
      CustomDataType<DateTime> _ => ColumnType.dateTime as ColumnType<S>,
      _ => throw ArgumentError.value(
          value,
          'value',
          'T in CustomDataType<T> must be String, int, double, bool, or DateTime!',
        ),
    };
    return Literal._(value, CustomExprType._(backingType, fromDatabase));
  }

  factory Literal(T value) {
    // TODO: Consider asking Lasse how to actually switch over T, because null is not a type!
    // TODO: We need to switch over T or use an extension method! If someone does
    //       select(toExpr(null as bool?)).union(select(toExpr(true)))
    //       We'll have a expression that can't actually decode bools!
    switch (value) {
      case true:
        return true$ as Literal<T>;

      case false:
        return false$ as Literal<T>;

      case null:
        return null$ as Literal<T>;

      case String _:
        return Literal._(value, ColumnType.text as _ExprType<T>);
      case int _:
        return Literal._(value, ColumnType.integer as _ExprType<T>);
      case double _:
        return Literal._(value, ColumnType.real as _ExprType<T>);
      case Uint8List _:
        return Literal._(value, ColumnType.blob as _ExprType<T>);
      case DateTime _:
        return Literal._(value, ColumnType.dateTime as _ExprType<T>);

      case CustomDataType _:
        throw ArgumentError.value(
          value,
          'value',
          'Use Literal.custom for CustomDataType!',
        );

      default:
        throw ArgumentError.value(
          value,
          'value',
          'Only String, int, double, bool, null, and DateTime '
              'literals are allowed',
        );
    }
  }
}

final class CurrentTimestampExpression extends SingleValueExpr<DateTime> {
  const CurrentTimestampExpression._() : super._();

  static const currentTimestamp = CurrentTimestampExpression._();

  @override
  final _type = ColumnType.dateTime;
}

sealed class BinaryOperationExpression<T, R> extends SingleValueExpr<R> {
  final Expr<T> left;
  final Expr<T> right;
  BinaryOperationExpression(this.left, this.right) : super._();
}

final class ExpressionBoolNot extends SingleValueExpr<bool> with _ExprBoolean {
  final Expr<bool> value;
  ExpressionBoolNot(this.value) : super._();
}

final class ExpressionBoolAnd extends BinaryOperationExpression<bool, bool>
    with _ExprBoolean {
  ExpressionBoolAnd(super.left, super.right);
}

final class ExpressionBoolOr extends BinaryOperationExpression<bool, bool>
    with _ExprBoolean {
  ExpressionBoolOr(super.left, super.right);
}

/// SQL Expression using `=`.
final class ExpressionEquals<T extends Object>
    extends BinaryOperationExpression<T?, bool?> {
  @override
  final _type = ColumnType.boolean;

  ExpressionEquals(super.left, super.right);
}

/// SQL Expression using `IS NOT DISTINCT FROM`.
final class ExpressionIsNotDistinctFrom<T extends Object>
    extends BinaryOperationExpression<T?, bool> with _ExprBoolean {
  ExpressionIsNotDistinctFrom(super.left, super.right);
}

/// SQL Expression using `<`.
final class ExpressionLessThan<T extends Object>
    extends BinaryOperationExpression<T, bool> with _ExprBoolean {
  ExpressionLessThan(super.left, super.right);
}

/// SQL Expression using `<=`.
final class ExpressionLessThanOrEqual<T extends Object>
    extends BinaryOperationExpression<T, bool> with _ExprBoolean {
  ExpressionLessThanOrEqual(super.left, super.right);
}

/// SQL Expression using `>`.
final class ExpressionGreaterThan<T extends Object>
    extends BinaryOperationExpression<T, bool> with _ExprBoolean {
  ExpressionGreaterThan(super.left, super.right);
}

/// SQL Expression using `>=`.
final class ExpressionGreaterThanOrEqual<T extends Object>
    extends BinaryOperationExpression<T, bool> with _ExprBoolean {
  ExpressionGreaterThanOrEqual(super.left, super.right);
}

final class ExpressionStringIsEmpty extends SingleValueExpr<bool>
    with _ExprBoolean {
  final Expr<String> value;
  ExpressionStringIsEmpty(this.value) : super._();
}

final class ExpressionStringLength extends SingleValueExpr<int>
    with _ExprInteger {
  final Expr<String> value;
  ExpressionStringLength(this.value) : super._();
}

final class ExpressionStringStartsWith extends SingleValueExpr<bool>
    with _ExprBoolean {
  final Expr<String> value;
  final Expr<String> prefix;
  ExpressionStringStartsWith(this.value, this.prefix) : super._();
}

final class ExpressionStringEndsWith extends SingleValueExpr<bool>
    with _ExprBoolean {
  final Expr<String> value;
  final Expr<String> suffix;
  ExpressionStringEndsWith(this.value, this.suffix) : super._();
}

final class ExpressionStringLike extends SingleValueExpr<bool>
    with _ExprBoolean {
  final Expr<String> value;
  final String pattern;
  ExpressionStringLike(this.value, this.pattern) : super._();
}

final class ExpressionStringContains extends SingleValueExpr<bool>
    with _ExprBoolean {
  final Expr<String> value;
  final Expr<String> needle;
  ExpressionStringContains(this.value, this.needle) : super._();
}

final class ExpressionStringToUpperCase extends SingleValueExpr<String>
    with _ExprText {
  final Expr<String> value;
  ExpressionStringToUpperCase(this.value) : super._();
}

final class ExpressionStringToLowerCase extends SingleValueExpr<String>
    with _ExprText {
  final Expr<String> value;
  ExpressionStringToLowerCase(this.value) : super._();
}

final class ExpressionNumAdd<T extends num>
    extends BinaryOperationExpression<T, T> {
  ExpressionNumAdd(super.left, super.right);

  @override
  _ExprType<T> get _type => left._type;
}

final class ExpressionNumSubtract<T extends num>
    extends BinaryOperationExpression<T, T> {
  ExpressionNumSubtract(super.left, super.right);

  @override
  _ExprType<T> get _type => left._type;
}

final class ExpressionNumMultiply<T extends num>
    extends BinaryOperationExpression<T, T> {
  ExpressionNumMultiply(super.left, super.right);

  @override
  _ExprType<T> get _type => left._type;
}

final class ExpressionNumDivide<T extends num>
    extends BinaryOperationExpression<T, double> with _ExprReal {
  ExpressionNumDivide(super.left, super.right);
}
