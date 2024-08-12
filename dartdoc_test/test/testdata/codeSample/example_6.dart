
import 'package:example/example.dart';

  import 'dart:convert';
  
  void main() {
    final x = LineSplitter().convert('2\n3').map(int.parse).toList();
    print(pow(x[0], x[1])); // 8
  }
