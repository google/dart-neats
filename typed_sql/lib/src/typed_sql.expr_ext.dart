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

/// Extension methods for accessing the encoded value of a custom data type
/// expression.
extension CustomTypeExt<S> on Expr<CustomDataType<S>> {
  /// Get an expression containing the encoded value of the [CustomDataType]
  /// implementation.
  Expr<S> asEncoded() =>
      EncodedCustomDataTypeExpression<S, CustomDataType<S>>._(this).asNotNull();
}

/// Extension methods for accessing the encoded value of a custom data type
/// expression.
extension CustomTypeNullableExt<S> on Expr<CustomDataType<S>?> {
  /// Get an expression containing the encoded value of the [CustomDataType]
  /// implementation.
  Expr<S?> asEncoded() => EncodedCustomDataTypeExpression._(this);
}

/// Extension methods for wrapping an [int] as an expression.
extension IntExt<T extends int?> on T {
  /// Wrap [int] as an [Expr] expression for use with `package:typed_sql`.
  Expr<T> get asExpr => toExpr(this);
}

/// Extension methods for wrapping a [double] as an expression.
extension DoubleExt<T extends double?> on T {
  /// Wrap [double] as an [Expr] expression for use with `package:typed_sql`.
  Expr<T> get asExpr => toExpr(this);
}

/// Extension methods for wrapping a [String] as an expression.
extension StringExt<T extends String?> on T {
  /// Wrap [String] as an [Expr] expression for use with `package:typed_sql`.
  Expr<T> get asExpr => toExpr(this);
}

/// Extension methods for wrapping a [DateTime] as an expression.
extension DateTimeExt<T extends DateTime?> on T {
  /// Wrap [DateTime] as an [Expr] expression for use with `package:typed_sql`.
  Expr<T> get asExpr => toExpr(this);
}

/// Extension methods for wrapping a [bool] as an expression.
extension BoolExt<T extends bool?> on T {
  /// Wrap [bool] as an [Expr] expression for use with `package:typed_sql`.
  Expr<T> get asExpr => toExpr(this);
}

/// Extension methods for wrapping an [Uint8List] as an expression.
extension Uint8ListExt<T extends Uint8List?> on T {
  /// Wrap [Uint8List] as an [Expr] expression for use with `package:typed_sql`.
  Expr<T> get asExpr => toExpr(this);
}

/// Extension methods for casting `NULL` to other types.
extension ExpressionNull on Expr<Null> {
  /// Cast as [Expr<int?>] using `CAST(NULL AS BIGINT)`.
  ///
  /// This method is rarely necessary, as you can generally pass `toExpr(null)`
  /// to any method expecting an `Expr<int?>`. But in some complex scenarios
  /// this can alleviate type inference issues.
  Expr<int?> asInt() => CastExpression._(this, ColumnType.integer);

  /// Cast as [Expr<String?>] using `CAST(NULL AS TEXT)`.
  ///
  /// This method is rarely necessary, as you can generally pass `toExpr(null)`
  /// to any method expecting an `Expr<String?>`. But in some complex scenarios
  /// this can alleviate type inference issues.
  Expr<String?> asString() => CastExpression._(this, ColumnType.text);

  /// Cast as [Expr<double?>] using `CAST(NULL AS DOUBLE PRECISION)`.
  ///
  /// This method is rarely necessary, as you can generally pass `toExpr(null)`
  /// to any method expecting an `Expr<double?>`. But in some complex scenarios
  /// this can alleviate type inference issues.
  Expr<double?> asDouble() => CastExpression._(this, ColumnType.real);

  /// Cast as [Expr<bool?>] using `CAST(NULL AS BOOLEAN)`.
  ///
  /// This method is rarely necessary, as you can generally pass `toExpr(null)`
  /// to any method expecting an `Expr<bool?>`. But in some complex scenarios
  /// this can alleviate type inference issues.
  Expr<bool?> asBool() => CastExpression._(this, ColumnType.boolean);

  /// Cast as [Expr<DateTime?>] using `CAST(NULL AS TIMESTAMP)`.
  ///
  /// This method is rarely necessary, as you can generally pass `toExpr(null)`
  /// to any method expecting an `Expr<DateTime?>`. But in some complex scenarios
  /// this can alleviate type inference issues.
  Expr<DateTime?> asDateTime() => CastExpression._(this, ColumnType.dateTime);

  /// Cast as [Expr<Uint8List?>] using `CAST(NULL AS BLOB)`.
  ///
  /// This method is rarely necessary, as you can generally pass `toExpr(null)`
  /// to any method expecting an `Expr<Uint8List?>`. But in some complex scenarios
  /// this can alleviate type inference issues.
  Expr<Uint8List?> asBlob() => CastExpression._(this, ColumnType.blob);

