// Copyright 2026 Google LLC
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

import '../util.dart';

extension UriChecksExt on Subject<Uri> {
  /// The scheme component of the URI.
  Subject<String> get scheme => has((u) => u.scheme, 'scheme');

  /// The authority component of the URI.
  Subject<String> get authority => has((u) => u.authority, 'authority');

  /// The host component of the URI.
  ///
  /// {@example /example/core/uri/host.dart}
  Subject<String> get host => has((u) => u.host, 'host');

  /// The port component of the URI.
  Subject<int> get port => has((u) => u.port, 'port');

  /// The path component of the URI.
  Subject<String> get path => has((u) => u.path, 'path');

  /// The query component of the URI.
  Subject<String> get query => has((u) => u.query, 'query');

  /// The fragment component of the URI.
  Subject<String> get fragment => has((u) => u.fragment, 'fragment');

  /// The path segments of the URI.
  Subject<Iterable<String>> get pathSegments =>
      has((u) => u.pathSegments, 'pathSegments');

  /// The query parameters of the URI.
  Subject<Map<String, String>> get queryParameters =>
      has((u) => u.queryParameters, 'queryParameters');

  /// The query parameters of the URI, with all values for each key.
  Subject<Map<String, List<String>>> get queryParametersAll =>
      has((u) => u.queryParametersAll, 'queryParametersAll');

  /// The data URI content if this is a data URI.
  Subject<UriData?> get data => has((u) => u.data, 'data');

  static const _absolute = (
    positive: 'is absolute',
    negative: 'is not absolute',
  );

  /// Expects that the URI is absolute.
  void isAbsolute() => expectTrue(_absolute, (u) => u.isAbsolute);

  /// Expects that the URI is not absolute.
  void isNotAbsolute() => expectFalse(_absolute, (u) => u.isAbsolute);

  /// Expects that the URI has the given [scheme].
  ///
  /// {@example /example/core/uri/has_scheme.dart}
  void hasScheme(String scheme) {
    context.expect(() => prefixFirst('has scheme ', literal(scheme)), (actual) {
      if (actual.scheme == scheme) return null;
      return Rejection(
        which: [...prefixFirst('has scheme ', literal(actual.scheme))],
      );
    });
  }
}
