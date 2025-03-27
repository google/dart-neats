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

/// This library defines base classes for all exceptions thrown by this package.
///
/// @docImport 'package:typed_sql/typed_sql.dart';
/// @docImport 'adaptor/adaptor.dart';
library;

/// Base class for all exceptions thrown by `package:typed_sql`.
sealed class DatabaseException implements Exception {}

/// Thrown when the database reports an error while executing an operation.
///
/// An operation could fail for a number of reasons, such as:
///  * Type cast error in the database (e.g. `CAST('NaN' AS INT)`),
///  * General runtime error in the SQL evaluation (e.g. division by zero),
///  * Constraint violation (e.g. `UNIQUE` constraint violation),
///  * Deadlock, timeout in the database, etc.
///
/// An [OperationException] means that the database failed to execute the SQL
/// query/command it was given. If this happens inside a transaction it's best
/// to let it propagate up to [Database.transact], such that the transaction is
/// rolled back, this will in turn cause [Database.transact] to throw a
/// [TransactionAbortedException].
abstract final class OperationException extends DatabaseException {
  // TODO: Make this class `sealed` when we are confident we don't need
  //       additional subclasses. This need not happen anytime soone, we can do
  //       this long after 1.0.0, when we have a number of reliable adaptors.
}

/// Thrown when an operation was aborted because a constraint violation in the
/// database.
abstract base class ConstraintViolationException extends OperationException {}

/// Thrown when a division by zero happened in the database.
///
/// Example: `SELECT 1 / 0`.
abstract base class DivisionByZeroException extends OperationException {}

/// Thrown when an SQL type cast fail in the database.
///
/// Example: `SELECT CAST('NaN' AS INT)`.
abstract base class TypeCastException extends OperationException {}

/// An unspecified [OperationException].
///
/// This class can be used if the database driver doesn't know exactly what kind
/// of [OperationException] happened, or if the database or _database driver_
/// simply doesn't distinguish between different exceptions.
///
/// An [UnspecifiedOperationException] may be caused by an error that should
/// have been an instance of [DivisionByZeroException], [TypeCastException],
/// [ConstraintViolationException], etc.
abstract base class UnspecifiedOperationException extends OperationException {}

/// Thrown when a transaction was rolled back.
///
/// If the callback passed to [Database.transact] throw an [Exception] then the
/// transaction is rolled back and the [TransactionAbortedException] is thrown.
/// The exception that caused [Database.transact] to rollback the transaction
/// will be given as [reason].
///
/// If the transaction was rolled back because the `COMMIT` operation failed,
/// then the underlying [OperationException] from the database driver will be
/// given as [reason].
final class TransactionAbortedException extends DatabaseException {
  /// Exception that caused the transaction to be rolled back.
  ///
  /// If the transaction was rolled back because the transaction callback threw
  /// an [Exception] then this exception will be the [reason].
  /// Otherwise, [reason] is the underlying exception from the database driver.
  final Exception reason;

  TransactionAbortedException._(this.reason);
}

/// Throw a [TransactionAbortedException] with the given [reason].
Never throwTransactionAbortedException(Exception reason) =>
    throw TransactionAbortedException._(reason);

/// Thrown when there is an issue with the database connection.
abstract final class DatabaseConnectionException extends DatabaseException {
  // TODO: Make this class `sealed` when we are confident we don't need
  //       additional subclasses. This need not happen anytime soone, we can do
  //       this long after 1.0.0, when we have a number of reliable adaptors.
}

/// Thrown when authentication with the database failed.
abstract base class AuthenticationException
    extends DatabaseConnectionException {}

/// Thrown when the database connection was refused.
abstract base class DatabaseConnectionRefusedException
    extends DatabaseConnectionException {}

/// Thrown when the database connection is closed.
///
/// This implies that [DatabaseAdaptor.close] was called, meaning that the
/// underlying database connection or connection pool was closed.
abstract base class DatabaseConnectionClosedException
    extends DatabaseConnectionException {}

/// Thrown when there is an intermittent issue with the database connection.
///
/// An intermittent connection issue could typically be:
///  * TCP connection was broken,
///  * Connection timeout,
///  * etc.
///
/// An intermittent connection issue implies that the operation may have failed.
/// If inside a transaction, the transaction must be assumed to have failed,
/// attempting to recover the transaction is impossible.
///
/// Instead the issue _may_ be resolved by retrying the transaction or
/// operation, though this is never assured.
abstract final class IntermittentConnectionException
    extends DatabaseConnectionException {
  // TODO: Make this class `sealed` when we are confident we don't need
  //       additional subclasses. This need not happen anytime soone, we can do
  //       this long after 1.0.0, when we have a number of reliable adaptors.
}

/// Thrown when the database connection was broken.
///
/// This is typically caused by an underlying TCP connection being broken.
abstract base class DatabaseConnectionBrokenException
    extends IntermittentConnectionException {}

/// Thrown when a connection timeout happened.
abstract base class DatabaseConnectionTimeoutException
    extends IntermittentConnectionException {}