  // TODO: Generate cast for CustomDataType!
}

/// Extension methods for casting a nullable [Expr] to a non-nullable Expr.
extension ExpressionNullable<T> on Expr<T?> {
  /// Cast as [Expr<T>] without doing anything in SQL.
  ///
  /// As SQL has no concept of nullability this is a no-op in SQL! This merely
  /// allows you to use an expression as if it is cannot be `NULL`. Hence, if
  /// you use this on an expression that can be null, you may be
  /// _null assertion errors_ in Dart at runtime, or unexpected behavior from
  /// your SQL queries.
  ///
  /// > [!WARNING]
  /// > This is a no-op in SQL, there is no enforcement. This merely casts the
  /// > current expression to a non-nullable expression and does not cause an
  /// > error if the assertion is violated.
  Expr<T> asNotNull() => NotNullExpression._(this);
}

/// Extension methods for nullable [int] and [double] expressions.
extension ExpressionNullableNum<T extends num> on Expr<T?> {
  /// {@template orElse}
  /// If this expression is `NULL`, use [value] instead.
  ///
  /// This is equivalent to `COALESCE(this, value)`.
  /// {@endtemplate}
  Expr<T> orElse(Expr<T> value) => OrElseExpression._(this, value);

  /// {@macro orElse}
  Expr<T> orElseValue(T value) => orElse(toExpr(value));

  /// {@template equals}
  /// Compare this expression to [value] using `=` in SQL coalesced to `FALSE`.
  ///
  /// This is equivalent to `COALESCE(this = value, FALSE)` in SQL.
  ///
  /// The `.equals` _extension method_ requires that one of the two operators
  /// are non-nullable. Because `NULL = NULL` evaluates to `UNKNOWN` in SQL,
  /// which is surprising in a Dart context.
  ///
  /// If you wish to compare two _nullable expressions_ you can use:
  ///  * [isNotDistinctFrom], to get `NULL` equivalent to `NULL`, or,
  ///  * [equalsUnlessNull], to explicitely get the SQL `=` semantics.
  /// {@endtemplate}
  Expr<bool> equals(Expr<T> value) =>
      ExpressionEquals(this, value).orElseValue(false);

  /// {@macro equals}
  Expr<bool> equalsValue(T value) => equals(toExpr(value));

  /// {@template notEquals}
  /// Compare this expression to [value] using `<>` in SQL.
  /// {@endtemplate}
  Expr<bool> notEquals(Expr<T> value) => equals(value).not();

  /// {@macro notEquals}
  Expr<bool> notEqualsValue(T value) => notEquals(toExpr(value));

  /// {@template isNotDistinctFrom}
  /// Compare this expression to [value] using `IS NOT DISTINCT FROM`.
  ///
  /// This is equivalent to `this IS NOT DISTINCT FROM value` in SQL.
  /// Hence, `NULL` is considered equal to `NULL`.
  /// {@endtemplate}
  Expr<bool> isNotDistinctFrom(Expr<T?> value) =>
      ExpressionIsNotDistinctFrom(this, value);

  /// {@template equalsUnlessNull}
  /// Compare this expression to [value] using `=`.
  ///
  /// This is equivalent to `this = value` in SQL, which if one of them is
  /// `NULL` will return `NULL`.
  ///
  /// Use [isNotDistinctFrom] if you wish to compare expressions in a manner
  /// where `NULL` is considered equal to `NULL`.
  /// {@endtemplate}
  Expr<bool?> equalsUnlessNull(Expr<T?> value) => ExpressionEquals(this, value);

  /// {@template isNull}
  /// Check if this expression is `NULL`.
  ///
  /// This is equivalent to `this IS NULL` in SQL.
  /// {@endtemplate}
  Expr<bool> isNull() => isNotDistinctFrom(toExpr(null));

  /// {@template isNotNull}
  /// Check if this expression is not `NULL`.
  ///
  /// This is equivalent to `this IS NOT NULL` in SQL.
  /// {@endtemplate}
  Expr<bool> isNotNull() => isNull().not();
}

/// Extension methods for nullable [String] expressions.
extension ExpressionNullableString on Expr<String?> {
  /// {@macro orElse}
  Expr<String> orElse(Expr<String> value) => OrElseExpression._(this, value);

  /// {@macro orElse}
  Expr<String> orElseValue(String value) => orElse(toExpr(value));

  /// {@macro equals}
  Expr<bool> equals(Expr<String> value) =>
      ExpressionEquals(this, value).orElseValue(false);

