import 'package:test/test.dart';
import 'package:typed_sql/src/dialect/mysql_dialect.dart';

void main() {
  group('MySQL escape', () {
    test('simple name', () {
      expect(escape('my_table'), '`my_table`');
    });

    test('name with backtick', () {
      expect(escape('my`table'), '`my``table`');
    });

    test('multiple backticks', () {
      expect(escape('`a``b`'), '```a````b```');
    });
  });
}
