// Copyright 2026 Google LLC
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
import '../util.dart';

extension CompleterChecksExt<T> on Subject<Completer<T>> {
  static const _completed = (
    positive: 'is completed',
    negative: 'is not completed',
  );

  /// Expects that the completer is completed.
  ///
  /// {@example /example/async/completer/is_completed.dart}
  void isCompleted() => expectTrue(_completed, (s) => s.isCompleted);

  /// Expects that the completer is not completed.
  void isNotCompleted() => expectFalse(_completed, (s) => s.isCompleted);

  /// The future that is completed by this completer.
  Subject<Future<T>> get future => has((s) => s.future, 'future');

  /// Expects that the future completes, optionally matching [completionCondition].
  Future<void> completes([AsyncCondition<T>? completionCondition]) =>
      future.completes(completionCondition);

  /// Expects that the future does not complete.
  void doesNotComplete() => future.doesNotComplete();

  /// Expects that the future throws an exception of type [E].
  Future<void> throws<E extends Object>([AsyncCondition<E>? errorCondition]) =>
      future.throws<E>(errorCondition);
}
