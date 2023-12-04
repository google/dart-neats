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

import 'package:meta/meta.dart';
import 'package:retry/retry.dart';

import 'private_ip.dart';
import 'unique_local_ip.dart';
import 'version.dart';

const defaultUserAgent = 'package:safe_url_check/$packageVersion '
    '(+https://github.com/google/dart-neats/tree/master/safe_url_check)';

Future<bool> doSafeUrlCheck(
  Uri url, {
  int maxRedirects = 8,
  String userAgent = defaultUserAgent,
  HttpClient? client,
  RetryOptions retryOptions = const RetryOptions(maxAttempts: 3),
  Duration timeout = const Duration(seconds: 90),
  @visibleForTesting bool skipLocalNetworkCheck = false,
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
        client: c,
        userAgent: userAgent,
        retryOptions: retryOptions,
        timeout: timeout,
        skipLocalNetworkCheck: skipLocalNetworkCheck,
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
  int maxRedirects, {
  required HttpClient client,
  required String userAgent,
  required RetryOptions retryOptions,
  required Duration timeout,
  required bool skipLocalNetworkCheck,
}) async {
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
  if (!skipLocalNetworkCheck) {
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
    final loc = Uri.parse(response.headers[HttpHeaders.locationHeader]![0]);
    final nextUri = url.resolveUri(loc);
    return _safeUrlCheck(
      nextUri,
      maxRedirects - 1,
      client: client,
      retryOptions: retryOptions,
      userAgent: userAgent,
      timeout: timeout,
      skipLocalNetworkCheck: skipLocalNetworkCheck,
    );
  }

  // Response is 4xx, or some other unsupported code.
  return false;
}
