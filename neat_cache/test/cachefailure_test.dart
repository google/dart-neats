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
import 'package:neat_cache/neat_cache.dart';
import 'package:neat_cache/cache_provider.dart';
import 'package:test/test.dart';
import 'utils.dart';

/// [CacheProvider] implementation that always fails, for testing only.
class _FailingCacheProvider extends CacheProvider<String> {
  bool _isClosed = false;
  int _attempts = 0;

  /// Return the number of attempts to do an operation.
  int get attempts => _attempts;

  @override
  Future<String> get(String key) async {
    if (_isClosed) {
      throw StateError('CacheProvider.close() have been called');
    }
    _attempts++;
    throw IntermittentCacheException('bad thing');
  }

  @override
  Future<void> set(String key, String value, [Duration? ttl]) async {
    if (_isClosed) {
      throw StateError('CacheProvider.close() have been called');
    }
    _attempts++;
    throw IntermittentCacheException('bad thing');
  }

  @override
  Future<void> purge(String key) async {
    if (_isClosed) {
      throw StateError('CacheProvider.close() have been called');
    }
    _attempts++;
    throw IntermittentCacheException('bad thing');
  }

  @override
  Future<void> close() async {
    _isClosed = true;
  }
}

void main() {
  setupLogging();

  // Here we test that Cache won't retry anything, or throw exceptions.
  // Except, for the special case in purge...
  group('failing cache provider', () {
    test('get', () async {
      final p = _FailingCacheProvider();
      final c = Cache(p);
      expect(await c.withPrefix('folder')['key'].get(), equals(null));
      expect(p.attempts, equals(1));
    });

    test('set', () async {
      final p = _FailingCacheProvider();
      final c = Cache(p);
      await c.withPrefix('folder')['key'].set('hello');
      expect(p.attempts, equals(1));
    });

    test('purge', () async {
      final p = _FailingCacheProvider();
      final c = Cache(p);
      await c.withPrefix('folder')['key'].purge();
      expect(p.attempts, equals(1));
    });

    test('purge (retries: 1)', () async {
      final p = _FailingCacheProvider();
      final c = Cache(p);
      await expectLater(
        c.withPrefix('folder')['key'].purge(retries: 1),
        throwsA(TypeMatcher<IntermittentCacheException>()),
      );
      expect(p.attempts, equals(2));
    });

    test('purge (retries: 2)', () async {
      final p = _FailingCacheProvider();
      final c = Cache(p);
      await expectLater(
        c.withPrefix('folder')['key'].purge(retries: 2),
        throwsA(TypeMatcher<IntermittentCacheException>()),
      );
      expect(p.attempts, equals(3));
    });
  });
}
