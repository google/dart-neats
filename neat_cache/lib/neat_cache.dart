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

import 'package:convert/convert.dart' show IdentityCodec;
import 'package:logging/logging.dart';
import 'package:retry/retry.dart';

import 'cache_provider.dart';
import 'src/providers/inmemory.dart';
import 'src/providers/redis.dart';

final _logger = Logger('neat_cache');

/// Cache for objects of type [T], wrapping a [CacheProvider] to provide a
/// high-level interface.
///
/// Cache entries are accessed using the indexing operator `[]`, this returns a
/// [Entry<T>] wrapper that can be used to get/set data cached at given key.
///
/// **Example**
/// ```dart
/// final Cache<List<int>> cache = Cache.inMemoryCache(4096);
///
/// // Write data to cache
/// await cache['cached-zeros'].set([0, 0, 0, 0]);
///
/// // Read data from cache
/// var r = await cache['cached-zeros'].get();
/// expect(r, equals([0, 0, 0, 0]));
/// ```
///
/// A [Cache] can be _fused_ with a [Codec] using [withCodec] to get a cache
/// that stores a different kind of objects. It is also possible to create
/// a chuild cache using [withPrefix], such that all entries in the child
/// cache have a given prefix.
abstract class Cache<T> {
  /// Get [Entry] wrapping data cached at [key].
  Entry<T> operator [](String key);

  /// Get a [Cache] wrapping of this cache with given [prefix].
  Cache<T> withPrefix(String prefix);

  /// Get a [Cache] wrapping of this cache by encoding objects of type [S] as
  /// [T] using the given [codec].
  Cache<S> withCodec<S>(Codec<S, T> codec);

  /// Get a [Cache] wrapping of this cache with given [ttl] as default for all
  /// entries being set using [Entry.set].
  ///
  /// This only specifies a different default [ttl], to be used when [Entry.set]
  /// is called without a [ttl] parameter.
  Cache<T> withTTL(Duration ttl);

  /// Create a [Cache] wrapping a [CacheProvider].
  factory Cache(CacheProvider<T> provider) {
    return _Cache<T, T>(provider, '', IdentityCodec());
  }

  /// Create an in-memory [CacheProvider] holding a maximum of [maxSize] cache
  /// entries.
  static CacheProvider<List<int>> inMemoryCacheProvider(int maxSize) {
    return InMemoryCacheProvider(maxSize);
  }

  /// Create a redis [CacheProvider] by connecting using a [connectionString] on
  /// the form `redis://<host>:<port>`.
  static CacheProvider<List<int>> redisCacheProvider(Uri connectionString) {
    return RedisCacheProvider(connectionString);
  }
}

/// Pointer to a location in the cache.
///
/// This simply wraps a cache key, such that you don't need to supply a cache
/// key for [get], [set] and [purge] operations.
abstract class Entry<T> {
  /// Get value stored in this cache entry.
  ///
  /// If used without [create], this function simply gets the value or `null` if
  /// no value is stored.
  ///
  /// If used with [create], this function becomes an upsert, returning the
  /// value stored if any, otherwise creating a new value and storing it with
  /// optional [ttl]. If multiple callers are using the same cache this is an
  /// inherently racy operation, that is multiple instances of the value may
  /// be created.
  ///
  /// The [get] method is a best-effort method. In case of intermittent failures
  /// from the underlying [CacheProvider] the [get] method will ignore failures
  /// and return `null` (or result from [create] if specified).
  Future<T?> get([Future<T?> Function() create, Duration ttl]);

  /// Set the value stored in this cache entry.
  ///
  /// If given [ttl] specifies the time-to-live. Notice that this is advisatory,
  /// the underlying [CacheProvider] may choose to evit cache entries at any
  /// time. However, it can be assumed that entries will not live far past
  /// their [ttl].
  ///
  /// The [set] method is a best-effort method. In case of intermittent failures
  /// from the underlying [CacheProvider] the [set] method will ignore failures.
  ///
  /// To ensure that cache entries are purged, use the [purge] method with
  /// `retries` not set to zero.
  Future<T?> set(T? value, [Duration ttl]);

  /// Clear the value stored in this cache entry.
  ///
  /// If [retries] is `0` (default), this is a best-effort method, which will
  /// ignore intermittent failures. If [retries] is non-zero the operation will
  /// be retried with exponential back-off, and [IntermittentCacheException]
  /// will be thrown if all retries fails.
  Future purge({int retries = 0});
}

class _Cache<T, V> implements Cache<T> {
  final CacheProvider<V> _provider;
  final String _prefix;
  final Codec<T, V> _codec;
  final Duration? _ttl;

  _Cache(this._provider, this._prefix, this._codec, [this._ttl]);

  @override
  Entry<T> operator [](String key) => _Entry(this, _prefix + key);

  @override
  Cache<T> withPrefix(String prefix) =>
      _Cache(_provider, _prefix + prefix, _codec, _ttl);

  @override
  Cache<S> withCodec<S>(Codec<S, T> codec) =>
      _Cache(_provider, _prefix, codec.fuse(_codec), _ttl);

  @override
  Cache<T> withTTL(Duration ttl) => _Cache(_provider, _prefix, _codec, ttl);
}

class _Entry<T, V> implements Entry<T> {
  final _Cache<T, V> _owner;
  final String _key;
  _Entry(this._owner, this._key);

  @override
  Future<T?> get([Future<T?> Function()? create, Duration? ttl]) async {
    V? value;
    try {
      _logger.finest(() => 'reading cache entry for "$_key"');
      value = await _owner._provider.get(_key);
    } on IntermittentCacheException {
      _logger.fine(
        // embedding [intermittent-cache-failure] to allow for easy log metrics
        '[intermittent-cache-failure], failed to get cache entry for "$_key"',
      );
      value = null;
    }
    if (value == null) {
      if (create == null) {
        return null;
      }
      final created = await create();
      if (created != null) {
        // Calling `set(null)` is equivalent to `purge()`, we can skip that here
        await set(created, ttl);
      }
      return created;
    }
    return _owner._codec.decode(value);
  }

  @override
  Future<T?> set(T? value, [Duration? ttl]) async {
    if (value == null) {
      await purge();
      return null;
    }
    ttl ??= _owner._ttl;
    final raw = _owner._codec.encode(value);
    try {
      await _owner._provider.set(_key, raw, ttl);
    } on IntermittentCacheException {
      _logger.fine(
        // embedding [intermittent-cache-failure] to allow for easy log metrics
        '[intermittent-cache-failure], failed to set cache entry for "$_key"',
      );
    }
    return value;
  }

  @override
  Future<void> purge({int retries = 0}) async {
    // Common path is that we have no retries
    if (retries == 0) {
      try {
        await _owner._provider.purge(_key);
      } on IntermittentCacheException {
        _logger.fine(
          // embedding [intermittent-cache-failure] to allow for easy log metrics
          '[intermittent-cache-failure], failed to purge cache entry for "$_key"',
        );
      }
      return;
    }
    // Test that we have a positive number of retries.
    if (retries < 0) {
      ArgumentError.value(retries, 'retries', 'retries < 0 is not allowed');
    }
    return await retry(
      () => _owner._provider.purge(_key),
      retryIf: (e) => e is IntermittentCacheException,
      maxAttempts: 1 + retries,
    );
  }
}
