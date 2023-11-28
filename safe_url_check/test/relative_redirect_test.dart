// Copyright 2023 Google LLC
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

import 'dart:io';

import 'package:retry/retry.dart';
import 'package:safe_url_check/src/safe_url_check.dart';
import 'package:test/test.dart';

void main() {
  late HttpServer server;
  setUpAll(() async {
    server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
    server.listen((e) async {
      switch (e.requestedUri.path) {
        case '/redirect/local':
          e.response.statusCode = 303;
          e.response.headers.set('location', 'target');
          await e.response.close();
          return;
        case '/redirect/target':
          e.response.write('OK');
          await e.response.close();
          return;
        default:
          e.response.statusCode = 404;
          await e.response.close();
      }
    });
  });

  tearDownAll(() async {
    await server.close();
  });

  test('relative redirect', () async {
    final client = HttpClient();
    final checker = SafeUrlChecker(
      client: client,
      userAgent: defaultUserAgent,
      retryOptions: RetryOptions(),
      timeout: Duration(seconds: 2),
      skipLocalNetworkCheck: true,
    );
    expect(
        await checker.checkUrl(
            Uri.parse('http://localhost:${server.port}/redirect/local'), 2),
        isTrue);
  });
}
