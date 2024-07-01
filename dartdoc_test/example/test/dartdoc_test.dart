import 'package:dartdoc_test/dartdoc_test.dart';
import 'package:test/test.dart';

void main() {
  test('analyze documentation code samples', () {
    DartDocTest(DartDocTestOptions(write: false)).analyze();
  });
}
