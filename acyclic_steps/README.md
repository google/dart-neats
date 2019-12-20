Acyclic Steps for Dart
======================

**Disclaimer:** This is not an officially supported Google product.

Package `acyclic_steps` enables the definition of steps with acyclic
dependencies on other steps and the evaluation of such steps. A step is a
function (optionally async) which produces a result (or side-effect).
A step may depend on other steps, but cyclic dependencies will produce a
compile-time error.

When a step is evaluated, the dependencies for the step is evaluated first.
To the extend permitted by dependency constraints the steps depended upon will
run concurrently. Steps can also be overriden to inject an initial value, or
a mock/fake object during testing. The result from a `Step` is cached in the
`Runner` object that evaluated the `Step`, this ensures that steps will not be
repeated.

`package:acyclic_steps` was written to facilitate complex projects with many
components that depends on other components to be initialized. This is
frequently the case for servers, where one step might be to setup a database
connection, while other steps depend upon the database connection. This is also
a frequent case where it is desirable to be able to override the database
connection step during testing, to use a different database or even database
driver.

The package is also intended to be useful for evaluation of complex task graphs,
where tasks may depend on the result of previous tasks.

## Example

```dart
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
```
