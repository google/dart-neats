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

extension ExpressionNull on Expr<Null> {
  /// Cast as [Expr<int?>] using `CAST(NULL AS BIGINT)`.
  ///
  /// This method is rarely necessar, as you can generally pass `literal(null)`
  /// to any method expecting an `Expr<int?>`. But in some complex scenarios
  /// this can alleviate type inference issues.
  Expr<int?> asInt() => CastExpression._(this, ColumnType.integer);

  /// Cast as [Expr<String?>] using `CAST(NULL AS TEXT)`.
  ///
  /// This method is rarely necessar, as you can generally pass `literal(null)`
  /// to any method expecting an `Expr<String?>`. But in some complex scenarios
  /// this can alleviate type inference issues.
  Expr<String?> asString() => CastExpression._(this, ColumnType.text);

  /// Cast as [Expr<double?>] using `CAST(NULL AS DOUBLE PRECISION)`.
  ///
  /// This method is rarely necessar, as you can generally pass `literal(null)`
  /// to any method expecting an `Expr<double?>`. But in some complex scenarios
  /// this can alleviate type inference issues.
  Expr<double?> asDouble() => CastExpression._(this, ColumnType.real);

  /// Cast as [Expr<bool?>] using `CAST(NULL AS BOOLEAN)`.
  ///
  /// This method is rarely necessar, as you can generally pass `literal(null)`
  /// to any method expecting an `Expr<bool?>`. But in some complex scenarios
  /// this can alleviate type inference issues.
  Expr<bool?> asBool() => CastExpression._(this, ColumnType.boolean);

  /// Cast as [Expr<DateTime?>] using `CAST(NULL AS TIMESTAMP)`.
  ///
  /// This method is rarely necessar, as you can generally pass `literal(null)`
  /// to any method expecting an `Expr<DateTime?>`. But in some complex scenarios
  /// this can alleviate type inference issues.
  Expr<DateTime?> asDateTime() => CastExpression._(this, ColumnType.dateTime);

  /// Cast as [Expr<Uint8List?>] using `CAST(NULL AS BLOB)`.
  ///
  /// This method is rarely necessar, as you can generally pass `literal(null)`
  /// to any method expecting an `Expr<Uint8List?>`. But in some complex scenarios
  /// this can alleviate type inference issues.
  Expr<Uint8List?> asBlob() => CastExpression._(this, ColumnType.blob);

  // TODO: Generate cast for CustomDataType!
}

extension ExpressionNullable<T> on Expr<T?> {
  // TODO: Consider renaming assertNotNull -> asNotNull()

  /// Assert that the value is not `NULL`.
  ///
  /// This is a no-op in SQL!
  ///
  /// > [!WARNING]
  /// > This is a no-op in SQL, there is no enforcement. This merely casts the
  /// > current expression to a non-nullable expression and does not cause an
  /// > error if the assertion is violated.
  Expr<T> assertNotNull() => NullAssertionExpression._(this);
}

extension ExpressionNullableNum<T extends num> on Expr<T?> {
  /// {@template orElse}
  /// If this expression is `NULL`, use [value] instead.
  ///
  /// This is equivalent to `COALESCE(this, value)`.
  /// {@endtemplate}
  Expr<T> orElse(Expr<T> value) => OrElseExpression._(this, value);

  /// {@macro orElse}
  Expr<T> orElseLiteral(T value) => orElse(literal(value));

  /// {@template equals}
  /// Compare this expression to [value].
  ///
  /// This is equivalent to `this IS NOT DISTINCT FROM value` in SQL.
  /// Hence, `NULL` is considered equal to `NULL`.
  /// {@endtemplate}
  Expr<bool> equals(Expr<T?> value) => ExpressionNumEquals(this, value);

  /// {@macro equals}
  Expr<bool> equalsLiteral(num? value) =>
      ExpressionNumEquals(this, literal(value));

