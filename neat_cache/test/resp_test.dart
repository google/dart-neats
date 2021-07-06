// Copyright 2021 Google LLC
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

import 'dart:io';
import 'dart:convert' show utf8;
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:neat_cache/src/providers/resp.dart';

import 'utils.dart';

void main() {
  setupLogging();
  final connectionString = 'redis://localhost:6379';

  late RespClient client;
  group('resp', () {
    setUp(() async {
      final u = Uri.parse(connectionString);
      final socket = await Socket.connect(
        u.host,
        u.port,
      );
      client = RespClient(socket, socket);
    });
    tearDown(() async {
      await client.close();
    });

    test('PING', () async {
      final r1 = await client.command(['PING']);
      expect(r1, equals('PONG'));

      final r2 = await client.command(['PING']);
      expect(r2, equals('PONG'));

      final r3 = await client.command(['PING']);
      expect(r3, equals('PONG'));
    });

    test('ECHO hello world', () async {
      final r1 = await client.command(['ECHO', 'hello world']);
      expect(r1, equals(utf8.encode('hello world')));

      final r2 = await client.command(['ECHO', utf8.encode('hello world')]);
      expect(r2, equals(r1));
    });

    test('CLIENT ID', () async {
      // Tests that we can read an integer
      final r1 = await client.command(['CLIENT', 'ID']);
      expect(r1, isA<int>());
    });

    test('SET / GET', () async {
      final m1 = 'hello-world: ${DateTime.now()}';
      final r1 = await client.command(['SET', 'test-key', m1]);
      expect(r1, equals('OK'));

      final r2 = await client.command(['GET', 'test-key']);
      expect(r2, isA<Uint8List>());
      expect(utf8.decode(r2 as Uint8List), equals(m1));

      // Let's also try to overwrite
      final m2 = 'hello-world again: ${DateTime.now()}';
      final r3 = await client.command(['SET', 'test-key', m2]);
      expect(r3, equals('OK'));

      final r4 = await client.command(['GET', 'test-key']);
      expect(r4, isA<Uint8List>());
      expect(utf8.decode(r4 as Uint8List), equals(m2));
    });

    test('SET <key> <value> PX <seconds>', () async {
      final key = 'test-at-${DateTime.now()}';

      final r1 = await client.command(['GET', key]);
      expect(r1, isNull);

      final m1 = 'hello-world';
      final r2 = await client.command(['SET', key, m1, 'PX', 250]);
      expect(r2, equals('OK'));

      final r3 = await client.command(['GET', key]);
      expect(r3, isA<Uint8List>());
      expect(utf8.decode(r3 as Uint8List), equals(m1));

      await Future.delayed(Duration(milliseconds: 300));

      final r4 = await client.command(['GET', key]);
      expect(r4, isNull);
    });

    test('Invalid-Command throws RedisCommandException', () {
      expect(
        client.command(['Invalid-Command', 'wrong-arg']),
        throwsA(isA<RedisCommandException>()),
      );
    });
  }, tags: 'redis');
}
