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

import 'dart:async';

import 'package:test/test.dart';
import 'package:acyclic_steps/acyclic_steps.dart';

void main() {
  test('the example works', () async {
    /// A step that provides a message, this is a _virtual step_ because it
    /// doesn't have an implementation instead it throws an error. Hence, to
    /// evaluate a step that depends on [messageStep] it is necessary to
    /// override this step, by injecting a value to replace it.
    final messageStep = Step.define('message').build<String>(
      () => throw UnimplementedError('message must be overriden with input'),
    );

    /// A step that provides date and time
    final dateTimeStep = Step.define('date-time').build(
      () => DateTime.now().toString(),
    );

    /// A step which has side effects.
    final printStep = Step.define(
      'print',
    ) // Dependencies:
        .dep(messageStep)
        .dep(dateTimeStep)
        .build<void>((
      msg, // result from evaluation of messageStep
      time, // result from evaluation of dateTimeStep
    ) async {
      print('$msg at $time');
    });

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
  });

  test('async steps runs concurrently', () async {
    final cA = Completer();
    final cB = Completer();
    final stepA = Step.define('step-a').build(() async {
      await Future.delayed(Duration(milliseconds: 200));
      // Create a deadlock, if stepA and stepB doesn't run concurrently
      cA.complete();
      await cB.future;
      return 'some-text';
    });
    final stepB = Step.define('step-b').build(() async {
      // Create a deadlock, if stepA and stepB doesn't run concurrently
      cB.complete();
      await cA.future;
      return 41;
    });
    final stepC =
        Step.define('step-c').dep(stepA).dep(stepB).build((a, b) async {
      b++;
      return '$a, value: $b';
    });
    final r = Runner();
    final result = await r.run(stepC);
    expect(result, equals('some-text, value: 42'));
  });

  test('Runner using wrapRunStep', () async {
    final stepA = Step.define('step-a').build(() async {
      await Future.delayed(Duration(milliseconds: 200));
      return 'some-text';
    });
    final stepB = Step.define('step-b').dep(stepA).build((a) async {
      await Future.delayed(Duration(milliseconds: 200));
      return 41;
    });
    final stepC =
        Step.define('step-c').dep(stepA).dep(stepB).build((a, b) async {
      b++;
      return '$a, value: $b';
    });

    var runStepCount = 0;
    Future<T> wrapRunStep<T>(Step<T> step, Future<T> Function() runStep) async {
      runStepCount++;
      return runStep();
    }

    final r = Runner(wrapRunStep: wrapRunStep);
    await r.run(stepC);
    await r.run(stepC);
    await r.run(stepB);
    await r.run(stepA);
    await r.run(stepB);
    expect(runStepCount, equals(3));
  });

  test('Cannot override step twice', () async {
    final stepA = Step.define('step-a').build(() async {
      return 'some-text';
    });
    final stepB = Step.define('step-b').dep(stepA).build((a) async {
      await Future.delayed(Duration(milliseconds: 200));
      return 41;
    });

    var runStepCount = 0;
    Future<T> wrapRunStep<T>(Step<T> step, Future<T> Function() runStep) async {
      runStepCount++;
      return runStep();
    }

    final r = Runner(wrapRunStep: wrapRunStep);
    r.override(stepA, 'other-text');
    expect(() {
      // We can't do this
      r.override(stepA, 'new-text');
    }, throwsStateError);
    await r.run(stepB);
    await r.run(stepA);
    await r.run(stepA);
    await r.run(stepB);
    expect(runStepCount, equals(1));
    expect(() {
      // We can't do this
      r.override(stepB, 42);
    }, throwsStateError);
  });
}
