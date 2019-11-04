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

/// The `package:acyclic_steps/acyclic_steps.dart` library enables the
/// definition and execution of acyclic graphs of dependent steps.
///
/// A [Step] is a function that produces a result, and which may depend on
/// results produced by other steps. The result of a [Step] can be computed
/// using a [Runner] which caches the result of the step and all dependent
/// steps.
///
/// ## Example using acyclic steps
/// ```dart
/// import 'package:acyclic_steps/acyclic_steps.dart';
///
/// /// A step that provides a message, this is a _virtual step_ because it
/// /// doesn't have an implementation instead it throws an error. Hence, to
/// /// evaluate a step that depends on [messageStep] it is necessary to
/// /// override this step, by injecting a value to replace it.
/// final Step<String> messageStep = Step.deps0(
///   'message',
///   () => throw UnimplementedError('message must be overriden with input'),
/// );
///
/// /// A step that provides date and time
/// final dateTimeStep = Step.deps0('date-time', () => DateTime.now().toString());
///
/// /// A step which has side effects.
/// final Step<void> printStep = Step.deps2(
///     'print',
///     // Dependencies:
///     messageStep,
///     dateTimeStep, (
///   msg, // result from evaluation of messageStep
///   time, // result from evaluation of dateTimeStep
/// ) async {
///   print('$msg at $time');
/// });
///
/// Future<void> main() async {
///   final r = Runner();
///   // Override [messageStep] to provide an input value.
///   r.override(messageStep, 'hello world');
///   // Evaluate [printStep] which in turn evaluates [dateTimeStep], and re-uses
///   // the overridden value for [messageStep].
///   await r.run(printStep);
///
///   // When testing it might be desirable to override the [dateTimeStep] to
///   // produce the same output independent of time. To do this we must create a
///   // new runner:
///   final testRunner = Runner();
///   testRunner.override(messageStep, 'hello world');
///   testRunner.override(dateTimeStep, '2019-11-04 09:47:37.461795');
///   // Now we can be use the [dateTimeStep] evaluates to something predictable
///   assert(await testRunner.run(dateTimeStep) == '2019-11-04 09:47:37.461795');
///   // This wil print a fixed time, useful when testing.
///   await testRunner.run(printStep);
/// }
/// ```
library acyclic_steps;

import 'dart:async' show FutureOr;

import 'dart:collection' show UnmodifiableListView;
import 'package:meta/meta.dart' show sealed;

Future<T> _defaultRunStep<T>(Step<T> step, Future<T> Function() fn) => fn();

/// A [RunStepWrapper] is a function that can wrap the [RunStep] function.
///
/// See the constructor of [Runner] for examples.
typedef RunStepWrapper = Future<T> Function<T>(
  Step<T> step,
  Future<T> Function() runStep,
);

/// A [Runner] can run a [Step] and its dependencies, caching the results of
/// each step.
///
/// A given [Step] is evaluated at-most once in a given [Runner]. Hence, if
/// `stepA` and `stepB` both depends on `stepC`, evaluating the result of both
/// `stepA` and `stepB` will not run `stepC` more than once. To run a step more
/// than once, it is necessary to create a new [Runner] instance.
///
/// It can sometimes be useful to _override_ the result of a specific [Step].
/// This can be achieved using the [override] method. When doing so a [Step]
/// must be overwritten before it is evaluated. It is always safe to override
/// steps before any calls to [run].
///
/// Overriding a [Step] causes the step to not be evaluated, and the overriden
/// value to be used instead. This is useful when injecting initial options
/// into an acyclic graph of steps, or when overriding specific components with
/// mocks/fakes in a testing setup.
@sealed
class Runner {
  final Map<Step<Object>, dynamic> _cache = {};
  final RunStepWrapper _wrapRunStep;

