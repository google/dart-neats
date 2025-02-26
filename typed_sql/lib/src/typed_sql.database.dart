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

sealed class DatabaseContext<T extends Schema> {
  DatabaseContext._(this._dialect);

  final SqlDialect _dialect;
  QueryExecutor get _db;

  Stream<RowReader> _query(String sql, List<Object?> params) =>
      _db.query(sql, params);

  Future<QueryResult> _execute(String sql, List<Object?> params) =>
      _db.execute(sql, params);
}

final class Database<T extends Schema> extends DatabaseContext<T> {
  Database(DatabaseAdaptor adaptor, super.dialect)
      : _db = adaptor,
        super._();

  @override
  final DatabaseAdaptor _db;

  Future<R> transaction<R>(
    FutureOr<R> Function(Transaction<T> tx) fn,
  ) async {
    return await _db.transaction((tx) async {
      return await fn(Transaction._(tx, _dialect));
    });
  }

  QuerySingle<S> select<S extends Record>(S expressions) =>
      QuerySingle._(_Query(this, expressions, SelectClause._));
}

final class Transaction<T extends Schema> extends DatabaseContext<T> {
  Transaction._(DatabaseTransaction adaptor, SqlDialect dialect)
      : _db = adaptor,
        super._(dialect);

  @override
  final DatabaseTransaction _db;

  // TODO: How do we deal with concurrent query/savePoint invocations?
  //       Clearly, if we have two concurrent calls to query() we'll just queue
  //       them. This works fine, and is expected. The user can do:
  //         await Future.wait(items.map((item) => ... tx ...));
  //       This is expected, even desired. We want these queries to be
  //       sequential, and this works fine!
  //       Sure it would have been faster with a [Database] instead, but it also
  //       possible that database isn't the only I/O happening in "... tx ...".
  //       In which case queued database lookups probably isn't bad, it's
  //       probably better than a runtime exception, though this can be debated!
  //
  //       But what if we have concurrent calls to savePoint(), again we could
  //       queue this, and doing so is probably not so bad.
  //       But if we do that and we accidentally have a call to [tx] inside the
  //       savePoint() then we have a deadlock! This is bad! Very bad!
  //       So might have to use zones to throw a StateError if trying to call
  //       tx from inside a savePoint. Or sp from inside a nested savePoint!
  //
  // TODO: Ensure we consistently throw StateError, if trying to do operations
  //       on a SavePoint or Transaction after it's been committed. This is a
  //       common error if you forget to await inside the method!
  Future<R> savePoint<R>(
    FutureOr<R> Function(SavePoint<T> tx) fn,
  ) async {
    return await _db.savePoint((tx) async {
      return await fn(SavePoint._(tx, _dialect));
    });
  }
}

final class SavePoint<T extends Schema> extends Transaction<T> {
  SavePoint._(DatabaseSavePoint adaptor, SqlDialect dialect)
      : super._(adaptor, dialect);
}
