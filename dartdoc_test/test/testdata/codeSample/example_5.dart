import 'dart:convert';
import 'file:///Users/takumma/work/gsoc/dart-neats/dartdoc_test/example/lib/example.dart';

void main() {
  final lines = splitLines('Hello\nWorld');
  print(lines); // ['Hello', 'World']
}
