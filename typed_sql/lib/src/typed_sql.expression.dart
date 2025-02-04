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

sealed class Expression<T> {
  const Expression();
}

final class RowExpression<T extends Model> extends Expression<T> {
  final String alias;
  RowExpression(this.alias);
}

final class FieldExpression<T> extends Expression<T> {
  // TODO: Consider using field index numbers, that would be much cooler!
  final String alias;
  final String name;
  FieldExpression(this.alias, this.name);
}

final class Literal<T> extends Expression<T> {
  final T value;
  // TODO: Consider supporting a Constant expression subclass, currently we
  //       always encode literals as ? and attach them as parameters.
  //       This is fine, but if we ever use this query builders to created
  //       prepared statements that are executed more than once, then it matters
  //       whether a literal is encoded as value or constant
  //       If we do this, we might have rename Literal to Value!

  static const literalTrue = Literal._(true);
  static const literalFalse = Literal._(false);

  const Literal._(this.value);

  factory Literal(T value) {
    if (value is bool) {
      if (value) {
        return literalTrue as Literal<T>;
      } else {
        return literalFalse as Literal<T>;
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

extension DotLiteral<R, T> on R Function(Expression<T>) {
  R literal(T value) => this(Literal(value));
}

sealed class BinaryOperationExpression<T, R> extends Expression<R> {
  final Expression<T> left;
  final Expression<T> right;
  BinaryOperationExpression(this.left, this.right);
}

final class ExpressionBoolNot extends Expression<bool> {
  final Expression<bool> value;
  ExpressionBoolNot(this.value);
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

final class ExpressionStringIsEmpty extends Expression<bool> {
  final Expression<String> value;
  ExpressionStringIsEmpty(this.value);
}

final class ExpressionStringLength extends Expression<int> {
  final Expression<String> value;
  ExpressionStringLength(this.value);
}

final class ExpressionStringStartsWith extends Expression<bool> {
  final Expression<String> value;
  final Expression<String> prefix;
  ExpressionStringStartsWith(this.value, this.prefix);
}

final class ExpressionStringEndsWith extends Expression<bool> {
  final Expression<String> value;
  final Expression<String> suffix;
  ExpressionStringEndsWith(this.value, this.suffix);
}

final class ExpressionStringLike extends Expression<bool> {
  final Expression<String> value;
  final String pattern;
  ExpressionStringLike(this.value, this.pattern);
}

final class ExpressionStringContains extends Expression<bool> {
  final Expression<String> value;
  final Expression<String> needle;
  ExpressionStringContains(this.value, this.needle);
}

final class ExpressionStringToUpperCase extends Expression<String> {
  final Expression<String> value;
  ExpressionStringToUpperCase(this.value);
}

final class ExpressionStringToLowerCase extends Expression<String> {
  final Expression<String> value;
  ExpressionStringToLowerCase(this.value);
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

extension ExpressionBool on Expression<bool> {
  Expression<bool> not() => ExpressionBoolNot(this);
  Expression<bool> operator ~() => ExpressionBoolNot(this);

  Expression<bool> and(Expression<bool> other) {
    if (other == Literal.literalTrue) {
      return this;
    }
    if (other == Literal.literalFalse) {
      return Literal.literalFalse;
    }
    if (this == Literal.literalTrue) {
      return other;
    }
    return ExpressionBoolAnd(this, other);
  }

  Expression<bool> operator &(Expression<bool> other) => and(other);

  Expression<bool> or(Expression<bool> other) => ExpressionBoolOr(this, other);
  Expression<bool> operator |(Expression<bool> other) =>
      ExpressionBoolOr(this, other);
}

extension ExpressionString on Expression<String> {
  Expression<bool> equals(Expression<String> value) =>
      ExpressionStringEquals(this, value);

  Expression<bool> notEquals(Expression<String> value) => equals(value).not();

  Expression<bool> get isEmpty => ExpressionStringIsEmpty(this);
  Expression<bool> get isNotEmpty => isEmpty.not();

  Expression<int> get length => ExpressionStringLength(this);

  Expression<bool> startsWith(Expression<String> value) =>
      ExpressionStringStartsWith(this, value);

  Expression<bool> endsWith(Expression<String> value) =>
      ExpressionStringEndsWith(this, value);

  /// Matches pattern where `%` is one or more characters, and
  /// `_` is one character.
  Expression<bool> like(String pattern) => ExpressionStringLike(this, pattern);

  Expression<bool> contains(Expression<String> substring) =>
      ExpressionStringContains(this, substring);

  Expression<String> toLowerCase() => ExpressionStringToUpperCase(this);

  Expression<String> toUpperCase() => ExpressionStringToLowerCase(this);

  Expression<bool> operator >=(Expression<String> other) =>
      ExpressionStringGreaterThanOrEqual(this, other);
  Expression<bool> operator <=(Expression<String> other) =>
      ExpressionStringLessThanOrEqual(this, other);
  Expression<bool> operator >(Expression<String> other) =>
      ExpressionStringGreaterThan(this, other);
  Expression<bool> operator <(Expression<String> other) =>
      ExpressionStringLessThan(this, other);
}

extension ExpressionNum on Expression<num> {
  Expression<bool> equals(Expression<num> value) =>
      ExpressionNumEquals(this, value);

  Expression<bool> notEquals(Expression<num> value) => equals(value).not();

  Expression<num> operator +(Expression<num> other) =>
      ExpressionNumAdd(this, other);
  Expression<num> operator -(Expression<num> other) =>
      ExpressionNumSubtract(this, other);
  Expression<num> operator *(Expression<num> other) =>
      ExpressionNumMultiply(this, other);
  Expression<num> operator /(Expression<num> other) =>
      ExpressionNumDivide(this, other);

  Expression<bool> operator >=(Expression<num> other) =>
      ExpressionNumGreaterThanOrEqual(this, other);
  Expression<bool> operator <=(Expression<num> other) =>
      ExpressionNumLessThanOrEqual(this, other);
  Expression<bool> operator >(Expression<num> other) =>
      ExpressionNumGreaterThan(this, other);
  Expression<bool> operator <(Expression<num> other) =>
      ExpressionNumLessThan(this, other);

  //... do other operators...
}

extension ExpressionDateTime on Expression<DateTime> {
  Expression<bool> equals(Expression<DateTime> value) =>
      ExpressionDateTimeEquals(this, value);

  Expression<bool> notEquals(Expression<DateTime> value) => equals(value).not();

  // TODO: Decide if we want to support storing a Duration
  // Expression<bool> difference(Expression<DateTime> value) =>

  Expression<bool> operator >=(Expression<DateTime> other) =>
      ExpressionDateTimeGreaterThanOrEqual(this, other);
  Expression<bool> operator <=(Expression<DateTime> other) =>
      ExpressionDateTimeLessThanOrEqual(this, other);
  Expression<bool> operator >(Expression<DateTime> other) =>
      ExpressionDateTimeGreaterThan(this, other);
  Expression<bool> operator <(Expression<DateTime> other) =>
      ExpressionDateTimeLessThan(this, other);

  Expression<bool> isBefore(Expression<DateTime> value) => this < value;

  Expression<bool> isAfter(Expression<DateTime> value) => this > value;

  // TODO: More features... maybe there is a duration in SQL?
}
