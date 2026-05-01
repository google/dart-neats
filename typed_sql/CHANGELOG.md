## 0.1.10-dev
 * Introduce `.insertValue` which automatically wraps with `toExpr()`, but is
   unfortunately unable to insert _default value_ for nullable fields that
   have a default value other than `NULL`.

## 0.1.9
 * Fix constraint name generation for `FOREIGN KEY` DDLs.

## 0.1.8
 * Set `PRAGMA foreign_keys = ON;` on all sqlite connections.
 * Use classes in generated files.
 * Add constraint name to `FOREIGN KEY` DDLs.
 * Support `ON DELETE` and `ON UPDATE` actions (e.g. `CASCADE`).

## 0.1.7
 * Removed the debug use of `package:test` from mysql adapter.

## 0.1.6
 * Fixed dependencies in `pubspec.yaml`.

## 0.1.5
 * Upgraded `package:build` dependency to allow `>=3.0.0 <5.0.0`.
 * Added check for a `Row` class not included in the `build.yaml` sources.
 * Support for `@DefaultValue(0)` on fields of type `double` (with value being
   cast during code generation).
 * Initial support for `JSONB` columns with `JsonValue` wrapper.

## 0.1.4
 * Upgraded dependencies (incl. `package:analyzer`).

## 0.1.3
 * Added `TransactionAbortedException.toString()` to render the `reason` when
   printing an exception.
 * Fix postgres support for `DateTime.utc(0)`, which must be encoded as 'BC'
   suffixed date-time.
 * Escaping table names in queries.
 * Fix `.update` / `.delete` for tables with composite primary keys.

## 0.1.2
 * Support for _composite foreign keys_ using the `@ForeignKey` annotation.
 * Extension methods for joining table using _foreign keys_.

## 0.1.1
 * Fixed build issues where it's unable to resolve `CustomDataType`.

## 0.1.0

Initial version.
