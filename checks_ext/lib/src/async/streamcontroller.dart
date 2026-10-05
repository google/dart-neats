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

extension StreamControllerChecksExt<T> on Subject<StreamController<T>> {
  static const _hasListener = (
    positive: 'has listener',
    negative: 'has no listener',
  );

  /// Expects that the stream controller has a listener.
  ///
  /// {@example /example/async/streamcontroller/has_listener.dart}
  void hasListener() => expectTrue(_hasListener, (s) => s.hasListener);

  /// Expects that the stream controller has no listener.
  void hasNoListener() => expectFalse(_hasListener, (s) => s.hasListener);

  static const _closed = (positive: 'is closed', negative: 'is not closed');

  /// Expects that the stream controller is closed.
  ///
  /// {@example /example/async/streamcontroller/is_closed.dart}
  void isClosed() => expectTrue(_closed, (s) => s.isClosed);

  /// Expects that the stream controller is not closed.
  void isNotClosed() => expectFalse(_closed, (s) => s.isClosed);

  static const _paused = (positive: 'is paused', negative: 'is not paused');

  /// Expects that the stream controller is paused.
  ///
  /// {@example /example/async/streamcontroller/is_paused.dart}
  void isPaused() => expectTrue(_paused, (s) => s.isPaused);

  /// Expects that the stream controller is not paused.
  void isNotPaused() => expectFalse(_paused, (s) => s.isPaused);

  /// The future that completes when the stream controller is closed.
  Subject<Future> get done => has((s) => s.done, 'done');
}
