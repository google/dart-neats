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

/// Utility library to check if an untrusted URL is broken or not.
///
/// This makes an HTTP `HEAD` request after checking that the hostname does not
/// resolve to a private IPv4 address or local unique IPv6 address.
///
/// **Example**
/// ```dart
/// import 'package:safe_url_check/safe_url_check.dart';
///
/// Future<void> main() async {
///   // Check if https://google.com is a broken URL.
///   final exists = await safeUrlCheck(
///     Uri.parse('https://google.com'),
///     userAgent: 'myexample/1.0.0 (+https://example.com)',
///   );
///   if (exists) {
///     print('The url: https://google.com is NOT broken');
///   }
/// }
/// ```
library safe_url_check;

import 'dart:io';
import 'dart:async';

import 'package:retry/retry.dart';

import 'src/safe_url_check.dart';

/// Check if [url] is available, without allowing access to private networks.
///
/// This will make a `HEAD` request to [url] with given [userAgent], following
/// redirects if the hostname of URLs do not resolve to a private IP address.
///
/// Each I/O is set to timeout after [timeout] duration. This coupled with the
/// large number of retries allow means that this operation can be slow.
///
/// It is good practice to set a custom [userAgent], this allows servers to see
/// which bots are requesting their resources. This package defaults to the
/// following user-agent:
/// ```
/// User-Agent: package:safe_url_check/1.0.0 (+https://github.com/google/dart-neats/tree/master/safe_url_check)
/// ```
Future<bool> safeUrlCheck(
  Uri url, {
  int maxRedirects = 8,
  String userAgent = defaultUserAgent,
  HttpClient? client,
  RetryOptions retryOptions = const RetryOptions(maxAttempts: 3),
  Duration timeout = const Duration(seconds: 90),
}) async {
  return doSafeUrlCheck(
    url,
    maxRedirects: maxRedirects,
    userAgent: userAgent,
    client: client,
    retryOptions: retryOptions,
    timeout: timeout,
  );
}
