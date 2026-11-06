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

/// HTML sanitization for embedding untrusted content in a page without
/// allowing script execution or interference with the rest of the page.
///
/// ```dart
/// import 'package:sanitize_html/sanitize_html.dart';
///
/// final safe = sanitizeHtml(
///   untrusted,
///   rewriters: [
///     HtmlRewriter.prefixIds('user-content-'),
///     HtmlRewriter.addLinkRel((href) => ['ugc', 'nofollow']),
///   ],
/// );
/// ```
///
/// [sanitizeHtml] is a pipeline whose parts are exported for custom
/// pipelines:
///
/// ```
/// untrusted String
///   -> HtmlTokenizer
///   -> HtmlTokenSink: HtmlRewriter.impliedEndTags()
///                  -> rewriters
///                  -> HtmlRewriter.sanitizer(rules)
///   -> htmlWriter
///   -> sanitized String
/// ```
///
/// Everything between tokenizer and writer is an [HtmlRewriter]; the
/// sanitizer must be the last one.
library;

export 'src/attribute_rule.dart' show AttributeRule;
export 'src/sanitize_html.dart' show sanitizeHtml;
export 'src/html_rewriter.dart' show HtmlRewriter, HtmlRewriters;
export 'src/rule_set.dart' show RuleSet;
export 'src/element_pattern.dart' show ElementPattern;
export 'src/element_rule.dart' show ElementRule;
export 'src/html_token_sink.dart' show HtmlTokenSink;
export 'src/html_tokenizer.dart' show HtmlTokenizer;
export 'src/html_writer.dart' show htmlWriter;