  /// {@template notEquals}
  /// Compare this expression to [value].
  ///
  /// This is equivalent to `this IS DISTINCT FROM value` in SQL.
  /// Hence, `NULL` is considered not equal to `NULL`.
  /// {@endtemplate}
  Expr<bool> notEquals(Expr<T?> value) => equals(value).not();

  /// {@macro notEquals}
  Expr<bool> notEqualsLiteral(T? value) => notEquals(literal(value));

  /// {@template isNull}
  /// Check if this expression is `NULL`.
  ///
  /// This is equivalent to `this IS NULL` in SQL.
  /// {@endtemplate}
  Expr<bool> isNull() => equals(literal(null));

  /// {@template isNotNull}
  /// Check if this expression is not `NULL`.
  ///
  /// This is equivalent to `this IS NOT NULL` in SQL.
  /// {@endtemplate}
  Expr<bool> isNotNull() => isNull().not();
}

extension ExpressionNullableString on Expr<String?> {
  /// {@macro orElse}
  Expr<String> orElse(Expr<String> value) => OrElseExpression._(this, value);

  /// {@macro orElse}
  Expr<String> orElseLiteral(String value) => orElse(literal(value));

  /// {@macro equals}
  Expr<bool> equals(Expr<String?> value) => ExpressionStringEquals(this, value);

  /// {@macro equals}
  Expr<bool> equalsLiteral(String? value) => equals(literal(value));

  /// {@macro notEquals}
  Expr<bool> notEquals(Expr<String?> value) => equals(value).not();

  /// {@macro notEquals}
  Expr<bool> notEqualsLiteral(String? value) => notEquals(literal(value));

  /// {@macro isNull}
  Expr<bool> isNull() => equals(literal(null));

  /// {@macro isNotNull}
  Expr<bool> isNotNull() => isNull().not();
}

extension ExpressionNullableBool on Expr<bool?> {
  /// {@macro orElse}
  Expr<bool> orElse(Expr<bool> value) => OrElseExpression._(this, value);

  /// {@macro orElse}
  Expr<bool> orElseLiteral(bool value) => orElse(literal(value));

  // TODO: Add boolean equality, so that we can do isNull() / isNotNull()!
}

extension ExpressionNullableDateTime on Expr<DateTime?> {
  /// {@macro orElse}
  Expr<DateTime> orElse(Expr<DateTime> value) =>
      OrElseExpression._(this, value);

  /// {@macro orElse}
  Expr<DateTime> orElseLiteral(DateTime value) => orElse(literal(value));

  /// {@macro equals}
  Expr<bool> equals(Expr<DateTime?> value) =>
      ExpressionDateTimeEquals(this, value);

  /// {@macro equals}
  Expr<bool> equalsLiteral(DateTime? value) =>
      ExpressionDateTimeEquals(this, literal(value));

  /// {@macro notEquals}
  Expr<bool> notEquals(Expr<DateTime?> value) => equals(value).not();

  /// {@macro notEquals}
  Expr<bool> notEqualsLiteral(DateTime? value) => notEquals(literal(value));

  /// {@macro isNull}
  Expr<bool> isNull() => equals(literal(null));

  /// {@macro isNotNull}
  Expr<bool> isNotNull() => isNull().not();
}

extension ExpressionBool on Expr<bool> {
  /// Negate this expression.
  ///
  /// This is equivalent to `NOT this` in SQL.
  ///
  /// Also available as `~` operator.
  Expr<bool> not() => ExpressionBoolNot(this);

  /// Negate this expression.
  ///
  /// This is equivalent to `NOT this` in SQL.
  ///
  /// Also available as [not] method.
  Expr<bool> operator ~() => ExpressionBoolNot(this);

  /// Logical AND.
  ///
  /// This is equivalent to `this AND other` in SQL.
  ///
  /// Also available as `&` operator.
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

  /// Logical AND.
  ///
  /// This is equivalent to `this AND other` in SQL.
  ///
  /// Also available as [and] method.
  Expr<bool> operator &(Expr<bool> other) => and(other);

