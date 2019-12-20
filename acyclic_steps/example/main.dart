// Copyright 2019 Google LLC
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

import 'dart:async' show Future;
import 'package:acyclic_steps/acyclic_steps.dart';

/// A step that provides a message, this is a _virtual step_ because it
/// doesn't have an implementation instead it throws an error. Hence, to
/// evaluate a step that depends on [messageStep] it is necessary to
/// override this step, by injecting a value to replace it.
final Step<String> messageStep = Step.define('message').build(
  () => throw UnimplementedError('message must be overriden with input'),
);

/// A step that provides date and time
final dateTimeStep = Step.define('date-time').build(
  () => DateTime.now().toString(),
);

/// A step which has side effects.
final Step<void> printStep = Step.define(
  'print',
) // Dependencies:
    .dep(messageStep)
    .dep(dateTimeStep)
    // Method to build the step
    .build((
  msg, // result from evaluation of messageStep
  time, // result from evaluation of dateTimeStep
) async {
  await Future.delayed(Duration(milliseconds: 100));
  print('$msg at $time');
});

Future<void> main() async {
  final r = Runner();
  // Override [messageStep] to provide an input value.
  r.override(messageStep, 'hello world');
  // Evaluate [printStep] which in turn evaluates [dateTimeStep], and re-uses
  // the overridden value for [messageStep].
  await r.run(printStep);

  // When testing it might be desirable to override the [dateTimeStep] to
  // produce the same output independent of time. To do this we must create a
  // new runner:
  final testRunner = Runner();
  testRunner.override(messageStep, 'hello world');
  testRunner.override(dateTimeStep, '2019-11-04 09:47:37.461795');
  // Now we can be use the [dateTimeStep] evaluates to something predictable
  assert(await testRunner.run(dateTimeStep) == '2019-11-04 09:47:37.461795');
  // This wil print a fixed time, useful when testing.
  await testRunner.run(printStep);
}
