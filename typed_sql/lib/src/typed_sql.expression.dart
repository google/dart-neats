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
  // TODO: This should probably be private!
  T? _read(RowReader r);

  const _ExprType._();
}

sealed class FieldType<T extends Object?> extends _ExprType<T> {
  const FieldType._() : super._();
}

/// A type that can appear in a database column.
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
        _ModelExprType<Model> type =>
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

final class _ModelExprType<T extends Model> extends _ExprType<T> {
  final List<ColumnType> fields;
  final T? Function(RowReader r) _readModel;

  // TODO: This class should probably be part of a table
  // definition, instead of this way around, but we can refactor that later.
  _ModelExprType._(TableDefinition<T> table)
      : _readModel = table.readModel,
        fields = table.columnInfo.map((c) => c.type).toList(),
        super._();

  @override
  T? _read(RowReader r) => _readModel(r);
}

abstract final class _ExprTyped<T extends Object?> {
  _ExprType<T> get _type;
}

sealed class Expr<T extends Object?> implements _ExprTyped<T> {
  factory Expr(T value) => literal(value);

  const Expr._();

  int get _columns;

  Expr<T> _standin(int index, Object handle);
  Expr<R> _field<R>(int index, FieldType<R> type);
  T? _decode(RowReader r) => _type._read(r);

  Iterable<Expr<Object?>> _explode();

  static const null$ = Literal.null$;
  static const true$ = Literal.true$;
  static const false$ = Literal.false$;

  static Literal<T> literal<T extends Object?>(T value) => Literal(value);
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
      throw AssertionError('Only Expr<Model> can have fields');

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

Literal<T> literal<T extends Object?>(T value) => Literal(value);

final class ModelExpression<T extends Model> extends Expr<T> {
  final TableDefinition<T> _table;
  final int _index;
  final Object _handle;

  @override
  Expr<T> _standin(int index, Object handle) =>
      ModelExpression._(index, _table, handle);

  @override
  int get _columns => _table.columns.length;

  Expr<R> _field<R>(int index, _ExprType<R> type) {
    if (index < 0 || index >= _table.columns.length) {
      throw ArgumentError.value(
        index,
        'index',
        'Table "${_table.tableName}" does not have a field '
            'at index $index',
      );
    }
    return FieldExpression._(this._index + index, _handle, type);
  }

  @override
  Iterable<Expr<Object?>> _explode() => Iterable.generate(
        _columns,
        (index) => _field<void>(index, _type.fields[index]),
      );

  ModelExpression._(this._index, this._table, this._handle) : super._();

