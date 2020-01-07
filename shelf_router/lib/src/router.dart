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

import 'router_entry.dart' show RouterEntry;
import 'package:shelf/shelf.dart';
import 'package:http_methods/http_methods.dart';

/// Get a URL parameter captured by the [Router].
String params(Request request, String name) {
  ArgumentError.checkNotNull(request, 'request');
  ArgumentError.checkNotNull(name, 'name');

  final p = request.context['shelf_router/params'];
  if (!(p is Map<String, String>)) {
    throw new Exception('no such parameter $name');
  }
  final value = (p as Map<String, String>)[name];
  if (value == null) {
    throw new Exception('no such parameter $name');
  }
  return value;
}

/// Middleware to remove body from request.
final _removeBody = createMiddleware(responseHandler: (r) {
  if (r == null) {
    return null;
  }
  if (r.headers.containsKey('content-length')) {
    r = r.change(headers: {'content-length': '0'});
  }
  return r.change(body: <int>[]);
});

/// A shelf [Router] routes requests to handlers based on HTTP verb and route
/// pattern.
///
/// ```dart
/// import 'package:shelf_router/shelf_router.dart';
/// import 'package:shelf/shelf.dart';
/// import 'package:shelf/shelf_io.dart' as io;
///
/// var app = Router();
///
/// // Route pattern parameters can be specified <paramName>
/// app.get('/users/<userName>/whoami', (Request request) async {
///   // The matched values can be read with params(request, param)
///   var userName = params(request, 'userName');
///   return Response.ok('You are ${userName}');
/// });
///
/// // The matched value can also be taken as parameter, if the handler given
/// // doesn't implement Handler, it's assumed to take all parameters in the
/// // order they appear in the route pattern.
/// app.get('/users/<userName>/say-hello', (Request request, String userName) async {
///   return Response.ok('Hello ${uName}');
/// });
///
/// // It is possible to have multiple parameters, and if desired a custom
/// // regular expression can be specified with <paramName|REGEXP>, where
/// // REGEXP is a regular expression (leaving out ^ and $).
/// // If no regular expression is specified `[^/]+` will be used.
/// app.get('/users/<userName>/messages/<msgId|\d+>', (Request request) async {
///   var msgId = int.parse(params(request, 'msgId'));
///   return Response.ok(message.getById(msgId));
/// });
///
/// var server = await io.serve(app.handler, 'localhost', 8080);
/// ```
///
/// If multiple routes match the same request, the handler for the first
/// route is called. If the handler returns `null` the next matching handler
/// will be attempted.
///
///
class Router {
  final List<RouterEntry> _routes = [];

  /// Add [handler] for [verb] requests to [route].
  ///
  /// If [verb] is `GET` the [handler] will also be called for `HEAD` requests
  /// matching [route]. This is because handling `GET` requests without handling
  /// `HEAD` is always wrong. To explicitely implement a `HEAD` handler it must
  /// be registered before the `GET` handler.
  void add(String verb, String route, Function handler) {
    ArgumentError.checkNotNull(verb, 'verb');
    if (!isHttpMethod(verb)) {
      throw ArgumentError.value(verb, 'verb', 'expected a valid HTTP method');
    }
    verb = verb.toUpperCase();

    if (verb == 'GET') {
      // Handling in a 'GET' request without handling a 'HEAD' request is always
      // wrong, thus, we add a default implementation that discards the body.
      _routes.add(RouterEntry('HEAD', route, handler, middleware: _removeBody));
    }
    _routes.add(RouterEntry(verb, route, handler));
  }

  /// Handle all request to [route] using [handler].
  void all(String route, Function handler) {
    _routes.add(RouterEntry('ALL', route, handler));
  }

  /// Mount a router below a prefix.
  ///
  /// In this case prefix may not contain any parameters, nor
  void mount(String prefix, Router router) {
    ArgumentError.checkNotNull(prefix, 'prefix');
    ArgumentError.checkNotNull(router, 'router');
    if (!prefix.startsWith('/') || !prefix.endsWith('/')) {
      throw ArgumentError.value(
          prefix, 'prefix', 'must start and end with a slash');
    }

    final handler = router.handler;
    // first slash is always in request.handlerPath
    final path = prefix.substring(1);
    all(prefix + '<path|[^]*>', (Request request) {
      return handler(request.change(path: path));
    });
  }

  /// Get a [Handler] that will route incoming requests to registered handlers.
  Handler get handler {
    // Note: this is a great place to optimize the implementation by building
    //       a trie for faster matching... left as an exercise for the reader :)
    return (Request request) async {
      for (var route in _routes) {
        if (route.verb != request.method.toUpperCase() && route.verb != 'ALL') {
          continue;
        }
        var params = route.match('/' + request.url.path);
        if (params != null) {
          var res = await route.invoke(request, params);
          if (res != null) {
            return res;
          }
        }
      }
      return null;
    };
  }

  // Handlers for all methods

  /// Handle `GET` request to [route] using [handler].
  ///
  /// If no matching handler for `HEAD` requests is registered, such requests
  /// will also be routed to the [handler] registered here.
  void get(String route, Function handler) => add('GET', route, handler);

  /// Handle `HEAD` request to [route] using [handler].
  void head(String route, Function handler) => add('HEAD', route, handler);

  /// Handle `POST` request to [route] using [handler].
  void post(String route, Function handler) => add('POST', route, handler);

  /// Handle `PUT` request to [route] using [handler].
  void put(String route, Function handler) => add('PUT', route, handler);

  /// Handle `DELETE` request to [route] using [handler].
  void delete(String route, Function handler) => add('DELETE', route, handler);

  /// Handle `CONNECT` request to [route] using [handler].
  void connect(String route, Function handler) =>
      add('CONNECT', route, handler);

  /// Handle `OPTIONS` request to [route] using [handler].
  void options(String route, Function handler) =>
      add('OPTIONS', route, handler);

  /// Handle `TRACE` request to [route] using [handler].
  void trace(String route, Function handler) => add('TRACE', route, handler);

  /// Handle `PATCH` request to [route] using [handler].
  void patch(String route, Function handler) => add('PATCH', route, handler);
}
