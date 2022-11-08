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

/// Library with all IANA registered HTTP methods.
///
/// Besides a list of all [httpMethods] this library also features utility
/// functions such as:
///  * [isHttpMethod] to tell if a [String] is an HTTP method,,
///  * [isSafeHttpMethod] to tell if it is a safe HTTP 1.1 method supported by
///  all HTTP servers, and,
///  * [isIdempotentHttpMethod] to tell if an HTTP method is idempotent.
library http_methods;

/// True, if the [method] given is an IANA registered HTTP method.
///
/// This method does a case-insensitive comparison.
bool isHttpMethod(String method) => httpMethods.contains(method.toUpperCase());

/// True, if the [method] given is specified in HTTP 1.1, and thus, MUST be
/// supported by all HTTP servers.
///
/// This method does a case-insensitive comparison.
bool isSafeHttpMethod(String method) =>
    safeHttpMethods.contains(method.toUpperCase());

/// True, if the [method] given is specified to be idempotent.
///
/// This method does a case-insensitive comparison.
bool isIdempotentHttpMethod(String method) =>
    idempotentHttpMethods.contains(method.toUpperCase());

/// List of all [IANA registered HTTP methods](https://www.iana.org/assignments/http-methods/http-methods.txt).
///
/// Provided in uppercase.
const List<String> httpMethods = [
  'ACL',
  'BASELINE-CONTROL',
  'BIND',
  'CHECKIN',
  'CHECKOUT',
  'CONNECT',
  'COPY',
  'DELETE',
  'GET',
  'HEAD',
  'LABEL',
  'LINK',
  'LOCK',
  'MERGE',
  'MKACTIVITY',
  'MKCALENDAR',
  'MKCOL',
  'MKREDIRECTREF',
  'MKWORKSPACE',
  'MOVE',
  'OPTIONS',
  'ORDERPATCH',
  'PATCH',
  'POST',
  'PRI',
  'PROPFIND',
  'PROPPATCH',
  'PUT',
  'REBIND',
  'REPORT',
  'SEARCH',
  'TRACE',
  'UNBIND',
  'UNCHECKOUT',
  'UNLINK',
  'UNLOCK',
  'UPDATE',
  'UPDATEREDIRECTREF',
  'VERSION-CONTROL',
];

/// List of all [HTTP 1.1 Methods](https://tools.ietf.org/html/rfc7231#section-4).
///
/// These are generally considered safe as all HTTP server MUST support these
/// methods.
const List<String> safeHttpMethods = [
  'GET',
  'HEAD',
  'POST',
  'PUT',
  'DELETE',
  'CONNECT',
  'OPTIONS',
  'TRACE',
];

/// List of all HTTP methods specified as idempotent.
const List<String> idempotentHttpMethods = [
  'ACL',
  'BASELINE-CONTROL',
  'BIND',
  'CHECKIN',
  'CHECKOUT',
  'COPY',
  'DELETE',
  'GET',
  'HEAD',
  'LABEL',
  'LINK',
  'MERGE',
  'MKACTIVITY',
  'MKCALENDAR',
  'MKCOL',
  'MKREDIRECTREF',
  'MKWORKSPACE',
  'MOVE',
  'OPTIONS',
  'ORDERPATCH',
  'PRI',
  'PROPFIND',
  'PROPPATCH',
  'PUT',
  'REBIND',
  'REPORT',
  'SEARCH',
  'TRACE',
  'UNBIND',
  'UNCHECKOUT',
  'UNLINK',
  'UNLOCK',
  'UPDATE',
  'UPDATEREDIRECTREF',
  'VERSION-CONTROL',
];
