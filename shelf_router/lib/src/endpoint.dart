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

/// Annotation for an API end-point.
class EndPoint {
  /// HTTP verb for requests routed to the annotated method.
  final String verb;

  /// HTTP route for request routed to the annotated method.
  final String route;

  /// Create an annotation that routes requests matching [verb] and [route] to
  /// the annotated method.
  const EndPoint(this.verb, this.route);

  /// Route `GET` requests matching [route] to annotated method.
  const EndPoint.get(this.route) : verb = 'GET';

  /// Route `HEAD` requests matching [route] to annotated method.
  const EndPoint.head(this.route) : verb = 'HEAD';

  /// Route `POST` requests matching [route] to annotated method.
  const EndPoint.post(this.route) : verb = 'POST';

  /// Route `PUT` requests matching [route] to annotated method.
  const EndPoint.put(this.route) : verb = 'PUT';

  /// Route `DELETE` requests matching [route] to annotated method.
  const EndPoint.delete(this.route) : verb = 'DELETE';

  /// Route `CONNECT` requests matching [route] to annotated method.
  const EndPoint.connect(this.route) : verb = 'CONNECT';

  /// Route `OPTIONS` requests matching [route] to annotated method.
  const EndPoint.options(this.route) : verb = 'OPTIONS';

  /// Route `TRACE` requests matching [route] to annotated method.
  const EndPoint.trace(this.route) : verb = 'TRACE';
}
