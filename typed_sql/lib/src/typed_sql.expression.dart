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

abstract final class _Decoder<T extends Object?> {
  T? _decode(RowReader r);
}

sealed class Expr<T extends Object?> implements _Decoder<T> {
  factory Expr(T value) => literal(value);

  const Expr._();

  int get _columns;

  Expr<T> _standin(int index, Object handle);
  Expr<R> _field<R>(int index, R? Function(RowReader) readValue);

  Iterable<Expr<Object?>> _explode();

  static const null$ = Literal.null$;
  static const true$ = Literal.true$;
  static const false$ = Literal.false$;

  static Literal<T> literal<T extends Object?>(T value) => Literal(value);
}

sealed class SingleValueExpr<T extends Object?> extends Expr<T> {
  const SingleValueExpr._() : super._();

  @override
  Iterable<Expr<T>> _explode() sync* {
    yield this;
  }

  @override
  Expr<T> _standin(int index, Object handle) =>
      FieldExpression(index, handle, _decode);

  @override
  Expr<R> _field<R>(int index, R? Function(RowReader) readValue) =>
      // This should never happen!
      throw AssertionError('Only Expr<Model> can have fields');

  @override
  int get _columns => 1;
}

base mixin _DecodeBool implements _Decoder<bool> {
  @override
  bool? _decode(RowReader r) => r.readBool();
}

base mixin _DecodeString implements _Decoder<String> {
  @override
  String? _decode(RowReader r) => r.readString();
}

base mixin _DecodeInt implements _Decoder<int> {
  @override
  int? _decode(RowReader r) => r.readInt();
}

base mixin _DecodeDouble implements _Decoder<double> {
  @override
  double? _decode(RowReader r) => r.readDouble();
}

base mixin _DecodeDateTime implements _Decoder<DateTime> {
  @override
  DateTime? _decode(RowReader r) => r.readDateTime();
}

base mixin _DecodeUint8List implements _Decoder<Uint8List> {
  @override
  Uint8List? _decode(RowReader r) => r.readUint8List();
}

Literal<T> literal<T extends Object?>(T value) => Literal(value);

final class ModelExpression<T extends Model> extends Expr<T> {
  final TableDefinition<T> _table;
  final int _index;
  final Object _handle;

  @override
  Expr<T> _standin(int index, Object handle) =>
      ModelExpression(index, _table, handle);

  @override
  int get _columns => _table.columns.length;

  @override
  // TODO: How can this be null? probably if all the values are null?
  T? _decode(RowReader row) => _table.readModel(row);

  Expr<R> _field<R>(int index, R? Function(RowReader) readValue) {
    if (index < 0 || index >= _table.columns.length) {
      throw ArgumentError.value(
        index,
        'index',
        'Table "${_table.tableName}" does not have a field '
            'at index $index',
      );
    }
    return FieldExpression(this._index + index, _handle, readValue);
  }

  @override
  Iterable<Expr<Object?>> _explode() => Iterable.generate(
      _columns,
      (index) => _field<Never>(
            index,
            (r) => throw AssertionError(
              'Exploded Expr<T> may not be decoded, '
              'Expr<T> from QueryClause may not be reused!',
            ),
          )).expand((e) => e._explode());

  ModelExpression(this._index, this._table, this._handle) : super._();
}

final class FieldExpression<T> extends SingleValueExpr<T> {
  final int _index;
  final Object _handle;
  final T? Function(RowReader) _readValue;

  @override
  T? _decode(RowReader row) => _readValue(row);

  FieldExpression(this._index, this._handle, this._readValue) : super._();
}

final class SubQueryExpression<T> extends Expr<T> {
  final QueryClause query;
  final Expr<T> _value;

  SubQueryExpression._(this.query, this._value) : super._();

  @override
  int get _columns => _value._columns;

  @override
  T? _decode(RowReader row) => _value._decode(row);