  /// Logical OR.
  ///
  /// This is equivalent to `this OR other` in SQL.
  ///
  /// Also available as `|` operator.
  Expr<bool> or(Expr<bool> other) => ExpressionBoolOr(this, other);

  /// Logical OR.
  ///
  /// This is equivalent to `this OR other` in SQL.
  ///
  /// Also available as [or] method.
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

extension ExpressionString on Expr<String> {
  /// {@macro equals}
  Expr<bool> equals(Expr<String?> value) => ExpressionStringEquals(this, value);

  /// {@macro equals}
  Expr<bool> equalsLiteral(String? value) => equals(literal(value));

  /// {@macro notEquals}
  Expr<bool> notEquals(Expr<String?> value) => equals(value).not();

  /// {@macro notEquals}
  Expr<bool> notEqualsLiteral(String? value) => notEquals(literal(value));

  /// Check if the string is empty.
  ///
  /// This is equivalent to `this = ''` in SQL.
  Expr<bool> get isEmpty => ExpressionStringIsEmpty(this);

  /// Check if the string is not empty.
  ///
  /// This is equivalent to `this != ''` in SQL.
  Expr<bool> get isNotEmpty => isEmpty.not();

  /// Get the length of the string.
  ///
  /// This is equivalent to `LENGTH(this)` in SQL.
  Expr<int> get length => ExpressionStringLength(this);

  /// {@template startsWith}
  /// Check if the string starts with [value].
  ///
  /// Similar to [String.startsWith] in Dart.
  ///
  /// > [!WARNING]
  /// > Behavior may differ slightly between databases when using special
  /// > characters or unicode.
  /// {@endtemplate}
  Expr<bool> startsWith(Expr<String> value) =>
      ExpressionStringStartsWith(this, value);

  /// {@macro startsWith}
  Expr<bool> startsWithLiteral(String value) =>
      ExpressionStringStartsWith(this, literal(value));

  /// {@template endsWith}
  /// Check if the string ends with [value].
  ///
  /// Similar to [String.endsWith] in Dart.
  ///
  /// > [!WARNING]
  /// > Behavior may differ slightly between databases when using special
  /// > characters or unicode.
  /// {@endtemplate}
  Expr<bool> endsWith(Expr<String> value) =>
      ExpressionStringEndsWith(this, value);

  /// {@macro endsWith}
  Expr<bool> endsWithLiteral(String value) =>
      ExpressionStringEndsWith(this, literal(value));

  /// Matches pattern where `%` is one or more characters, and
  /// `_` is one character.
  ///
  /// This is equivalent to `this LIKE pattern` in SQL.
  Expr<bool> like(String pattern) => ExpressionStringLike(this, pattern);

  /// {@template contains}
  /// Check if the string contains [substring].
  ///
  /// Similar to [String.contains] in Dart.
  ///
  /// > [!WARNING]
  /// > Behavior may differ slightly between databases when using unicode.
  /// {@endtemplate}
  Expr<bool> contains(Expr<String> substring) =>
      ExpressionStringContains(this, substring);

  /// {@macro contains}
  Expr<bool> containsLiteral(String substring) =>
      ExpressionStringContains(this, literal(substring));

  /// Converts the string to lower case.
  ///
  /// This is equivalent to `LOWER(this)` in SQL.
  ///
  /// {@template unicode-consistency}
  /// > [!WARNING]
  /// > For non-ascii characters the behavior may depend on database
  /// > specifics and configuration.
  /// {@endtemplate}
  Expr<String> toLowerCase() => ExpressionStringToLowerCase(this);

  /// Converts the string to upper case.
  ///
  /// This is equivalent to `UPPER(this)` in SQL.
  ///
  /// {@macro unicode-consistency}
  Expr<String> toUpperCase() => ExpressionStringToUpperCase(this);

