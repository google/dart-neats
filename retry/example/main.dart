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
import 'dart:io';
import 'package:retry/retry.dart';

Future<void> main() async {
  // Create an HttpClient.
  final client = HttpClient();

  try {
    // Get statusCode by retrying a function
    final statusCode = await retry(
      () async {
        // Make a HTTP request and return the status code.
        final request = await client
            .getUrl(Uri.parse('https://www.google.com'))
            .timeout(Duration(seconds: 5));
        final response = await request.close().timeout(Duration(seconds: 5));
        await response.drain();
        return response.statusCode;
      },
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    // Print result from status code
    if (statusCode == 200) {
      print('google.com is running');
    } else {
      print('google.com is not availble...');
    }
  } finally {
    // Always close an HttpClient from dart:io, to close TCP connections in the
    // connection pool. Many servers has keep-alive to reduce round-trip time
    // for additional requests and avoid that clients run out of port and
    // end up in WAIT_TIME unpleasantries...
    client.close();
  }
}