  /// Create a [Runner] instance with an empty cache.
  ///
  /// The optional [wrapRunStep] parameters allows specification of a function
  /// that will wrap the `runStep` methods provided in the [Step] definitons.
  /// This can be used to catch exceptions, run steps in a zone, measure
  /// execution time of a step (excluding dependencies), or simply log step
  /// execution as illustrated in the example below.
  ///
  /// ```dart
  /// // Define a step that return 'Hello World!'
  /// final helloWorldStep = Step.deps0('hello-world', () => 'Hello World!');
  ///
  /// /// Define a step that depends on helloWorldStep and prints its return
  /// /// value.
  /// final Step<void> printStep = Step.deps1(
  ///     'print-msg',
  ///     // Dependenices:
  ///     helloWorldStep, (
  ///   msg, // result of helloWorldStep will be passed in here.
  /// ) {
  ///   print(msg);
  /// });
  ///
  /// /// Implementation of [RunStepWrapper] that logs start and finish for
  /// /// each step.
  /// Future<T> wrapStepWithLogging<T>(
  ///   Step<T> step,
  ///   Future<T> Function() runStep,
  /// ) async {
  ///   print('Starting to run ${step.name}');
  ///   try {
  ///     return await runStep();
  ///   } finally {
  ///     print('Finishing running ${step.name}');
  ///   }
  /// }
  ///
  /// Future<void> main() async {
  ///   // This creates a Runner that will wrap calls to runStep with
  ///   // wrapStepWithLogging, hence, printing log entries for step execution.
  ///   final r = Runner(wrapRunStep: wrapStepWithLogging);
  ///   await r.run(printStep);
  /// }
  /// ```
  Runner({
    RunStepWrapper wrapRunStep = _defaultRunStep,
  }) : _wrapRunStep = wrapRunStep {
    ArgumentError.checkNotNull(wrapRunStep, 'runStep');
  }

  /// Override [step] with [value], ensuring that [step] evaluates to [value]
  /// when [run] is called in this [Runner].
  ///
  /// Overriding a [Step] is a useful technique for injecting input that steps
  /// depend on, as illstrated in the example below. It can also be useful for
  /// injecting mock objects or fakes when writing tests.
  ///
  /// Overriding a [step] after it has been evaluated or overriden once is not
  /// allowed.
  ///
  /// ## Example overriding a step to provide input
  /// ```dart
  /// /// A step that provides a message, this is a _virtual step_ because it
  /// /// doesn't have an implementation instead it throws an error. Hence, to
  /// /// evaluate a step that depends on [messageStep] it is necessary to
  /// /// override this step, by injecting a value to replace it.
  /// final Step<String> messageStep = Step.deps0(
  ///   'message',
  ///   () => throw UnimplementedError('message must be overriden with input'),
  /// );
  ///
  /// /// A step that provides date and time
  /// final dateTimeStep = Step.deps0('date-time', () => DateTime.now().toString());
  ///
  /// /// A step which has side effects.
  /// final Step<void> printStep = Step.deps2(
  ///     'print',
  ///     // Dependencies:
  ///     messageStep,
  ///     dateTimeStep, (
  ///   msg, // result from evaluation of messageStep
  ///   time, // result from evaluation of dateTimeStep
  /// ) {
  ///   print('$msg at $time');
  /// });
  ///
  /// Future<void> main() async {
  ///   final r = Runner();
  ///   // Override [messageStep] to provide an input value.
  ///   r.override(messageStep, 'hello world');
  ///   // Evaluate [printStep] which in turn evaluates [dateTimeStep], and re-uses
  ///   // the overridden value for [messageStep].
  ///   await r.run(printStep);
  /// }
  /// ```
  void override<T, S extends Step<T>>(S step, FutureOr<T> value) {
    ArgumentError.checkNotNull(step, 'step');

    if (_cache.containsKey(step)) {
      throw StateError('Value for $step is already cached');
    }
    _cache[step] = Future.value(value);
  }

