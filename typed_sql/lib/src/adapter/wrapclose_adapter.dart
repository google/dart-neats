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

/// Wrap [adapter] such that [onClosed] is called instead of
/// [DatabaseAdapter.close].
///
/// > [!NOTE]
/// > It becomes your responsibility to ensure that [adapter] is closed!
DatabaseAdapter withOnCloseDatabaseAdapter(
  DatabaseAdapter adapter,
  Future<void> Function({required bool force}) onClosed,
) =>
    _DatabaseAdapterWithOnClosed(adapter, onClosed);

final class _DatabaseAdapterWithOnClosed extends DatabaseAdapter {
  final DatabaseAdapter _adapter;
  final Future<void> Function({required bool force}) _onClosed;

  _DatabaseAdapterWithOnClosed(this._adapter, this._onClosed);

  @override
  Future<void> close({bool force = false}) async {
    await _onClosed(force: force);
  }

  @override
  Future<QueryResult> execute(String sql, List<Object?> params) =>
      _adapter.execute(sql, params);

  @override
  Stream<RowReader> query(String sql, List<Object?> params) =>
      _adapter.query(sql, params);

  @override
  Future<void> script(String sql) => _adapter.script(sql);

  @override
  Future<T> transact<T>(Future<T> Function(Executor tx) fn) =>
      _adapter.transact(fn);
}
