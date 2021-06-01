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

import 'dart:async' show FutureOr;

import 'dart:collection' show UnmodifiableListView;
import 'package:meta/meta.dart' show sealed;

Future<T> _defaultRunStep<T>(Step<T> step, Future<T> Function() fn) => fn();

/// A [RunStepWrapper] is a function that can wrap the [runStep] function.
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
  final Map<Step<Object?>, dynamic> _cache = {};
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
  /// /// Define a step that return 'Hello World!'
  /// final helloWorldStep = Step.define('hello-world').build(() => 'Hello World!');
  ///
  /// /// Define a step that depends on helloWorldStep and prints its return
  /// /// value.
  /// final Step<void> printStep = Step.define('print-msg')
  ///     // Declare dependency on helloWorldStep
  ///     .dep(helloWorldStep)
  ///     // Build step, result from helloWorldStep will be passed in as `msg`
  ///     .build((msg) {
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
  }) : _wrapRunStep = wrapRunStep;

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
  /// final Step<String> messageStep = Step.define('message').build(
  ///   () => throw UnimplementedError('message must be overriden with input'),
  /// );
  ///
  /// /// A step that provides date and time
  /// final dateTimeStep =
  ///     Step.define('date-time').build(() => DateTime.now().toString());
  ///
  /// /// A step which has side effects.
  /// final Step<void> printStep = Step.define('print')
  ///     // Dependencies:
  ///     .dep(messageStep)
  ///     .dep(dateTimeStep)
  ///     .build((
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
  ///     Step.define('my-component').build(() => MyComponent());
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
  Future<T> run<T>(Step<T> step) => _cache.putIfAbsent(
        step,
        () => step._create(
          this,
          (fn) => _wrapRunStep(step, () => Future.value(fn())),
        ),
      );
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
/// should be created using the static method [define] which returns a
/// [StepBuilder] that can be used to build a step without dependencies or
/// create a [StepBuilder1] which can build a step with 1 dependency, or create
/// a [StepBuilder2] which can build a step with 2 dependencies, or create
/// [StepBuilder3] an so forth until [StepBuilder9] which holds 9 dependencies.
///
/// If more than 9 dependencies is needed, then [StepBuilder.deps] can be used
/// to create a [StepBuilderN] which takes `N` dependencies. This allows an
/// arbitrary number of dependencies, but consuming the result may require type
/// casting.
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
  final Iterable<Step<Object?>> directDependencies;

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

  Step._(this.name, this._create, List<Step<Object?>> dependencies)
      : directDependencies = UnmodifiableListView(dependencies);

  /// Define a [Step] using a [StepBuilder].
  ///
  /// This method returns a _builder_ which has two methods `dep` and `build`.
  /// Calling `builder.dep(stepA)` adds a dependency on `stepA` and returns
  /// a new builder. Calling `builder.build(runStep)` creates a [Step<T>] if
  /// `runStep` is a function that returns `T` and takes the result value
  /// from dependent steps.
  ///
  /// As adding new dependenices with `builder.dep` changes the number of
  /// arguments for the `runStep` method required by the `builder.build` method,
  /// the type of the _builder_ will be [StepBuilder], [StepBuilder1] through
  /// [StepBuilder9] depending on the number of dependenices. The `StepBuilder`
  /// types have the same interface, except the [StepBuilder] and
  /// [StepBuilder9] which offers a `builder.deps(Iterable<Step<S>> steps)`
  /// method that allows for an arbitrary number of dependencies. This useful if
  /// all the dependent steps have the same type, or if a step has more than 9
  /// dependencies.
  ///
  /// ### Example
  /// ```dart
  /// // Define a step without dependencies
  /// final Step<Router> routerStep = Step.define('router').build(() {
  ///   return Router(/* setup request router */);
  /// });
  ///
  /// // Define a step without dependencies
  /// final Step<Database> databaseStep = Step.define('database').build(() {
  ///   return Database(/* setup database connection and schema */);
  /// });
  ///
  /// // Define a step with two dependencies
  /// final Step<Server> server = Step.define('server')
  ///     .dep(routerStep)
  ///     .dep(databaseStep)
  ///     .build((router, router) async {
  ///   // Setup Server using router and database
  /// });
  /// ```
  static StepBuilder define(String name) => StepBuilder._(name);
}