  /// Evaluate [step] after evaluating dependencies or re-use cached values.
  ///
  /// This will return the value of [step] as cached in this [Runner], if [Step]
  /// has been evaluated or overridden. Otherwise, this wil evaluate the
  /// dependencies of [step], execute the step and cache the result.
  ///
  /// Call this method on a given instance of [Runner] with the same [step]
  /// will always produce the same result.
  ///
  /// ## Example evaluation of a step
  /// ```dart
  /// class MyComponent {
  ///   // ...
  /// }
  ///
  /// final Step<MyComponent> myStep =
  ///     Step.deps0('my-component', () => MyComponent());
  ///
  /// Future<void> main() async {
  ///   final r = Runner();
  ///   // Create a MyComponent instance using myStep
  ///   final myComponent1 = await r.run(myStep);
  ///   // Retrieve the previoysly cached result
  ///   final myComponent2 = await r.run(myStep);
  ///   // myComponent1 and myComponent2 will be the same instance.
  ///   // to create a new instance a new Runner must be used.
  ///   assert(myComponent1 == myComponent2);
  /// }
  /// ```
  Future<T> run<T>(Step<T> step) {
    ArgumentError.checkNotNull(step, 'step');

    return _cache.putIfAbsent(
      step,
      () => step._create(
        this,
        (fn) => _wrapRunStep(step, () => Future.value(fn())),
      ),
    );
  }
}

/// A [Step] is a function that may depend on the result of other steps.
///
/// A [Step] has a [name], a set of [directDependencies], a type [T], and an
/// internal function that given the result of all the dependencies can
/// compute a result of type [T].
///
/// On its own a [Step] cannot be evaluated. To execute a [Step] a [Runner]
/// must be used. A [Runner] caches the result of steps as they are evaluated.
/// Hence, within a given [Runner] instance a single [Step] instance is
/// evaluated at most once.
///
/// To evaluate a [Step] call [Runner.run] passing in the step. This will
/// evaluate dependencies (if results are not already cached), and evaluate
/// the step passed in.
///
/// Do not implement the [Step] interface, this class is sealed. Instances
/// should be created using the static methods [deps0], [deps1] through [depsN].
///
/// The [deps2] method allows creation of a [Step] with 2 dependencies. These
/// methods are enumerated to allow for type-safety. The method [depsN] allows
/// for creation of steps with arbitrary number of dependencies, but consuming
/// results of multiple types requires casting.
@sealed
class Step<T> {
  /// Name of the step.
  ///
  /// This is used to identify the step, typically for debugging, logging or
  /// other instrospection purposes, such as [toString].
  final String name;

  /// Direct dependencies of this step.
  ///
  /// This is the steps that this step depends on, directly. These steps may
  /// depend on other steps and so forth. However, as the set of dependencies
  /// must be specified when a [Step] is created, it is not possible for there
  /// to be any dependency cycles.
  final Iterable<Step<Object>> directDependencies;

  /// Internal method for creating an [T] given a [Runner] [r] that evaluate
  /// the [directDependencies].
  ///
  /// After [r] has been called to provide dependencies, the [wrap] function
  /// should wrap the actual user-provided method that generates the result.
  /// This allows [RunStepWrapper] to interscept exceptions, retry steps, log
  /// step execution, record step execution time, etc.
  ///
  /// This method is intentionally private, and should only be called from
  /// [Runner.run].
  final Future<T> Function(
    Runner r,
    Future<T> Function(FutureOr<T> Function()) wrap,
  ) _create;

  @override
  String toString() => 'Step[$name]';

  Step._(this.name, this._create, List<Step<Object>> dependencies)
      : directDependencies = UnmodifiableListView(dependencies);

