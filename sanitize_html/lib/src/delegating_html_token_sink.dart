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

/// The base of rewriter sinks: forwards every token to the next sink.
library;

import 'html_token_sink.dart';

/// Forwards every token to the sink it wraps; subclasses override what they
/// change and call `super` for the rest.
abstract base class DelegatingHtmlTokenSink extends HtmlTokenSink {
  final HtmlTokenSink _sink;

  DelegatingHtmlTokenSink(this._sink);

  @override
  void text(String source, int start, int end) =>
      _sink.text(source, start, end);

  @override
  void startTag(String name, Map<String, String> attributes) =>
      _sink.startTag(name, attributes);

  @override
  void endTag(String name) => _sink.endTag(name);

  @override
  void close() => _sink.close();
}
