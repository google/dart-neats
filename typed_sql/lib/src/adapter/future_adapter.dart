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

import 'dart:async';

import 'adapter.dart';

/// Wrap [adapter] as [DatabaseAdapter].
///
/// This returns a [DatabaseAdapter] that awaits the future [adapter] before
/// calling doing whatever operation was requested.
DatabaseAdapter futureDatabaseAdapter(
  Future<DatabaseAdapter> adapter,
) =>
    _DatabaseAdapterFromFuture(adapter);

final class _DatabaseAdapterFromFuture extends DatabaseAdapter {
  final Future<DatabaseAdapter> _adapter;

  _DatabaseAdapterFromFuture(this._adapter);

  @override
  Future<void> close({bool force = false}) async {
    final adapter = await _adapter;
    await adapter.close(force: force);
  }

  @override
  Future<QueryResult> execute(String sql, List<Object?> params) async =>
      (await _adapter).execute(sql, params);

  @override
  Stream<RowReader> query(String sql, List<Object?> params) async* {
    final adapter = await _adapter;
    yield* adapter.query(sql, params);
  }

  @override
  Future<void> script(String sql) async => (await _adapter).script(sql);

  @override
  Future<T> transact<T>(Future<T> Function(Executor tx) fn) async =>
      (await _adapter).transact(fn);
}