/// Builder for creating a [Step].
///
/// This type is only intended to be used an intermediate result in an
/// expression defining a step. See [Step.define] for how to define steps.
@sealed
class StepBuilder {
  final String _name;

  StepBuilder._(this._name);

  /// Add dependency on [stepA] and return a new _builder_ from which to
  /// continue (building the final step).
  ///
  /// This methods returns a new builder to be used as an intermediate result in
  /// the expression defining a step. See [Step.define] for how to define steps.
  StepBuilder1<A> dep<A>(Step<A> stepA) {
    return StepBuilder1._(_name, stepA);
  }

  /// Add dependency on an arbitrary number of steps [dependencies] and return
  /// a new _builder_ from which to continue (building the final step).
  ///
  /// This methods returns a new builder to be used as an intermediate result in
  /// the expression defining a step. See [Step.define] for how to define steps.
  StepBuilderN<S> deps<S>(Iterable<Step<S>> dependencies) {
    final dependencies_ = List<Step<S>>.from(dependencies);
    return StepBuilderN._(_name, dependencies_);
  }

  /// Build a step without dependencies.
  ///
  /// This methods requires a [runStep] function which runs the step. The
  /// [runStep] method may be asynchronous. The [runStep] method will be invoked
  /// by `Runner.run` when the step is evaluated.
  ///
  /// This method returns the [Step] built by the builder, see [Step.define] for
  /// how to define steps using this API.
  Step<T> build<T>(FutureOr<T> Function() runStep) {
    return Step._(_name, (r, wrap) async {
      return await wrap(() => runStep());
    }, []);
  }
}

/// Builder for creating a [Step].
///
/// This type is only intended to be used an intermediate result in an
/// expression defining a step. See [Step.define] for how to define steps.
@sealed
class StepBuilderN<S> {
  final String _name;
  final List<Step<S>> _dependencies;

  StepBuilderN._(this._name, this._dependencies);

  /// Build a step with a single dependency.
  ///
  /// This methods requires a [runStep] function which runs the step, given
  /// values from evaluation of dependent steps. The [runStep] method may be
  /// asynchronous. The [runStep] method will be invoked by `Runner.run` when
  /// the step is evaluated.
  ///
  /// The dependent steps which creates `values` passed to [runStep] have
  /// already be defined when this object was created. See [Step.define] for
  /// how to define steps using this API.
  ///
  /// This method returns the [Step] built by the builder.
  Step<T> build<T>(FutureOr<T> Function(List<S> values) runStep) =>
      Step._(_name, (r, wrap) async {
        final values = await Future.wait(_dependencies.map(r.run));
        return await wrap(() => runStep(values));
      }, [..._dependencies]);
}

/// Builder for creating a [Step].
///
/// This type is only intended to be used an intermediate result in an
/// expression defining a step. See [Step.define] for how to define steps.
@sealed
class StepBuilder1<A> {
  final String _name;
  final Step<A> _a;

  StepBuilder1._(this._name, this._a);

  /// Add dependency on [stepB] and return a new _builder_ from which to
  /// continue (building the final step).
  ///
  /// This methods returns a new builder to be used as an intermediate result in
  /// the expression defining a step. See [Step.define] for how to define steps.
  StepBuilder2<A, B> dep<B>(Step<B> stepB) {
    return StepBuilder2._(_name, _a, stepB);
  }

  /// Build a step with a single dependency.
  ///
  /// This methods requires a [runStep] function which runs the step, given
  /// values from evaluation of dependent steps. The [runStep] method may be
  /// asynchronous. The [runStep] method will be invoked by `Runner.run` when
  /// the step is evaluated.
  ///
  /// The dependent [Step] which creates `valueA` passed to [runStep] have
  /// already be defined when this object was created. See [Step.define] for
  /// how to define steps using this API.
  ///
  /// This method returns the [Step] built by the builder.
  Step<T> build<T>(FutureOr<T> Function(A valueA) runStep) =>
      Step._(_name, (r, wrap) async {
        final a_ = r.run(_a);
        await Future.wait([a_]);
        final a = await a_;
        return await wrap(() => runStep(a));
      }, [_a]);
}