  @override
  Iterable<Expr<Object?>> _explode() {
    if (_columns == 1) {
      return [this];
    }
    return Iterable.generate(
        _columns,
        (index) => _field<Never>(
              index,
              (r) => throw AssertionError(
                'Exploded Expr<T> may not be decoded, '
                'Expr<T> from QueryClause may not be reused!',
              ),
            )).expand((e) => e._explode());
  }

  @override
  Expr<R> _field<R>(int index, R? Function(RowReader) readValue) {
    final handle = Object();
    return SubQueryExpression._(
      SelectFromClause._(
        query,
        handle,
        [FieldExpression(index, handle, readValue)],
      ),
      _value._field<R>(index, readValue),
    );
  }

  @override
  Expr<T> _standin(int index, Object handle) => _value._standin(index, handle);
}

final class ExistsExpression extends SingleValueExpr<bool> with _DecodeBool {
  final QueryClause query;
  ExistsExpression._(this.query) : super._();
}

final class SumExpression<T extends num> extends SingleValueExpr<T> {
  final Expr<T> value;
  SumExpression._(this.value) : super._();

  @override
  T? _decode(RowReader r) => value._decode(r);
}

final class AvgExpression extends SingleValueExpr<double> with _DecodeDouble {
  final Expr<num> value;
  AvgExpression._(this.value) : super._();
}

// TODO: Consider if T extends Comparable makes sense!
final class MinExpression<T extends Comparable> extends SingleValueExpr<T> {
  final Expr<T> value;
  MinExpression._(this.value) : super._();

  @override
  T? _decode(RowReader r) => value._decode(r);
}

final class MaxExpression<T extends Comparable> extends SingleValueExpr<T> {
  final Expr<T> value;
  MaxExpression._(this.value) : super._();

  @override
  T? _decode(RowReader r) => value._decode(r);
}

final class CountAllExpression extends SingleValueExpr<int> with _DecodeInt {
  CountAllExpression._() : super._();
}

final class OrElseExpression<T> extends SingleValueExpr<T> {
  final Expr<T?> value;
  final Expr<T> orElse;

  OrElseExpression._(this.value, this.orElse) : super._();

  @override
  T? _decode(RowReader r) => value._decode(r);
}

// TODO: Do we even need this, or can we simply cast?
final class NullAssertionExpression<T> extends Expr<T> {
  final Expr<T?> value;

  @override
  int get _columns => value._columns;

  @override
  T? _decode(RowReader row) => value._decode(row);

  @override
  Iterable<Expr<Object?>> _explode() => value._explode();

  Expr<T> _standin(int index, Object handle) =>
      NullAssertionExpression._(value._standin(index, handle));
  Expr<R> _field<R>(int index, R? Function(RowReader) readValue) =>
      value._field(index, readValue);

  NullAssertionExpression._(this.value) : super._();
}

sealed class CastExpression<T, R> extends SingleValueExpr<R> {
  final Expr<T> value;
  ColumnType get type;

  CastExpression._(this.value) : super._();
}

final class _CastIntExpression<T> extends CastExpression<T, int>
    with _DecodeInt {
  @override
  ColumnType get type => ColumnType.integer;

  _CastIntExpression._(super.value) : super._();
}

// ignore: unused_element
final class _CastBoolExpression<T> extends CastExpression<T, bool>
    with _DecodeBool {
  @override
  ColumnType get type => ColumnType.boolean;

  _CastBoolExpression._(super.value) : super._();
}

final class _CastDoubleExpression<T> extends CastExpression<T, double>
    with _DecodeDouble {
  @override
  ColumnType get type => ColumnType.real;

  _CastDoubleExpression._(super.value) : super._();
}

// ignore: unused_element
final class _CastDateTimeExpression<T> extends CastExpression<T, DateTime>
    with _DecodeDateTime {
  @override
  ColumnType get type => ColumnType.datetime;

  _CastDateTimeExpression._(super.value) : super._();
}

