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

sealed class Expr<T extends Object?> {
  factory Expr(T value) => literal(value);

  const Expr._();

  int get _columns => 1;
  T _decode(Object? Function(int index) get) => get(0) as T;

  Expr<T> _standin(int index, Object handle) => FieldExpression(index, handle);

  static const true$ = Literal.true$;
  static const false$ = Literal.false$;

  static Literal<T> literal<T extends Object?>(T value) => Literal(value);
}

Literal<T> literal<T extends Object?>(T value) => Literal(value);

final class ModelExpression<T extends Model> extends Expr<T> {
  // TODO: These should be private!
  final Table<T> table;
  final int index;
  final Object handle;

  @override
  Expr<T> _standin(int index, Object handle) =>
      ModelExpression(index, table, handle);

  @override
  int get _columns => table._columns.length;

  @override
  T _decode(Object? Function(int index) get) => table._deserialize(get);

  Expr<R> field<R>(int index) {
    if (index < 0 || index >= table._columns.length) {
      throw ArgumentError.value(
        index,
        'index',
        'Table "${table._tableName}" does not have a field at index $index',
      );
    }
    return FieldExpression(this.index + index, handle);
  }

  ModelExpression(this.index, this.table, this.handle) : super._();
}

final class FieldExpression<T> extends Expr<T> {
  // TODO: These should be private!
  final int index;
  final Object handle;

  FieldExpression(this.index, this.handle) : super._();
}

final class Literal<T> extends Expr<T> {
  final T value;
  // TODO: Consider supporting a Constant expression subclass, currently we
  //       always encode literals as ? and attach them as parameters.
  //       This is fine, but if we ever use this query builders to created
  //       prepared statements that are executed more than once, then it matters
  //       whether a literal is encoded as value or constant
  //       If we do this, we might have rename Literal to Value!

  static const true$ = Literal._(true);
  static const false$ = Literal._(false);

  const Literal._(this.value) : super._();

  factory Literal(T value) {
    if (value is bool) {
      if (value) {
        return true$ as Literal<T>;
      } else {
        return false$ as Literal<T>;
      }
    }
    if (value is! String &&
        value is! int &&
        value is! double &&
        // TODO: Isn't null allowed?
        value is! DateTime) {
      throw ArgumentError.value(
        value,
        'value',
        'Only String, int, double, bool and DateTime literals are allowed',
      );
    }
    return Literal._(value);
  }
}

sealed class BinaryOperationExpression<T, R> extends Expr<R> {
  final Expr<T> left;
  final Expr<T> right;
  BinaryOperationExpression(this.left, this.right) : super._();
}

final class ExpressionBoolNot extends Expr<bool> {
  final Expr<bool> value;
  ExpressionBoolNot(this.value) : super._();
}

final class ExpressionBoolAnd extends BinaryOperationExpression<bool, bool> {
  ExpressionBoolAnd(super.left, super.right);
}

final class ExpressionBoolOr extends BinaryOperationExpression<bool, bool> {
  ExpressionBoolOr(super.left, super.right);
}

final class ExpressionStringEquals
    extends BinaryOperationExpression<String, bool> {
  ExpressionStringEquals(super.left, super.right);
}

final class ExpressionStringLessThan
    extends BinaryOperationExpression<String, bool> {
  ExpressionStringLessThan(super.left, super.right);
}

final class ExpressionStringLessThanOrEqual
    extends BinaryOperationExpression<String, bool> {
  ExpressionStringLessThanOrEqual(super.left, super.right);
}

final class ExpressionStringGreaterThan
    extends BinaryOperationExpression<String, bool> {
  ExpressionStringGreaterThan(super.left, super.right);
}

final class ExpressionStringGreaterThanOrEqual
    extends BinaryOperationExpression<String, bool> {
  ExpressionStringGreaterThanOrEqual(super.left, super.right);
}

final class ExpressionStringIsEmpty extends Expr<bool> {
  final Expr<String> value;
  ExpressionStringIsEmpty(this.value) : super._();
}

final class ExpressionStringLength extends Expr<int> {
  final Expr<String> value;
  ExpressionStringLength(this.value) : super._();
}

final class ExpressionStringStartsWith extends Expr<bool> {
  final Expr<String> value;
  final Expr<String> prefix;
  ExpressionStringStartsWith(this.value, this.prefix) : super._();
}