/// Builder for creating a [Step].
///
/// This type is only intended to be used an intermediate result in an
/// expression defining a step. See [Step.define] for how to define steps.
@sealed
class StepBuilder2<A, B> {
  final String _name;
  final Step<A> _a;
  final Step<B> _b;

  StepBuilder2._(this._name, this._a, this._b);

  /// Add dependency on [stepC] and return a new _builder_ from which to
  /// continue (building the final step).
  ///
  /// This methods returns a new builder to be used as an intermediate result in
  /// the expression defining a step. See [Step.define] for how to define steps.
  StepBuilder3<A, B, C> dep<C>(Step<C> stepC) {
    return StepBuilder3._(_name, _a, _b, stepC);
  }

  /// Build a step with a single dependency.
  ///
  /// This methods requires a [runStep] function which runs the step, given
  /// values from evaluation of dependent steps. The [runStep] method may be
  /// asynchronous. The [runStep] method will be invoked by `Runner.run` when
  /// the step is evaluated.
  ///
  /// The dependent steps which creates `valueA` and `valueB` passed to
  /// [runStep] have already be defined when this object was created.
  /// See [Step.define] for how to define steps using this API.
  ///
  /// This method returns the [Step] built by the builder.
  Step<T> build<T>(FutureOr<T> Function(A valueA, B valueB) runStep) =>
      Step._(_name, (r, wrap) async {
        final a_ = r.run(_a);
        final b_ = r.run(_b);
        await Future.wait([a_, b_]);
        final a = await a_;
        final b = await b_;
        return await wrap(() => runStep(a, b));
      }, [_a, _b]);
}

/// Builder for creating a [Step].
///
/// This type is only intended to be used an intermediate result in an
/// expression defining a step. See [Step.define] for how to define steps.
@sealed
class StepBuilder3<A, B, C> {
  final String _name;
  final Step<A> _a;
  final Step<B> _b;
  final Step<C> _c;

  StepBuilder3._(
    this._name,
    this._a,
    this._b,
    this._c,
  );

  /// Add dependency on [stepD] and return a new _builder_ from which to
  /// continue (building the final step).
  ///
  /// This methods returns a new builder to be used as an intermediate result in
  /// the expression defining a step. See [Step.define] for how to define steps.
  StepBuilder4<A, B, C, D> dep<D>(Step<D> stepD) {
    return StepBuilder4._(_name, _a, _b, _c, stepD);
  }

  /// Build a step with a single dependency.
  ///
  /// This methods requires a [runStep] function which runs the step, given
  /// values from evaluation of dependent steps. The [runStep] method may be
  /// asynchronous. The [runStep] method will be invoked by `Runner.run` when
  /// the step is evaluated.
  ///
  /// The dependent steps which creates `valueA`, `valueB`, ..., passed to
  /// [runStep] have already be defined when this object was created.
  /// See [Step.define] for how to define steps using this API.
  ///
  /// This method returns the [Step] built by the builder.
  Step<T> build<T>(
    FutureOr<T> Function(
      A valueA,
      B valueB,
      C valueC,
    )
        runStep,
  ) {
    return Step._(_name, (r, wrap) async {
      final a_ = r.run(_a);
      final b_ = r.run(_b);
      final c_ = r.run(_c);
      await Future.wait([a_, b_, c_]);
      final a = await a_;
      final b = await b_;
      final c = await c_;
      return await wrap(() => runStep(a, b, c));
    }, [_a, _b, _c]);
  }
}

/// Builder for creating a [Step].
///
/// This type is only intended to be used an intermediate result in an
/// expression defining a step. See [Step.define] for how to define steps.
@sealed
class StepBuilder4<A, B, C, D> {
  final String _name;
  final Step<A> _a;
  final Step<B> _b;
  final Step<C> _c;
  final Step<D> _d;

  StepBuilder4._(
    this._name,
    this._a,
    this._b,
    this._c,
    this._d,
  );

