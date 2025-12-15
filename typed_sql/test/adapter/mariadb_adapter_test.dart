// test/adapter/mysql_adapter_test.dart
import 'dart:async';
import 'dart:io';

import 'package:test/test.dart';
import 'package:typed_sql/adapter.dart';
import 'package:typed_sql/src/adapter/mysql_adapter.dart'
    show mysqlTestingAdapter;

// Helper to wait for stream results
extension on Stream<RowReader> {
  Future<List<List<Object?>>> toIntStr() async =>
      (await toList()).map((row) => [row.readInt(), row.readString()]).toList();
}

final String? _getMariadbSocket = () {
  final socketFile = File('.dart_tool/run/mariadb/mysqld.sock');
  if (socketFile.existsSync()) {
    return socketFile.absolute.path;
  }
  return null;
}();

void main() {
  late final DatabaseAdapter adapter;

  setUp(() async {
    adapter = mysqlTestingAdapter(
      host: _getMariadbSocket,
      port: int.tryParse(Platform.environment['MARIADB_PORT'] ?? ''),
    );
  });

  tearDown(() async {
    await adapter.close();
  });

  test('create table, insert and select, drop table', () async {
    await adapter.execute('CREATE TABLE users (id INT, name TEXT)', []);

    await adapter.execute(
      'INSERT INTO users (id, name) VALUES (?1, ?2)',
      [1, 'Alice'],
    );

    final result = await adapter.query(
      'SELECT id, name FROM users',
      [],
    ).toIntStr();
    expect(
        result,
        equals([
          [1, 'Alice']
        ]));

    await adapter.execute('DROP TABLE users', []);
  });
}
