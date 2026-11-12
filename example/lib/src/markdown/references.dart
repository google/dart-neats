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
import 'package:string_scanner/string_scanner.dart';

import '../diagnostic.dart';
import '../util/scanner.dart';
import 'fenced_code_block.dart';

/// A request to fill a fenced code block with the content of a file.
final class ExampleReference {
  /// The path, exactly as written, without the `#region` fragment.
  final String path;

  /// The region named after `#`, or `null` for the whole file.
  final String? region;

  /// `key=value` tokens.
  final Map<String, String> options;

  /// The block whose content this reference controls.
  final FencedCodeBlock block;

  /// Span of the reference token in the markdown document.
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
final _fileExtension = RegExp(r'[^./]\.[a-zA-Z0-9]{1,10}$');
final _commentOpen =
    RegExp(r'[ \t>]*<!--\s*@example(?=\s|-->)', caseSensitive: false);
final _commentBody = RegExp(r'.*?(?=-->\s*$)');

/// Collects every [ExampleReference] on [blocks] in document order.
///
/// Checks both the info string on each block (` ```dart example/hello.dart `)
/// and an optional `<!-- @example ... -->` comment on the line immediately
/// above it.
List<ExampleReference> findReferences(
  Iterable<FencedCodeBlock> blocks, {
  required ErrorSink report,
}) =>
    blocks
        .map((block) {
          final fromInfo = _fromInfoString(block);
          final fromComment = _fromHtmlComment(block, report: report);

          if (fromInfo != null &&
              fromComment != null &&
              fromInfo.reference != fromComment.reference) {
            report(ExampleFormatException(
              'this code block is claimed by two different references: '
              '`${fromComment.reference}` in an HTML comment and '
              '`${fromInfo.reference}` in the info string',
              fromInfo.span,
            ));
            return null;
          }

          return fromInfo ?? fromComment;
        })
        .nonNulls
        .toList();

/// Syntax (B): `<lang> <reference>? <key=value>*` in [block]'s info string.
///
/// Tokens that are neither a reference nor an option are ignored, because
/// info strings are also used by other tools.
ExampleReference? _fromInfoString(FencedCodeBlock block) {
  final tokens = block.infoSpan.scanTokens();

  FileSpan? referenceToken;
  final options = <String, String>{};
  for (final token in tokens.skip(1)) {
    final option = _optionPattern.firstMatch(token.text);
    if (option != null) {
      options[option[1]!] = option[2]!;
      continue;
    }
    if (referenceToken == null && _looksLikeReference(token.text)) {
      referenceToken = token;
    }
  }

  if (referenceToken == null) return null;

  return _buildReference(
    referenceToken,
    options: options,
    block: block,
  );
}

/// Syntax (A): `<!-- @example <reference> <key=value>* -->` on the line before
/// [block].
ExampleReference? _fromHtmlComment(
  FencedCodeBlock block, {
  required ErrorSink report,
}) {
  final fenceLine = block.openFence.start.line;
  if (fenceLine == 0) return null;

  final file = block.openFence.file;
  final commentLine = file.span(
    file.getOffset(fenceLine - 1),
    file.getOffset(fenceLine),
  );
  final scanner = SpanScanner.within(commentLine);
  if (!scanner.scan(_commentOpen) || !scanner.scan(_commentBody)) return null;

  final tokens = scanner.lastSpan!.scanTokens();
  if (tokens.isEmpty) {
    report(ExampleFormatException(
      'the `@example` comment names no file',
      commentLine,
    ));
    return null;
  }

  final first = tokens.first;
  if (!_looksLikeReference(first.text)) {
    report(ExampleFormatException(
      '`${first.text}` is not a file reference',
      first,
    ));
    return null;
  }

  final options = <String, String>{};
  for (final token in tokens.skip(1)) {
    final option = _optionPattern.firstMatch(token.text);
    if (option == null || option[1] != 'indent') {
      report(ExampleFormatException(
        'unexpected `${token.text}` in `@example` comment; '
        'expected `indent=strip` or `indent=keep`',
        token,
      ));
      return null;
    }
    options[option[1]!] = option[2]!;
  }

  return _buildReference(
    first,
    options: options,
    block: block,
  );
}

bool _looksLikeReference(String token) {
  if (token.contains('=') || token.startsWith('{')) return false;
  final path = token.split('#').first;
  return path.contains('/') || _fileExtension.hasMatch(path);
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
