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
import 'package:shelf/shelf.dart';

/// Check if the [regexp] is non-capturing.
bool _isNoCapture(String regexp) {
  ArgumentError.checkNotNull(regexp, 'regexp');

  // Construct a new regular expression matching anything containing regexp,
  // then match with empty-string and count number of groups.
  return RegExp('^(?:$regexp)|.*\$').firstMatch('').groupCount == 0;
}

/// Entry in the router.
///
/// This class implements the logic for matching the path pattern.
class RouterEntry {
  /// Pattern for parsing the route pattern
  static final RegExp _parser = RegExp(r'([^<]*)(?:<([^>|]+)(?:\|([^>]*))?>)?');

  final String verb, route;
  final Function _handler;
  final Middleware _middleware;

  /// Expression that the request path must match.
  ///
  /// This also captures any parameters in the route pattern.
  RegExp _routePattern;

  /// Names for the parameters in the route pattern.
  final List<String> _params = [];

  /// List of parameter names in the route pattern.
  List<String> get params => _params.toList(); // exposed for using generator.

  RouterEntry(
    this.verb,
    this.route,
    this._handler, {
    Middleware middleware,
  }) : _middleware = middleware ?? ((Handler fn) => fn) {
    ArgumentError.checkNotNull(verb, 'verb');
    ArgumentError.checkNotNull(route, 'route');
    ArgumentError.checkNotNull(_handler, 'handler');
    if (!route.startsWith('/')) {
      throw ArgumentError.value(
          route, 'route', 'expected route to start with a slash');
    }
    if (!(_handler is Function)) {
      throw ArgumentError.value(_handler, 'handler', 'expected a function');
    }

    var pattern = '';
    for (var m in _parser.allMatches(route)) {
      pattern += RegExp.escape(m[1]);
      if (m[2] != null) {
        _params.add(m[2]);
        if (m[3] != null && !_isNoCapture(m[3])) {
          throw ArgumentError.value(
              route, 'route', 'expression for "${m[2]}" is capturing');
        }
        pattern += '(${m[3] ?? r'[^/]+'})';
      }
    }
    _routePattern = RegExp('^$pattern\$');
  }

  /// Returns a map from parameter name to value, if the path matches the
  /// route pattern. Otherwise returns null.
  Map<String, String> match(String path) {
    // Check if path matches the route pattern
    var m = _routePattern.firstMatch(path);
    if (m == null) {
      return null;
    }
    // Construct map from parameter name to matched value
    var params = <String, String>{};
    for (var i = 0; i < _params.length; i++) {
      // first group is always the full match, we ignore this group.
      params[_params[i]] = m[i + 1];
    }
    return params;
  }

  // invoke handler with given request and params
  Future<Response> invoke(Request request, Map<String, String> params) async {
    request = request.change(context: {'shelf_router/params': params});

    return await _middleware((request) async {
      if (_handler is Handler || _params.isEmpty) {
        return await _handler(request);
      }
      return await Function.apply(
          _handler, [request]..addAll(_params.map((n) => params[n])));
    })(request);
  }
}
