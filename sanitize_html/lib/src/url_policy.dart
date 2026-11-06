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

/// Which URLs may be the value of a URL attribute.
///
/// After tab, LF and CR are removed and leading and trailing spaces
/// stripped, as a browser does, a URL is accepted if it contains no other
/// ASCII control character, no `\`, and is one of:
///
///  * `https://`, `http://`, `mailto://` or `//`, ASCII case-insensitive,
///    followed by an authority with at least one character and no `@` or
///    `%` before the first `/`, `?` or `#`;
///  * `mailto:` followed by anything else;
///  * a relative URL: no `:` before the first `/`, `?` or `#`.
///
/// Everything else (`javascript:`, `data:`, `vbscript:`, `file:`, custom
/// handlers) is refused. The restrictions beyond the scheme exist because
/// [Uri] (RFC 3986) and the browser (WHATWG URL Standard) disagree on `\`,
/// on slashes after `https:`, and on `@` and `%` in a host; refusing those
/// forms means the [Uri] handed to `AttributeRule.url(where)` has the host
/// the browser will use. The host is not IDNA-mapped or IPv4-canonicalized:
/// compare it to an allowlist, never a denylist.
library;

import 'util/ascii.dart';

/// [url] parsed, or `null` if it may not be used.
Uri? safeUrl(String url) {
  // Browsers delete these anywhere in a URL before parsing it.
  // https://url.spec.whatwg.org/#concept-basic-url-parser
  var u = url.replaceAll('\t', '').replaceAll('\n', '').replaceAll('\r', '');
  // Every other ASCII control character is refused rather than reasoned
  // about, and so is `\`, which browsers read as `/` in `http(s)` and
  // relative URLs. https://url.spec.whatwg.org/#special-scheme
  if (u.codeUnits.any((c) => c < $space || c == $del) || u.contains(r'\')) {
    return null;
  }
  u = _stripSpaces(u);

  // Index of the authority, if the URL has one.
  int? authority;
  if (_startsWithIgnoringCase(u, 'https://')) {
    authority = 'https://'.length;
  } else if (_startsWithIgnoringCase(u, 'http://')) {
    authority = 'http://'.length;
  } else if (_startsWithIgnoringCase(u, 'mailto://')) {
    authority = 'mailto://'.length;
  } else if (_startsWithIgnoringCase(u, 'mailto:')) {
    return Uri.tryParse(u);
  } else if (u.startsWith('//')) {
    authority = 2;
  } else if (_hasScheme(u)) {
    return null;
  } else {
    return Uri.tryParse(u);
  }

  // Browsers skip any number of slashes after `https:` (`https:evil.com`
  // and `https:///evil.com` reach evil.com), decode `%` in a host
  // (`e%76il.com`) and send `good.com@evil.com` to evil.com; `Uri` does
  // none of that. Require a non-empty authority without `@` or `%`.
  // https://url.spec.whatwg.org/#authority-state
  final end = _indexOfPathStart(u, authority);
  if (end == authority) {
    return null;
  }
  for (var i = authority; i < end; i++) {
    final c = u.codeUnitAt(i);
    if (c == $at || c == $percent) {
      return null;
    }
  }
  return Uri.tryParse(u);
}

/// The candidate URLs of [srcset] parsed, or `null` unless every
/// [candidate][1] is a URL [safeUrl] accepts, optionally followed by a width
/// (`100w`) or density (`1.5x`) descriptor.
///
/// [1]: https://html.spec.whatwg.org/multipage/images.html#parse-a-srcset-attribute
List<Uri>? safeSrcset(String srcset) {
  final urls = <Uri>[];
  for (var position = 0; position < srcset.length;) {
    final candidate = _candidate.matchAsPrefix(srcset, position);
    if (candidate == null) {
      return null;
    }
    final url = safeUrl(candidate[1]!);
    if (url == null) {
      return null;
    }
    urls.add(url);
    position = candidate.end;
  }
  return urls.isEmpty ? null : urls;
}

/// An [image candidate string][1] and its separator.
///
/// [1]: https://html.spec.whatwg.org/multipage/images.html#image-candidate-string
final _candidate = RegExp(
  '[$_ws]*' // leading whitespace
  '([^$_ws,](?:[^$_ws]*[^$_ws,])?)' // URL: no comma at either end
  '(?:[$_ws]+(?:[0-9]+w|[0-9]*\\.?[0-9]+x))?' // optional: 200w | 1.5x
  '[$_ws]*(?:,+|\$)', // comma or end
);

/// ASCII whitespace, as a character class body.
const _ws = r' \t\n\f\r';

/// Whether [s] has a `:` before its first `/`, `?` or `#`.
///
/// A browser scheme is `[a-zA-Z][a-zA-Z0-9+.-]*:`; treating every such prefix
/// as a scheme refuses a few strings a browser would read as relative, such
/// as `1javascript:`, and never accepts one it would read as a scheme.
/// https://url.spec.whatwg.org/#scheme-state
bool _hasScheme(String s) {
  final colon = s.indexOf(':');
  return colon >= 0 && colon < _indexOfPathStart(s, 0);
}

/// Index of the first `/`, `?` or `#` in [s] at or after [start], or
/// `s.length`.
int _indexOfPathStart(String s, int start) {
  var end = s.length;
  for (final delimiter in const ['/', '?', '#']) {
    final index = s.indexOf(delimiter, start);
    if (index >= 0 && index < end) {
      end = index;
    }
  }
  return end;
}

/// Whether [s] starts with the lowercase ASCII [prefix], compared ASCII
/// case-insensitively as the [URL parser][1] does for schemes;
/// `String.toLowerCase` would also fold U+212A KELVIN SIGN to `k`.
///
/// [1]: https://url.spec.whatwg.org/#scheme-state
bool _startsWithIgnoringCase(String s, String prefix) =>
    s.length >= prefix.length &&
    asciiLowerSubstring(s, 0, prefix.length) == prefix;

/// [s] without leading and trailing spaces; unlike `String.trim`, Unicode
/// whitespace, which the browser keeps, stays.
String _stripSpaces(String s) {
  var start = 0;
  var end = s.length;
  while (start < end && s.codeUnitAt(start) == $space) {
    start++;
  }
  while (end > start && s.codeUnitAt(end - 1) == $space) {
    end--;
  }
  return start == 0 && end == s.length ? s : s.substring(start, end);
}