  /// {@macro equals}
  Expr<bool> equalsValue(String value) => equals(toExpr(value));

  /// {@macro notEquals}
  Expr<bool> notEquals(Expr<String> value) => equals(value).not();

  /// {@macro notEquals}
  Expr<bool> notEqualsValue(String value) => notEquals(toExpr(value));

  /// {@macro isNotDistinctFrom}
  Expr<bool> isNotDistinctFrom(Expr<String?> value) =>
      ExpressionIsNotDistinctFrom(this, value);

  /// {@macro equalsUnlessNull}
  Expr<bool?> equalsUnlessNull(Expr<String?> value) =>
      ExpressionEquals(this, value);

  /// {@macro isNull}
  Expr<bool> isNull() => isNotDistinctFrom(toExpr(null));

  /// {@macro isNotNull}
  Expr<bool> isNotNull() => isNull().not();
}

/// Extension methods for nullable [bool] expressions.
extension ExpressionNullableBool on Expr<bool?> {
  /// {@macro orElse}
  Expr<bool> orElse(Expr<bool> value) => OrElseExpression._(this, value);

  /// {@macro orElse}
  Expr<bool> orElseValue(bool value) => orElse(toExpr(value));

  /// {@macro equals}
  Expr<bool> equals(Expr<bool> value) =>
      ExpressionEquals(this, value).orElseValue(false);

  /// {@macro equals}
  Expr<bool> equalsValue(bool value) => equals(toExpr(value));

  /// {@macro notEquals}
  Expr<bool> notEquals(Expr<bool> value) => equals(value).not();

  /// {@macro notEquals}
  Expr<bool> notEqualsValue(bool value) => notEquals(toExpr(value));

  /// {@macro isNotDistinctFrom}
  Expr<bool> isNotDistinctFrom(Expr<bool?> value) =>
      ExpressionIsNotDistinctFrom(this, value);

  /// {@macro equalsUnlessNull}
  Expr<bool?> equalsUnlessNull(Expr<bool?> value) =>
      ExpressionEquals(this, value);

  /// {@macro isNull}
  Expr<bool> isNull() => isNotDistinctFrom(toExpr(null));

  /// {@macro isNotNull}
  Expr<bool> isNotNull() => isNull().not();

  /// True, if this expression evaluates to `TRUE`.
  Expr<bool> get isTrue => isNotDistinctFrom(Literal.true$);

  /// True, if this expression evaluates to `FALSE`.
  ///
  /// If this is `NULL`, [isFalse] will evaluate to `FALSE`.
  Expr<bool> get isFalse => isNotDistinctFrom(Literal.false$);
}

/// Extension methods for nullable [DateTime] expressions.
extension ExpressionNullableDateTime on Expr<DateTime?> {
  /// {@macro orElse}
  Expr<DateTime> orElse(Expr<DateTime> value) =>
      OrElseExpression._(this, value);

  /// {@macro orElse}
  Expr<DateTime> orElseValue(DateTime value) => orElse(toExpr(value));

  /// {@macro equals}
  Expr<bool> equals(Expr<DateTime> value) =>
      ExpressionEquals(this, value).orElseValue(false);

  /// {@macro equals}
  Expr<bool> equalsValue(DateTime value) => equals(toExpr(value));

  /// {@macro notEquals}
  Expr<bool> notEquals(Expr<DateTime> value) => equals(value).not();

  /// {@macro notEquals}
  Expr<bool> notEqualsValue(DateTime value) => notEquals(toExpr(value));

  /// {@macro isNotDistinctFrom}
  Expr<bool> isNotDistinctFrom(Expr<DateTime?> value) =>
      ExpressionIsNotDistinctFrom(this, value);

  /// {@macro equalsUnlessNull}
  Expr<bool?> equalsUnlessNull(Expr<DateTime?> value) =>
      ExpressionEquals(this, value);

  /// {@macro isNull}
  Expr<bool> isNull() => isNotDistinctFrom(toExpr(null));

  /// {@macro isNotNull}
  Expr<bool> isNotNull() => isNull().not();
}

/// Extension methods for [bool] expressions.
extension ExpressionBool on Expr<bool> {
  /// {@macro equals}
  Expr<bool> equals(Expr<bool?> value) =>
      ExpressionEquals(this, value).orElseValue(false);

  /// {@macro equals}
  Expr<bool> equalsValue(bool? value) => equals(toExpr(value));

  /// {@macro notEquals}
  Expr<bool> notEquals(Expr<bool?> value) => equals(value).not();