  /// Add dependency on [stepE] and return a new _builder_ from which to
  /// continue (building the final step).
  ///
  /// This methods returns a new builder to be used as an intermediate result in
  /// the expression defining a step. See [Step.define] for how to define steps.
  StepBuilder5<A, B, C, D, E> dep<E>(Step<E> stepE) {
    return StepBuilder5._(_name, _a, _b, _c, _d, stepE);
  }

  /// Build a step with a single dependency.
  ///
  /// This methods requires a [runStep] function which runs the step, given
  /// values from evaluation of dependent steps. The [runStep] method may be
  /// asynchronous. The [runStep] method will be invoked by `Runner.run` when
  /// the step is evaluated.
  ///
  /// The dependent steps which creates `valueA`, `valueB`, ..., passed to
  /// [runStep] have already be defined when this object was created.
  /// See [Step.define] for how to define steps using this API.
  ///
  /// This method returns the [Step] built by the builder.
  Step<T> build<T>(
    FutureOr<T> Function(
      A valueA,
      B valueB,
      C valueC,
      D valueD,
    )
        runStep,
  ) {
    return Step._(_name, (r, wrap) async {
      final a_ = r.run(_a);
      final b_ = r.run(_b);
      final c_ = r.run(_c);
      final d_ = r.run(_d);
      await Future.wait([a_, b_, c_, d_]);
      final a = await a_;
      final b = await b_;
      final c = await c_;
      final d = await d_;
      return await wrap(() => runStep(a, b, c, d));
    }, [_a, _b, _c, _d]);
  }
}

/// Builder for creating a [Step].
///
/// This type is only intended to be used an intermediate result in an
/// expression defining a step. See [Step.define] for how to define steps.
@sealed
class StepBuilder5<A, B, C, D, E> {
  final String _name;
  final Step<A> _a;
  final Step<B> _b;
  final Step<C> _c;
  final Step<D> _d;
  final Step<E> _e;

  StepBuilder5._(
    this._name,
    this._a,
    this._b,
    this._c,
    this._d,
    this._e,
  );

  /// Add dependency on [stepF] and return a new _builder_ from which to
  /// continue (building the final step).
  ///
  /// This methods returns a new builder to be used as an intermediate result in
  /// the expression defining a step. See [Step.define] for how to define steps.
  StepBuilder6<A, B, C, D, E, F> dep<F>(Step<F> stepF) {
    return StepBuilder6._(_name, _a, _b, _c, _d, _e, stepF);
  }

  /// Build a step with a single dependency.
  ///
  /// This methods requires a [runStep] function which runs the step, given
  /// values from evaluation of dependent steps. The [runStep] method may be
  /// asynchronous. The [runStep] method will be invoked by `Runner.run` when
  /// the step is evaluated.
  ///
  /// The dependent steps which creates `valueA`, `valueB`, ..., passed to
  /// [runStep] have already be defined when this object was created.
  /// See [Step.define] for how to define steps using this API.
  ///
  /// This method returns the [Step] built by the builder.
  Step<T> build<T>(
    FutureOr<T> Function(
      A valueA,
      B valueB,
      C valueC,
      D valueD,
      E valueE,
    )
        runStep,
  ) {
    return Step._(_name, (r, wrap) async {
      final a_ = r.run(_a);
      final b_ = r.run(_b);
      final c_ = r.run(_c);
      final d_ = r.run(_d);
      final e_ = r.run(_e);
      await Future.wait([a_, b_, c_, d_, e_]);
      final a = await a_;
      final b = await b_;
      final c = await c_;
      final d = await d_;
      final e = await e_;
      return await wrap(() => runStep(a, b, c, d, e));
    }, [_a, _b, _c, _d, _e]);
  }
}

/// Builder for creating a [Step].
///
/// This type is only intended to be used an intermediate result in an
/// expression defining a step. See [Step.define] for how to define steps.
@sealed
class StepBuilder6<A, B, C, D, E, F> {
  final String _name;
  final Step<A> _a;
  final Step<B> _b;
  final Step<C> _c;
  final Step<D> _d;
  final Step<E> _e;
  final Step<F> _f;

  StepBuilder6._(
    this._name,
    this._a,
    this._b,
    this._c,
    this._d,
    this._e,
    this._f,
  );

