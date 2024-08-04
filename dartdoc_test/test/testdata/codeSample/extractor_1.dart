import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:markdown/markdown.dart';
import 'package:source_span/source_span.dart';
import 'package:dartdoc_test/src/extractor.dart';

void main() {
  final comment1 = '/// some comment';
  print(stripComments(comment1)); // 'some comment'
}