  /// Create a [Step] with zero dependencies, given [name] and [runStep]
  /// function.
  ///
  /// When the step is passed to [Runner.run] the [runStep] function will be
  /// called unless the result of the [Step] is already cached, in the given
  /// [Runner].
  ///
  /// ## Example without dependencies
  /// ```dart
  /// // Define a step that return 'Hello World!'
  /// final Step<String> helloWorldStep = Step.deps0(
  ///   // Name of the step:
  ///   'hello-world-step',
  ///   // Function that given zero dependencies creates the result of the step:
  ///   () async {
  ///     return 'Hello World!';
  ///   },
  /// );
  ///
  /// /// Run the helloWorldStep step.
  /// Future<void> main() async {
  ///   final r = Runner();
  ///   final msg = await r.run(helloWorldStep);
  ///   print(msg);
  /// }
  /// ```
  static Step<T> deps0<T>(
    String name,
    FutureOr<T> Function() runStep,
  ) =>
      Step._(name, (r, wrap) async {
        return await wrap(() => runStep());
      }, []);

  /// Create a [Step] with one dependency, given [name] and [runStep]
  /// function.
  ///
  /// ## Example with one dependency
  /// ```dart
  /// // Define a step that return 'Hello World!'
  /// final helloWorldStep = Step.deps0('hello-world', () => 'Hello World!');
  ///
  /// /// Define a step that depends on helloWorldStep and prints its return
  /// /// value.
  /// final Step<void> printStep = Step.deps1(
  ///     'print-msg',
  ///     // Dependenices:
  ///     helloWorldStep, (
  ///   msg, // result of helloWorldStep will be passed in here.
  /// ) {
  ///   print(msg);
  /// });
  ///
  /// /// Run the printStep step.
  /// Future<void> main() async {
  ///   final r = Runner();
  ///   await r.run(printStep);
  ///   print(msg);
  /// }
  /// ```
  static Step<T> deps1<T, A>(
    String name,
    Step<A> a,
    FutureOr<T> Function(A) runStep,
  ) =>
      Step._(name, (r, wrap) async {
        final a_ = r.run(a);
        await Future.wait([a_]);
        final _a = await a_;
        return await wrap(() => runStep(_a));
      }, [a]);

  /// Create a [Step] with two dependencies, given [name] and [runStep]
  /// function.
  ///
  /// ## Example with two dependencies
  /// ```dart
  /// final helloWorldStep = Step.deps0('hello-world', () => 'Hello World!');
  /// final dateTimeStep = Step.deps0(
  ///   'date-time',
  ///   () => DateTime.now().toString(),
  /// );
  ///
  /// final Step<String> helloWorldAt = Step.deps2(
  ///     'hello-at',
  ///     // Dependencies:
  ///     helloWorldStep,
  ///     dateTimeStep, (
  ///   msg,
  ///   time,
  /// ) async {
  ///   return '$msg at $time';
  /// });
  /// ```
  static Step<T> deps2<T, A, B>(
    String name,
    Step<A> a,
    Step<B> b,
    FutureOr<T> Function(A, B) runStep,
  ) =>
      Step._(name, (r, wrap) async {
        final a_ = r.run(a);
        final b_ = r.run(b);
        await Future.wait([a_, b_]);
        final _a = await a_;
        final _b = await b_;
        return await wrap(() => runStep(_a, _b));
      }, [a, b]);

  /// Create a [Step] with 3 dependencies, given [name] and [runStep]
  /// function.
  ///
  /// See [deps2] for an example.
  static Step<T> deps3<T, A, B, C>(
    String name,
    Step<A> a,
    Step<B> b,
    Step<C> c,
    FutureOr<T> Function(A, B, C) runStep,
  ) =>
      Step._(name, (r, wrap) async {
        final a_ = r.run(a);
        final b_ = r.run(b);
        final c_ = r.run(c);
        await Future.wait([a_, b_, c_]);
        final _a = await a_;
        final _b = await b_;
        final _c = await c_;
        return await wrap(() => runStep(_a, _b, _c));
      }, [a, b, c]);

