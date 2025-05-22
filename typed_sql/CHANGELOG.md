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
