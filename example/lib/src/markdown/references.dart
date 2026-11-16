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

import 'package:source_span/source_span.dart';

import '../diagnostic.dart';
import '../util/scanner.dart';
import 'fenced_code_block.dart';

/// A request to fill a fenced code block with the content of a file.
final class ExampleReference {
  /// The path, exactly as written, without the `#region` fragment.
  final String path;

  /// The region named after `#`, or `null` for the whole file.
  final String? region;

  /// `key=value` tokens after the file reference.
  final Map<String, String> options;

  /// The block whose content this reference controls.
  final FencedCodeBlock block;

  /// Span of the `<path>[#<region>]` token in the markdown document.
  final FileSpan span;

  ExampleReference({
    required this.path,
    required this.region,
    required Map<String, String> options,
    required this.block,
    required this.span,
  }) : options = Map.unmodifiable(options);

  /// The reference as written: `path` or `path#region`.
  String get reference => region == null ? path : '$path#$region';
}

final _optionPattern = RegExp(r'^([a-zA-Z_][a-zA-Z0-9_-]*)=(.+)$');

/// Collects every [ExampleReference] on [blocks] in document order.
///
/// Matches fences with info string
/// `<lang> @example <path>[#<region>] [<key>=<value>]*`.
List<ExampleReference> findReferences(
  Iterable<FencedCodeBlock> blocks, {
  required ErrorSink report,
}) =>
    blocks
        .map((block) => _fromInfoString(block, report: report))
        .nonNulls
        .toList();

ExampleReference? _fromInfoString(
  FencedCodeBlock block, {
  required ErrorSink report,
}) {
  final tokens = block.infoSpan.scanTokens();
  final atIndex = tokens.indexWhere((t) => t.text.toLowerCase() == '@example');
  if (atIndex < 0) return null;

  if (atIndex == 0) {
    report(ExampleFormatException(
      'missing language before `@example`; '
      'expected e.g. ` ```text @example ... `',
      tokens[0],
    ));
    return null;
  }
  if (atIndex > 1) {
    report(ExampleFormatException(
      '`@example` must come immediately after the fence language',
      tokens[atIndex],
    ));
    return null;
  }
  if (tokens[1].text != '@example') {
    report(ExampleFormatException(
      'expected lowercase `@example`, got `${tokens[1].text}`',
      tokens[1],
    ));
    return null;
  }
  if (tokens.length < 3) {
    report(ExampleFormatException('`@example` names no file', tokens[1]));
    return null;
  }

  final pathToken = tokens[2];
  if (pathToken.text.contains('=')) {
    report(ExampleFormatException(
      'expected a file path after `@example`, got `${pathToken.text}`',
      pathToken,
    ));
    return null;
  }

  final options = <String, String>{};
  for (final token in tokens.skip(3)) {
    final option = _optionPattern.firstMatch(token.text);
    if (option == null) {
      report(ExampleFormatException(
        'expected `key=value` option after `@example`, got `${token.text}`',
        token,
      ));
      return null;
    }
    options[option[1]!] = option[2]!;
  }

  return _buildReference(
    pathToken,
    options: options,
    block: block,
  );
}

ExampleReference _buildReference(
  FileSpan span, {
  required Map<String, String> options,
  required FencedCodeBlock block,
}) {
  final text = span.text;
  final hash = text.indexOf('#');
  if (hash < 0) {
    return ExampleReference(
      path: text,
      region: null,
      options: options,
      block: block,
      span: span,
    );
  }
  final fragment = text.substring(hash + 1);
  return ExampleReference(
    path: text.substring(0, hash),
    region: fragment.isEmpty ? null : fragment,
    options: options,
    block: block,
    span: span,
  );
}