  /// Create a [Step] with 4 dependencies, given [name] and [runStep]
  /// function.
  ///
  /// See [deps2] for an example.
  static Step<T> deps4<T, A, B, C, D>(
    String name,
    Step<A> a,
    Step<B> b,
    Step<C> c,
    Step<D> d,
    FutureOr<T> Function(A, B, C, D) runStep,
  ) =>
      Step._(name, (r, wrap) async {
        final a_ = r.run(a);
        final b_ = r.run(b);
        final c_ = r.run(c);
        final d_ = r.run(d);
        await Future.wait([a_, b_, c_, d_]);
        final _a = await a_;
        final _b = await b_;
        final _c = await c_;
        final _d = await d_;
        return await wrap(() => runStep(_a, _b, _c, _d));
      }, [a, b, c, d]);

  /// Create a [Step] with 5 dependencies, given [name] and [runStep]
  /// function.
  ///
  /// See [deps2] for an example.
  static Step<T> deps5<T, A, B, C, D, E>(
    String name,
    Step<A> a,
    Step<B> b,
    Step<C> c,
    Step<D> d,
    Step<E> e,
    FutureOr<T> Function(A, B, C, D, E) runStep,
  ) =>
      Step._(name, (r, wrap) async {
        final a_ = r.run(a);
        final b_ = r.run(b);
        final c_ = r.run(c);
        final d_ = r.run(d);
        final e_ = r.run(e);
        await Future.wait([a_, b_, c_, d_, e_]);
        final _a = await a_;
        final _b = await b_;
        final _c = await c_;
        final _d = await d_;
        final _e = await e_;
        return await wrap(() => runStep(_a, _b, _c, _d, _e));
      }, [a, b, c, d, e]);

  /// Create a [Step] with 6 dependencies, given [name] and [runStep]
  /// function.
  ///
  /// See [deps2] for an example.
  static Step<T> deps6<T, A, B, C, D, E, F>(
    String name,
    Step<A> a,
    Step<B> b,
    Step<C> c,
    Step<D> d,
    Step<E> e,
    Step<F> f,
    FutureOr<T> Function(A, B, C, D, E, F) runStep,
  ) =>
      Step._(name, (r, wrap) async {
        final a_ = r.run(a);
        final b_ = r.run(b);
        final c_ = r.run(c);
        final d_ = r.run(d);
        final e_ = r.run(e);
        final f_ = r.run(f);
        await Future.wait([a_, b_, c_, d_, e_, f_]);
        final _a = await a_;
        final _b = await b_;
        final _c = await c_;
        final _d = await d_;
        final _e = await e_;
        final _f = await f_;
        return await wrap(() => runStep(_a, _b, _c, _d, _e, _f));
      }, [a, b, c, d, e, f]);

  /// Create a [Step] with 7 dependencies, given [name] and [runStep]
  /// function.
  ///
  /// See [deps2] for an example.
  static Step<T> deps7<T, A, B, C, D, E, F, G>(
    String name,
    Step<A> a,
    Step<B> b,
    Step<C> c,
    Step<D> d,
    Step<E> e,
    Step<F> f,
    Step<G> g,
    FutureOr<T> Function(A, B, C, D, E, F, G) runStep,
  ) =>
      Step._(name, (r, wrap) async {
        final a_ = r.run(a);
        final b_ = r.run(b);
        final c_ = r.run(c);
        final d_ = r.run(d);
        final e_ = r.run(e);
        final f_ = r.run(f);
        final g_ = r.run(g);
        await Future.wait([a_, b_, c_, d_, e_, f_, g_]);
        final _a = await a_;
        final _b = await b_;
        final _c = await c_;
        final _d = await d_;
        final _e = await e_;
        final _f = await f_;
        final _g = await g_;
        return await wrap(() => runStep(_a, _b, _c, _d, _e, _f, _g));
      }, [a, b, c, d, e, f, g]);

