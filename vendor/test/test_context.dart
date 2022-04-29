// Copyright 2022 Google LLC
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
import 'package:meta/meta.dart' show sealed;
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:http/src/client.dart' as http;
import 'package:vendor/src/context.dart' show Context;
import 'package:test/test.dart' show test, printOnFailure;

import 'pub_test_server.dart';

/// Test with a [Context] that assumes [d.sandbox] is the package root.
void testWithContext(String title, FutureOr<void> Function(TestContext) fn) =>
    test(title, () async {
      final server = await PubTestServer.listen();
      final client = http.Client();
      try {
        await fn(TestContext(
          context: _Context(
            rootPackageFolder: Uri.directory(d.sandbox),
            client: client,
            defaultHostedUrl: server.url,
          ),
          server: server,
        ));
      } finally {
        client.close();
        await server.close();
      }
    });

@sealed
class TestContext {
  final PubTestServer server;
  final Context context;

  TestContext({
    required this.context,
    required this.server,
  });
}

@sealed
class _Context extends Context {
  @override
  final http.Client client;

  @override
  final Uri rootPackageFolder;

  @override
  final Uri defaultHostedUrl;

  _Context({
    required this.rootPackageFolder,
    required this.client,
    required this.defaultHostedUrl,
  });

  @override
  void log(String message) => printOnFailure(message);

  @override
  void warning(String message) => printOnFailure('WARNING: $message');
}
