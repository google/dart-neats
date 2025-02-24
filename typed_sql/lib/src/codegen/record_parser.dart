// Copyright 2025 Google LLC
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

import 'package:analyzer/dart/ast/ast.dart' show AstNode, RecordLiteral;
import 'package:analyzer/dart/ast/visitor.dart' show RecursiveAstVisitor;
import 'package:analyzer/dart/element/type.dart' show RecordType;
import 'package:collection/collection.dart';

import 'parsed_library.dart';

final class RecordParser {
  final _records = <RecordType>{};
  late final _forEachRecordLiteral = _ForEachRecordLiteral((record) {
    if (record.staticType case final RecordType type) {
      _records.add(type);
    }
  });

  void parseRecords(AstNode node) => node.visitChildren(_forEachRecordLiteral);

  List<ParsedRecord> canonicalizedParsedRecords() {
    final canonicalizedRecords = <String, ParsedRecord>{};

    for (final record in _records) {
      // If there are no named fields, then we ship this record.
      if (record.namedFields.isEmpty) {
        continue;
      }

      // TODO: Consider if we want to only generate for named records where
      //       at-least one of named entries has Expr<T> type.
      //       This is possibly hard to check, because we have to look at the
      //       expressions passed to the record when it's recreated as inference
      //       does not seem to be reflected in the analyzer APIs.
      // NOTE: This is probably not important, extension methods are cheap
      //       and the fact that we generate a bunch of extension that need not
      //       exist is fairly harmless.

      // Join names with a comma, so we don't generate more than one
      // ParsedRecord for each set of unique names
      final id = record.namedFields.map((f) => f.name).sorted().join(',');
      if (!canonicalizedRecords.containsKey(id)) {
        canonicalizedRecords[id] = ParsedRecord(
          fields: record.namedFields.map((f) => f.name).sorted(),
        );
      }
    }

    return canonicalizedRecords.values.toList();
  }
}

final class _ForEachRecordLiteral extends RecursiveAstVisitor<void> {
  final void Function(RecordLiteral node) _forEach;

  _ForEachRecordLiteral(this._forEach);

  @override
  void visitRecordLiteral(RecordLiteral node) {
    super.visitRecordLiteral(node);
    _forEach(node);
  }
}