  /// {@macro notEquals}
  Expr<bool> notEqualsValue(bool? value) => notEquals(toExpr(value));

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

/// Extension methods for [String] expressions.
extension ExpressionString on Expr<String> {
  /// {@macro equals}
  Expr<bool> equals(Expr<String?> value) =>
      ExpressionEquals(this, value).orElseValue(false);

  /// {@macro equals}
  Expr<bool> equalsValue(String? value) => equals(toExpr(value));

  /// {@macro notEquals}
  Expr<bool> notEquals(Expr<String?> value) => equals(value).not();

  /// {@macro notEquals}
  Expr<bool> notEqualsValue(String? value) => notEquals(toExpr(value));

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
  Expr<bool> startsWithValue(String value) =>
      ExpressionStringStartsWith(this, toExpr(value));

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
  Expr<bool> endsWithValue(String value) =>
      ExpressionStringEndsWith(this, toExpr(value));

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
  Expr<bool> containsValue(String substring) =>
      ExpressionStringContains(this, toExpr(substring));

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
  Expr<bool> lessThan(Expr<String> other) => ExpressionLessThan(this, other);

  /// {@template lessThanOrEqual}
  /// Check if this expression is less than [other].
  ///
  /// This is equivalent to `this <= other` in SQL.
  ///
  /// {@endtemplate}
  /// {@macro unicode-consistency}
  Expr<bool> lessThanOrEqual(Expr<String> other) =>
      ExpressionLessThanOrEqual(this, other);

  /// {@template greaterThan}
  /// Check if this expression is less than [other].
  ///
  /// This is equivalent to `this > other` in SQL.
  ///
  /// {@endtemplate}
  /// {@macro unicode-consistency}
  Expr<bool> greaterThan(Expr<String> other) =>
      ExpressionGreaterThan(this, other);

  /// {@template greaterThanOrEqual}
  /// Check if this expression is less than [other].
  ///
  /// This is equivalent to `this >= other` in SQL.
  ///
  /// {@endtemplate}
  /// {@macro unicode-consistency}
  Expr<bool> greaterThanOrEqual(Expr<String> other) =>
      ExpressionGreaterThanOrEqual(this, other);

  /// {@macro lessThan}
  /// {@macro unicode-consistency}
  Expr<bool> operator <(Expr<String> other) => ExpressionLessThan(this, other);

  /// {@macro lessThanOrEqual}
  /// {@macro unicode-consistency}
  Expr<bool> operator <=(Expr<String> other) =>
      ExpressionLessThanOrEqual(this, other);

  /// {@macro greaterThan}
  /// {@macro unicode-consistency}
  Expr<bool> operator >(Expr<String> other) =>
      ExpressionGreaterThan(this, other);

  /// {@macro greaterThanOrEqual}
  /// {@macro unicode-consistency}
  Expr<bool> operator >=(Expr<String> other) =>
      ExpressionGreaterThanOrEqual(this, other);

  /// {@macro lessThan}
  /// {@macro unicode-consistency}
  Expr<bool> lessThanValue(String other) => lessThan(toExpr(other));

  /// {@macro lessThanOrEqual}
  /// {@macro unicode-consistency}
  Expr<bool> lessThanOrEqualValue(String other) =>
      lessThanOrEqual(toExpr(other));

  /// {@macro greaterThan}
  /// {@macro unicode-consistency}
  Expr<bool> greaterThanValue(String other) => greaterThan(toExpr(other));

  /// {@macro greaterThanOrEqual}
  /// {@macro unicode-consistency}
  Expr<bool> greaterThanOrEqualValue(String other) =>
      greaterThanOrEqual(toExpr(other));

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

/// Extension methods for [int] expressions.
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
  Expr<int> addValue(int other) => ExpressionNumAdd(this, toExpr(other));

  /// {@macro subtract}
  Expr<int> subtractValue(int other) =>
      ExpressionNumSubtract(this, toExpr(other));

  /// {@macro multiply}
  Expr<int> multiplyValue(int other) =>
      ExpressionNumMultiply(this, toExpr(other));

  /// {@macro divide-integer-cast}
  Expr<double> divideValue(int other) =>
      ExpressionNumDivide(this, toExpr(other));

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

/// Extension methods for [double] expressions.
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
  Expr<double> addValue(double other) => ExpressionNumAdd(this, toExpr(other));

  /// {@macro subtract}
  Expr<double> subtractValue(double other) =>
      ExpressionNumSubtract(this, toExpr(other));

  /// {@macro multiply}
  Expr<double> multiplyValue(double other) =>
      ExpressionNumMultiply(this, toExpr(other));

