// Copyright 2022 Google LLC
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

import 'dart:io' show IOException;

import 'package:http/http.dart';
import 'package:retry/retry.dart';

/// Create a retrying [Client] wrapping [client], if [client] is not supplied
/// then a new [Client] will be created.
///
/// The retrying [Client] will buffer the entire request before sending it.
/// Similarly, it will also buffer the entire response before returning a
/// response. This ensures that the request can be successfully retried if the
/// connection breaks.
///
/// This client should only be used when:
///  * The request is idempotent,
///  * The size of the request will fit in memory,
///  * The server is trusted to not return large responses.
///
/// The wrapped [client] will not be closed when [close] is called, unless it
/// was created by the call to [retryClient] (that is if [client] was `null`).
Client retryClient({
  Client? client,
  RetryOptions retryOptions = const RetryOptions(),
  Set<int> transientStatusCodes = const {
    // See: https://cloud.google.com/storage/docs/xml-api/reference-status
    429,
    500,
    503,
  },
}) =>
    _RetryClient(
      client: client,
      retryOptions: retryOptions,
      transientStatusCodes: transientStatusCodes,
    );

class _RetryClient extends BaseClient {
  final RetryOptions _r;
  final Client _client;
  final bool _closeInnerClient;
  final Set<int> _transientStatusCodes;

  /// Create a [_RetryClient] wrapping [client], if [client] is not supplied then
  /// a new [Client] will be created.
  ///
  /// The wrapped [Client] will not be closed when [close] is called, unless the
  /// it was created in the constructor because [client] is `null`.
  _RetryClient({
    Client? client,
    RetryOptions retryOptions = const RetryOptions(),
    Set<int> transientStatusCodes = const {
      // See: https://cloud.google.com/storage/docs/xml-api/reference-status
      429,
      500,
      503,
    },
  })  : _client = client ?? Client(),
        _r = retryOptions,
        _closeInnerClient = client == null,
        _transientStatusCodes = transientStatusCodes;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final body = await request.finalize().toBytes();

    try {
      return await _r.retry(() async {
        final bufferedRequest = Request(
          request.method,
          request.url,
        )
          ..bodyBytes = body
          ..followRedirects = request.followRedirects
          ..headers.addAll(request.headers)
          ..maxRedirects = request.maxRedirects
          ..persistentConnection = request.persistentConnection;

        final bufferedResponse =
            await Response.fromStream(await _client.send(bufferedRequest));

        final response = StreamedResponse(
          Stream.value(bufferedResponse.bodyBytes),
          bufferedResponse.statusCode,
          contentLength: bufferedResponse.bodyBytes.length,
          request: bufferedRequest,
          headers: bufferedResponse.headers,
          isRedirect: bufferedResponse.isRedirect,
          persistentConnection: bufferedResponse.persistentConnection,
          reasonPhrase: bufferedResponse.reasonPhrase,
        );

        if (_transientStatusCodes.contains(response.statusCode)) {
          throw _IntermittentHttpResponseException(response);
        }
        return response;
      },
          retryIf: (e) =>
              e is IOException || e is _IntermittentHttpResponseException);
    } on _IntermittentHttpResponseException catch (e) {
      return e.response;
    }
  }

  @override
  void close() {
    if (_closeInnerClient) {
      _client.close();
    }
    super.close();
  }
}

class _IntermittentHttpResponseException implements Exception {
  final StreamedResponse response;
  _IntermittentHttpResponseException(this.response);
}