  /// Add dependency on [stepG] and return a new _builder_ from which to
  /// continue (building the final step).
  ///
  /// This methods returns a new builder to be used as an intermediate result in
  /// the expression defining a step. See [Step.define] for how to define steps.
  StepBuilder7<A, B, C, D, E, F, G> dep<G>(Step<G> stepG) {
    return StepBuilder7._(_name, _a, _b, _c, _d, _e, _f, stepG);
  }

  /// Build a step with a single dependency.
  ///
  /// This methods requires a [runStep] function which runs the step, given
  /// values from evaluation of dependent steps. The [runStep] method may be
  /// asynchronous. The [runStep] method will be invoked by `Runner.run` when
  /// the step is evaluated.
  ///
  /// The dependent steps which creates `valueA`, `valueB`, ..., passed to
  /// [runStep] have already be defined when this object was created.
  /// See [Step.define] for how to define steps using this API.
  ///
  /// This method returns the [Step] built by the builder.
  Step<T> build<T>(
    FutureOr<T> Function(
      A valueA,
      B valueB,
      C valueC,
      D valueD,
      E valueE,
      F valueF,
    )
        runStep,
  ) {
    return Step._(_name, (r, wrap) async {
      final a_ = r.run(_a);
      final b_ = r.run(_b);
      final c_ = r.run(_c);
      final d_ = r.run(_d);
      final e_ = r.run(_e);
      final f_ = r.run(_f);
      await Future.wait([a_, b_, c_, d_, e_, f_]);
      final a = await a_;
      final b = await b_;
      final c = await c_;
      final d = await d_;
      final e = await e_;
      final f = await f_;
      return await wrap(() => runStep(a, b, c, d, e, f));
    }, [_a, _b, _c, _d, _e, _f]);
  }
}

/// Builder for creating a [Step].
///
/// This type is only intended to be used an intermediate result in an
/// expression defining a step. See [Step.define] for how to define steps.
@sealed
class StepBuilder7<A, B, C, D, E, F, G> {
  final String _name;
  final Step<A> _a;
  final Step<B> _b;
  final Step<C> _c;
  final Step<D> _d;
  final Step<E> _e;
  final Step<F> _f;
  final Step<G> _g;

  StepBuilder7._(
    this._name,
    this._a,
    this._b,
    this._c,
    this._d,
    this._e,
    this._f,
    this._g,
  );

  /// Add dependency on [stepH] and return a new _builder_ from which to
  /// continue (building the final step).
  ///
  /// This methods returns a new builder to be used as an intermediate result in
  /// the expression defining a step. See [Step.define] for how to define steps.
  StepBuilder8<A, B, C, D, E, F, G, H> dep<H>(Step<H> stepH) {
    return StepBuilder8._(_name, _a, _b, _c, _d, _e, _f, _g, stepH);
  }

  /// Build a step with a single dependency.
  ///
  /// This methods requires a [runStep] function which runs the step, given
  /// values from evaluation of dependent steps. The [runStep] method may be
  /// asynchronous. The [runStep] method will be invoked by `Runner.run` when
  /// the step is evaluated.
  ///
  /// The dependent steps which creates `valueA`, `valueB`, ..., passed to
  /// [runStep] have already be defined when this object was created.
  /// See [Step.define] for how to define steps using this API.
  ///
  /// This method returns the [Step] built by the builder.
  Step<T> build<T>(
    FutureOr<T> Function(
      A valueA,
      B valueB,
      C valueC,
      D valueD,
      E valueE,
      F valueF,
      G valueG,
    )
        runStep,
  ) {
    return Step._(_name, (r, wrap) async {
      final a_ = r.run(_a);
      final b_ = r.run(_b);
      final c_ = r.run(_c);
      final d_ = r.run(_d);
      final e_ = r.run(_e);
      final f_ = r.run(_f);
      final g_ = r.run(_g);
      await Future.wait([a_, b_, c_, d_, e_, f_, g_]);
      final a = await a_;
      final b = await b_;
      final c = await c_;
      final d = await d_;
      final e = await e_;
      final f = await f_;
      final g = await g_;
      return await wrap(() => runStep(a, b, c, d, e, f, g));
    }, [_a, _b, _c, _d, _e, _f, _g]);
  }
}

