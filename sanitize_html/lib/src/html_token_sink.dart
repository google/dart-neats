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

/// The interface HTML tokens are delivered through.
library;

/// A receiver of HTML tokens.
abstract base class HtmlTokenSink {
  /// Pushes the text `source[start..end)`, undecoded.
  ///
  /// Character references are as written: `&amp;` is five characters.
  void text(String source, int start, int end);

  /// Pushes a start tag.
  ///
  /// [name] and the keys of [attributes] are lowercase; values are decoded.
  /// The map belongs to the sink until the call returns: it may be mutated
  /// unless it is empty, which may be a shared `const` map, and must not be
  /// retained.
  void startTag(String name, Map<String, String> attributes);

  /// Pushes an end tag.
  ///
  /// Closes the innermost open element called [name] and every element
  /// opened after it. With no such element open it means nothing.
  void endTag(String name);

  /// Ends the input; no more tokens follow.
  void close();
}
