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

/// Wrap [adaptor] as [DatabaseAdaptor].
///
/// This returns a [DatabaseAdaptor] that awaits the future [adaptor] before
/// calling doing whatever operation was requested.
DatabaseAdaptor futureDatabaseAdaptor(
  Future<DatabaseAdaptor> adaptor,
) =>
    _DatabaseAdaptorFromFuture(adaptor);

final class _DatabaseAdaptorFromFuture extends DatabaseAdaptor {
  final Future<DatabaseAdaptor> _adaptor;

  _DatabaseAdaptorFromFuture(this._adaptor);

  @override
  Future<void> close({bool force = false}) async {
    final adaptor = await _adaptor;
    await adaptor.close(force: force);
  }

  @override
  Future<QueryResult> execute(String sql, List<Object?> params) async =>
      (await _adaptor).execute(sql, params);

  @override
  Stream<RowReader> query(String sql, List<Object?> params) async* {
    final adaptor = await _adaptor;
    yield* adaptor.query(sql, params);
  }

  @override
  Future<void> script(String sql) async => (await _adaptor).script(sql);

  @override
  Future<T> transact<T>(Future<T> Function(Executor tx) fn) async =>
      (await _adaptor).transact(fn);
}