/// Builder for creating a [Step].
///
/// This type is only intended to be used an intermediate result in an
/// expression defining a step. See [Step.define] for how to define steps.
@sealed
class StepBuilder8<A, B, C, D, E, F, G, H> {
  final String _name;
  final Step<A> _a;
  final Step<B> _b;
  final Step<C> _c;
  final Step<D> _d;
  final Step<E> _e;
  final Step<F> _f;
  final Step<G> _g;
  final Step<H> _h;

  StepBuilder8._(
    this._name,
    this._a,
    this._b,
    this._c,
    this._d,
    this._e,
    this._f,
    this._g,
    this._h,
  );

  /// Add dependency on [stepI] and return a new _builder_ from which to
  /// continue (building the final step).
  ///
  /// This methods returns a new builder to be used as an intermediate result in
  /// the expression defining a step. See [Step.define] for how to define steps.
  StepBuilder9<A, B, C, D, E, F, G, H, I> dep<I>(Step<I> stepI) {
    return StepBuilder9._(_name, _a, _b, _c, _d, _e, _f, _g, _h, stepI);
  }

  /// Build a step with a single dependency.
  ///
  /// This methods requires a [runStep] function which runs the step, given
  /// values from evaluation of dependent steps. The [runStep] method may be
  /// asynchronous. The [runStep] method will be invoked by `Runner.run` when
  /// the step is evaluated.
  ///
  /// The dependent steps which creates `valueA`, `valueB`, ..., passed to
  /// [runStep] have already be defined when this object was created.
  /// See [Step.define] for how to define steps using this API.
  ///
  /// This method returns the [Step] built by the builder.
  Step<T> build<T>(
    FutureOr<T> Function(
      A valueA,
      B valueB,
      C valueC,
      D valueD,
      E valueE,
      F valueF,
      G valueG,
      H valueH,
    )
        runStep,
  ) {
    return Step._(_name, (r, wrap) async {
      final a_ = r.run(_a);
      final b_ = r.run(_b);
      final c_ = r.run(_c);
      final d_ = r.run(_d);
      final e_ = r.run(_e);
      final f_ = r.run(_f);
      final g_ = r.run(_g);
      final h_ = r.run(_h);
      await Future.wait([a_, b_, c_, d_, e_, f_, g_, h_]);
      final a = await a_;
      final b = await b_;
      final c = await c_;
      final d = await d_;
      final e = await e_;
      final f = await f_;
      final g = await g_;
      final h = await h_;
      return await wrap(() => runStep(a, b, c, d, e, f, g, h));
    }, [_a, _b, _c, _d, _e, _f, _g, _h]);
  }
}

/// Builder for creating a [Step].
///
/// This type is only intended to be used an intermediate result in an
/// expression defining a step. See [Step.define] for how to define steps.
@sealed
class StepBuilder9<A, B, C, D, E, F, G, H, I> {
  final String _name;
  final Step<A> _a;
  final Step<B> _b;
  final Step<C> _c;
  final Step<D> _d;
  final Step<E> _e;
  final Step<F> _f;
  final Step<G> _g;
  final Step<H> _h;
  final Step<I> _i;

  StepBuilder9._(
    this._name,
    this._a,
    this._b,
    this._c,
    this._d,
    this._e,
    this._f,
    this._g,
    this._h,
    this._i,
  );

  /// Add dependency on an arbitrary number of steps [deps] and return
  /// a new _builder_ from which to continue (building the final step).
  ///
  /// This methods returns a new builder to be used as an intermediate result in
  /// the expression defining a step. See [Step.define] for how to define steps.
  StepBuilder9N<A, B, C, D, E, F, G, H, I, S> deps<S>(Iterable<Step<S>> deps) {
    ArgumentError.checkNotNull(deps, 'deps');
    final _deps = List<Step<S>>.from(deps);
    return StepBuilder9N._(_name, _a, _b, _c, _d, _e, _f, _g, _h, _i, _deps);
  }