  /// Create a [Step] with 8 dependencies, given [name] and [runStep]
  /// function.
  ///
  /// See [deps2] for an example.
  static Step<T> deps8<T, A, B, C, D, E, F, G, H>(
    String name,
    Step<A> a,
    Step<B> b,
    Step<C> c,
    Step<D> d,
    Step<E> e,
    Step<F> f,
    Step<G> g,
    Step<H> h,
    FutureOr<T> Function(A, B, C, D, E, F, G, H) runStep,
  ) =>
      Step._(name, (r, wrap) async {
        final a_ = r.run(a);
        final b_ = r.run(b);
        final c_ = r.run(c);
        final d_ = r.run(d);
        final e_ = r.run(e);
        final f_ = r.run(f);
        final g_ = r.run(g);
        final h_ = r.run(h);
        await Future.wait([a_, b_, c_, d_, e_, f_, g_, h_]);
        final _a = await a_;
        final _b = await b_;
        final _c = await c_;
        final _d = await d_;
        final _e = await e_;
        final _f = await f_;
        final _g = await g_;
        final _h = await h_;
        return await wrap(() => runStep(_a, _b, _c, _d, _e, _f, _g, _h));
      }, [a, b, c, d, e, f, g, h]);

  /// Create a [Step] with 9 dependencies, given [name] and [runStep]
  /// function.
  ///
  /// See [deps2] for an example.
  static Step<T> deps9<T, A, B, C, D, E, F, G, H, I>(
    String name,
    Step<A> a,
    Step<B> b,
    Step<C> c,
    Step<D> d,
    Step<E> e,
    Step<F> f,
    Step<G> g,
    Step<H> h,
    Step<I> i,
    FutureOr<T> Function(A, B, C, D, E, F, G, H, I) runStep,
  ) =>
      Step._(name, (r, wrap) async {
        final a_ = r.run(a);
        final b_ = r.run(b);
        final c_ = r.run(c);
        final d_ = r.run(d);
        final e_ = r.run(e);
        final f_ = r.run(f);
        final g_ = r.run(g);
        final h_ = r.run(h);
        final i_ = r.run(i);
        await Future.wait([a_, b_, c_, d_, e_, f_, g_, h_, i_]);
        final _a = await a_;
        final _b = await b_;
        final _c = await c_;
        final _d = await d_;
        final _e = await e_;
        final _f = await f_;
        final _g = await g_;
        final _h = await h_;
        final _i = await i_;
        return await wrap(() => runStep(_a, _b, _c, _d, _e, _f, _g, _h, _i));
      }, [a, b, c, d, e, f, g, h, i]);

  /// Create a [Step] with any number of [dependencies], given [name] and
  /// [runStep] function.
  ///
  /// Unlike the [deps0] through [deps9] methods, this method allows a variable
  /// number of dependencies. However, the number of dependencies must be fixed
  /// when the step is created.
  ///
  /// When evaluated the [runStep] function will be called with the result of
  /// each of the [dependencies] in the same order as the [dependenices] are
  /// given.
  ///
  /// While all [Step] entries in the dependencies are required to be `Step<S>`,
  /// it is possible to depend on steps of different types. Simply pass a
  /// `List<Step<dynamic>>` as [dependencies] and cast the results as needed.
  ///
  /// ## Example with N dependencies
  /// ```dart
  /// final helloWorldStep = Step.deps0('hello-world', () => 'Hello World!');
  /// final dateTimeStep = Step.deps0(
  ///   'date-time',
  ///   () => DateTime.now().toString(),
  /// );
  ///
  /// final Step<String> helloWorldAt = Step.depsN('hello-at', [
  ///   helloWorldStep,
  ///   dateTimeStep,
  /// ], (
  ///   results,
  /// ) async {
  ///   final msg = results[0] as String; // Output from helloWorldStep
  ///   final time = results[1] as String; // Output from dateTimeStep
  ///   return '$msg at $time';
  /// });
  /// ```
  static Step<T> depsN<T, S>(
    String name,
    Iterable<Step<S>> dependencies,
    FutureOr<T> Function(List<S>) runStep,
  ) =>
      Step._(name, (r, wrap) async {
        final values = await Future.wait(dependencies.map(r.run));
        return await wrap(() => runStep(values));
      }, [...dependencies]);
}