final class ExpressionStringEndsWith extends Expr<bool> {
  final Expr<String> value;
  final Expr<String> suffix;
  ExpressionStringEndsWith(this.value, this.suffix) : super._();
}

final class ExpressionStringLike extends Expr<bool> {
  final Expr<String> value;
  final String pattern;
  ExpressionStringLike(this.value, this.pattern) : super._();
}

final class ExpressionStringContains extends Expr<bool> {
  final Expr<String> value;
  final Expr<String> needle;
  ExpressionStringContains(this.value, this.needle) : super._();
}

final class ExpressionStringToUpperCase extends Expr<String> {
  final Expr<String> value;
  ExpressionStringToUpperCase(this.value) : super._();
}

final class ExpressionStringToLowerCase extends Expr<String> {
  final Expr<String> value;
  ExpressionStringToLowerCase(this.value) : super._();
}

final class ExpressionNumEquals<T extends num>
    extends BinaryOperationExpression<T, bool> {
  ExpressionNumEquals(super.left, super.right);
}

final class ExpressionNumAdd<T extends num>
    extends BinaryOperationExpression<T, T> {
  ExpressionNumAdd(super.left, super.right);
}

final class ExpressionNumSubtract<T extends num>
    extends BinaryOperationExpression<T, T> {
  ExpressionNumSubtract(super.left, super.right);
}

final class ExpressionNumMultiply<T extends num>
    extends BinaryOperationExpression<T, T> {
  ExpressionNumMultiply(super.left, super.right);
}

final class ExpressionNumDivide<T extends num>
    extends BinaryOperationExpression<T, T> {
  ExpressionNumDivide(super.left, super.right);
}

final class ExpressionNumLessThan<T extends num>
    extends BinaryOperationExpression<T, bool> {
  ExpressionNumLessThan(super.left, super.right);
}

final class ExpressionNumLessThanOrEqual<T extends num>
    extends BinaryOperationExpression<T, bool> {
  ExpressionNumLessThanOrEqual(super.left, super.right);
}

final class ExpressionNumGreaterThan<T extends num>
    extends BinaryOperationExpression<T, bool> {
  ExpressionNumGreaterThan(super.left, super.right);
}

final class ExpressionNumGreaterThanOrEqual<T extends num>
    extends BinaryOperationExpression<T, bool> {
  ExpressionNumGreaterThanOrEqual(super.left, super.right);
}

final class ExpressionDateTimeEquals
    extends BinaryOperationExpression<DateTime, bool> {
  ExpressionDateTimeEquals(super.left, super.right);
}

final class ExpressionDateTimeLessThan
    extends BinaryOperationExpression<DateTime, bool> {
  ExpressionDateTimeLessThan(super.left, super.right);
}

final class ExpressionDateTimeLessThanOrEqual
    extends BinaryOperationExpression<DateTime, bool> {
  ExpressionDateTimeLessThanOrEqual(super.left, super.right);
}

final class ExpressionDateTimeGreaterThan
    extends BinaryOperationExpression<DateTime, bool> {
  ExpressionDateTimeGreaterThan(super.left, super.right);
}

final class ExpressionDateTimeGreaterThanOrEqual
    extends BinaryOperationExpression<DateTime, bool> {
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
}

extension ExpressionNum on Expr<num> {
  Expr<bool> equals(Expr<num> value) => ExpressionNumEquals(this, value);
  Expr<bool> equalsLiteral(num value) =>
      ExpressionNumEquals(this, literal(value));

  Expr<bool> notEquals(Expr<num> value) => equals(value).not();
  Expr<bool> notEqualsLiteral(num value) => notEquals(literal(value));

  Expr<num> operator +(Expr<num> other) => ExpressionNumAdd(this, other);
  Expr<num> operator -(Expr<num> other) => ExpressionNumSubtract(this, other);
  Expr<num> operator *(Expr<num> other) => ExpressionNumMultiply(this, other);
  Expr<num> operator /(Expr<num> other) => ExpressionNumDivide(this, other);

  Expr<bool> operator >=(Expr<num> other) =>
      ExpressionNumGreaterThanOrEqual(this, other);
  Expr<bool> operator <=(Expr<num> other) =>
      ExpressionNumLessThanOrEqual(this, other);
  Expr<bool> operator >(Expr<num> other) =>
      ExpressionNumGreaterThan(this, other);
  Expr<bool> operator <(Expr<num> other) => ExpressionNumLessThan(this, other);

  //... do other operators...
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
