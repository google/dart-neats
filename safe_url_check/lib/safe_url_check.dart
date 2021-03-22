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

import 'src/private_ip.dart';
import 'src/unique_local_ip.dart';
import 'src/version.dart';

const _defaultUserAgent = 'package:safe_url_check/$packageVersion '
    '(+https://github.com/google/dart-neats/tree/master/safe_url_check)';

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
  String userAgent = _defaultUserAgent,
  HttpClient? client,
  RetryOptions retryOptions = const RetryOptions(maxAttempts: 3),
  Duration timeout = const Duration(seconds: 90),
}) async {
  ArgumentError.checkNotNull(url, 'url');
  ArgumentError.checkNotNull(maxRedirects, 'maxRedirects');
  ArgumentError.checkNotNull(userAgent, 'userAgent');
  ArgumentError.checkNotNull(retryOptions, 'retryOptions');
  if (maxRedirects < 0) {
    throw ArgumentError.value(
      maxRedirects,
      'maxRedirects',
      'must be a positive integer',
    );
  }

  try {
    // Create client if one wasn't given.
    var c = client;
    c ??= HttpClient();
    try {
      return await _safeUrlCheck(
        url,
        maxRedirects,
        c,
        userAgent,
        retryOptions,
        timeout,
      );
    } finally {
      // Close client, if it was created here.
      if (client == null) {
        c.close(force: true);
      }
    }
  } on Exception {
    return false;
  }
}

Future<bool> _safeUrlCheck(
  Uri url,
  int maxRedirects,
  HttpClient client,
  String userAgent,
  RetryOptions retryOptions,
  Duration timeout,
) async {
  assert(maxRedirects >= 0);

  // If no scheme or not http or https, we fail.
  if (!url.hasScheme || (!url.isScheme('http') && !url.isScheme('https'))) {
    return false;
  }

  final ips = await retryOptions.retry(() async {
    final ips = await InternetAddress.lookup(url.host).timeout(timeout);
    if (ips.isEmpty) {
      throw Exception('DNS resolution failed');
    }
    return ips;
  });
  for (final ip in ips) {
    // If given a loopback, linklocal or multicast IP, return false
    if (ip.isLoopback ||
        ip.isLinkLocal ||
        ip.isMulticast ||
        isPrivateIpV4(ip) ||
        isUniqueLocalIpV6(ip)) {
      return false;
    }
  }

  final response = await retryOptions.retry(() async {
    // We can't use the HttpClient from dart:io with a custom socket, so instead
    // of making a connection to one of the IPs resolved above, and specifying
    // the host header, we rely on the OS caching DNS queries and not returning
    // different IPs for a second lookup.
    final request = await client.headUrl(url).timeout(timeout);
    request.followRedirects = false;
    request.headers.set(HttpHeaders.userAgentHeader, userAgent);
    final response = await request.close().timeout(timeout);
    await response.drain().catchError((e) => null).timeout(timeout);
    if (500 <= response.statusCode && response.statusCode < 600) {
      // retry again, when we hit a 5xx response
      throw Exception('internal server error');
    }
    return response;
  });
  if (200 <= response.statusCode && response.statusCode < 300) {
    return true;
  }
  if (response.isRedirect &&
      response.headers[HttpHeaders.locationHeader]!.isNotEmpty &&
      maxRedirects > 0) {
    return _safeUrlCheck(
      Uri.parse(response.headers[HttpHeaders.locationHeader]![0]),
      maxRedirects - 1,
      client,
      userAgent,
      retryOptions,
      timeout,
    );
  }

  // Response is 4xx, or some other unsupported code.
  return false;
}
