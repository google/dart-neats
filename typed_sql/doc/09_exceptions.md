All exceptions thrown by `package:typed_sql` subclass [DatabaseException], the
inheritance hierarchy for [DatabaseException] is as follows:

* [DatabaseException]:
  * [OperationException]:
    * [ConstraintViolationException],
    * [DivisionByZeroException],
    * [TypeCastException], and,
    * [UnspecifiedOperationException].
  * [TransactionAbortedException].
  * [DatabaseConnectionException]:
    * [AuthenticationException],
    * [DatabaseConnectionRefusedException],
    * [DatabaseConnectionForceClosedException],
    * [IntermittentConnectionException]:
      * [DatabaseConnectionBrokenException],
      * [DatabaseConnectionTimeoutException].

As evident from the hierarchy above we have 3 general classes of exceptions:
 * [OperationException], an operation or query failed.
 * [TransactionAbortedException], a transaction created with `db.transact()` was
   rolled back.
 * [DatabaseConnectionException], a problem with the connection to the database.

The [OperationException] implies that some query or operation you asked the
database failed. This is typically a constraint violation, division by zero,
invalid cast or some other runtime issue that couldn't be detected before the
query (or operation) was executed.

> [!WARNING]
> Database adapters may throw [UnspecifiedOperationException] for any error,
> even when a more specific exception is exists. This means that if you catch a
> [DivisionByZeroException] then you know the problem was division by zero.
> But if you catch a [UnspecifiedOperationException] then the problem could be
> division by zero, or some other problem.
>
> Database adapters may throw [UnspecifiedOperationException] when a query fails
> due to _division by zero_, even if [DivisionByZeroException] is more specific.

The [TransactionAbortedException] is thrown by `db.transact()` when a
transaction is rolled backed. The [TransactionAbortedException.reason] property
holds the `Exception` that caused the transaction to be aborted.

This could be an `Exception` you threw inside the transaction callback, or it
could be an [OperationException] caused by one of the queries or operations
inside the transaction. See [Transactions], for details on how recover from
aborted an transaction.

The [DatabaseConnectionException] is thrown when there is a problem with the
connection to the database. It could be that database is down, that a TCP
connection to the database was dropped, or that the database connection is
simply misconfigured.

<!-- GENERATED DOCUMENTATION LINKS -->
[AuthenticationException]: ../typed_sql/AuthenticationException-class.html
[ConstraintViolationException]: ../typed_sql/ConstraintViolationException-class.html
[DatabaseConnectionBrokenException]: ../typed_sql/DatabaseConnectionBrokenException-class.html
[DatabaseConnectionException]: ../typed_sql/DatabaseConnectionException-class.html
[DatabaseConnectionForceClosedException]: ../typed_sql/DatabaseConnectionForceClosedException-class.html
[DatabaseConnectionRefusedException]: ../typed_sql/DatabaseConnectionRefusedException-class.html
[DatabaseConnectionTimeoutException]: ../typed_sql/DatabaseConnectionTimeoutException-class.html
[DatabaseException]: ../typed_sql/DatabaseException-class.html
[DivisionByZeroException]: ../typed_sql/DivisionByZeroException-class.html
[IntermittentConnectionException]: ../typed_sql/IntermittentConnectionException-class.html
[OperationException]: ../typed_sql/OperationException-class.html
[TransactionAbortedException]: ../typed_sql/TransactionAbortedException-class.html
[TransactionAbortedException.reason]: ../typed_sql/TransactionAbortedException/reason.html
[Transactions]: ../topics/Transactions-topic.html
[TypeCastException]: ../typed_sql/TypeCastException-class.html
[UnspecifiedOperationException]: ../typed_sql/UnspecifiedOperationException-class.html