  /// Build a step with a single dependency.
  ///
  /// This methods requires a [runStep] function which runs the step, given
  /// values from evaluation of dependent steps. The [runStep] method may be
  /// asynchronous. The [runStep] method will be invoked by `Runner.run` when
  /// the step is evaluated.
  ///
  /// The dependent steps which creates `valueA`, `valueB`, ..., passed to
  /// [runStep] have already be defined when this object was created.
  /// See [Step.define] for how to define steps using this API.
  ///
  /// This method returns the [Step] built by the builder.
  Step<T> build<T>(
    FutureOr<T> Function(
      A valueA,
      B valueB,
      C valueC,
      D valueD,
      E valueE,
      F valueF,
      G valueG,
      H valueH,
      I valueI,
    )
        runStep,
  ) {
    return Step._(_name, (r, wrap) async {
      final a_ = r.run(_a);
      final b_ = r.run(_b);
      final c_ = r.run(_c);
      final d_ = r.run(_d);
      final e_ = r.run(_e);
      final f_ = r.run(_f);
      final g_ = r.run(_g);
      final h_ = r.run(_h);
      final i_ = r.run(_i);
      await Future.wait([a_, b_, c_, d_, e_, f_, g_, h_, i_]);
      final a = await a_;
      final b = await b_;
      final c = await c_;
      final d = await d_;
      final e = await e_;
      final f = await f_;
      final g = await g_;
      final h = await h_;
      final i = await i_;
      return await wrap(() => runStep(a, b, c, d, e, f, g, h, i));
    }, [_a, _b, _c, _d, _e, _f, _g, _h, _i]);
  }
}

/// Builder for creating a [Step].
///
/// This type is only intended to be used an intermediate result in an
/// expression defining a step. See [Step.define] for how to define steps.
@sealed
class StepBuilder9N<A, B, C, D, E, F, G, H, I, S> {
  final String _name;
  final Step<A> _a;
  final Step<B> _b;
  final Step<C> _c;
  final Step<D> _d;
  final Step<E> _e;
  final Step<F> _f;
  final Step<G> _g;
  final Step<H> _h;
  final Step<I> _i;
  final List<Step<S>> _dependencies;

  StepBuilder9N._(
    this._name,
    this._a,
    this._b,
    this._c,
    this._d,
    this._e,
    this._f,
    this._g,
    this._h,
    this._i,
    this._dependencies,
  );

  /// Build a step with a single dependency.
  ///
  /// This methods requires a [runStep] function which runs the step, given
  /// values from evaluation of dependent steps. The [runStep] method may be
  /// asynchronous. The [runStep] method will be invoked by `Runner.run` when
  /// the step is evaluated.
  ///
  /// The dependent steps which creates `valueA`, `valueB`, ..., passed to
  /// [runStep] have already be defined when this object was created.
  /// See [Step.define] for how to define steps using this API.
  ///
  /// This method returns the [Step] built by the builder.
  Step<T> build<T>(
    FutureOr<T> Function(
      A valueA,
      B valueB,
      C valueC,
      D valueD,
      E valueE,
      F valueF,
      G valueG,
      H valueH,
      I valueI,
      List<S> values,
    )
        runStep,
  ) {
    return Step._(_name, (r, wrap) async {
      final a_ = r.run(_a);
      final b_ = r.run(_b);
      final c_ = r.run(_c);
      final d_ = r.run(_d);
      final e_ = r.run(_e);
      final f_ = r.run(_f);
      final g_ = r.run(_g);
      final h_ = r.run(_h);
      final i_ = r.run(_i);
      final values_ = _dependencies.map(r.run).toList();
      await Future.wait([a_, b_, c_, d_, e_, f_, g_, h_, i_, ...values_]);
      final a = await a_;
      final b = await b_;
      final c = await c_;
      final d = await d_;
      final e = await e_;
      final f = await f_;
      final g = await g_;
      final h = await h_;
      final i = await i_;
      final values = await Future.wait(values_);
      return await wrap(() => runStep(a, b, c, d, e, f, g, h, i, values));
    }, [_a, _b, _c, _d, _e, _f, _g, _h, _i, ..._dependencies]);
  }
}