  /// {@template lessThan}
  /// Check if this expression is less than [other].
  ///
  /// This is equivalent to `this < other` in SQL.
  ///
  /// {@endtemplate}
  /// {@macro unicode-consistency}
  Expr<bool> lessThan(Expr<String> other) =>
      ExpressionStringLessThan(this, other);

  /// {@template lessThanOrEqual}
  /// Check if this expression is less than [other].
  ///
  /// This is equivalent to `this <= other` in SQL.
  ///
  /// {@endtemplate}
  /// {@macro unicode-consistency}
  Expr<bool> lessThanOrEqual(Expr<String> other) =>
      ExpressionStringLessThanOrEqual(this, other);

  /// {@template greaterThan}
  /// Check if this expression is less than [other].
  ///
  /// This is equivalent to `this > other` in SQL.
  ///
  /// {@endtemplate}
  /// {@macro unicode-consistency}
  Expr<bool> greaterThan(Expr<String> other) =>
      ExpressionStringGreaterThan(this, other);

  /// {@template greaterThanOrEqual}
  /// Check if this expression is less than [other].
  ///
  /// This is equivalent to `this >= other` in SQL.
  ///
  /// {@endtemplate}
  /// {@macro unicode-consistency}
  Expr<bool> greaterThanOrEqual(Expr<String> other) =>
      ExpressionStringGreaterThanOrEqual(this, other);

  /// {@macro lessThan}
  /// {@macro unicode-consistency}
  Expr<bool> operator <(Expr<String> other) =>
      ExpressionStringLessThan(this, other);

  /// {@macro lessThanOrEqual}
  /// {@macro unicode-consistency}
  Expr<bool> operator <=(Expr<String> other) =>
      ExpressionStringLessThanOrEqual(this, other);

  /// {@macro greaterThan}
  /// {@macro unicode-consistency}
  Expr<bool> operator >(Expr<String> other) =>
      ExpressionStringGreaterThan(this, other);

  /// {@macro greaterThanOrEqual}
  /// {@macro unicode-consistency}
  Expr<bool> operator >=(Expr<String> other) =>
      ExpressionStringGreaterThanOrEqual(this, other);

  /// {@macro lessThan}
  /// {@macro unicode-consistency}
  Expr<bool> lessThanLiteral(String other) => lessThan(literal(other));

  /// {@macro lessThanOrEqual}
  /// {@macro unicode-consistency}
  Expr<bool> lessThanOrEqualLiteral(String other) =>
      lessThanOrEqual(literal(other));

  /// {@macro greaterThan}
  /// {@macro unicode-consistency}
  Expr<bool> greaterThanLiteral(String other) => greaterThan(literal(other));

  /// {@macro greaterThanOrEqual}
  /// {@macro unicode-consistency}
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
  /// {@template add}
  /// Add this expression to [other].
  ///
  /// This is equivalent to `this + other` in SQL.
  ///
  /// Also available as `+` operator.
  /// {@endtemplate}
  Expr<int> add(Expr<int> other) => ExpressionNumAdd(this, other);

  /// {@template subtract}
  /// Add this expression to [other].
  ///
  /// This is equivalent to `this - other` in SQL.
  ///
  /// Also available as `-` operator.
  /// {@endtemplate}
  Expr<int> subtract(Expr<int> other) => ExpressionNumSubtract(this, other);

  /// {@template multiply}
  /// Add this expression to [other].
  ///
  /// This is equivalent to `this * other` in SQL.
  ///
  /// Also available as `*` operator.
  /// {@endtemplate}
  Expr<int> multiply(Expr<int> other) => ExpressionNumMultiply(this, other);

  /// {@template divide-integer-cast}
  /// Add this expression to [other].
  ///
  /// This is equivalent to `CAST(this AS DOUBLE PRECISION) / other` in SQL.
  ///
  /// Also available as `/` operator.
  /// {@endtemplate}
  Expr<double> divide(Expr<int> other) => ExpressionNumDivide(this, other);

