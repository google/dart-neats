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

extension UriDataChecksExt on Subject<UriData> {
  /// The MIME type of the data URI.
  Subject<String> get mimeType => has((d) => d.mimeType, 'mimeType');

  /// The charset of the data URI.
  Subject<String> get charset => has((d) => d.charset, 'charset');

  /// The raw text content of the data URI.
  Subject<String> get contentText => has((d) => d.contentText, 'contentText');

  /// Extracts the content of the data URI as a string.
  Subject<String> get contentAsString =>
      has((d) => d.contentAsString(), 'contentAsString');

  /// Extracts the content of the data URI as bytes.
  Subject<List<int>> get contentAsBytes =>
      has((d) => d.contentAsBytes(), 'contentAsBytes');

  /// Expects that the data URI is base64 encoded.
  void isBase64() {
    context.expect(() => ['is base64'], (actual) {
      if (actual.isBase64) return null;
      return Rejection(which: ['is not base64']);
    });
  }

  /// Expects that the data URI is not base64 encoded.
  void isNotBase64() {
    context.expect(() => ['is not base64'], (actual) {
      if (!actual.isBase64) return null;
      return Rejection(which: ['is base64']);
    });
  }
}