  @override
  _ModelExprType<T> get _type => _ModelExprType._(_table);
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
        _ModelExprType<Model> type => Iterable.generate(
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

// AVG returns NULL, if applied to the empty set of values, also it ignores
// NULL and will return NULL if applied to set of NULLs
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

// TODO: Do we even need this, or can we simply cast?
final class NullAssertionExpression<T> extends Expr<T> {
  final Expr<T?> value;

  @override
  int get _columns => value._columns;

  // TODO: Does this actually work?
  @override
  _ExprType<T> get _type => value._type as _ExprType<T>;

  @override
  Iterable<Expr<Object?>> _explode() => value._explode();

  Expr<T> _standin(int index, Object handle) =>
      NullAssertionExpression._(value._standin(index, handle));
  Expr<R> _field<R>(int index, FieldType<R> type) => value._field(index, type);

  NullAssertionExpression._(this.value) : super._();
}

final class CastExpression<T, R> extends SingleValueExpr<R> {
  final Expr<T> value;
  final ColumnType<R> type;

  CastExpression._(this.value, this.type) : super._();

  @override
  _ExprType<R> get _type => type;
}

extension ExpressionNullable<T> on Expr<T?> {
  Expr<T> assertNotNull() => NullAssertionExpression._(this);
}

extension ExpressionNullableNum<T extends num> on Expr<T?> {
  Expr<T> orElse(Expr<T> value) => OrElseExpression._(this, value);
  Expr<T> orElseLiteral(T value) => orElse(literal(value));
}

extension ExpressionNullableString on Expr<String?> {
  Expr<String> orElse(Expr<String> value) => OrElseExpression._(this, value);
  Expr<String> orElseLiteral(String value) => orElse(literal(value));
}

extension ExpressionNullableBool on Expr<bool?> {
  Expr<bool> orElse(Expr<bool> value) => OrElseExpression._(this, value);
  Expr<bool> orElseLiteral(bool value) => orElse(literal(value));
}

extension ExpressionNullableDateTime on Expr<DateTime?> {
  Expr<DateTime> orElse(Expr<DateTime> value) =>
      OrElseExpression._(this, value);
  Expr<DateTime> orElseLiteral(DateTime value) => orElse(literal(value));
}

final class Literal<T> extends SingleValueExpr<T> {
  final T value;

  @override
  final _ExprType<T> _type;

  // TODO: Consider supporting a Constant expression subclass, currently we
  //       always encode literals as ? and attach them as parameters.
  //       This is fine, but if we ever use this query builders to created
  //       prepared statements that are executed more than once, then it matters
  //       whether a literal is encoded as value or constant
  //       If we do this, we might have rename Literal to Value!

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
    //       select(literal(null as bool?)).union(select(literal(true)))
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

final class ExpressionStringEquals
    extends BinaryOperationExpression<String?, bool> with _ExprBoolean {
  ExpressionStringEquals(super.left, super.right);
}

final class ExpressionStringLessThan
    extends BinaryOperationExpression<String, bool> with _ExprBoolean {
  ExpressionStringLessThan(super.left, super.right);
}

final class ExpressionStringLessThanOrEqual
    extends BinaryOperationExpression<String, bool> with _ExprBoolean {
  ExpressionStringLessThanOrEqual(super.left, super.right);
}

final class ExpressionStringGreaterThan
    extends BinaryOperationExpression<String, bool> with _ExprBoolean {
  ExpressionStringGreaterThan(super.left, super.right);
}

final class ExpressionStringGreaterThanOrEqual
    extends BinaryOperationExpression<String, bool> with _ExprBoolean {
  ExpressionStringGreaterThanOrEqual(super.left, super.right);
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

final class ExpressionNumEquals<T extends num>
    extends BinaryOperationExpression<T?, bool> with _ExprBoolean {
  ExpressionNumEquals(super.left, super.right);
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

final class ExpressionNumLessThan<T extends num>
    extends BinaryOperationExpression<T, bool> with _ExprBoolean {
  ExpressionNumLessThan(super.left, super.right);
}

final class ExpressionNumLessThanOrEqual<T extends num>
    extends BinaryOperationExpression<T, bool> with _ExprBoolean {
  ExpressionNumLessThanOrEqual(super.left, super.right);
}

final class ExpressionNumGreaterThan<T extends num>
    extends BinaryOperationExpression<T, bool> with _ExprBoolean {
  ExpressionNumGreaterThan(super.left, super.right);
}

final class ExpressionNumGreaterThanOrEqual<T extends num>
    extends BinaryOperationExpression<T, bool> with _ExprBoolean {
  ExpressionNumGreaterThanOrEqual(super.left, super.right);
}

final class ExpressionDateTimeEquals
    extends BinaryOperationExpression<DateTime?, bool> with _ExprBoolean {
  ExpressionDateTimeEquals(super.left, super.right);
}

final class ExpressionDateTimeLessThan
    extends BinaryOperationExpression<DateTime, bool> with _ExprBoolean {
  ExpressionDateTimeLessThan(super.left, super.right);
}

final class ExpressionDateTimeLessThanOrEqual
    extends BinaryOperationExpression<DateTime, bool> with _ExprBoolean {
  ExpressionDateTimeLessThanOrEqual(super.left, super.right);
}

final class ExpressionDateTimeGreaterThan
    extends BinaryOperationExpression<DateTime, bool> with _ExprBoolean {
  ExpressionDateTimeGreaterThan(super.left, super.right);
}

final class ExpressionDateTimeGreaterThanOrEqual
    extends BinaryOperationExpression<DateTime, bool> with _ExprBoolean {
  ExpressionDateTimeGreaterThanOrEqual(super.left, super.right);
}

extension ExpressionBool on Expr<bool> {
  Expr<bool> not() => ExpressionBoolNot(this);
  Expr<bool> operator ~() => ExpressionBoolNot(this);

  Expr<bool> and(Expr<bool> other) {
    if (other == Literal.true$) {
      return this;
    }
    if (other == Literal.false$) {
      return Literal.false$;
    }
    if (this == Literal.true$) {
      return other;
    }
    return ExpressionBoolAnd(this, other);
  }

  Expr<bool> operator &(Expr<bool> other) => and(other);

  Expr<bool> or(Expr<bool> other) => ExpressionBoolOr(this, other);
  Expr<bool> operator |(Expr<bool> other) => ExpressionBoolOr(this, other);

  /// Cast as integer.
  ///
  /// In SQL often translates to `CAST(value AS BIGINT)`.
  ///
  /// This is generally safe and won't cause runtime errors.
  ///
  /// Results:
  /// * `true` -> `1`
  /// * `false` -> `0`
  Expr<int> asInt() => CastExpression._(this, ColumnType.integer);
  // Remark we could support casting to double it works, but requires an extra
  // step in postgres. It's not really a sensible thing to do. Should you ever
  // find it useful, just use `.asInt().asDouble()`.
  // Notice, that `.asInt()´ can be useful for multiplication with boolean.
}

extension ExpressionNull on Expr<Null> {
  Expr<int?> asInt() => CastExpression._(this, ColumnType.integer);
  Expr<String?> asString() => CastExpression._(this, ColumnType.text);
  Expr<double?> asDouble() => CastExpression._(this, ColumnType.real);
  Expr<bool?> asBool() => CastExpression._(this, ColumnType.boolean);
  Expr<DateTime?> asDateTime() => CastExpression._(this, ColumnType.dateTime);
  Expr<Uint8List?> asBlob() => CastExpression._(this, ColumnType.blob);
  // TODO: Generate cast for CustomDataType!
}

extension ExpressionString on Expr<String> {
  Expr<bool> equals(Expr<String?> value) => ExpressionStringEquals(this, value);
  Expr<bool> equalsLiteral(String? value) => equals(literal(value));

  Expr<bool> notEquals(Expr<String?> value) => equals(value).not();
  Expr<bool> notEqualsLiteral(String? value) => notEquals(literal(value));

  Expr<bool> get isEmpty => ExpressionStringIsEmpty(this);
  Expr<bool> get isNotEmpty => isEmpty.not();

  Expr<int> get length => ExpressionStringLength(this);

  Expr<bool> startsWith(Expr<String> value) =>
      ExpressionStringStartsWith(this, value);
  Expr<bool> startsWithLiteral(String value) =>
      ExpressionStringStartsWith(this, literal(value));

  Expr<bool> endsWith(Expr<String> value) =>
      ExpressionStringEndsWith(this, value);
  Expr<bool> endsWithLiteral(String value) =>
      ExpressionStringEndsWith(this, literal(value));

  /// Matches pattern where `%` is one or more characters, and
  /// `_` is one character.
  Expr<bool> like(String pattern) => ExpressionStringLike(this, pattern);

  Expr<bool> contains(Expr<String> substring) =>
      ExpressionStringContains(this, substring);

  Expr<bool> containsLiteral(String substring) =>
      ExpressionStringContains(this, literal(substring));

  Expr<String> toLowerCase() => ExpressionStringToLowerCase(this);

  Expr<String> toUpperCase() => ExpressionStringToUpperCase(this);

  Expr<bool> operator >=(Expr<String> other) =>
      ExpressionStringGreaterThanOrEqual(this, other);
  Expr<bool> operator <=(Expr<String> other) =>
      ExpressionStringLessThanOrEqual(this, other);
  Expr<bool> operator >(Expr<String> other) =>
      ExpressionStringGreaterThan(this, other);
  Expr<bool> operator <(Expr<String> other) =>
      ExpressionStringLessThan(this, other);

  Expr<bool> lessThan(Expr<String> other) =>
      ExpressionStringLessThan(this, other);
  Expr<bool> lessThanOrEqual(Expr<String> other) =>
      ExpressionStringLessThanOrEqual(this, other);
  Expr<bool> greaterThan(Expr<String> other) =>
      ExpressionStringGreaterThan(this, other);
  Expr<bool> greaterThanOrEqual(Expr<String> other) =>
      ExpressionStringGreaterThanOrEqual(this, other);

  Expr<bool> lessThanLiteral(String other) => lessThan(literal(other));
  Expr<bool> lessThanOrEqualLiteral(String other) =>
      lessThanOrEqual(literal(other));
  Expr<bool> greaterThanLiteral(String other) => greaterThan(literal(other));
  Expr<bool> greaterThanOrEqualLiteral(String other) =>
      greaterThanOrEqual(literal(other));

  /// Cast as integer.
  ///
  /// In SQL often translates to `CAST(value AS BIGINT)`.
  ///
  /// This is **unsafe** and may cause runtime errors.
  ///
  /// The behavior is also database dependent.
  ///  * sqlite will return `0` when parsing fails.
  ///  * postgres will abort the query when parsing fails.
  ///
  /// Example:
  /// * `'123'` -> `123`
  Expr<int> asInt() => CastExpression._(this, ColumnType.integer);

  /// Cast as double.
  ///
  /// In SQL often translates to `CAST(value AS DOUBLE PRECISION)`.
  ///
  /// This is **unsafe** and may cause runtime errors.
  ///
  /// The behavior is also database dependent.
  ///  * sqlite will return `0.0` when parsing fails.
  ///  * postgres will abort the query when parsing fails.
  ///
  /// Example:
  /// * `'3.14'` -> `3.14`
  Expr<double> asDouble() => CastExpression._(this, ColumnType.real);
}

extension ExpressionInt on Expr<int> {
  Expr<int> operator +(Expr<int> other) => ExpressionNumAdd(this, other);
  Expr<int> operator -(Expr<int> other) => ExpressionNumSubtract(this, other);
  Expr<int> operator *(Expr<int> other) => ExpressionNumMultiply(this, other);
  Expr<double> operator /(Expr<int> other) => ExpressionNumDivide(this, other);

  Expr<int> add(Expr<int> other) => ExpressionNumAdd(this, other);
  Expr<int> subtract(Expr<int> other) => ExpressionNumSubtract(this, other);
  Expr<int> multiply(Expr<int> other) => ExpressionNumMultiply(this, other);
  Expr<double> divide(Expr<int> other) => ExpressionNumDivide(this, other);

  Expr<int> addLiteral(int other) => ExpressionNumAdd(this, literal(other));
  Expr<int> subtractLiteral(int other) =>
      ExpressionNumSubtract(this, literal(other));
  Expr<int> multiplyLiteral(int other) =>
      ExpressionNumMultiply(this, literal(other));
  Expr<double> divideLiteral(int other) =>
      ExpressionNumDivide(this, literal(other));

  /// Cast as string.
  ///
  /// In SQL often translates to `CAST(value AS TEXT)`.
  ///
  /// This is generally safe and won't cause runtime errors.
  ///
  /// Example:
  /// * `12345` -> `'12345'`
  Expr<String> asString() => CastExpression._(this, ColumnType.text);

  /// Cast as double.
  ///
  /// In SQL often translates to `CAST(value AS DOUBLE PRECISION)`.
  ///
  /// This is generally safe and won't cause runtime errors.
  /// Though precision may be lost when casting large integers to double.
  ///
  /// Example:
  /// * `123` -> `123.0`
  Expr<double> asDouble() => CastExpression._(this, ColumnType.real);
}

extension ExpressionDouble on Expr<double> {
  Expr<double> operator +(Expr<double> other) => ExpressionNumAdd(this, other);
  Expr<double> operator -(Expr<double> other) =>
      ExpressionNumSubtract(this, other);
  Expr<double> operator *(Expr<double> other) =>
      ExpressionNumMultiply(this, other);
  Expr<double> operator /(Expr<double> other) =>
      ExpressionNumDivide(this, other);

  Expr<double> add(Expr<double> other) => ExpressionNumAdd(this, other);
  Expr<double> subtract(Expr<double> other) =>
      ExpressionNumSubtract(this, other);
  Expr<double> multiply(Expr<double> other) =>
      ExpressionNumMultiply(this, other);
  Expr<double> divide(Expr<double> other) => ExpressionNumDivide(this, other);

  Expr<double> addLiteral(double other) =>
      ExpressionNumAdd(this, literal(other));
  Expr<double> subtractLiteral(double other) =>
      ExpressionNumSubtract(this, literal(other));
  Expr<double> multiplyLiteral(double other) =>
      ExpressionNumMultiply(this, literal(other));
  Expr<double> divideLiteral(double other) =>
      ExpressionNumDivide(this, literal(other));

  /// Cast as string.
  ///
  /// In SQL often translates to `CAST(value AS TEXT)`.
  ///
  /// This is generally safe and won't cause runtime errors.
  ///
  /// Example:
  /// * `3.14` -> `'3.14'`
  Expr<String> asString() => CastExpression._(this, ColumnType.text);

  /// Cast as integer.
  ///
  /// In SQL often translates to `CAST(value AS BIGINT)`.
  ///
  /// This is generally safe and won't cause runtime errors.
  /// Though decimals are truncated when casting a double to integer.
  ///
  /// Example:
  /// * `3.14` -> `3`
  Expr<int> asInt() => CastExpression._(this, ColumnType.integer);
}

extension ExpressionNum<T extends num> on Expr<T> {
  Expr<bool> equals(Expr<T?> value) => ExpressionNumEquals(this, value);
  Expr<bool> equalsLiteral(num? value) =>
      ExpressionNumEquals(this, literal(value));

  Expr<bool> notEquals(Expr<T?> value) => equals(value).not();
  Expr<bool> notEqualsLiteral(T? value) => notEquals(literal(value));

  Expr<bool> operator >=(Expr<T> other) =>
      ExpressionNumGreaterThanOrEqual(this, other);
  Expr<bool> operator <=(Expr<T> other) =>
      ExpressionNumLessThanOrEqual(this, other);
  Expr<bool> operator >(Expr<T> other) => ExpressionNumGreaterThan(this, other);
  Expr<bool> operator <(Expr<T> other) => ExpressionNumLessThan(this, other);

  Expr<bool> lessThan(Expr<T> other) => ExpressionNumLessThan(this, other);
  Expr<bool> lessThanOrEqual(Expr<T> other) =>
      ExpressionNumLessThanOrEqual(this, other);
  Expr<bool> greaterThan(Expr<T> other) =>
      ExpressionNumGreaterThan(this, other);
  Expr<bool> greaterThanOrEqual(Expr<T> other) =>
      ExpressionNumGreaterThanOrEqual(this, other);

  Expr<bool> lessThanLiteral(T other) => lessThan(literal(other));
  Expr<bool> lessThanOrEqualLiteral(T other) => lessThanOrEqual(literal(other));
  Expr<bool> greaterThanLiteral(T other) => greaterThan(literal(other));
  Expr<bool> greaterThanOrEqualLiteral(T other) =>
      greaterThanOrEqual(literal(other));

  //... do other operators...
  // TODO: integerDivide!
}

extension ExpressionDateTime on Expr<DateTime> {
  Expr<bool> equals(Expr<DateTime?> value) =>
      ExpressionDateTimeEquals(this, value);
  Expr<bool> equalsLiteral(DateTime? value) =>
      ExpressionDateTimeEquals(this, literal(value));

  Expr<bool> notEquals(Expr<DateTime?> value) => equals(value).not();
  Expr<bool> notEqualsLiteral(DateTime? value) => notEquals(literal(value));

  // TODO: Decide if we want to support storing a Duration
  // Expression<bool> difference(Expression<DateTime> value) =>

  Expr<bool> operator >=(Expr<DateTime> other) =>
      ExpressionDateTimeGreaterThanOrEqual(this, other);
  Expr<bool> operator <=(Expr<DateTime> other) =>
      ExpressionDateTimeLessThanOrEqual(this, other);
  Expr<bool> operator >(Expr<DateTime> other) =>
      ExpressionDateTimeGreaterThan(this, other);
  Expr<bool> operator <(Expr<DateTime> other) =>
      ExpressionDateTimeLessThan(this, other);

  Expr<bool> isBefore(Expr<DateTime> value) => this < value;
  Expr<bool> isBeforeLiteral(DateTime value) => isBefore(literal(value));

  Expr<bool> isAfter(Expr<DateTime> value) => this > value;
  Expr<bool> isAfterLiteral(DateTime value) => isAfter(literal(value));

  // TODO: More features... maybe there is a duration in SQL?
}