  /// {@template add-operator}
  /// Add this expression to [other].
  ///
  /// This is equivalent to `this + other` in SQL.
  /// {@endtemplate}
  Expr<int> operator +(Expr<int> other) => ExpressionNumAdd(this, other);

  /// {@template subtract-operator}
  /// Add this expression to [other].
  ///
  /// This is equivalent to `this - other` in SQL.
  /// {@endtemplate}
  Expr<int> operator -(Expr<int> other) => ExpressionNumSubtract(this, other);

  /// {@template multiply-operator}
  /// Add this expression to [other].
  ///
  /// This is equivalent to `this * other` in SQL.
  /// {@endtemplate}
  Expr<int> operator *(Expr<int> other) => ExpressionNumMultiply(this, other);

  /// {@template divide-integer-cast-operator}
  /// Add this expression to [other].
  ///
  /// This is equivalent to `CAST(this AS DOUBLE PRECISION) / other` in SQL.
  /// {@endtemplate}
  Expr<double> operator /(Expr<int> other) => ExpressionNumDivide(this, other);

  /// {@macro add}
  Expr<int> addLiteral(int other) => ExpressionNumAdd(this, literal(other));

  /// {@macro subtract}
  Expr<int> subtractLiteral(int other) =>
      ExpressionNumSubtract(this, literal(other));

  /// {@macro multiply}
  Expr<int> multiplyLiteral(int other) =>
      ExpressionNumMultiply(this, literal(other));

  /// {@macro divide-integer-cast}
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
  /// {@macro add}
  Expr<double> operator +(Expr<double> other) => ExpressionNumAdd(this, other);

  /// {@macro subtract}
  Expr<double> operator -(Expr<double> other) =>
      ExpressionNumSubtract(this, other);

  /// {@macro multiply}
  Expr<double> operator *(Expr<double> other) =>
      ExpressionNumMultiply(this, other);

  /// Add this expression to [other].
  ///
  /// This is equivalent to `this / other` in SQL.
  Expr<double> operator /(Expr<double> other) =>
      ExpressionNumDivide(this, other);

  /// {@macro add}
  Expr<double> add(Expr<double> other) => ExpressionNumAdd(this, other);

  /// {@macro subtract}
  Expr<double> subtract(Expr<double> other) =>
      ExpressionNumSubtract(this, other);

  /// {@macro multiply}
  Expr<double> multiply(Expr<double> other) =>
      ExpressionNumMultiply(this, other);

  /// {@template divide}
  /// Add this expression to [other].
  ///
  /// This is equivalent to `this / other` in SQL.
  ///
  /// Also available as `/` operator.
  /// {@endtemplate}
  Expr<double> divide(Expr<double> other) => ExpressionNumDivide(this, other);

  /// {@macro add}
  Expr<double> addLiteral(double other) =>
      ExpressionNumAdd(this, literal(other));

  /// {@macro subtract}
  Expr<double> subtractLiteral(double other) =>
      ExpressionNumSubtract(this, literal(other));

  /// {@macro multiply}
  Expr<double> multiplyLiteral(double other) =>
      ExpressionNumMultiply(this, literal(other));

  /// {@macro divide}
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
  /// {@macro equals}
  Expr<bool> equals(Expr<T?> value) => ExpressionNumEquals(this, value);

  /// {@macro equals}
  Expr<bool> equalsLiteral(num? value) =>
      ExpressionNumEquals(this, literal(value));

  /// {@macro notEquals}
  Expr<bool> notEquals(Expr<T?> value) => equals(value).not();

  /// {@macro notEquals}
  Expr<bool> notEqualsLiteral(T? value) => notEquals(literal(value));

  /// {@macro lessThan}
  Expr<bool> operator <(Expr<T> other) => ExpressionNumLessThan(this, other);

  /// {@macro lessThanOrEqual}
  Expr<bool> operator <=(Expr<T> other) =>
      ExpressionNumLessThanOrEqual(this, other);

