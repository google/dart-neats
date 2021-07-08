// Copyright 2019 Google LLC
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

import 'dart:async';
import 'dart:convert';
import 'package:test/test.dart';
import 'package:neat_cache/neat_cache.dart';
import 'package:neat_cache/cache_provider.dart';
import 'utils.dart';

void testCacheProvider({
  required String name,
  required Future<CacheProvider<String>> Function() create,
  Future Function()? destroy,
  List<String> tags = const <String>[],
}) =>
    group(name, () {
      late CacheProvider<String> cache;
      setUpAll(() async => cache = await create());
      tearDownAll(() => destroy != null ? destroy() : null);

      test('get empty key', () async {
        await cache.purge('test-key');
        final r = await cache.get('test-key');
        expect(r, isNull);
      });

      test('get multiple keys at the same time', () async {
        await cache.purge('test-key');
        final list = await Future.wait([
          cache.get('test-empty-key-1'),
          cache.get('test-empty-key-2'),
          cache.get('test-empty-key-3'),
          cache.get('test-empty-key-4'),
          cache.get('test-empty-key-1'),
          cache.get('test-empty-key-2'),
          cache.get('test-empty-key-3'),
          cache.get('test-empty-key-4'),
        ]);
        expect(list, isNotEmpty);
        expect(list.where((e) => e != null), isEmpty);
      });

      test('get/set key', () async {
        await cache.set('test-key-2', 'hello-world-42');
        final r = await cache.get('test-key-2');
        expect(r, equals('hello-world-42'));
      });

      test('get/set multiple keys', () async {
        await Future.wait([
          cache.set('test-multi-key-1', 'hello-world-1'),
          cache.set('test-multi-key-2', 'hello-world-2'),
          cache.set('test-multi-key-3', 'hello-world-3'),
        ]);
        final values = await Future.wait([
          cache.get('test-multi-key-1'),
          cache.get('test-multi-key-2'),
          cache.get('test-multi-key-3'),
        ]);
        expect(values, ['hello-world-1', 'hello-world-2', 'hello-world-3']);
      });

      test('set key (overwrite)', () async {
        await cache.set('test-key-3', 'hello-once');
        final r = await cache.get('test-key-3');
        expect(r, equals('hello-once'));

        await cache.set('test-key-3', 'hello-again');
        final r2 = await cache.get('test-key-3');
        expect(r2, equals('hello-again'));
      });

      test('purge key', () async {
        await cache.set('test-key-4', 'hello-once');
        final r = await cache.get('test-key-4');
        expect(r, equals('hello-once'));

        await cache.purge('test-key-4');
        final r2 = await cache.get('test-key-4');
        expect(r2, isNull);
      });

      test('set key w. ttl', () async {
        await cache.set('test-key-5', 'should-expire', Duration(seconds: 2));
        final r = await cache.get('test-key-5');
        expect(r, equals('should-expire'));

        await Future.delayed(Duration(seconds: 3));

        final r2 = await cache.get('test-key-5');
        expect(r2, isNull);
      }, tags: ['ttl']);
    }, tags: tags);

void main() {
  setupLogging();

  testCacheProvider(
    name: 'in-memory cache',
    create: () async => StringCacheProvider(
      cache: Cache.inMemoryCacheProvider(4096),
      codec: utf8,
    ),
  );

  late CacheProvider<List<int>> p;
  testCacheProvider(
    name: 'redis cache',
    create: () async {
      p = Cache.redisCacheProvider(Uri.parse('redis://localhost:6379'));
      return StringCacheProvider(cache: p, codec: utf8);
    },
    destroy: () => p.close(),
    tags: ['redis'],
  );
}