  /// {@macro divide}
  Expr<double> divideValue(double other) =>
      ExpressionNumDivide(this, toExpr(other));

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

/// Extension methods for [int] and [double] expressions.
extension ExpressionNum<T extends num> on Expr<T> {
  /// {@macro equals}
  Expr<bool> equals(Expr<T?> value) =>
      ExpressionEquals(this, value).orElseValue(false);

  /// {@macro equals}
  Expr<bool> equalsValue(T? value) => equals(toExpr(value));

  /// {@macro notEquals}
  Expr<bool> notEquals(Expr<T?> value) => equals(value).not();

  /// {@macro notEquals}
  Expr<bool> notEqualsValue(T? value) => notEquals(toExpr(value));

  /// {@macro lessThan}
  Expr<bool> operator <(Expr<T> other) => ExpressionLessThan(this, other);

  /// {@macro lessThanOrEqual}
  Expr<bool> operator <=(Expr<T> other) =>
      ExpressionLessThanOrEqual(this, other);

  /// {@macro greaterThan}
  Expr<bool> operator >(Expr<T> other) => ExpressionGreaterThan(this, other);

  /// {@macro greaterThanOrEqual}
  Expr<bool> operator >=(Expr<T> other) =>
      ExpressionGreaterThanOrEqual(this, other);

  /// {@macro lessThan}
  Expr<bool> lessThan(Expr<T> other) => ExpressionLessThan(this, other);

  /// {@macro lessThanOrEqual}
  Expr<bool> lessThanOrEqual(Expr<T> other) =>
      ExpressionLessThanOrEqual(this, other);

  /// {@macro greaterThan}
  Expr<bool> greaterThan(Expr<T> other) => ExpressionGreaterThan(this, other);

  /// {@macro greaterThanOrEqual}
  Expr<bool> greaterThanOrEqual(Expr<T> other) =>
      ExpressionGreaterThanOrEqual(this, other);

  /// {@macro lessThan}
  Expr<bool> lessThanValue(T other) => lessThan(toExpr(other));

  /// {@macro lessThanOrEqual}
  Expr<bool> lessThanOrEqualValue(T other) => lessThanOrEqual(toExpr(other));

  /// {@macro greaterThan}
  Expr<bool> greaterThanValue(T other) => greaterThan(toExpr(other));

  /// {@macro greaterThanOrEqual}
  Expr<bool> greaterThanOrEqualValue(T other) =>
      greaterThanOrEqual(toExpr(other));

  //... do other operators...
  // TODO: integerDivide!
}

/// Extension methods for [DateTime] expressions.
extension ExpressionDateTime on Expr<DateTime> {
  /// {@macro equals}
  Expr<bool> equals(Expr<DateTime?> value) =>
      ExpressionEquals(this, value).orElseValue(false);

  /// {@macro equals}
  Expr<bool> equalsValue(DateTime? value) => equals(toExpr(value));

  /// {@macro notEquals}
  Expr<bool> notEquals(Expr<DateTime?> value) => equals(value).not();

  /// {@macro notEquals}
  Expr<bool> notEqualsValue(DateTime? value) => notEquals(toExpr(value));

  // TODO: Decide if we want to support storing a Duration
  // Expression<bool> difference(Expression<DateTime> value) =>

  /// {@macro lessThan}
  Expr<bool> operator <(Expr<DateTime> other) =>
      ExpressionLessThan(this, other);

  /// {@macro lessThanOrEqual}
  Expr<bool> operator <=(Expr<DateTime> other) =>
      ExpressionLessThanOrEqual(this, other);

  /// {@macro greaterThan}
  Expr<bool> operator >(Expr<DateTime> other) =>
      ExpressionGreaterThan(this, other);

  /// {@macro greaterThanOrEqual}
  Expr<bool> operator >=(Expr<DateTime> other) =>
      ExpressionGreaterThanOrEqual(this, other);

  /// {@template isBefore}
  /// Check if this expression is before [value].
  ///
  /// This is equivalent to `this < value` in SQL.
  ///
  /// This is also available as `<` operator.
  /// {@endtemplate}
  Expr<bool> isBefore(Expr<DateTime> value) => this < value;

  /// {@macro isBefore}
  Expr<bool> isBeforeValue(DateTime value) => isBefore(toExpr(value));

  /// {@template isAfter}
  /// Check if this expression is after [value].
  ///
  /// This is equivalent to `this > value` in SQL.
  ///
  /// This is also available as `>` operator.
  /// {@endtemplate}
  Expr<bool> isAfter(Expr<DateTime> value) => this > value;

  /// {@macro isAfter}
  Expr<bool> isAfterValue(DateTime value) => isAfter(toExpr(value));

  // TODO: More features... maybe there is a duration in SQL?
}
