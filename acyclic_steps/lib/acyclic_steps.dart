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
/// import 'dart:io';
/// import 'dart:typed_data';
/// import 'package:acyclic_steps/acyclic_steps.dart';
///
/// /// A [Step] that provides a port we can listen on, this is a _virtual step_
/// /// because it doesn't have an implementation instead it throws an error. Hence,
/// /// to evaluate a ste that depends on [portStep] it is necessary to override
/// /// this step by injecting a value to replace it.
/// final Step<int> portStep = Step.define('port').build(() {
///   throw UnimplementedError('port must be overriden with input');
/// });
///
/// /// A [Step] that loads content to be served from disk, this assumes we're
/// /// writing a server that always serves the same file.
/// final Step<Uint8List> contentSetup = Step.define('content').build(() async {
///   return await File('index.html').readAsBytes();
/// });
///
/// /// A [Step] that sets up an [HttpServer] to listen to the port found in
/// /// [portStep], and serves content loaded by [contentSetup].
/// final Step<HttpServer> serverSetup = Step.define(
///   'server-setup',
/// ).dep(portStep).dep(contentSetup).build((
///   port,
///   content,
/// ) async {
///   // Listen to port
///   final server = await HttpServer.bind(InternetAddress.anyIPv4, port);
///
///   // Handle requests
///   server.listen((request) {
///     request.response
///       ..statusCode = 200
///       ..write(content)
///       ..close();
///   });
///   return server;
/// });
///
/// Future<void> main() async {
///   final r = Runner();
///   // Override [portStep] to provide a port from environment variables.
///   r.override(portStep, int.parse(Platform.environment['PORT']));
///   // Evaluate [serverSetup] which in turn evaluates [contentSetup], and re-uses
///   // the overridden value for [portStep].
///   final server = await r.run(serverSetup);
///   // Now we can close the server, maybe this is useful after SIGTERM
///   await ProcessSignal.sigterm.watch().first;
///   await server.close();
///
///   // When testing it might be desirable to override the [contentSetup] to
///   // produce content that is smaller/different from what is stored on disk.
///   // To do this we must create a new runner:
///   final testRunner = Runner();
///   testRunner.override(portStep, 8080);
///   testRunner.override(contentSetup, Uint8List.fromList([1, 2, 3, 4, 5, 6, 7]));
///   // This will create a server that listens on 8080 and serves the content
///   // injected above.
///   await testRunner.run(serverSetup);
///   // ... run some tests ...
/// }
/// ```
library acyclic_steps;

export 'src/fluent_api.dart' show RunStepWrapper, Runner, Step;
