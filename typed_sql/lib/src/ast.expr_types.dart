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

/// The SQL column-type system shared between the query-builder
/// (`typed_sql.dart`) and the SQL dialects (`dialect/`).
///
/// This library is never exported from `package:typed_sql/typed_sql.dart`.
library;

import 'dart:typed_data' show Uint8List;

import 'adapter/adapter.dart' show RowReader;
import 'ast.expr.dart' show CastExpression, Expr;
import 'typed_sql.dart' show Row, TableDefinition;
import 'types/custom_data_type.dart' show CustomDataType;
import 'types/json_value.dart' show JsonValue;

sealed class ExprType<T extends Object?> {
  T? _read(RowReader r);

  const ExprType._();
}

sealed class FieldType<T extends Object?> extends ExprType<T> {
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
  static const ColumnType<JsonValue> jsonValue = _JsonValueExprType._();
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

final class _JsonValueExprType extends ColumnType<JsonValue> {
  const _JsonValueExprType._() : super._();

  @override
  JsonValue? _read(RowReader r) => r.readJsonValue();
}

final class _NullExprType extends ColumnType<Null> {
  const _NullExprType._() : super._();

  @override
  Null _read(RowReader r) => r.tryReadNull()
      ? null
      : throw AssertionError(
          'Expr<Null> should always be `null`!',
        );
}

/// Cast [value] (whose static type is unknown, e.g. an untyped `NULL`) to
/// match [type], exploding row types into one [CastExpression] per field.
Iterable<Expr> explodedCastAs<T, S>(
  Expr<T> value,
  ExprType<S> type,
) => switch (type) {
  _RowExprType<Row> type => type.fields.map(
    (f) => CastExpression.internal(value, f),
  ),
  CustomExprType type => [CastExpression.internal(value, type._backingType)],
  ColumnType type => [CastExpression.internal(value, type)],
};

final class CustomExprType<S, T extends CustomDataType<S>>
    extends FieldType<T> {
  final ColumnType<S> _backingType;
  final T Function(S value) _fromDatabase;

  const CustomExprType.internal(this._backingType, this._fromDatabase)
    : super._();

  @override
  T? _read(RowReader r) {
    final value = _backingType._read(r);
    if (value != null) {
      return _fromDatabase(value);
    }
    return null;
  }
}

final class _RowExprType<T extends Row> extends ExprType<T> {
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

/// Get the [ExprType] describing rows of [table].
ExprType<T> rowExprType<T extends Row>(TableDefinition<T> table) =>
    _RowExprType._(table);

/// If [type] describes a row (e.g. a whole table row), returns the
/// [ColumnType] of each of its fields; otherwise returns `null`.
List<ColumnType>? rowFieldsOf(ExprType type) => switch (type) {
  _RowExprType t => t.fields,
  _ => null,
};

/// Package-internal view of [ExprType], exposing members used by the
/// query-builder and SQL dialects without making them part of [ExprType]'s
/// own (still private) API.
///
/// Members are prefixed with `$` (matching the `$ForGeneratedCode`
/// convention) so they can't collide with a generated per-model extension
/// member named after a user's column.
extension ExprTypeInternal<T extends Object?> on ExprType<T> {
  T? $read(RowReader r) => _read(r);
}

/// Package-internal view of [CustomExprType], exposing members used by the
/// query-builder and SQL dialects without making them part of
/// [CustomExprType]'s own (still private) API.
extension CustomExprTypeInternal<S, T extends CustomDataType<S>>
    on CustomExprType<S, T> {
  ColumnType<S> get $backingType => _backingType;
}
