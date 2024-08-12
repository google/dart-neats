import 'dart:convert';
import '../../../example/lib/example.dart';

void main() {
  final lines = splitLines('Hello\nWorld');
  print(lines); // ['Hello', 'World']
}