final class _CastStringExpression<T> extends CastExpression<T, String>
    with _DecodeString {
  @override
  ColumnType get type => ColumnType.text;

  _CastStringExpression._(super.value) : super._();
}

// ignore: unused_element
final class _CastUint8ListExpression<T> extends CastExpression<T, Uint8List>
    with _DecodeUint8List {
  @override
  ColumnType get type => ColumnType.blob;

  _CastUint8ListExpression._(super.value) : super._();
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
  final T? Function(RowReader) _readValue;
  final T value;
  // TODO: Consider supporting a Constant expression subclass, currently we
  //       always encode literals as ? and attach them as parameters.
  //       This is fine, but if we ever use this query builders to created
  //       prepared statements that are executed more than once, then it matters
  //       whether a literal is encoded as value or constant
  //       If we do this, we might have rename Literal to Value!

  static Null _readNull(RowReader r) {
    if (!r.tryReadNull()) {
      throw AssertionError('Expr<Null> should always be `null`!');
    }
    return null;
  }

  static bool _readBool(RowReader r) => r.readBool()!;

  static const null$ = Literal<Null>._(null, _readNull);
  static const true$ = Literal._(true, _readBool);
  static const false$ = Literal._(false, _readBool);

  const Literal._(this.value, this._readValue) : super._();

  static Literal<T> custom<S, T extends CustomDataType<S>>(
    T value,
    T Function(S) fromDatabase,
  ) =>
      switch (value) {
        CustomDataType<bool> _ =>
          Literal._(value, (r) => fromDatabase(r.readBool() as S)),
        CustomDataType<String> _ =>
          Literal._(value, (r) => fromDatabase(r.readString() as S)),
        CustomDataType<int> _ =>
          Literal._(value, (r) => fromDatabase(r.readInt() as S)),
        CustomDataType<double> _ =>
          Literal._(value, (r) => fromDatabase(r.readDouble() as S)),
        CustomDataType<Uint8List> _ =>
          Literal._(value, (r) => fromDatabase(r.readUint8List() as S)),
        CustomDataType<DateTime> _ =>
          Literal._(value, (r) => fromDatabase(r.readDateTime() as S)),
        _ => throw ArgumentError.value(
            value,
            'value',
            'T in CustomDataType<T> must be String, int, double, bool, or DateTime!',
          ),
      };

  factory Literal(T value) {
    // TODO: Consider asking Lasse how to actually switch over T, because null is not a type!
    switch (value) {
      case true:
        return true$ as Literal<T>;

      case false:
        return false$ as Literal<T>;

      case null:
        return null$ as Literal<T>;

      case String _:
        return Literal._(value, (r) => r.readString() as T?);
      case int _:
        return Literal._(value, (r) => r.readInt() as T?);
      case double _:
        return Literal._(value, (r) => r.readDouble() as T?);
      case Uint8List _:
        return Literal._(value, (r) => r.readUint8List() as T?);
      case DateTime _:
        return Literal._(value, (r) => r.readDateTime() as T?);

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

  @override
  T? _decode(RowReader row) => _readValue(row);
}

sealed class BinaryOperationExpression<T, R> extends SingleValueExpr<R> {
  final Expr<T> left;
  final Expr<T> right;
  BinaryOperationExpression(this.left, this.right) : super._();
}

final class ExpressionBoolNot extends SingleValueExpr<bool> with _DecodeBool {
  final Expr<bool> value;
  ExpressionBoolNot(this.value) : super._();
}

final class ExpressionBoolAnd extends BinaryOperationExpression<bool, bool>
    with _DecodeBool {
  ExpressionBoolAnd(super.left, super.right);
}

final class ExpressionBoolOr extends BinaryOperationExpression<bool, bool>
    with _DecodeBool {
  ExpressionBoolOr(super.left, super.right);
}

final class ExpressionStringEquals
    extends BinaryOperationExpression<String, bool> with _DecodeBool {
  ExpressionStringEquals(super.left, super.right);
}

final class ExpressionStringLessThan
    extends BinaryOperationExpression<String, bool> with _DecodeBool {
  ExpressionStringLessThan(super.left, super.right);
}

final class ExpressionStringLessThanOrEqual
    extends BinaryOperationExpression<String, bool> with _DecodeBool {
  ExpressionStringLessThanOrEqual(super.left, super.right);
}

final class ExpressionStringGreaterThan
    extends BinaryOperationExpression<String, bool> with _DecodeBool {
  ExpressionStringGreaterThan(super.left, super.right);
}

final class ExpressionStringGreaterThanOrEqual
    extends BinaryOperationExpression<String, bool> with _DecodeBool {
  ExpressionStringGreaterThanOrEqual(super.left, super.right);
}

final class ExpressionStringIsEmpty extends SingleValueExpr<bool>
    with _DecodeBool {
  final Expr<String> value;
  ExpressionStringIsEmpty(this.value) : super._();
}

final class ExpressionStringLength extends SingleValueExpr<int>
    with _DecodeInt {
  final Expr<String> value;
  ExpressionStringLength(this.value) : super._();
}

final class ExpressionStringStartsWith extends SingleValueExpr<bool>
    with _DecodeBool {
  final Expr<String> value;
  final Expr<String> prefix;
  ExpressionStringStartsWith(this.value, this.prefix) : super._();
}

final class ExpressionStringEndsWith extends SingleValueExpr<bool>
    with _DecodeBool {
  final Expr<String> value;
  final Expr<String> suffix;
  ExpressionStringEndsWith(this.value, this.suffix) : super._();
}

final class ExpressionStringLike extends SingleValueExpr<bool>
    with _DecodeBool {
  final Expr<String> value;
  final String pattern;
  ExpressionStringLike(this.value, this.pattern) : super._();
}

final class ExpressionStringContains extends SingleValueExpr<bool>
    with _DecodeBool {
  final Expr<String> value;
  final Expr<String> needle;
  ExpressionStringContains(this.value, this.needle) : super._();
}

final class ExpressionStringToUpperCase extends SingleValueExpr<String>
    with _DecodeString {
  final Expr<String> value;
  ExpressionStringToUpperCase(this.value) : super._();
}

final class ExpressionStringToLowerCase extends SingleValueExpr<String>
    with _DecodeString {
  final Expr<String> value;
  ExpressionStringToLowerCase(this.value) : super._();
}

final class ExpressionNumEquals<T extends num>
    extends BinaryOperationExpression<T, bool> with _DecodeBool {
  ExpressionNumEquals(super.left, super.right);
}

final class ExpressionNumAdd<T extends num>
    extends BinaryOperationExpression<T, T> {
  ExpressionNumAdd(super.left, super.right);

  @override
  T? _decode(RowReader r) => left._decode(r);
}

final class ExpressionNumSubtract<T extends num>
    extends BinaryOperationExpression<T, T> {
  ExpressionNumSubtract(super.left, super.right);

  @override
  T? _decode(RowReader r) => left._decode(r);
}

final class ExpressionNumMultiply<T extends num>
    extends BinaryOperationExpression<T, T> {
  ExpressionNumMultiply(super.left, super.right);

  @override
  T? _decode(RowReader r) => left._decode(r);
}

final class ExpressionNumDivide<T extends num>
    extends BinaryOperationExpression<T, double> with _DecodeDouble {
  ExpressionNumDivide(super.left, super.right);
}

final class ExpressionNumLessThan<T extends num>
    extends BinaryOperationExpression<T, bool> with _DecodeBool {
  ExpressionNumLessThan(super.left, super.right);
}

final class ExpressionNumLessThanOrEqual<T extends num>
    extends BinaryOperationExpression<T, bool> with _DecodeBool {
  ExpressionNumLessThanOrEqual(super.left, super.right);
}

final class ExpressionNumGreaterThan<T extends num>
    extends BinaryOperationExpression<T, bool> with _DecodeBool {
  ExpressionNumGreaterThan(super.left, super.right);
}

final class ExpressionNumGreaterThanOrEqual<T extends num>
    extends BinaryOperationExpression<T, bool> with _DecodeBool {
  ExpressionNumGreaterThanOrEqual(super.left, super.right);
}

final class ExpressionDateTimeEquals
    extends BinaryOperationExpression<DateTime, bool> with _DecodeBool {
  ExpressionDateTimeEquals(super.left, super.right);
}

final class ExpressionDateTimeLessThan
    extends BinaryOperationExpression<DateTime, bool> with _DecodeBool {
  ExpressionDateTimeLessThan(super.left, super.right);
}

final class ExpressionDateTimeLessThanOrEqual
    extends BinaryOperationExpression<DateTime, bool> with _DecodeBool {
  ExpressionDateTimeLessThanOrEqual(super.left, super.right);
}

final class ExpressionDateTimeGreaterThan
    extends BinaryOperationExpression<DateTime, bool> with _DecodeBool {
  ExpressionDateTimeGreaterThan(super.left, super.right);
}

final class ExpressionDateTimeGreaterThanOrEqual
    extends BinaryOperationExpression<DateTime, bool> with _DecodeBool {
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
  Expr<int> asInt() => _CastIntExpression._(this);
  // Remark we could support casting to double it works, but requires an extra
  // step in postgres. It's not really a sensible thing to do. Should you ever
  // find it useful, just use `.asInt().asDouble()`.
  // Notice, that `.asInt()´ can be useful for multiplication with boolean.
}

extension ExpressionString on Expr<String> {
  Expr<bool> equals(Expr<String> value) => ExpressionStringEquals(this, value);
  Expr<bool> equalsLiteral(String value) => equals(literal(value));

  Expr<bool> notEquals(Expr<String> value) => equals(value).not();
  Expr<bool> notEqualsLiteral(String value) => notEquals(literal(value));

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
  Expr<int> asInt() => _CastIntExpression._(this);

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
  Expr<double> asDouble() => _CastDoubleExpression._(this);
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
  Expr<String> asString() => _CastStringExpression._(this);

  /// Cast as double.
  ///
  /// In SQL often translates to `CAST(value AS DOUBLE PRECISION)`.
  ///
  /// This is generally safe and won't cause runtime errors.
  /// Though precision may be lost when casting large integers to double.
  ///
  /// Example:
  /// * `123` -> `123.0`
  Expr<double> asDouble() => _CastDoubleExpression._(this);
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
  Expr<String> asString() => _CastStringExpression._(this);

  /// Cast as integer.
  ///
  /// In SQL often translates to `CAST(value AS BIGINT)`.
  ///
  /// This is generally safe and won't cause runtime errors.
  /// Though decimals are truncated when casting a double to integer.
  ///
  /// Example:
  /// * `3.14` -> `3`
  Expr<int> asInt() => _CastIntExpression._(this);
}

extension ExpressionNum<T extends num> on Expr<T> {
  Expr<bool> equals(Expr<T> value) => ExpressionNumEquals(this, value);
  Expr<bool> equalsLiteral(num value) =>
      ExpressionNumEquals(this, literal(value));

  Expr<bool> notEquals(Expr<T> value) => equals(value).not();
  Expr<bool> notEqualsLiteral(T value) => notEquals(literal(value));

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
  Expr<bool> equals(Expr<DateTime> value) =>
      ExpressionDateTimeEquals(this, value);
  Expr<bool> equalsLiteral(DateTime value) =>
      ExpressionDateTimeEquals(this, literal(value));

  Expr<bool> notEquals(Expr<DateTime> value) => equals(value).not();
  Expr<bool> notEqualsLiteral(DateTime value) => notEquals(literal(value));

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