  /// {@macro greaterThan}
  Expr<bool> operator >(Expr<T> other) => ExpressionNumGreaterThan(this, other);

  /// {@macro greaterThanOrEqual}
  Expr<bool> operator >=(Expr<T> other) =>
      ExpressionNumGreaterThanOrEqual(this, other);

  /// {@macro lessThan}
  Expr<bool> lessThan(Expr<T> other) => ExpressionNumLessThan(this, other);

  /// {@macro lessThanOrEqual}
  Expr<bool> lessThanOrEqual(Expr<T> other) =>
      ExpressionNumLessThanOrEqual(this, other);

  /// {@macro greaterThan}
  Expr<bool> greaterThan(Expr<T> other) =>
      ExpressionNumGreaterThan(this, other);

  /// {@macro greaterThanOrEqual}
  Expr<bool> greaterThanOrEqual(Expr<T> other) =>
      ExpressionNumGreaterThanOrEqual(this, other);

  /// {@macro lessThan}
  Expr<bool> lessThanLiteral(T other) => lessThan(literal(other));

  /// {@macro lessThanOrEqual}
  Expr<bool> lessThanOrEqualLiteral(T other) => lessThanOrEqual(literal(other));

  /// {@macro greaterThan}
  Expr<bool> greaterThanLiteral(T other) => greaterThan(literal(other));

  /// {@macro greaterThanOrEqual}
  Expr<bool> greaterThanOrEqualLiteral(T other) =>
      greaterThanOrEqual(literal(other));

  //... do other operators...
  // TODO: integerDivide!
}

extension ExpressionDateTime on Expr<DateTime> {
  /// {@macro equals}
  Expr<bool> equals(Expr<DateTime?> value) =>
      ExpressionDateTimeEquals(this, value);

  /// {@macro equals}
  Expr<bool> equalsLiteral(DateTime? value) =>
      ExpressionDateTimeEquals(this, literal(value));

  /// {@macro notEquals}
  Expr<bool> notEquals(Expr<DateTime?> value) => equals(value).not();

  /// {@macro notEquals}
  Expr<bool> notEqualsLiteral(DateTime? value) => notEquals(literal(value));

  // TODO: Decide if we want to support storing a Duration
  // Expression<bool> difference(Expression<DateTime> value) =>

  /// {@macro lessThan}
  Expr<bool> operator <(Expr<DateTime> other) =>
      ExpressionDateTimeLessThan(this, other);

  /// {@macro lessThanOrEqual}
  Expr<bool> operator <=(Expr<DateTime> other) =>
      ExpressionDateTimeLessThanOrEqual(this, other);

  /// {@macro greaterThan}
  Expr<bool> operator >(Expr<DateTime> other) =>
      ExpressionDateTimeGreaterThan(this, other);

  /// {@macro greaterThanOrEqual}
  Expr<bool> operator >=(Expr<DateTime> other) =>
      ExpressionDateTimeGreaterThanOrEqual(this, other);

  /// {@template isBefore}
  /// Check if this expression is before [value].
  ///
  /// This is equivalent to `this < value` in SQL.
  ///
  /// This is also available as `<` operator.
  /// {@endtemplate}
  Expr<bool> isBefore(Expr<DateTime> value) => this < value;

  /// {@macro isBefore}
  Expr<bool> isBeforeLiteral(DateTime value) => isBefore(literal(value));

  /// {@template isAfter}
  /// Check if this expression is after [value].
  ///
  /// This is equivalent to `this > value` in SQL.
  ///
  /// This is also available as `>` operator.
  /// {@endtemplate}
  Expr<bool> isAfter(Expr<DateTime> value) => this > value;

  /// {@macro isAfter}
  Expr<bool> isAfterLiteral(DateTime value) => isAfter(literal(value));

  // TODO: More features... maybe there is a duration in SQL?
}
